extends Node2D
class_name Board

var height: int
var width: int
var cellPixels: int
var stonesOnBoard: Array[Stone] = []
var board: Array = []

func _ready() -> void:
	pass

func init(width, height, cellPixels):
	self.width = width
	self.height = height
	self.cellPixels = cellPixels
	board.resize(width * height)

func place_all(stones: Array[Stone]):
	for stone in stones:
		place(stone)

func place(stone: Stone):
	stonesOnBoard.append(stone)
	stone.position = get_position_for(stone.rootPoint)
	add_child(stone)

func get_position_for(point: Vector2i) -> Vector2:
	return point * cellPixels

func _draw() -> void:
	for col in range(width):
		# Line goes one pixel (half of the line width) extra to cover the corner
		draw_line(Vector2(col * cellPixels,-1), Vector2(col * cellPixels, (height - 1) * cellPixels + 1),
		Color(0,0,0), 2.0)
	for row in range(height):
		draw_line(Vector2(0,row * cellPixels), Vector2((width - 1) * cellPixels, row * cellPixels),
		Color(0,0,0), 2.0)
