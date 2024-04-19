# SceneManager.gd

extends Node

var current_scene = null
var pause_menu = null
var win_screen = null
var timer_screen = null
var total_gems_screen = null
var time_taken = 0
var total_gems = 0

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
	
var gem_scene = preload("res://scenes/other/gem.tscn")
func spawn_gem():
	# Instantiate the pre-cached collectable scene
	var gem = gem_scene.instantiate()
	# Determine the direction based on the gem's initial position
	var direction = Vector2.ZERO
	get_parent().add_child(gem)
	gem.position = Vector2(40, 0)
	

func _process(delta):
	if Input.is_action_just_pressed("debug"):
		pass
		#SceneManager.finish_level()
		#spawn_gem()
		
	if timer_screen != null:
		time_taken = timer_screen.return_timer_value()


func load_scene(scene_path):
	# Unload the current scene if there is one
	if current_scene != null:
		current_scene.queue_free()
	
	# Load the new scene
	current_scene = load(scene_path).instantiate()
	#print(current_scene)
	add_child(current_scene)
	
	if current_scene.name == "Menu":
		total_gems = 0
	
	#timer for each level
	if current_scene.name != "Menu" && current_scene.name != "CreditsCanvas":
		timer_screen = preload("res://scenes/other/timer_scene.tscn").instantiate()
		add_child(timer_screen)
		total_gems_screen = preload("res://scenes/other/gems_screen.tscn").instantiate()
		add_child(total_gems_screen)
	else:
		if timer_screen != null:
			timer_screen.queue_free()
		if total_gems_screen != null:
			total_gems_screen.queue_free()

func load_credits():
	load_scene("res://scenes/menus/credits.tscn")
	

func start_game():
	load_scene("res://scenes/levels/Level 1/Tutorial_level.tscn")

func quit_game():
	get_tree().quit()


func finish_level():
	if win_screen.visible == false:
		win_screen.show_win_screen()
	
	if timer_screen != null:
		timer_screen.stop_timer()
		timer_screen.queue_free()
	if total_gems_screen != null:
		total_gems_screen.queue_free()
