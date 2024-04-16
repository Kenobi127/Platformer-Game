extends CharacterBody2D


@export var normal_speed: float = 20
@export var chase_speed: float = 35
@export var direction: float = 1
@export var max_lives: int = 3

@onready var anim = $AnimationPlayer


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_chasing: bool = false
var is_attacking: bool = false
var can_hurt: bool = false
var is_hurt: bool = false
var lives: int = 1
signal hurt_player


var debug = "not set"

func _ready():
	lives = max_lives

func _physics_process(delta):
	#print("lives: ", lives, " ", debug, " is hurt ", is_hurt)
	if is_on_floor() && !is_chasing && !is_attacking && !is_hurt:
		velocity.x = normal_speed * direction
		anim.play("walk")
		
	else:
		velocity.y += gravity * delta
	
	
	if !$PlatformRayCast2D.is_colliding() || $ObstacleRayCast2D.is_colliding():
		direction *= -1
		scale.x *= -1

	move_and_slide()



func _on_detection_area_body_entered(body):
	if !is_attacking && is_on_floor() && !is_hurt:
		is_chasing = true
		chase_player(body)


func _on_detection_area_body_exited(body):
	is_chasing = false
	anim.speed_scale = 1

func chase_player(body):	
	if position.x < body.position.x && direction==-1:
		direction *= -1
		scale.x *= -1
	elif position.x > body.position.x && direction==1:
		direction *= -1
		scale.x *= -1
		
	velocity.x = chase_speed * direction
	anim.speed_scale = 1.75
	
	
func _on_damage_area_body_entered(body):
	is_chasing = false
	is_attacking = true
	can_hurt = true
	velocity.x = 0
	if !is_hurt:
		anim.play("attack")	


func _on_damage_area_body_exited(body):
	can_hurt = false

func damage_player():
	if can_hurt:
		emit_signal("hurt_player")

func stop_attacking():
	is_attacking = false
	

func hurt(amount):
	lives -= amount
	is_hurt = true
	velocity = Vector2(0,0)
	if lives<1:
		anim.play("death")
	else:
		anim.play("hurt")

func back_to_normal():
	is_hurt = false

func die():
	queue_free()



