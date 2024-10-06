extends Area3D

class_name Cube

var nearby_mines = 0
var revealed = false
var is_mine = false

var board_pos: Vector2i

@onready var arena: Arena = get_parent()
@onready var flag_mesh: Node3D = $Flag
@onready var fog: MeshInstance3D = $Fog

@export var runes: Array[Decal]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


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
	if not arena.board_init:
		arena.arrange_mines(board_pos)

	if not arena.lost and is_mine:
		arena.lost = true
		print("You lost")
	else:
		revealed = true
		flag_mesh.visible = false
		fog.visible = false
		nearby_mines = get_nearby_mines()
		print(nearby_mines)
		update_hint()
		
func update_hint():
	for i in range(1, 7):
			if i == nearby_mines:
				runes[i].visible = true
			else:
				runes[i].visible = false

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
	
func set_puddle():
	if $Puddle.visible:
		return false
		
	$Puddle.visible = true
	return true
