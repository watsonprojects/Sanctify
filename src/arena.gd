extends Node3D

class_name Arena

const CUBE_SCENE = preload("res://prefabs/cube.tscn")

var grid_width = 8
var grid_length = 8
var mines = 8

var board = []
var max_flag_count = 8
var flag_count = 0
var lost = false
var board_init = false
var revealing_multi = false
var top_view = false

@onready var cursor: Cursor = $Cursor

# Called when the node enters the scene tree for the first time.
func _ready():
	arrange_grid()
	cursor.move(Vector2i(-1 + grid_length / 2, grid_width - 1))

func _process(delta):
	if Input.get_action_strength("cursor_joy_up") > 0.5:
		if cursor.target_pos.y > 0:
			cursor.move(Vector2(0, -1))
	elif Input.get_action_strength("cursor_joy_down") > 0.5:
		if cursor.target_pos.y < grid_length - 1:
			cursor.move(Vector2(0, 1))
	elif Input.get_action_strength("cursor_joy_left") > 0.5:
		if cursor.target_pos.x > 0:
			cursor.move(Vector2(-1, 0))
	elif Input.get_action_strength("cursor_joy_right") > 0.5:
		if cursor.target_pos.x < grid_width - 1:
			cursor.move(Vector2(1, 0))

func _input(event):
	var e = event as InputEvent

	if e.is_action("cursor_up"):
		if cursor.target_pos.y > 0:
			cursor.move(Vector2(0, -1))
	elif e.is_action("cursor_down"):
		if cursor.target_pos.y < grid_length - 1:
			cursor.move(Vector2(0, 1))
	elif e.is_action("cursor_left"):
		if cursor.target_pos.x > 0:
			cursor.move(Vector2(-1, 0))
	elif e.is_action("cursor_right"):
		if cursor.target_pos.x < grid_width - 1:
			cursor.move(Vector2(1, 0))
			
	if e.is_action_pressed("cursor_flag"):
		(board[cursor.target_pos.x][cursor.target_pos.y] as Cube).flag()
	elif e.is_action_pressed("cursor_reveal"):
		var cube = board[cursor.target_pos.x][cursor.target_pos.y] as Cube
		if not revealing_multi:
			reveal_recursive(cube.board_pos)
			
	if e.is_action_pressed("switch_view"):
		switch_view()

func arrange_grid():
	board = []
	for x in range(grid_length):
		var row = []
		for z in range(grid_width):
			var cube_instance = CUBE_SCENE.instantiate() as Cube  # Create an instance of the cube scene
			row.append(cube_instance)
			# Set the cube's position in the grid
			var position = Vector3(
				x,  # X-position based on grid column
				0,  # Y-position (you can change this if you want to stack cubes)
				z   # Z-position based on grid row
			)
			cube_instance.position = position
			cube_instance.board_pos = Vector2i(x, z)

			# Add the cube to the scene
			add_child(cube_instance)
		board.append(row)

func arrange_mines(exc: Vector2i):
	board_init = true
	var m = 0
	while m < mines:
		var i = randi_range(0, grid_length - 1)
		var j = randi_range(0, grid_width - 1)
		
		if i == exc.x and j == exc.y:
			continue
			
		if not (board[i][j] as Cube).is_mine:
			(board[i][j] as Cube).is_mine = true
			m += 1

func reveal_recursive(start_position: Vector2i):
	const matrix = [[-1, 0], [1, 0], [0, -1], [0, 1]]
	var queue = []
	
	if (board[start_position.x][start_position.y] as Cube).is_mine:
		print("YOU LOST")
		return

	# Add the first clicked cell to the queue
	queue.append(start_position)
	revealing_multi = true

	while queue.size() > 0:
		var current_pos = queue.pop_front()
		var x = current_pos.x
		var y = current_pos.y
		
		if x < 0 or x >= grid_length or y < 0 or y >= grid_width:
			continue
			
		var cube = board[x][y] as Cube
		# Skip if this cell is out of bounds or already revealed
		if cube.revealed or cube.is_mine:
			if cube.is_mine:
				print("Is mine")
			else:
				print("Already done", cube.get_nearby_mines())
			continue

		cube.reveal()

		if cube.get_nearby_mines() > 0:
			continue

		# Otherwise, add all neighboring cells to the queue to reveal them
		for m in matrix:
			var neighbor_pos = Vector2(x + m[0], y + m[1])
			# Add the neighbor to the queue for further processing
			queue.append(neighbor_pos)

	revealing_multi = false

func switch_view():
	top_view = !top_view
	if top_view:
		$IsoCam.set_priority(0)
		$TopCam.set_priority(10)
	else:
		$IsoCam.set_priority(10)
		$TopCam.set_priority(0)
		
