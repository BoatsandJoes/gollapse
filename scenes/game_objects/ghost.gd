extends Node2D
class_name Ghost

var Stone = preload("res://scenes/game_objects/Stone.tscn")
var stones: Array[Stone] = []
var offsetPoints: Array[Vector2i] = []
var point: Vector2i

func _ready() -> void:
	for i in range(4): #4 is the max number of stones per group
		var stone = Stone.instantiate()
		stone.set_modulate(Color(1,1,1,0.5))
		stones.append(stone)
		add_child(stone)

#items: color, shape, orientation, rootOffset
func set_stones(items: Array[Dictionary], shapes: Array[Array], textures: Array[Array]):
	for i in range(4): #4 is the max number of stones per group
		if i < items.size():
			var item = items[i]
			var stone = stones[i]
			stone.visible = true
			stone.init(item[&"color"], item[&"shape"], item[&"orientation"], shapes, textures)
			offsetPoints[i] = item[&"rootOffset"]
			stone.position = offsetPoints[i] * 32 #32 is the cell size
		else:
			stones[i].visible = false
