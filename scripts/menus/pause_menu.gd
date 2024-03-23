extends Control

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _on_options_pressed():
	var options_menu_resource = ResourceLoader.load("res://scenes/menus/options_menu.tscn")
	if options_menu_resource:
		get_tree().change_scene_to_file("res://scenes/menus/options_menu.tscn")
	else:
		print("Error: Failed to load options_menu.tscn")
