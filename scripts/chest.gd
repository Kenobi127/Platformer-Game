extends Area2D
var is_open = false
var gem_num = 0

func _ready() -> void:
	$AnimationPlayer.play("default")

func _on_body_entered(body):
	if body.name=="Player" && !is_open:
		is_open = true
		$AnimationPlayer.play("open")
		gem_num = randi_range(1, 4)
		$Timer.start()
	

func _on_timer_timeout() -> void:
	if gem_num>0:
		gem_num-=1
		var gem = SceneManager.gem_scene.instantiate()
		get_parent().add_child(gem)
		gem.position = position + Vector2(randf_range(-3, 3), 0)
		if gem_num>1:
			var rand_time = randf_range(0.3, 0.6)
			$Timer.wait_time = rand_time
			$Timer.start()


func gem_spawn_delay():
	var gem = SceneManager.gem_scene.instantiate()
	get_parent().add_child(gem)
	gem.position = position


