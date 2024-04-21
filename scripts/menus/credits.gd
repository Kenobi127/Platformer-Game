extends CanvasLayer

func _on_button_pressed():
	SceneManager.button_sound.play()
	SceneManager.menu_music.stop()
	SceneManager.load_scene("res://scenes/menus/menu.tscn")
