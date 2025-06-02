extends Node2D
class_name GameManager

var cellPixels: int = 32
var width: int = 9
var height: int = 11
var Board = preload("res://scenes/game_objects/Board.tscn")
var board: Board

func _ready() -> void:
	board = Board.instantiate()
	board.cellPixels = self.cellPixels
	board.height = self.height
	board.width = self.width
	board.position = Vector2i(cellPixels, 360 - cellPixels / 2 - cellPixels * (height - 1))
	add_child(board)
