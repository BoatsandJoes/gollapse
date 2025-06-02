extends Node2D
class_name GroupOfStones

var Stone = preload("res://scenes/game_objects/Stone.tscn")
var stones: Array[Dictionary] = []

func init_group(stones: Array[Dictionary], shapes: Array[Array], textures: Array[Array]):
	for item in stones: #color, shape, orientation, rootOffset
		var stone: Stone = Stone.instantiate()
		stone.init(item[&"color"], item[&"shape"], item[&"orientation"], shapes, textures)
		var dict: Dictionary = {&"stone": stone, &"rootOffset": stone[&"rootOffset"]}
		stones.append(dict)
		add_child(stone)
