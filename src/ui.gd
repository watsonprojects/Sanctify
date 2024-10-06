extends Control

var dark_theme: Theme
var light_theme: Theme

var dark = DisplayServer.is_dark_mode()

# Called when the node enters the scene tree for the first time.
func _ready():
	dark_theme = preload("res://data/elementary_dark.theme")
	light_theme = preload("res://data/elementary_light.theme")
	
	if dark:
		theme = dark_theme
		
	else:
		theme = light_theme

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if DisplayServer.is_dark_mode() != dark:
		dark = DisplayServer.is_dark_mode()
		if dark:
			theme = dark_theme
		else:
			theme = light_theme

func start_over():
	get_tree().change_scene_to_file("res://arena.tscn")
	
func give_up():
	get_tree().change_scene_to_file("res://main_menu.tscn")
