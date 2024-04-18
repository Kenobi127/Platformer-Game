extends RigidBody2D

# expiry time in seconds	
var expiryTime = 5 
var direction = Vector2(1, 0)

@onready var particles: GPUParticles2D = $GPUParticles2D


var t: SceneTreeTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	# set off particles
	particles.emitting = true
	# set position to random
	t = get_tree().create_timer(expiryTime)
	t.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	queue_free()


func _on_collectable_pickup_area_body_entered(body: Node2D) -> void:
	if body.has_method("pick_up_collectable"):
		body.pick_up_collectable(self)
		queue_free()
