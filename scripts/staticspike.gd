extends Area2D

func _on_body_entered(body):
	if body.name == "Player" && $Timer.time_left==0:
		body.hurt_player()
		$Timer.start()
