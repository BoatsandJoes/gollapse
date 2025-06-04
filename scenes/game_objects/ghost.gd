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

func can_place(stonesOnBoard: Array[Stone]) -> bool:
	return true

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

#items: color, shape, orientation, rootOffset
func set_stones(items: Array[Dictionary], shapes: Array[Array], textures: Array[Array]):
	var kick: Vector2i = Vector2i(0,0)
	for i in range(4): #4 is the max number of stones per group
		if i < items.size():
			var item = items[i]
			var stone = stones[i]
			stone.visible = true
			stone.init(item[&"color"], item[&"shape"], item[&"orientation"], shapes, textures)
			offsetPoints[i] = item[&"rootOffset"]
			stone.rootPoint = point + offsetPoints[i]
			stone.position = offsetPoints[i] * 32 #32 is the cell size
			# check for kicks
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
		else:
			stones[i].visible = false
	if kick != Vector2i(0,0):
		move(kick, shapes) # This will fail if it's possible to get stuck 2 cells deep in the wall
