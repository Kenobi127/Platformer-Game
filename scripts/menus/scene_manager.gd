# SceneManager.gd
extends Node

@onready var gem_particles_scene = preload("res://scenes/other/gem_gpu_particles_2d.tscn")
@onready var gem_scene = preload("res://scenes/other/gem.tscn")
@onready var skeleton_scene = preload("res://scenes/character bodies/enemies/skeleton1_0.tscn")

@onready var button_sound = $ButtonPressed
@onready var music_level1 = $MusicLevel1
@onready var music_menu = $MenuMusic

var start = true
var current_scene = null
var pause_menu = null
var win_screen = null
var screen_timer = null
var screen_total_gems = null
var time_taken = 0
var total_gems = 0

signal faded_in
signal faded_out


func _ready() -> void:
	if OS.get_name().to_lower().find("android") > -1 || OS.get_name().to_lower().find("iphone") > -1:
		print("Running on a mobile platform")
	
	# Load the initial scene (menu scene)
	load_scene("res://scenes/menus/menu.tscn")
	start = false
	
	# Preload the pause menu
	pause_menu = preload("res://scenes/menus/pause_screen.tscn").instantiate()
	add_child(pause_menu)
	pause_menu.hide()
	
	#results screen for each level
	win_screen = preload("res://scenes/menus/win.tscn").instantiate()
	add_child(win_screen)
	win_screen.hide()


func _process(_delta: float) -> void:
	return
	#if Input.is_action_just_pressed("debug"):
		#SceneManager.finish_level()
		#spawn_gem()

func fade_in():
	$ScreenCenter/ScreenFader/FadePlayer.play("fade_in")
	await $ScreenCenter/ScreenFader/FadePlayer.animation_finished
	emit_signal("faded_in")
	
# Wrapper function for performing fade out animation
func fade_out():
	$ScreenCenter/ScreenFader/FadePlayer.play("fade_out")
	await $ScreenCenter/ScreenFader/FadePlayer.animation_finished
	emit_signal("faded_out")


func spawn_gem() -> void:
	var gem = SceneManager.gem_scene.instantiate()
	get_parent().add_child(gem)
	gem.position = Vector2(45, 100)


func load_scene(scene_path) -> void:
	if start == true:
		fade_in()
	else: 
		fade_out()
		await faded_out

	# Unload the current scene if there is one
	if current_scene != null:
		current_scene.queue_free()
	if screen_timer != null:
		screen_timer.queue_free()
	if screen_total_gems != null:
		screen_total_gems.queue_free()
	
	# Load the new scene
	current_scene = load(scene_path).instantiate()
	add_child(current_scene)
	
	
	#timer and gems for each level
	if current_scene.name != "Menu" && current_scene.name != "CreditsCanvas":
		music_menu.stop()
		music_level1.play()
		screen_timer = preload("res://scenes/other/timer_scene.tscn").instantiate()
		add_child(screen_timer)
		screen_total_gems = preload("res://scenes/other/gems_screen.tscn").instantiate()
		add_child(screen_total_gems)
	else:
		music_level1.stop()
	fade_in()
	await faded_in


func load_credits() -> void:
	load_scene("res://scenes/menus/credits.tscn")
	music_menu.play()
	

func start_game() -> void:
	load_scene("res://scenes/levels/Level 1/Tutorial_level.tscn")

func quit_game() -> void:
	fade_out()
	await faded_out
	get_tree().quit()


func finish_level():
	if win_screen.visible == false:
		win_screen.show_win_screen()
	
	if screen_timer != null:
		screen_timer.stop_timer()
		time_taken = screen_timer.return_timer_value()
		screen_timer.queue_free()
	if screen_total_gems != null:
		screen_total_gems.queue_free()
