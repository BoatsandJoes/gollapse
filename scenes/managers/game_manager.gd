extends Node2D
class_name GameManager

var rando: Randomizer = Randomizer.new()
var textures: Array[Array]
var shapes: Array[Array]
var numColors: int = 2
var cellPixels: int = 32
var width: int = 9
var height: int = 11
var Board = preload("res://scenes/game_objects/Board.tscn")
var boards: Array[Board] = []
var Controller = preload("res://scenes/managers/Controller.tscn")
var controllers: Array[Controller] = []
var Ghost = preload("res://scenes/game_objects/Ghost.tscn")
var ghosts: Array[Ghost] = []
var Queue = preload("res://scenes/ui/hud/Queue.tscn")
var queues: Array[Queue] = []
var Hud = preload("res://scenes/ui/hud/Hud.tscn")
var hud: Hud
var numBoards: int = 1
var numPlayers: int = 1
var numHumanPlayers: int = 1

func _ready() -> void:
	rando.init(numColors)
	for i in range(numBoards):
		var board = Board.instantiate()
		board.init(width, height, cellPixels)
		board.position = Vector2(cellPixels, 360 - cellPixels / 2 - cellPixels * (height - 1))
		add_child(board)
		boards.append(board)
	for i in range(numPlayers):
		controllers.append(Controller.instantiate())
		add_child(controllers[i])
		ghosts.append(Ghost.instantiate())
		if numBoards == numPlayers:
			ghosts[i].point = Vector2i(width / 2, height / 2)
		update_ghost_visual_position(i)
		queues.append(Queue.instantiate())
		if numBoards == numPlayers:
			queues[i].position = boards[i].position + Vector2((cellPixels) * (width), cellPixels / 2)
		add_child(queues[i])
		add_child(ghosts[i])
		for j in range(queues[i].queueSize + 1):
			if j == queues[i].queueSize:
				#array of dicts of color, shape, orientation, rootOffset
				var items: Array[Dictionary] = []
				for k in range(queues[i].queue[0].size()):
					var stone = queues[i].queue[0][k]
					if stone.visible:
						items.append({&"color": stone.color, &"shape": stone.shape,
						&"orientation": stone.orientation, &"rootOffset": queues[i].offsetPoints[0][k]})
				ghosts[i].set_stones(items, shapes, textures)
			queues[i].advance_queue(rando.get_piece(queues[i].piecesLoaded), shapes, textures)

func update_ghost_visual_position(ghostIndex: int):
	if numBoards == numPlayers:
		ghosts[ghostIndex].position = (boards[ghostIndex].position
		+ Vector2(ghosts[ghostIndex].point * cellPixels))

func _physics_process(delta: float) -> void:
	var controllersToProcess: Array[Controller] = []
	for i in range(controllers.size()):
		var controller = controllers[i]
		controller.poll_input(delta)
		#randomize processing order to make it fair
		controllersToProcess.insert(randi_range(0, controllersToProcess.size()), controller)
	for controller in controllersToProcess:
		pass #todo
