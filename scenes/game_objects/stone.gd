extends Node2D
class_name Stone

signal clear(stone: Stone)

var rootPoint: Vector2i
#use these to index into shapes array: shapes[shape][orientation]
var shape: int
var orientation: int = 0
var color: int #concat colors[color] and shapes[shape][orientation][&"spriteTexture"]
var clearing: bool = false
var falling: bool = false
var clearTimer: Timer

func _ready() -> void:
	clearTimer = Timer.new()
	clearTimer.one_shot = true
	clearTimer.autostart = false
	clearTimer.wait_time = 0.5
	clearTimer.timeout.connect(_on_clearTimer_timeout)
	add_child(clearTimer)

func _on_clearTimer_timeout():
	emit_signal("clear", self)

func begin_clear() -> void:
	clearing = true
	clearTimer.start()
	$AnimationPlayer.play(&"clear")

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
