extends RigidBody2D


var speed = 600  # You can adjust this value to what works well for your purposes.
var direction: Vector2 = Vector2()

@onready var t: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	t.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = direction * speed * delta
	var collision = move_and_collide(velocity)

func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if(body != $"."):
		t.stop()
		t.start(.015)
