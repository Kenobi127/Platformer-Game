extends Node2D

func _ready() -> void:
	SceneManager.total_gems = 0
	SceneManager.music_menu.play()

func _on_start_game_pressed():
	# Call the start_game function in the scene manager
	SceneManager.button_sound.play()
	SceneManager.music_menu.stop()
	SceneManager.start_game()

func _on_credits_view_pressed():
	# Call the view_credits function in the scene manager
	SceneManager.button_sound.play()
	SceneManager.load_credits()


func _on_quit_game_pressed():
	# Call the quit_game function in the scene manager
	SceneManager.quit_game()


func _on_arena_pressed() -> void:
	SceneManager.button_sound.play()
	SceneManager.music_menu.stop()
	SceneManager.load_scene("res://scenes/levels/testing mechanics/testing_mechanics.tscn")
