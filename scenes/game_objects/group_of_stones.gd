extends Node2D
class_name GroupOfStones

var Stone = preload("res://scenes/game_objects/Stone.tscn")
var stones: Array[Stone] = []

func add_stone(stone: Stone):
	stones.append(stone)
	add_child(stone)
