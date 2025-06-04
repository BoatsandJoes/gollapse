extends Node
class_name Controller

var keyboard: bool = true
var device: int = -1
var DAS: float = 1.0/6.0
var ARR: float = 0.05

var direction: Vector2i = Vector2i(0,0)
var horizontalHeldFor: float = 0.0
var verticalHeldFor: float = 0.0
var cw: bool = false
var ccw: bool = false
var place: bool = false
var pause: bool = false
var accept: bool = false
var cancel: bool = false

func poll_input(delta: float) -> void:
	#todo respect devices
	cw = Input.is_action_just_pressed(&"cw")
	ccw = Input.is_action_just_pressed(&"ccw")
	if cw && ccw:
		cw = false
		ccw = false
	place = Input.is_action_just_pressed(&"place")
	pause = Input.is_action_just_pressed(&"pause")
	accept = Input.is_action_just_pressed(&"select")
	cancel = Input.is_action_just_pressed(&"cancel")
	var newDirection: Vector2i = Vector2i(0,0)
	#socd last wins option commented out because das doesn't work with it
	#if Input.is_action_just_pressed("up") && Input.is_action_just_pressed("down"):
	#	newDirection.y = 0
	#elif Input.is_action_just_pressed("up"):
	#	newDirection.y = -1
	#elif Input.is_action_just_pressed("down"):
	#	newDirection.y = 1
	#if Input.is_action_just_pressed("left") && Input.is_action_just_pressed("right"):
	#	newDirection.x = 0
	#elif Input.is_action_just_pressed("left"):
	#	newDirection.x = -1
	#elif Input.is_action_just_pressed("right"):
	#	newDirection.x = 1
	if(newDirection.y == 0):
		if Input.is_action_pressed("up"):
			newDirection.y = newDirection.y - 1
		if Input.is_action_pressed("down"):
			newDirection.y = newDirection.y + 1
	if(newDirection.x == 0):
		if Input.is_action_pressed("left"):
			newDirection.x = newDirection.x - 1
		if Input.is_action_pressed("right"):
			newDirection.x = newDirection.x + 1
	if newDirection.x != direction.x:
		horizontalHeldFor = 0.0
	elif direction.x != 0:
		horizontalHeldFor = horizontalHeldFor + delta
	if newDirection.y != direction.y:
		verticalHeldFor = 0.0
	elif direction.y != 0:
		verticalHeldFor = verticalHeldFor + delta
	direction = newDirection
