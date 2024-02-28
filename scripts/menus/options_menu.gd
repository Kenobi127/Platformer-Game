extends Control

# Variables
@onready var options = $Options
@onready var video = $Video
@onready var audio = $Audio
@onready var music = $AudioManager/Music
@onready var sfx =  $AudioManager/SFX

var music_bus_name = "Music"
var music_bus_index = 0
var sfx_bus_name = "sfx"
var sfx_bus_index = 0

@onready var musicPlayer: AudioStreamPlayer = $AudioManager/Music
@onready var sfxPlayer: AudioStreamPlayer = $AudioManager/SFX

# Functions
func _on_volume_pressed():
	pass # Replace with function body.

func _on_back_to_main_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn") # Replace with function body.

func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_audio_pressed():
	show_and_hide(audio, options)

func _on_video_pressed():
	show_and_hide(video, options)

func _on_back_to_option_video_pressed():
	show_and_hide(options, video)

func _on_back_to_option_audio_pressed():
	show_and_hide(options, audio)

func _on_fullscreen_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _get_Music_Name():
	music_bus_index = AudioServer.get_bus_index(music_bus_name)
	print("Custom audio bus index:", music_bus_index)

func _on_music_value_changed(value):
	# Ensure the custom bus index is valid
		# Adjust the volume of the custom bus based on the slider's value
	AudioServer.set_bus_volume_db(music_bus_index, value)
	print("Music volume changed to:", value)

func _get_SFX_Name():
	sfx_bus_index = AudioServer.get_bus_index(sfx_bus_name)
	print("SFX bus index:", sfx_bus_index)

func _on_sound_fx_value_changed(value):
	# Ensure the custom bus index is valid
	# Adjust the volume of the custom bus based on the slider's value
	AudioServer.set_bus_volume_db(sfx_bus_index, value)
	print("SFX volume changed to:", value)

# Button event handlers
func _on_test_music_button_pressed():
	musicPlayer.play()

func _on_test_sfx_button_pressed():
	sfxPlayer.play()
