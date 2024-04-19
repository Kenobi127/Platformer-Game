extends RigidBody2D

# expiry time in seconds	
var expiryTime = 5 
var value = 1
var type_gems = 5
var total_weights = (type_gems * (type_gems + 1)) / 2  # Example total weights
var random_weight
var color = Color(0, 0, 0, 0)

#@onready var particles: GPUParticles2D = $GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# set off particles
	#particles.emitting = true
	$Timer.start()
	$Timer.timeout.connect(_on_timer_timeout)
	
	#generate a random weight
	random_weight = randi_range(1, total_weights)  
	#this formula does the inverse of finding the total weights
	value = type_gems+1 - ceili((-1 + sqrt(1 + 8 * random_weight)) / 2) 
	
	if value == 1: #green
		color = Color(0.498039, 1, 0, 1)
	elif value == 2: #blue
		color = Color(0.498039, 1, 0.831373, 1)
	elif value == 3: #light purple
		color = Color(1, 0.353, 0.765, 1)
	elif value == 4: #purple
		color = Color(0.851, 0, 0.608, 1)
	elif value == 5: #red
		color = Color(1, 0, 0, 1)
		
	$Sprite2D.self_modulate = color

func _on_timer_timeout():
	queue_free()

func _on_collectable_pickup_area_body_entered(body: Node2D) -> void:
	if body.has_method("pick_up_collectable"):
		body.pick_up_collectable(value)
		queue_free()
