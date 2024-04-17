extends Area2D

var i: float = 0

func _process(delta: float) -> void:
	i += 1*delta
	print(i)

func _on_body_entered(body):
	if body.name == "Player" && i>3:
		body.hurt_player()
		i = 0
