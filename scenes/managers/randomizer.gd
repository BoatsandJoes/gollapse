extends Node
class_name Randomizer
const groups: Array[Array] = [
	# 1 (randomizer deals these out at a fixed rate)
	# [[{&"shape": 0, &"orientation": 0, &"offset": Vector2i(0,0)}]],
	# 2
	[[{&"shape": 1, &"orientation": 0, &"offset": Vector2i(0,0)}]],
	# straight 3
	[[{&"shape": 2, &"orientation": 0, &"offset": Vector2i(0,0)}]],
	# bent 3
	[[{&"shape": 3, &"orientation": 0, &"offset": Vector2i(0,0)}]],
	#=
	[[{&"shape": 0, &"orientation": 0, &"offset": Vector2i(-1,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,0)}]],
	#T
	[[{&"shape": 3, &"orientation": 0, &"offset": Vector2i(0,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(-1,0)}],
	[{&"shape": 3, &"orientation": 1, &"offset": Vector2i(0,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,0)}]],
	#L
	[[{&"shape": 3, &"orientation": 0, &"offset": Vector2i(-1,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,0)}],
	[{&"shape": 1, &"orientation": 0, &"offset": Vector2i(0,0)},
		{&"shape": 1, &"orientation": 1, &"offset": Vector2i(-1,0)}]],
	#J
	[[{&"shape": 3, &"orientation": 1, &"offset": Vector2i(1,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(-1,0)}],
	[{&"shape": 1, &"orientation": 0, &"offset": Vector2i(-1,0)},
		{&"shape": 1, &"orientation": 1, &"offset": Vector2i(1,0)}]],
	#S
	[[{&"shape": 3, &"orientation": 0, &"offset": Vector2i(0,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(-1,1)}]],
	#Z
	[[{&"shape": 3, &"orientation": 1, &"offset": Vector2i(0,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,1)}]],
	#smashboy
	[[{&"shape": 3, &"orientation": 0, &"offset": Vector2i(0,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,1)}]]
]
var pieces: Array[Array] # array of array of dicts of color, shape, orientation, rootOffset

func init(colors: int):
	var piecesPerSingle: int = colors + 1 #ensures that we rotate through all colors
	for i in range(1000):
		var group: Array[Dictionary] = []
		var choice = groups[randi_range(0, groups.size() - 1)]
		choice = choice[randi_range(0, choice.size() - 1)]
		if i != 0 && i % piecesPerSingle == 0:
			# Deal a single.
			choice = [{&"shape": 0, &"orientation": 0, &"offset": Vector2i(0,0)}]
		for spec in choice:
			group.append({&"color": i % colors, &"shape": spec[&"shape"], &"orientation": spec[&"orientation"],
		&"rootOffset": spec[&"offset"]})
		pieces.append(group)

func get_piece(index: int) -> Array[Dictionary]:
	return pieces[index]
