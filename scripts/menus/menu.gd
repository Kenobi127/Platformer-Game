extends Node2D

func _on_start_game_pressed():
	# Call the start_game function in the scene manager
	SceneManager.start_game()


func _on_credits_view_pressed():
	# Call the view_credits function in the scene manager
	SceneManager.load_credits()


func _on_quit_game_pressed():
	# Call the quit_game function in the scene manager
	SceneManager.quit_game()


func _on_arena_pressed() -> void:
	SceneManager.load_scene("res://scenes/levels/testing mechanics/testing_mechanics.tscn")
