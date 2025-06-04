extends Node2D
class_name Stone

var rootPoint: Vector2i
#use these to index into shapes array: shapes[shape][orientation]
var shape: int
var orientation: int = 0
var color: int #concat colors[color] and shapes[shape][orientation][&"spriteTexture"]

func _ready() -> void:
	pass

func init(color: int, shape: int, orientation: int, shapes: Array[Array], textures: Array[Array]):
	self.color = color
	self.shape = shape
	spin(orientation, shapes, textures)

func spin(orientation: int, shapes: Array[Array], textures: Array[Array]) -> void:
	self.orientation = orientation
	$Sprite2D.position = shapes[shape][orientation][&"spriteOffset"]
	$Sprite2D.texture = textures[color][shape][orientation % textures[color][shape].size()]

func move(offset: Vector2i) -> void:
	rootPoint = rootPoint + offset
