extends Node2D
class_name Queue

var Stone = preload("res://scenes/game_objects/Stone.tscn")
var offsetPoints: Array[Array] = []
var queue: Array[Array] = []
var previewPositions: Array[Vector2] = []
var queueSize: int = 2
var piecesLoaded: int = 0

func _ready() -> void:
	for i in queueSize:
		queue.append([])
		offsetPoints.append([])
		#32 is cell size (one is an arbitrary spacer), 3 is max group height, 48 corrects for top left corner
		previewPositions.append(Vector2(48, 48 + (queueSize - 1 - i)*(32 + 32 * 3))) #top is last in queue
		for j in range(4): #4 is the max number of stones per group
			var stone = Stone.instantiate()
			queue[i].append(stone)
			add_child(stone)
			offsetPoints[i].append(Vector2i(0,0))

#items: array of dicts of color, shape, orientation, rootOffset
func advance_queue(items: Array[Dictionary], shapes: Array[Array], textures: Array[Array]):
	#advance through queue
	piecesLoaded = piecesLoaded + 1
	# Use temp objects: these object references will go to the back of the line to be written with the new group.
	var tempQueue = queue[0]
	var tempOffsetPoints = offsetPoints[0]
	for i in range(queue.size() - 1):
		queue[i] = queue[i+1]
		offsetPoints[i] = offsetPoints[i+1]
		for j in range(4):
			queue[i][j].visible = queue[i+1][j].visible
			queue[i][j].position = previewPositions[i] + Vector2(offsetPoints[i][j] * 32) #32 is the cell size
	#fill end of queue
	queue[queue.size() - 1] = tempQueue
	offsetPoints[offsetPoints.size() - 1] = tempOffsetPoints
	for i in range(4): #4 is the max number of stones per group
		if i < items.size():
			var item = items[i]
			queue[queue.size() - 1][i].visible = true
			queue[queue.size() - 1][i].init(item[&"color"], item[&"shape"], item[&"orientation"],
			shapes, textures)
			offsetPoints[queue.size() - 1][i] = item[&"rootOffset"]
			#32 is the cell size
			queue[queue.size() - 1][i].position = (previewPositions[queueSize - 1]
			+ Vector2(offsetPoints[queue.size() - 1][i] * 32))
		else:
			queue[queue.size() - 1][i].visible = false

func set_queue(newQueue: Array[Array], shapes: Array[Array], textures: Array[Array], lastPiece: int):
	#todo optimize
	for items in newQueue:
		advance_queue(items, shapes, textures)
		piecesLoaded = lastPiece
