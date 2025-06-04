extends Node2D
class_name Board

var height: int
var width: int
var cellPixels: int
var stonesOnBoard: Array[Stone] = []
var board: Array = []
var flagForClearCheck: bool = false
var priorityClearColors: Array[int] = [0,1]
var shapes: Array[Array]
var checkedStones: Array[Stone] = []

func _ready() -> void:
	pass

func init(width, height, cellPixels, shapes):
	self.width = width
	self.height = height
	self.cellPixels = cellPixels
	self.shapes = shapes
	board.resize(width * height)

func place_all(stones: Array[Stone]):
	for stone in stones:
		place(stone)

func place(stone: Stone):
	stonesOnBoard.append(stone)
	stone.position = get_position_for(stone.rootPoint)
	stone.clear.connect(_on_stone_clear)
	add_child(stone)
	flagForClearCheck = true
	# This stone's color will be cleared last (ie will capture before it is captured)
	priorityClearColors.erase(stone.color)
	priorityClearColors.append(stone.color)

func _on_stone_clear(stone: Stone):
	stonesOnBoard.erase(stone)
	stone.clear.disconnect(_on_stone_clear)
	remove_child(stone)
	stone.queue_free()

func get_position_for(point: Vector2i) -> Vector2:
	return point * cellPixels

func check_for_clears() -> void:
	if flagForClearCheck: #only check on frames with a placement or a landing (or a rollback?)
		flagForClearCheck = false #don't check next frame unless this is set again.
		for i in range(priorityClearColors.size()):
			#if black was placed most recently, clear white first and vice versa
			var checkingColor: int = priorityClearColors[i]
			for stone in stonesOnBoard:
				checkedStones = []
				if !stone.clearing && stone.color == checkingColor && !checkedStones.has(stone):
					var capturedGroup: Array[Stone] = return_surrounded_group_containing(stone)
					if !capturedGroup.is_empty():
						for capturedStone in capturedGroup:
							capturedStone.begin_clear()

func return_surrounded_group_containing(stone: Stone) -> Array[Stone]:
	var clearing: Array[Stone] = []
	var emptyLiberty: bool = false
	checkedStones.append(stone) # Caller must make sure to not call this method if stone is already checked
	# Check this stone's liberties.
	for genericLiberty in shapes[stone.shape][stone.orientation][&"liberties"]:
		var liberty = genericLiberty + stone.rootPoint
		if !(liberty.x < 0 || liberty.y < 0 || liberty.x >= width || liberty.y >= height):
			#Liberty is NOT off the edge of the board. Check for other stones
			emptyLiberty = true #We don't know this for sure yet, but it's our new default assumption.
			for otherStone in stonesOnBoard:
				var doneCheckingEarly: bool = false
				if !otherStone.falling && !otherStone.clearing:
					# Stone is not falling or clearing. Let's see if it's a neighbor
					for genericOtherStonePoint in shapes[otherStone.shape][otherStone.orientation][&"occupies"]:
						var otherStonePoint = genericOtherStonePoint + otherStone.rootPoint
						if otherStonePoint == liberty:
							if otherStone.color != stone.color:
								# This liberty is occupied by a stone of another color.
								emptyLiberty = false
								break # Finish looping through stones. Continue looping through liberties.
							else:
								# Colors match. Recursively check the connected stone.
								if checkedStones.has(otherStone):
									# The status of the connected stone either:
									# has been (sibling) or is being (parent) decided already.
									# This check will move on to other liberties.
									emptyLiberty = false
									break
								else:
									var result: Array[Stone] = return_surrounded_group_containing(otherStone)
									if result.is_empty():
										#We're done. No clear
										emptyLiberty = true
										doneCheckingEarly = true
										break #We're outta here
									else:
										clearing.append_array(result)
										emptyLiberty = false
										break #Check the next liberty.
						if emptyLiberty == false || doneCheckingEarly == true:
							break #We found a neighbor. Go on to next liberty
				if doneCheckingEarly:
					break
			if emptyLiberty:
				# We're done. No clear
				clearing = []
				break
	if !emptyLiberty:
		#All liberties occupied. This stone is captured, along with connected stones (if any).
		clearing.append(stone)
	return clearing

func apply_gravity() -> void:
	#todo
	checkedStones = []

func _physics_process(delta: float) -> void:
	check_for_clears()
	apply_gravity()

func _draw() -> void:
	for col in range(width):
		# Line goes one pixel (half of the line width) extra to cover the corner
		draw_line(Vector2(col * cellPixels,-1), Vector2(col * cellPixels, (height - 1) * cellPixels + 1),
		Color(0,0,0), 2.0)
	for row in range(height):
		draw_line(Vector2(0,row * cellPixels), Vector2((width - 1) * cellPixels, row * cellPixels),
		Color(0,0,0), 2.0)
