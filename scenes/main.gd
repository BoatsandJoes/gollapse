extends Node2D
class_name Main

var MainMenu = preload("res://scenes/ui/menus/MainMenu.tscn")
var GameManager = preload("res://scenes/managers/GameManager.tscn")
var scene

func _ready() -> void:
	go_to_game()

func remove_scene():
	if scene != null:
		remove_child(scene)
		scene.queue_free()
		scene = null

func go_to_game():
	remove_scene()
	scene = GameManager.instantiate()
	# todo connect signals
	add_child(scene)
