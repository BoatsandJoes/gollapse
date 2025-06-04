extends Node2D
class_name Ghost

var Stone = preload("res://scenes/game_objects/Stone.tscn")
var stones: Array[Stone] = []
var offsetPoints: Array[Vector2i] = []
var point: Vector2i
var height: int
var width: int

func _ready() -> void:
	for i in range(4): #4 is the max number of stones per group
		var stone = Stone.instantiate()
		stone.set_modulate(Color(1,1,1,0.5))
		stones.append(stone)
		add_child(stone)
		offsetPoints.append(Vector2i(0,0))

func can_place(stonesOnBoard: Array[Stone], shapes) -> bool:
	for i in range(stones.size()):
		var stone = stones[i]
		if stone.visible:
			for boardStone in stonesOnBoard:
				for boardPoint in shapes[boardStone.shape][boardStone.orientation][&"occupies"]:
					for myPoint in shapes[stone.shape][stone.orientation][&"occupies"]:
						#offsetPoints are baked into the root point already
						if boardPoint + boardStone.rootPoint == myPoint + stone.rootPoint:
							return false
	return true

func spin(clockwise: bool, shapes: Array[Array], textures: Array[Array]) -> void:
	var direction: int = 1 if clockwise else -1
	for i in range(stones.size()):
		var stone = stones[i]
		var kick: Vector2i = Vector2i(0,0)
		if stone.visible:
			var newOrientation = stone.orientation + direction
			if newOrientation < 0:
				newOrientation = 3
			newOrientation = newOrientation % shapes[stone.shape].size()
			stone.spin(newOrientation, shapes, textures)
			#rotate the offset by multiplying the vectors.
			if direction == 1:
				update_offset(i, Vector2i(-offsetPoints[i].y, offsetPoints[i].x))
			else:
				update_offset(i, Vector2i(offsetPoints[i].y, -offsetPoints[i].x))
			kick = check_for_kicks(kick, stone, shapes)
		if kick != Vector2i(0,0):
			move(kick, shapes) #this assumes the piece is no more than 1 in the wall.

func move(direction: Vector2i, shapes: Array[Array]):
	#this assumes direction.x and direction.y are no more than +- 1
	var stoneIndex: int = 0
	while stoneIndex < stones.size() && direction != Vector2i(0,0):
		var stone = stones[stoneIndex]
		stoneIndex = stoneIndex + 1
		if stone.visible:
			for intersection in shapes[stone.shape][stone.orientation][&"occupies"]:
				intersection = intersection + stone.rootPoint
				if direction.y < 0 && intersection.y <= 0:
					direction.y = 0
				elif direction.y > 0 && intersection.y >= height - 1:
					direction.y = 0
				if direction.x < 0 && intersection.x <= 0:
					direction.x = 0
				elif direction.x > 0 && intersection.x >= width - 1:
					direction.x = 0
	if direction != Vector2i(0,0):
		#perform the move
		point = point + direction
		for stone in stones:
			stone.move(direction)

func update_offset(i: int, offset: Vector2i) -> void:
	offsetPoints[i] = offset
	stones[i].rootPoint = point + offset
	stones[i].position = offset * 32 #32 is the cell size

#items: color, shape, orientation, rootOffset
func set_stones(items: Array[Dictionary], shapes: Array[Array], textures: Array[Array]):
	var kick: Vector2i = Vector2i(0,0)
	for i in range(4): #4 is the max number of stones per group
		if i < items.size():
			var item = items[i]
			var stone = stones[i]
			stone.visible = true
			stone.init(item[&"color"], item[&"shape"], item[&"orientation"], shapes, textures)
			update_offset(i, item[&"rootOffset"])
			kick = check_for_kicks(kick, stone, shapes)
		else:
			stones[i].visible = false
	if kick != Vector2i(0,0):
		move(kick, shapes) # This will fail if it's possible to get stuck 2 cells deep in the wall

func check_for_kicks(kick: Vector2i, stone: Stone, shapes: Array[Array]) -> Vector2i:
	for intersection in shapes[stone.shape][stone.orientation][&"occupies"]:
		intersection = intersection + stone.rootPoint
		if intersection.x < 0:
			kick.x = 1
		elif intersection.x >= width:
			kick.x = -1
		if intersection.y < 0:
			kick.y = 1
		elif intersection.y >= height:
			kick.y = -1
	return kick
