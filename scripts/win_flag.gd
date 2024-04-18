extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		SceneManager.finish_level()
		$Win.play()
