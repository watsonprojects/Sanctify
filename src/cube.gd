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
		if not arena.revealing_multi:
			arena.reveal_recursive(board_pos)
	if (event as InputEvent).is_action_released("flag"):
		flag()


func reveal():
	print("revealing")
	if not arena.board_init:
		arena.arrange_mines(board_pos)

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

	# Loop through all the neighboring cells (including diagonals)
	for dx in range(-1, 2):  # -1, 0, 1
		for dy in range(-1, 2):  # -1, 0, 1
			# Skip the current cell itself
			if dx == 0 and dy == 0:
				continue

			var neighbor_x = board_pos.x + dx
			var neighbor_y = board_pos.y + dy

			# Check bounds to avoid accessing out-of-bounds array indices
			if neighbor_x >= 0 and neighbor_x < arena.grid_length and neighbor_y >= 0 and neighbor_y < arena.grid_width:
				if (arena.board[neighbor_x][neighbor_y] as Cube).is_mine:
					count += 1

	return count
