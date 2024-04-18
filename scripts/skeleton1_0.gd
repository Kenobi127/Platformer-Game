extends CharacterBody2D


#normal speed is 20 and chase is 35
@export var normal_speed: float = randf_range(16, 24)
@export var chase_speed: float = 35
@export var direction: float = 1
@export var max_lives: int = 5

@onready var anim = $AnimationPlayer
@onready var player: Player


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_chasing: bool = false
var is_attacking: bool = false
var can_hurt: bool = false
var is_hurt: bool = false
var lives: int = 1


var debug = "not set"

func _ready():
	lives = max_lives
	for node in get_parent().get_parent().get_children():
		if node.name == "Player":
			player = node
			

func _physics_process(delta):
	#print("lives: ", lives, " ", debug, ", is hurt ", is_hurt, ", is chasing ", is_chasing, ", is attacking ", is_attacking)
	if is_on_floor() && !is_chasing && !is_attacking && !is_hurt && !can_hurt:
		velocity.x = normal_speed * direction
		anim.play("walk") 
		
	else:
		velocity.y += gravity * delta
		if position.y>1000:
			queue_free()
	
	if can_hurt:
		if !is_hurt:
			anim.speed_scale = 1
			anim.play("attack")
	
	if (($PlatformRayCast2D.is_colliding()&&$ObstacleShapeCast2D.is_colliding()) || (!$PlatformRayCast2D.is_colliding()&&!$ObstacleShapeCast2D.is_colliding())) && is_on_floor():
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

func _on_damage_area_body_exited(body):
	can_hurt = false

func damage_player():
	if can_hurt:
		player.hurt_player()

func stop_attacking():
	is_attacking = false

func hurt(amount):
	lives -= amount
	is_hurt = true
	velocity = Vector2(0,0)
	if position.x < player.position.x:
		position.x += -5
	else:
		position.x += 5
	
	if lives<1:
		anim.play("death")
	else:
		anim.stop(true)
		anim.play("hurt")

func back_to_normal():
	is_hurt = false
	is_attacking = false
	is_chasing = false

func die():
	# spawn a collectable gem on death
	spawn_gem()
	queue_free()



# Pre-cache the collectable scene
var collectable_scene = preload("res://scenes/other/collectable.tscn")

func spawn_gem():
	# Instantiate the pre-cached collectable scene
	var gem = collectable_scene.instantiate()
	# Determine the direction based on the gem's initial position
	var direction = Vector2.ZERO
	if position.x < 0:
		direction = Vector2(-1, -2)
	else:
		direction = Vector2(1, -2)
		gem.direction = direction

	# Add the gem as a child of the parent node
	get_parent().add_child(gem)

	# Set the gem's position
	gem.position = position


