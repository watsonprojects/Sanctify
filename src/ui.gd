extends Control

class_name UI

var dark_theme: Theme
var light_theme: Theme

var dark = DisplayServer.is_dark_mode()

signal on_switch_view

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
			
func update_time(seconds: float):
	var hours = int(seconds / 3600)
	var minutes = int(fmod(seconds, 3600) / 60)
	var secs = int(fmod(seconds, 60.0))

	var time_str = ''
	# If the time is an hour or more, format as HH:MM:SS
	if hours > 0:
		time_str = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(secs).pad_zeros(2)
	else:
		# Otherwise, format as MM:SS
		time_str = str(minutes).pad_zeros(2) + ":" + str(secs).pad_zeros(2)
		
	$VBoxContainer/UI/StatusBox/TimeLabel.text = time_str

func start_over():
	get_tree().change_scene_to_file("res://arena.tscn")
	
func give_up():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func switch_view():
	on_switch_view.emit()
