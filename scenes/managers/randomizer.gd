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
	#2 2 L / J
	[[{&"shape": 1, &"orientation": 0, &"offset": Vector2i(0,0)},
		{&"shape": 1, &"orientation": 1, &"offset": Vector2i(-1,0)}],
	[{&"shape": 1, &"orientation": 0, &"offset": Vector2i(-1,0)},
		{&"shape": 1, &"orientation": 1, &"offset": Vector2i(1,0)}]],
	#Bent 3 + 1 all grouped together
	[
		#T
		[{&"shape": 3, &"orientation": 0, &"offset": Vector2i(0,0)},
			{&"shape": 0, &"orientation": 0, &"offset": Vector2i(-1,0)}],
		[{&"shape": 3, &"orientation": 1, &"offset": Vector2i(0,0)},
			{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,0)}],
		#L
		[{&"shape": 3, &"orientation": 0, &"offset": Vector2i(-1,0)},
			{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,0)}],
		#J
		[{&"shape": 3, &"orientation": 1, &"offset": Vector2i(1,0)},
			{&"shape": 0, &"orientation": 0, &"offset": Vector2i(-1,0)}],
		#S
		[{&"shape": 3, &"orientation": 0, &"offset": Vector2i(0,0)},
			{&"shape": 0, &"orientation": 0, &"offset": Vector2i(-1,1)}],
		#Z
		[{&"shape": 3, &"orientation": 1, &"offset": Vector2i(0,0)},
			{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,1)}],
		#smashboy
		[{&"shape": 3, &"orientation": 0, &"offset": Vector2i(0,0)},
			{&"shape": 0, &"orientation": 0, &"offset": Vector2i(1,1)}]
	]
]
var pieces: Array[Array] # array of array of dicts of color, shape, orientation, rootOffset
var garbageRows: Array[Array] # array of array of dicts of color, shape, orientation, rootOffset

func init(colors: int, width: int):
	var piecesPerSingle: int = colors + 1 #ensures that we rotate through all colors
	for i in range(1000):
		var group: Array[Dictionary] = []
		var choice = groups[randi_range(0, groups.size() - 3)] #exclude the 2 meanest groups
		choice = choice[randi_range(0, choice.size() - 1)]
		if i != 0 && i % piecesPerSingle == 0:
			# Deal a single.
			choice = [{&"shape": 0, &"orientation": 0, &"offset": Vector2i(0,0)}]
		for spec in choice:
			group.append({&"color": i % colors, &"shape": spec[&"shape"], &"orientation": spec[&"orientation"],
		&"rootOffset": spec[&"offset"]})
		pieces.append(group)
	#simple version of garbage rows. Each cell has an x% chance to be on.
	#If adjacent cells are on, they clump together (left priority). Clumps get a random color.
	#If all cells are empty, one shape is added at random.
	for i in range(500):
		var row: Array[Dictionary] = []
		for col in range(width):
			if randf() < 0.3:
				if (!row.is_empty() && row[row.size() - 1][&"rootOffset"] == Vector2i(col - 1, 0)
				&& row[row.size() - 1][&"shape"] != 2):
					#merge with previous
					row[row.size() - 1][&"shape"] = row[row.size() - 1][&"shape"] + 1
					if row[row.size() - 1][&"shape"] == 2:
						row[row.size() - 1][&"rootOffset"] = row[row.size() - 1][&"rootOffset"] + 1
				else:
					#new stone
					row.append({&"color": randi_range(0, colors - 1),
					&"shape": 0, &"orientation": 0, &"rootOffset": Vector2i(col,0)})
		if row.is_empty():
			# Add one shape at random (not to the edge). This is the simplest way to do it code-wise
			row.append({&"color": randi_range(0, colors - 1), &"shape": randi_range(0,2),
			&"orientation": 0, &"rootOffset": Vector2i(randi_range(1, width - 2),0)})
		garbageRows.append(row)

func get_piece(index: int) -> Array[Dictionary]:
	return pieces[index % pieces.size()]
