extends Node2D
class_name Queue

var Stone = preload("res://scenes/game_objects/Stone.tscn")
var offsetPoints: Array[Array] = []
var queue: Array[Array] = []
var previewPositions: Array[Vector2] = []
var queueSize: int = 1

func _ready() -> void:
	for i in queueSize:
		queue.append([])
		offsetPoints.append([])
		#96 is a spacer, 32 is cell size, 3 is max group height, 48 corrects for top left corner
		previewPositions.append(Vector2(48, 48 + (queueSize - 1 - i)*(96 + 32 * 3))) #top is last in queue
		for j in range(4): #4 is the max number of stones per group
			var stone = Stone.instantiate()
			queue[i].append(stone)
			add_child(stone)
			offsetPoints[i].append(Vector2i(0,0))

#items: color, shape, orientation, rootOffset
func advance_queue(items: Array[Dictionary], shapes: Array[Array], textures: Array[Array]):
	#todo advance through queue
	for i in range(queue.size() - 1):
		queue[i] = queue[i+1]
		offsetPoints[i] = offsetPoints[i+1]
		for j in range(4):
			queue[i][j].visible = queue[i+1][j].visible
			queue[i][j].position = previewPositions[i] + offsetPoints[i][j] * 32 #32 is the cell size
	#fill end of queue
	for i in range(4): #4 is the max number of stones per group
		if i < items.size():
			var item = items[i]
			var stone = queue[queue.size() - 1][i]
			stone.visible = true
			stone.init(item[&"color"], item[&"shape"], item[&"orientation"], shapes, textures)
			offsetPoints[queue.size() - 1][i] = item[&"rootOffset"]
			#32 is the cell size
			stone.position = previewPositions[queueSize - 1] + offsetPoints[queue.size() - 1][i] * 32
		else:
			queue[queue.size() - 1][i].visible = false

func set_queue(newQueue: Array[Array], shapes: Array[Array], textures: Array[Array]):
	#todo optimize
	for items in newQueue:
		advance_queue(items, shapes, textures)
