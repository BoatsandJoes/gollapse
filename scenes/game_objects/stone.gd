extends Node2D
class_name Stone

const shapes: Array = [[{&"spriteTexture": "1.png", &"spriteOffset": Vector2i(0,0),
&"occupies": [Vector2i(0,0)], &"liberties": [Vector2i(0,1), Vector2i(1,0), Vector2i(-1,0),Vector2i(0,-1)],
&"pointsBelow": [Vector2i(0,1)]}],
#todo rest of occupies, liberties, and pointsBelow. I put 0,0 in all occupies, but nothing else.
[{&"spriteTexture": "2straight1.png", &"spriteOffset": Vector2i(16,0),
&"occupies": [Vector2i(0,0)], &"liberties": [], &"pointsBelow": []},
{&"spriteTexture": "2straight2.png", &"spriteOffset": Vector2i(0,16),
&"occupies": [Vector2i(0,0)], &"liberties": [], &"pointsBelow": []},
{&"spriteTexture": "2straight1.png", &"spriteOffset": Vector2i(-16,0),
&"occupies": [Vector2i(0,0)], &"liberties": [], &"pointsBelow": []},
{&"spriteTexture": "2straight2.png", &"spriteOffset": Vector2i(0,-16),
&"occupies": [Vector2i(0,0)], &"liberties": [], &"pointsBelow": []}],
[{&"spriteTexture": "3straight1.png", &"spriteOffset": Vector2i(0,0),
&"occupies": [Vector2i(0,0)], &"liberties": [], &"pointsBelow": []},
{&"spriteTexture": "3straight2.png", &"spriteOffset": Vector2i(0,0),
&"occupies": [Vector2i(0,0)], &"liberties": [], &"pointsBelow": []}],
[{&"spriteTexture": "3bent1.png", &"spriteOffset": Vector2i(16,16),
&"occupies": [Vector2i(0,0)], &"liberties": [], &"pointsBelow": []},
{&"spriteTexture": "3bent2.png", &"spriteOffset": Vector2i(-16,16),
&"occupies": [Vector2i(0,0)], &"liberties": [], &"pointsBelow": []},
{&"spriteTexture": "3bent3.png", &"spriteOffset": Vector2i(-16,-16),
&"occupies": [Vector2i(0,0)], &"liberties": [], &"pointsBelow": []},
{&"spriteTexture": "3bent4.png", &"spriteOffset": Vector2i(16,-16),
&"occupies": [Vector2i(0,0)], &"liberties": [], &"pointsBelow": []}]
]
const colors: Array[StringName] = [&"white", &"black"]
var occupies: Array[int] = []
var liberties: Array[int] = []
var pointsBelow: Array[int] = []
var rootPoint: int
#use these to index into shapes array: shapes[shape][orientation]
var shape: int
var orientation: int
var color: int #concat colors[color] and shapes[shape][orientation][&"spriteTexture"]

func _ready() -> void:
	pass

func move(offset: int) -> void: #Usually, offset will be width, for falling one row.
	for i in range(occupies.size()):
		occupies[i] = occupies[i] + offset
	for i in range(liberties.size()):
		liberties[i] = liberties[i] + offset
	for i in range(pointsBelow.size()):
		pointsBelow[i] = pointsBelow[i] + offset
