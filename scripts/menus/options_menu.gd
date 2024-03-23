extends Control

# Variables
@onready var main = $Main
@onready var music = $AudioManager/Music
@onready var sfx =  $AudioManager/SFX

var music_bus_name = "Music"
var music_bus_index = 20
var sfx_bus_name = "SFX"
var sfx_bus_index = 20

@onready var musicPlayer: AudioStreamPlayer = $AudioManager/Music
@onready var sfxPlayer: AudioStreamPlayer = $AudioManager/SFX

func _ready():
	_get_Music_Name()
	_on_music_slider_value_changed(20)
	
	_get_SFX_Name()
	_on_sfx_slider_value_changed(20)

# Functions
func _enter_tree():
	$Main.show()

func _on_main_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/pause_menu.tscn")

func _on_fullscreen_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _get_Music_Name():
	music_bus_index = AudioServer.get_bus_index(music_bus_name)
	print("Custom audio bus index:", music_bus_index)

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus_index, value)
	print("Music volume changed to:", value)

func _get_SFX_Name():
	sfx_bus_index = AudioServer.get_bus_index(sfx_bus_name)
	print("SFX bus index:", sfx_bus_index)

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_index, value)
	print("SFX volume changed to:", value)

# Button event handlers
func _on_music_test_pressed():
	musicPlayer.play()

func _on_sfx_test_pressed():
	sfxPlayer.play()
