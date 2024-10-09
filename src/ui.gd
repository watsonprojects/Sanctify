extends Control

class_name UI

var dark_theme: Theme
var light_theme: Theme

var dark = DisplayServer.is_dark_mode()
var end_game = false

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
	if end_game:
		return
		
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
	$PostGame/VBoxContainer/FinalLabel.text = "EvadeD"
	$PostGame/VBoxContainer/StoryLabel.text = "The curse still haunts this place"
	$PostGame/VBoxContainer/StatusLabel.text = "All hope is lost!"
	$PostGame/WinningTexture.visible = false
	$PostGame/LosingTexture.visible = false
	$AnimationPlayer.play("end_game")
	end_game = true
	
func go_back():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func switch_view():
	on_switch_view.emit()
	
func win(final_word: String, seconds: float):
	$PostGame/VBoxContainer/FinalLabel.text = "SanctifieD"
	$PostGame/VBoxContainer/StoryLabel.text = final_word
	var hours = int(seconds / 3600)
	var minutes = int(fmod(seconds, 3600) / 60)
	var secs = int(fmod(seconds, 60.0))
	end_game = true

	var time_str = ''
	# If the time is an hour or more, format as HH:MM:SS
	if hours > 0:
		time_str = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(secs).pad_zeros(2)
	else:
		# Otherwise, format as MM:SS
		time_str = str(minutes).pad_zeros(2) + ":" + str(secs).pad_zeros(2)
	$PostGame/VBoxContainer/StatusLabel.text = "Time Taken: " + time_str
	$PostGame/WinningTexture.visible = true
	$PostGame/LosingTexture.visible = false
	$AnimationPlayer/EndTimer.start()
	
	
func lose(final_word: String, tiles_left: int):
	$PostGame/VBoxContainer/FinalLabel.text = "DefeateD"
	$PostGame/VBoxContainer/StoryLabel.text = final_word
	$PostGame/VBoxContainer/StatusLabel.text = "Tiles Left: " + str(tiles_left)
	$PostGame/WinningTexture.visible = false
	$PostGame/LosingTexture.visible = true
	$AnimationPlayer/EndTimer.start()
	end_game = true
