extends Node3D

class_name Arena

const CUBE_SCENE = preload("res://prefabs/cube.tscn")

var grid_width = 8
var grid_length = 8
var mines = 16

var board = []
var max_flag_count = 8
var flag_count = 0
var lost = false

@onready var cursor: Cursor = $Cursor

# Called when the node enters the scene tree for the first time.
func _ready():
	arrange_grid()
	cursor.move(Vector2i(-1 + grid_length / 2, grid_width - 1))

	
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
		(board[cursor.target_pos.x][cursor.target_pos.y] as Cube).reveal()

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
	
	var m = 0
	while m < mines:
		var i = randi_range(0, grid_length - 1)
		var j = randi_range(0, grid_width - 1)
		
		if not (board[i][j] as Cube).is_mine:
			(board[i][j] as Cube).is_mine = true
			m += 1
