extends Area2D

func _on_body_entered(body):
	if body.has_method("hurt_function"):
		body.hurt_function(null)
