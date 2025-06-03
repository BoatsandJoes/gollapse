extends Node
class_name Randomizer
var pieces: Array[Array] # array of array of dicts of color, shape, orientation, rootOffset

func init(colors: int):
	for i in range(1000):
		var group: Array[Dictionary] = []
		#todo include compound groups
		group.append({&"color": i % colors, &"shape": randi_range(0,3), &"orientation": 0,
		&"rootOffset": Vector2i(0,0)})
		pieces.append(group)

func get_piece(index: int) -> Array[Dictionary]:
	return pieces[index]
