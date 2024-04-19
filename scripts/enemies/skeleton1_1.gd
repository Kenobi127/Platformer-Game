extends CharacterBody2D

# Constants
const NORMAL_SPEED_MIN = 16
const NORMAL_SPEED_MAX = 24
const CHASE_SPEED = 35
const MAX_LIVES = 5

# exports
@export var normal_speed: float = randf_range(NORMAL_SPEED_MIN, NORMAL_SPEED_MAX)
@export var chase_speed: float = CHASE_SPEED
@export var direction: float = 1
@export var max_lives: int = MAX_LIVES

# References
@onready var anim = $AnimationPlayer
@onready var player: Node2D
var gem_scene = preload("res://scenes/other/gem.tscn")

# State variables
var is_chasing: bool = false
var is_attacking: bool = false
var can_hurt: bool = false
var is_hurt: bool = false
var lives: int = 1

func _ready():
	lives = max_lives
	for node in get_parent().get_parent().get_children():
		if node.name == "Player":
			player = node

func _physics_process(delta):
	print("lives: ", lives, ", is hurt ", is_hurt, ", is chasing ", is_chasing, ", is attacking ", is_attacking)
	if is_on_floor():
		if !is_chasing && !is_attacking && !is_hurt && !can_hurt:
			velocity.x = normal_speed * direction
			anim.play("walk")
		elif !is_attacking && can_hurt:
			anim.speed_scale = 1
			anim.play("attack")
	else:
		apply_gravity(delta)
		if position.y > 1000:
			queue_free()

	if (($PlatformRayCast2D.is_colliding() && $ObstacleShapeCast2D.is_colliding()) ||
			(!$PlatformRayCast2D.is_colliding() && !$ObstacleShapeCast2D.is_colliding())) && is_on_floor():
		direction *= -1
		scale.x *= -1
	move_and_slide()

func apply_gravity(delta):
	velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	if position.y > 1000:
		queue_free()

func _on_detection_area_body_entered(body):
	if !is_attacking && is_on_floor() && !is_hurt:
		is_chasing = true
		chase_player(player)

func _on_detection_area_body_exited(body):
	is_chasing = false
	anim.speed_scale = 1

func chase_player(body):
	if position.x < body.position.x && direction == -1 or position.x > body.position.x && direction == 1:
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
	velocity = Vector2.ZERO
	if position.x < player.position.x:
		position.x -= 5
	else:
		position.x += 5
	
	if lives < 1:
		anim.play("death")
	else:
		anim.stop(true)
		anim.play("hurt")

func die():
	spawn_gem()
	queue_free()

func spawn_gem():
	var gem = gem_scene.instantiate()
	get_parent().add_child(gem)
	gem.position = position
