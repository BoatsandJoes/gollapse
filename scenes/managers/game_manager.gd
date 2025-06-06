extends Node2D
class_name GameManager

var rando: Randomizer = Randomizer.new()
var textures: Array[Array]
var shapes: Array[Array]
var numColors: int = 3
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
var Stone = preload("res://scenes/game_objects/Stone.tscn")
var numBoards: int = 1
var numPlayers: int = 1
var numHumanPlayers: int = 1

func _ready() -> void:
	rando.init(numColors)
	for i in range(numBoards):
		var board = Board.instantiate()
		board.init(width, height, cellPixels, shapes)
		board.position = Vector2(cellPixels, 360 - cellPixels / 2 - cellPixels * (height - 1))
		add_child(board)
		boards.append(board)
	for i in range(numPlayers):
		controllers.append(Controller.instantiate())
		add_child(controllers[i])
		ghosts.append(Ghost.instantiate())
		ghosts[i].width = width
		ghosts[i].height = height
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
				populate_ghost_from_queue(queues[i], ghosts[i])
			queues[i].advance_queue(rando.get_piece(queues[i].piecesLoaded), shapes, textures)

func populate_ghost_from_queue(queue: Queue, ghost: Ghost):
	#array of dicts of color, shape, orientation, rootOffset
	var items: Array[Dictionary] = []
	for i in range(queue.queue[0].size()):
		var stone = queue.queue[0][i]
		if stone.visible:
			items.append({&"color": stone.color, &"shape": stone.shape,
			&"orientation": stone.orientation, &"rootOffset": queue.offsetPoints[0][i]})
	ghost.set_stones(items, shapes, textures)

func update_ghost_visual_position(ghostIndex: int):
	if numBoards == numPlayers:
		ghosts[ghostIndex].position = (boards[ghostIndex].position
		+ Vector2(ghosts[ghostIndex].point * cellPixels))

func _physics_process(delta: float) -> void:
	var controllersToProcess: Array[Dictionary] = []
	for i in range(controllers.size()):
		var controller = controllers[i]
		controller.poll_input(delta)
		#randomize processing order to make it fair
		controllersToProcess.insert(randi_range(0, controllersToProcess.size()),
		{&"controller": controller, &"playerNum": i})
	for controllerDict in controllersToProcess:
		var controller: Controller = controllerDict[&"controller"]
		var playerNum: int = controllerDict[&"playerNum"]
		var ghost = ghosts[playerNum]
		var board = boards[playerNum]
		var queue = queues[playerNum]
		var moved: bool = false
		if controller.pause:
			pass #todo
		if controller.place:
			if ghost.can_place(board.stonesOnBoard, shapes):
				var stones: Array[Stone] = []
				for stone in ghost.stones:
					if stone.visible:
						stones.append(Stone.instantiate())
						stones[stones.size() - 1].init(stone.color,stone.shape,stone.orientation,
						shapes,textures)
						stones[stones.size() - 1].rootPoint = stone.rootPoint
				board.place_all(stones)
				populate_ghost_from_queue(queue, ghost)
				queue.advance_queue(rando.get_piece(queue.piecesLoaded), shapes, textures)
				moved = true
		if controller.cw:
			ghost.spin(true, shapes, textures)
			moved = true
		elif controller.ccw:
			ghost.spin(false, shapes, textures)
			moved = true
		var move: Vector2i = Vector2i(0,0)
		if (controller.direction.x != 0 && (controller.horizontalHeldFor == 0.0
		|| controller.horizontalHeldFor >= controller.DAS)):
			move.x = controller.direction.x
			moved = true
			if controller.horizontalHeldFor != 0.0:
				controller.horizontalHeldFor = controller.horizontalHeldFor - controller.ARR
		if (controller.direction.y != 0 && (controller.verticalHeldFor == 0.0
		|| controller.verticalHeldFor >= controller.DAS)):
			move.y = controller.direction.y
			moved = true
			if controller.verticalHeldFor != 0.0:
				controller.verticalHeldFor = controller.verticalHeldFor - controller.ARR
		if move != Vector2i(0,0):
			ghost.move(move, shapes)
		if moved:
			update_ghost_visual_position(playerNum)
