extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("InputTest"):
		var skeleton = preload("res://scenes/character bodies/enemies/skeleton1_0.tscn").instantiate()
		skeleton.initial_position = Vector2(50, 0)
		$Enemies.add_child(skeleton)
		
		
