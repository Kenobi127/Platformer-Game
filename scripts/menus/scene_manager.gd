# SceneManager.gd

extends Node

var current_scene = null
var pause_menu = null
var win_screen = null
var timer_screen = null
var time_taken = 0

func _ready():
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

func _process(delta):
	if timer_screen != null:
		time_taken = timer_screen.return_timer_value()
	#for node in get_children():
		#print(node, " ", debug)
	#print()

func load_scene(scene_path):
	# Unload the current scene if there is one
	if current_scene != null:
		current_scene.queue_free()
	
	# Load the new scene
	current_scene = load(scene_path).instantiate()
	#print(current_scene)
	add_child(current_scene)
	
	#timer for each level
	if current_scene.name != "Menu":
		timer_screen = preload("res://scenes/other/timer_scene.tscn").instantiate()
		add_child(timer_screen)
	else:
		if timer_screen != null:
			timer_screen.queue_free()

func load_credits():
	load_scene("res://scenes/menus/credits.tscn")
	

func start_game():
	load_scene("res://scenes/levels/Level 1/Tutorial_level.tscn")

func quit_game():
	get_tree().quit()

func finish_level():
	win_screen.show()
	if timer_screen != null:
		timer_screen.stop_timer()
		timer_screen.queue_free()
