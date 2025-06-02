extends Node2D
class_name GameManager

var textures: Array[Array]
var shapes: Array[Array]
var numColors: int = 2
var cellPixels: int = 32
var width: int = 9
var height: int = 11
var Board = preload("res://scenes/game_objects/Board.tscn")
var boards: Array[Board]
var Ghost = preload("res://scenes/game_objects/Ghost.tscn")
var ghosts: Array[Ghost]
var Queue = preload("res://scenes/ui/hud/Queue.tscn")
var queues: Array[Queue]
var Hud = preload("res://scenes/ui/hud/Hud.tscn")
var hud: Hud
var numBoards: int = 1
var numPlayers: int = 1
var numHumanPlayers: int = 1

func _ready() -> void:
	for i in range(numBoards):
		var board = Board.instantiate()
		board.cellPixels = self.cellPixels
		board.height = self.height
		board.width = self.width
		board.position = Vector2i(cellPixels, 360 - cellPixels / 2 - cellPixels * (height - 1))
		add_child(board)
		boards.append(board)
