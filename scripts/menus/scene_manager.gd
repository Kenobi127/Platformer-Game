# SceneManager.gd
extends Node


@onready var gem_particles_scene = preload("res://scenes/other/gem_gpu_particles_2d.tscn")
@onready var gem_scene = preload("res://scenes/other/gem.tscn")
@onready var skeleton_scene = preload("res://scenes/character bodies/enemies/skeleton1_0.tscn")

@onready var button_sound = $ButtonPressed
@onready var backround_music = $Background
@onready var menu_music = $MenuMusic

var current_scene = null
var pause_menu = null
var win_screen = null
var screen_timer = null
var screen_total_gems = null
var time_taken = 0
var total_gems = 0

func _ready() -> void:
	# Load the initial scene (menu scene)
	load_scene("res://scenes/menus/menu.tscn")

	# Preload the pause menu
	pause_menu = preload("res://scenes/menus/pause_screen.tscn").instantiate()
	add_child(pause_menu)
	pause_menu.hide()
	
	#results screen for each level
	win_screen = preload("res://scenes/menus/win.tscn").instantiate()
	add_child(win_screen)
	win_screen.hide()


func _process(_delta: float) -> void:
	#return
	if Input.is_action_just_pressed("debug"):
		SceneManager.finish_level()
		#spawn_gem()
	
func spawn_gem() -> void:
	var gem = SceneManager.gem_scene.instantiate()
	get_parent().add_child(gem)
	gem.position = Vector2(45, 100)


func load_scene(scene_path) -> void:
	# Unload the current scene if there is one
	if current_scene != null:
		current_scene.queue_free()
	# Load the new scene
	current_scene = load(scene_path).instantiate()
	add_child(current_scene)
	
	#timer and gems for each level
	if current_scene.name != "Menu" && current_scene.name != "CreditsCanvas":
		backround_music.play()
		screen_timer = preload("res://scenes/other/timer_scene.tscn").instantiate()
		add_child(screen_timer)
		screen_total_gems = preload("res://scenes/other/gems_screen.tscn").instantiate()
		add_child(screen_total_gems)
	else:
		if screen_timer != null:
			screen_timer.queue_free()
		if screen_total_gems != null:
			screen_total_gems.queue_free()

func load_credits() -> void:
	load_scene("res://scenes/menus/credits.tscn")
	menu_music.play()
	

func start_game() -> void:
	load_scene("res://scenes/levels/Level 1/Tutorial_level.tscn")

func quit_game() -> void:
	get_tree().quit()


func finish_level():
	if win_screen.visible == false:
		win_screen.show_win_screen()
	
	if screen_timer != null:
		screen_timer.stop_timer()
		screen_timer.queue_free()
	if screen_total_gems != null:
		screen_total_gems.queue_free()
