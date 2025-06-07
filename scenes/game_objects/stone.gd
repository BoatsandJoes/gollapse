extends Node2D
class_name Stone

signal clear(stone: Stone)
signal land(stone: Stone)

var rootPoint: Vector2i
#use these to index into shapes array: shapes[shape][orientation]
var shape: int
var orientation: int = 0
var color: int #concat colors[color] and shapes[shape][orientation][&"spriteTexture"]
var clearable: bool = true
var clearing: bool = false
var falling: bool = false
var fallThreshold: float = 0.2
var fallCounter: float = fallThreshold / 2.0
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
	if color == 2:
		$Sprite2D.set_modulate(Color.from_rgba8(228, 58, 147))
	else:
		$Sprite2D.set_modulate(Color(1, 1, 1))

func spin(orientation: int, shapes: Array[Array], textures: Array[Array]) -> void:
	self.orientation = orientation
	$Sprite2D.position = shapes[shape][orientation][&"spriteOffset"]
	$Sprite2D.texture = textures[color][shape][orientation % textures[color][shape].size()]

func move(offset: Vector2i) -> void:
	rootPoint = rootPoint + offset

func advance_fall(delta: float, cap: float) -> bool: #cap of less than 0 represents a solid floor
	var tempFalling: bool = falling
	falling = true
	fallCounter = fallCounter + delta
	if cap < 0.0 && fallCounter >= fallThreshold / 2.0:
		fallCounter = fallThreshold / 2.0
		falling = false
		if tempFalling:
			emit_signal("land", self)
	elif cap >= 0.0 && fallCounter > cap:
		fallCounter = cap
	elif fallCounter > fallThreshold:
		fallCounter = fallCounter - fallThreshold
		return true # True indicates we crossed a cell boundary
	return false #no boundary crossed
