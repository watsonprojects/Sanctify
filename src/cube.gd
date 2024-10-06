extends Area3D

class_name Cube

var nearby_mines = 0
var revealed = false
var is_mine = false

var board_pos: Vector2i

@onready var arena: Arena = get_parent()
@onready var flag_mesh: Node3D = $Flag
@onready var reveal_decal: Decal = $Decal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func mouse_input(camera, event, event_position, normal, shape_idx):
	if (event as InputEvent).is_action_released("reveal"):
		reveal()
	if (event as InputEvent).is_action_released("flag"):
		flag()


func reveal():
	if not arena.lost and is_mine:
		arena.lost = true
		print("You lost")
	else:
		revealed = true
		flag_mesh.visible = false
		reveal_decal.visible = true
		nearby_mines = get_nearby_mines()
		print(nearby_mines)
		for i in range(7):
			if i == nearby_mines - 1:
				get_node("RuneDecals/Rune" + str(i + 1)).visible = true
			else:
				get_node("RuneDecals/Rune" + str(i + 1)).visible = false

func flag():
	if flag_mesh.visible:
		flag_mesh.visible = false
		arena.flag_count -= 1
	elif arena.flag_count < arena.max_flag_count and not revealed:
		flag_mesh.visible = true
		arena.flag_count += 1


func get_nearby_mines():
	var count = 0

	for i in range(-1, 2, 1):
		for j in range(-1, 2, 1):
			if i != 0 and j != 0:
				if board_pos.x + i > 0 and board_pos.x < arena.grid_length - 1 \
				and board_pos.y + j > 0 and board_pos.y < arena.grid_width - 1:
					if (arena.board[board_pos.x + i][board_pos.y + j] as Cube).is_mine:
						count += 1

	return count
