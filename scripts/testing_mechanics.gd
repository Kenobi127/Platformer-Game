extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("SpawnE1"):
		var skeleton = preload("res://scenes/character bodies/enemies/skeleton1_0.tscn").instantiate()
		skeleton.position = Vector2(randi_range(250, 500), 0)
		$Enemies.add_child(skeleton)

