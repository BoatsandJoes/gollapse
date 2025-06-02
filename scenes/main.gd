extends Node2D
class_name Main

const shapes: Array[Array] = [[{&"spriteOffset": Vector2i(0,0), &"occupies": [Vector2i(0,0)],
&"liberties": [Vector2i(0,-1), Vector2i(-1,0), Vector2i(1,0), Vector2i(0,1)], &"pointsBelow": [Vector2i(0,1)]}],
[{&"spriteOffset": Vector2i(16,0), &"occupies": [Vector2i(0,0), Vector2i(1,0)],
&"liberties": [Vector2i(0,-1), Vector2i(1,-1), Vector2i(-1,0), Vector2i(2,0), Vector2i(0,1), Vector2i(1,1)],
&"pointsBelow": [Vector2i(0,1), Vector2i(1,1)]},
{&"spriteOffset": Vector2i(0,16), &"occupies": [Vector2i(0,0), Vector2i(0,1)],
&"liberties": [Vector2i(0,-1), Vector2i(-1,0), Vector2i(1,0), Vector2i(-1,1), Vector2i(1,1), Vector2i(0,2)],
&"pointsBelow": [Vector2i(0,2)]},
{&"spriteOffset": Vector2i(-16,0), &"occupies": [Vector2i(-1,0), Vector2i(0,0)],
&"liberties": [Vector2i(-1,-1), Vector2i(0,-1), Vector2i(-2,0), Vector2i(1,0), Vector2i(-1,1), Vector2i(0,1)],
&"pointsBelow": [Vector2i(-1,1), Vector2i(0,1)]},
{&"spriteOffset": Vector2i(0,-16), &"occupies": [Vector2i(0,-1), Vector2i(0,0)],
&"liberties": [Vector2i(0,-2), Vector2i(-1,-1), Vector2i(1,-1), Vector2i(-1,0), Vector2i(1,0), Vector2i(0,1)],
&"pointsBelow": [Vector2i(0,1)]}],
[{&"spriteOffset": Vector2i(0,0), &"occupies": [Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0)],
&"liberties": [Vector2i(-1,-1), Vector2i(0,-1), Vector2i(1,-1), Vector2i(-2,0), Vector2i(2,0),
Vector2i(-1,1), Vector2i(0,1), Vector2i(1,1)],
&"pointsBelow": [Vector2i(-1,1), Vector2i(0,1), Vector2i(1,1)]},
{&"spriteOffset": Vector2i(0,0), &"occupies": [Vector2i(0,-1), Vector2i(0,0), Vector2i(0,1)],
&"liberties": [Vector2i(0,-2), Vector2i(-1,-1), Vector2i(1,-1), Vector2i(-1,0), Vector2i(1,0),
Vector2i(-1,1), Vector2i(1,1), Vector2i(0,2)],
&"pointsBelow": [Vector2i(0,2)]}],
[{&"spriteOffset": Vector2i(16,16), &"occupies": [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1)],
&"liberties": [Vector2i(0,-1), Vector2i(1,-1), Vector2i(-1,0), Vector2i(2,0),
Vector2i(-1,1), Vector2i(1,1), Vector2i(0,2)],
&"pointsBelow": [Vector2i(1,1), Vector2i(0,2)]},
{&"spriteOffset": Vector2i(-16,16), &"occupies": [Vector2i(-1,0), Vector2i(0,0), Vector2i(0,1)],
&"liberties": [Vector2i(-1,-1), Vector2i(0,-1), Vector2i(-2,0), Vector2i(1,0),
Vector2i(-1,1), Vector2i(1,1), Vector2i(0,2)],
&"pointsBelow": [Vector2i(-1,1), Vector2i(0,2)]},
{&"spriteOffset": Vector2i(-16,-16), &"occupies": [Vector2i(0,-1), Vector2i(-1,0), Vector2i(0,0)],
&"liberties": [Vector2i(0,-2), Vector2i(-1,-1), Vector2i(1,-1), Vector2i(-2,0),
Vector2i(1,0), Vector2i(-1,1), Vector2i(0,1)],
&"pointsBelow": [Vector2i(-1,1), Vector2i(0,1)]},
{&"spriteOffset": Vector2i(16,-16), &"occupies": [Vector2i(0,-1), Vector2i(0,0), Vector2i(1,0)],
&"liberties": [Vector2i(0,-2), Vector2i(-1,-1), Vector2i(1,-1), Vector2i(-1,0),
Vector2i(2,0), Vector2i(0,1), Vector2i(1,1)],
&"pointsBelow": [Vector2i(0,1), Vector2i(1,1)]}
]]
const colors: Array[StringName] = [&"white", &"black"]
var textures: Array[Array] = []
var MainMenu = preload("res://scenes/ui/menus/MainMenu.tscn")
var GameManager = preload("res://scenes/managers/GameManager.tscn")
var scene

func _ready() -> void:
	for i in range(colors.size()):
		textures.append([])
		for j in range(shapes.size()):
			textures[i].append([])
			for k in range(shapes[i].size()):
				textures[i][j].append(load("res://assets/sprites/"
				+ colors[i] + "_" + str(j) + "_" + str(k) + ".png"))
	go_to_game()

func remove_scene():
	if scene != null:
		remove_child(scene)
		scene.queue_free()
		scene = null

func go_to_game():
	remove_scene()
	scene = GameManager.instantiate()
	scene.textures = textures
	scene.shapes = shapes
	# todo connect signals
	add_child(scene)
