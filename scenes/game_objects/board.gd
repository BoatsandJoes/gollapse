extends Node2D
class_name Board

var height: int
var width: int
var cellPixels: int
var Stone = preload("res://scenes/game_objects/Stone.tscn")
var stonesOnBoard: Array[Stone]
var board: Array

func _ready() -> void:
	stonesOnBoard = []
	board = []
	board.resize(width * height)

func _draw() -> void:
	for col in range(width):
		draw_line(Vector2(col * cellPixels,0), Vector2(col * cellPixels, (height - 1) * cellPixels),
		Color(0,0,0))
	for row in range(height):
		draw_line(Vector2(0,row * cellPixels), Vector2((width - 1) * cellPixels, row * cellPixels),
		Color(0,0,0))
