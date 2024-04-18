extends Node2D

@onready var jump_particles: GPUParticles2D = $JumpParticles;

# dict of particles
var particleDict: Dictionary = {
	"jump": jump_particles
}


func _ready():
	spawn(position)


func spawn(gposition: Vector2, type: String = "jump", expiry: float = 0.5):
	# duplicate the particles
	var particles_copy = particleDict[type]
	print(typeof(particles_copy))
	# make a copy
	particles_copy = jump_particles.duplicate()
	# add it to the scene
	
	# play it
	particles_copy.emitting = true
	particles_copy.lifetime = expiry
	
	add_child(particles_copy)
	# wait
	await get_tree().create_timer(expiry).timeout
	# remove it
	particles_copy.queue_free()
