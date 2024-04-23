extends Area2D
var is_open = false


func _on_body_entered(body):
	if body.name=="Player" && !is_open:
		is_open = true
		$AnimationPlayer.play("open")
	

func spawn_gems():
	for i in range(randi_range(5, 10)):
		await gem_spawn_delay()
		print(i)
	

func gem_spawn_delay():
	var gem = SceneManager.gem_scene.instantiate()
	get_parent().add_child(gem)
	gem.position = position
