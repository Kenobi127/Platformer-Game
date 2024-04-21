extends CanvasLayer

signal return_title

var music_bus_index: int
var sfx_bus_index: int


func _ready():
	# Hide pause menu once in tree
	hide()
	_on_music_slider_value_changed(0.5)
	_on_sfx_slider_value_changed(0.5)


func _input(event):
	# Check if esc is pressed and swap paused state
	if event.is_action_pressed("pause") && !SceneManager.win_screen.visible && SceneManager.current_scene.name!="Menu" && SceneManager.current_scene.name!="CreditsCanvas":
		$PauseControl/ButtonPressed.play()
		if get_tree().paused == false:
			get_tree().paused = true
			show()
		else:
			get_tree().paused = false
			hide()

func _on_full_choice_toggled(toggled_on):
	$PauseControl/ButtonPressed.play()
	# Shift screen between windowed and fullscreen
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func _on_return_title_pressed():
	$PauseControl/BackToMenu.play()
	# Hide the pause menu
	hide()
	# Unpause tree
	get_tree().paused = false
	# Emit signal to return to title screen
	SceneManager.load_scene("res://scenes/menus/menu.tscn")

func _on_music_slider_value_changed(value):
	music_bus_index = AudioServer.get_bus_index("Music")
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(music_bus_index, db)

func _on_sfx_slider_value_changed(value):
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(sfx_bus_index, db)
	

func _on_music_slider_drag_started() -> void:
	$PauseControl/ButtonPressed.play()


func _on_sfx_slider_drag_started() -> void:
	$PauseControl/ButtonPressed.play()
