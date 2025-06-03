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
		board.init(width, height, cellPixels)
		board.position = Vector2(cellPixels, 360 - cellPixels / 2 - cellPixels * (height - 1))
		add_child(board)
		boards.append(board)
	for i in range(numPlayers):
		ghosts.append(Ghost.instantiate())
		if numBoards == numPlayers:
			ghosts[i].point = Vector2i((width + 1) / 2, (height / 2))
		update_ghost_visual_position(i)
		add_child(ghosts[i])
		queues.append(Queue.instantiate())
		if numBoards == numPlayers:
			queues[i].position = boards[i].position + Vector2((cellPixels) * (width + 1), cellPixels)
		add_child(queues[i])

func update_ghost_visual_position(ghostIndex: int):
	if numBoards == numPlayers:
		ghosts[ghostIndex].position = boards[ghostIndex].position
		+ Vector2(ghosts[ghostIndex].point * cellPixels)
