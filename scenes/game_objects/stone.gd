extends Node2D
class_name Stone

var occupies: Array[int] = []
var liberties: Array[int] = []
var pointsBelow: Array[int] = []
var rootPoint: int
#use these to index into shapes array: shapes[shape][orientation]
var shape: int
var orientation: int = 0
var color: int #concat colors[color] and shapes[shape][orientation][&"spriteTexture"]

func _ready() -> void:
	pass

func init(color: int, shape: int, orientation: int, shapes: Array[Array], textures: Array[Array]):
	self.color = color
	self.shape = shape
	self.orientation = orientation
	$Sprite2D.position = shapes[shape][orientation][&"spriteOffset"]
	$Sprite2D.texture = textures[color][shape][orientation % textures[color][shape].size()]

func move(offset: int) -> void: #offset will be width for falling one row, - width for up, 1 or -1 for sideways.
	for i in range(occupies.size()):
		occupies[i] = occupies[i] + offset
	for i in range(liberties.size()):
		liberties[i] = liberties[i] + offset
	for i in range(pointsBelow.size()):
		pointsBelow[i] = pointsBelow[i] + offset
