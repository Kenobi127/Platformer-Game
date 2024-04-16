extends Control

signal faded_in
signal faded_out

var currentLevel = "World"

# Wrapper function for performing fade in animation
func fade_in():
	$ScreenCenter/ScreenFader/FadePlayer.play("fade_in")
	await $ScreenCenter/ScreenFader/FadePlayer.animation_finished
	emit_signal("faded_in")
	
# Wrapper function for performing fade out animation
func fade_out():
	$ScreenCenter/ScreenFader/FadePlayer.play("fade_out")
	await $ScreenCenter/ScreenFader/FadePlayer.animation_finished
	emit_signal("faded_out")
	
# Wrapper function for playing button press sound
func button_chime():
	$ButtonPress.play()
	
func _ready():
	# Load the main menu scene
	var main_menu=preload("res://scenes/menus/menu.tscn").instantiate()
	add_child(main_menu)
	# Fade into main menu
	fade_in()
	# Connect a signal so that when start game is pressed, the game begins
	main_menu.connect('start_pressed',transition_to_level_one)

func transition_to_level_one():
	# Fade out of main menu
	fade_out()
	await faded_out
	# Remove the main menu
	get_node("Menu").queue_free()
	# Load in level one
	var world=preload("res://scenes/levels/Level 1/Tutorial_level.tscn").instantiate()
	add_child(world)
	# Load in pause menu
	var pause=preload("res://scenes/menus/pause_screen.tscn").instantiate()
	add_child(pause)
	# Connect signal for returning later
	pause.connect('return_title', return_to_title)
	world.connect('next_level', switch_to_level)
	# Connect win signal to game
	get_node(currentLevel + "/Player").connect('win_signal',player_won)
	# Fade into level one
	fade_in()
	await faded_in

func return_to_title():
	# Fade out of game
	fade_out()
	await faded_out
	# Remove the game and pause menu
	get_node("Level1").queue_free()
	get_node("PauseMenu").queue_free()
	# Load in main menu
	var main_menu=preload("res://scenes/menus/menu.tscn").instantiate()
	add_child(main_menu)
	# Connect Main Menu start signal
	get_node("Menu").connect('start_pressed',transition_to_level_one)
	# Fade into level one
	fade_in()
	await faded_in

func switch_to_level(levelName: String) -> void:
	# Perform any pre-switch logic (e.g., save game state, transition effects)
	print("Switching to level:", levelName)
	get_node(currentLevel).queue_free()
	currentLevel = levelName
	
	
	# Load the level scene
	var levelScene = load("res://scenes/levels/Level 1/" + currentLevel + ".tscn")
	if levelScene:
		# Instantiate the level scene
		var newLevel = levelScene.instance()
		if newLevel:
			# Replace the current scene with the new level scene
			print(newLevel)
			#get_tree().get_root().replace_child(get_tree().get_root().get_child(0), newLevel)
			#newLevel.name = levelName  # Optional: Set the name of the new level node
		else:
			print("Error: Failed to instantiate level scene.")
	else:
		print("Error: Level scene not found.")

func player_won():
	# Show win screen
	$Win.show()
	# Pause game
	#get_tree().paused = true
	# Wait 5 seconds
	await get_tree().create_timer(2.0).timeout
	# Hide win screen
	$Win.hide()
	# Unpause game
	#get_tree().paused = false
	# Return to main menu
	return_to_title()
