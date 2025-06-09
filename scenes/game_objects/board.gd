extends Node2D
class_name Board

var height: int
var width: int
var cellPixels: int
var Stone = preload("res://scenes/game_objects/Stone.tscn")
var stonesOnBoard: Array[Stone] = []
var board: Array = []
var flagForClearCheck: bool = false
var priorityClearColors: Array[int] = [0,1,2]
var shapes: Array[Array]
var textures: Array[Array]
var checkedStones: Array[Stone] = []

func _ready() -> void:
	pass

func init(width, height, cellPixels, shapes, textures):
	self.width = width
	self.height = height
	self.cellPixels = cellPixels
	self.shapes = shapes
	self.textures = textures
	board.resize(width * height)

func place_all(stones: Array[Stone], updatePriority: bool = true):
	for stone in stones:
		place(stone, updatePriority)

func place(stone: Stone, updatePriority: bool = true):
	stonesOnBoard.append(stone)
	stone.position = get_position_for(stone.rootPoint)
	stone.clear.connect(_on_stone_clear)
	stone.land.connect(_on_stone_land)
	add_child(stone)
	if updatePriority:
		flagForClearCheck = true
		# This stone's color will be cleared last (ie will capture before it is captured)
		priorityClearColors.erase(stone.color)
		priorityClearColors.append(stone.color)

func _on_stone_clear(stone: Stone):
	stonesOnBoard.erase(stone)
	stone.clear.disconnect(_on_stone_clear)
	stone.land.disconnect(_on_stone_land)
	remove_child(stone)
	stone.queue_free()

func _on_stone_land(_stone: Stone):
	flagForClearCheck = true

func get_position_for(point: Vector2i) -> Vector2:
	return point * cellPixels

func check_for_clears() -> void:
	if flagForClearCheck: #only check on frames with a placement or a landing (or a rollback?)
		flagForClearCheck = false #don't check next frame unless this is set again.
		var captures: Array[Array] = []
		for i in range(priorityClearColors.size()):
			#if black was placed most recently, clear white first and vice versa
			var checkingColor: int = priorityClearColors[i]
			for stone in stonesOnBoard:
				checkedStones = []
				if (stone.clearable && !stone.clearing && stone.color == checkingColor
				&& !checkedStones.has(stone)):
					var capturedGroup: Array[Stone] = return_surrounded_group_containing(stone)
					if !capturedGroup.is_empty():
						captures.append(capturedGroup)
			if i >= priorityClearColors.size() - 2:
				#Two two batches of clears: one for all colors but one, and a second for the last color.
				for capturedGroup in captures:
					for capturedStone in capturedGroup:
						capturedStone.begin_clear()
				captures = []

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

func apply_gravity(delta: float) -> void:
	checkedStones = []
	for stone in stonesOnBoard:
		if !stone.clearing && !checkedStones.has(stone):
			fall(stone, delta)

func fall(stone: Stone, delta: float) -> float:
	#This method assumes that there is no C stone that can wrap around and be above + below at the same time.
	checkedStones.append(stone)
	var highestFloor: float = stone.fallThreshold * 2 #this default is a lower bound
	var hardFloor: bool = false
	var garbage: bool = false
	for genericPoint in shapes[stone.shape][stone.orientation][&"pointsBelow"]:
		var point = genericPoint + stone.rootPoint
		if point.y > height:
			#garbage below the board
			hardFloor = false
			garbage = true
		if point.y == height:
			if stone.fallCounter <= stone.fallThreshold / 2.0:
				#not garbage, at least not anymore
				hardFloor = true
				highestFloor = min(highestFloor, stone.fallThreshold / 2.0)
				stone.clearable = true
				#todo check for rising garbage. We may need to pop up.
			else:
				#garbage in the lower half of the in-board cell
				hardFloor = false
				garbage = true
		else:
			# Check to see if there's a stone below
			for otherStone in stonesOnBoard:
				var doneLookingAtStonesForThisLiberty: bool = false
				for genericOtherPoint in shapes[otherStone.shape][otherStone.orientation][&"occupies"]:
					var otherPoint: Vector2i = genericOtherPoint + otherStone.rootPoint
					if otherPoint == point:
						if !checkedStones.has(otherStone):
							#the stone below hasn't fallen yet. Make it fall first.
							var tempOtherRootPoint = otherStone.rootPoint
							fall(otherStone, delta)
							if otherStone.rootPoint != tempOtherRootPoint:
								#stone fell far enough that it's no longer in the cell below us.
								#It isn't blocking us anymore.
								doneLookingAtStonesForThisLiberty = true
								break
						#Don't overlap the stone below us.
						highestFloor = min(highestFloor, otherStone.fallCounter)
						if !otherStone.falling:
							hardFloor = true
						doneLookingAtStonesForThisLiberty = true
						break
				if doneLookingAtStonesForThisLiberty:
					break
	var crossedThreshold: bool
	#todo it's possible that there is no piece below us now but there will be one later in the frame
	if !garbage:
		if highestFloor < stone.fallThreshold / 2.0 || !hardFloor:
			crossedThreshold = stone.advance_fall(delta, highestFloor)
		else:
			crossedThreshold = stone.advance_fall(delta, -1.0)
		if crossedThreshold:
			stone.move(Vector2i(0,1))
			stone.position = get_position_for(stone.rootPoint)
	else:
		#push garbage
		if stone.advance_fall(-delta, stone.fallThreshold):
			stone.move(Vector2i(0, -1))
			stone.position = get_position_for(stone.rootPoint)
			#todo push anyone stacked on top of us up too
	if !stone.falling:
		return -1.0
	else:
		return stone.fallCounter

func push_floor(garbage: Array[Dictionary]): #array of dicts of color, shape, orientation, rootOffset
	for piece in garbage:
		var stone = Stone.instantiate()
		stone.init(piece[&"color"], piece[&"shape"], piece[&"orientation"], shapes, textures)
		stone.rootOffset = piece[&"rootOffset"] + Vector2i(0,height) #below bottom of board
		stone.clearable = false
		place(stone, false)

func _physics_process(delta: float) -> void:
	check_for_clears()
	apply_gravity(delta)

func _draw() -> void:
	for col in range(width):
		# Line goes one pixel (half of the line width) extra to cover the corner
		draw_line(Vector2(col * cellPixels,-1), Vector2(col * cellPixels, (height - 1) * cellPixels + 1),
		Color(0,0,0), 2.0)
	for row in range(height):
		draw_line(Vector2(0,row * cellPixels), Vector2((width - 1) * cellPixels, row * cellPixels),
		Color(0,0,0), 2.0)
