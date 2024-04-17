extends CanvasLayer

signal return_title

var music_bus_name = "Music"
var music_bus_index = 20
var sfx_bus_name = "SFX"
var sfx_bus_index = 20
var pause = false

func _ready():
	# Hide pause menu once in tree
	#_get_Music_Name()
	#_on_music_slider_value_changed(20)
	hide()
	
	#_get_SFX_Name()
	#_on_sfx_slider_value_changed(20)
	
func _input(event):
	# Check if esc is pressed and swap paused state
	if event.is_action_pressed("pause"):
		$PauseControl/PauseAudio.play()
		if pause == false:
			pause = true
			get_tree().paused = true
			show()
		else:
			pause = false
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
	$PauseControl/ButtonPressed.play()
	# Hide the pause menu
	hide()
	# Unpause tree
	get_tree().paused = false
	pause = false
	# Emit signal to return to title screen
	SceneManager.load_scene("res://scenes/menus/menu.tscn")


#func _get_Music_Name():
#	music_bus_index = AudioServer.get_bus_index(music_bus_name)
#	print("Custom audio bus index:", music_bus_index)

func _on_music_slider_value_changed(value):
	music_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus_index, value)
	print("Music volume changed to:", value)

#func _get_SFX_Name():
#	sfx_bus_index = AudioServer.get_bus_index(sfx_bus_name)
#	print("SFX bus index:", sfx_bus_index)
#
func _on_sfx_slider_value_changed(value):
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_bus_index, value)
	print("SFX volume changed to:", value)
