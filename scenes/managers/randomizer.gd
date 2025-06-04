extends Node
class_name Randomizer
const groups: Array[Array] = [
	# 1
	[[{&"shape": 0, &"orientation": 0, &"offset": Vector2i(0,0)}]],
	# 2
	[[{&"shape": 1, &"orientation": 0, &"offset": Vector2i(0,0)}],
	[{&"shape": 0, &"orientation": 0, &"offset": Vector2i(0,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,0)}]],
	# straight 3
	[[{&"shape": 2, &"orientation": 0, &"offset": Vector2i(0,0)}],
	[{&"shape": 0, &"orientation": 0, &"offset": Vector2i(0,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(-1,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,0)}],
	[{&"shape": 1, &"orientation": 0, &"offset": Vector2i(-1,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,0)}]],
	# bent 3
	[[{&"shape": 3, &"orientation": 0, &"offset": Vector2i(0,0)}],
	[{&"shape": 0, &"orientation": 0, &"offset": Vector2i(0,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(0,1)}],
	[{&"shape": 1, &"orientation": 1, &"offset": Vector2i(0,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,0)}]],
	#=[],
	#T[],
	#L[],
	#J[],
	#S[],
	#Z[],
	#smashboy
	[[{&"shape": 0, &"orientation": 0, &"offset": Vector2i(0,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(0,1)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,1)}],
	[{&"shape": 1, &"orientation": 1, &"offset": Vector2i(0,0)},
		{&"shape": 1, &"orientation": 1, &"offset": Vector2i(1,0)}],
	[{&"shape": 3, &"orientation": 0, &"offset": Vector2i(0,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,1)}],
	[{&"shape": 1, &"orientation": 1, &"offset": Vector2i(0,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,0)},
		{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,1)}]]
]
var pieces: Array[Array] # array of array of dicts of color, shape, orientation, rootOffset

func init(colors: int):
	for i in range(1000):
		var group: Array[Dictionary] = []
		#todo include compound groups
		var choice = groups[randi_range(0, groups.size() - 1)]
		choice = choice[randi_range(0, choice.size() - 1)]
		for spec in choice:
			group.append({&"color": i % colors, &"shape": spec[&"shape"], &"orientation": spec[&"orientation"],
		&"rootOffset": spec[&"offset"]})
		pieces.append(group)

func get_piece(index: int) -> Array[Dictionary]:
	return pieces[index]
