class_name Player
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var jump_particles: CPUParticles2D = $JumpParticles
@onready var crouch_shapecast: ShapeCast2D = $CrouchShapeCast2D
@onready var cshape: CollisionShape2D = $CollisionShape2D
@onready var standing_cshape = preload("res://assets/collision shapes/player/StandingCollisionShape.tres")
@onready var crouching_cshape = preload("res://assets/collision shapes/player/CrouchCollisionShape.tres")
@onready var sliding_cshape = preload("res://assets/collision shapes/player/SlidingCollisionShape.tres")
var pixel_scale: float = 0.55 #fix the scaling, somehow the pixels are not exacly by 0.5 

@export var max_lives: int = 5
@export var max_jump_num: int = 2
@export var initial_position: Vector2 = Vector2(155,128)

#debug *******************************************
#get_tree().quit()
var debug = "not set"
var state_names = {
	states.IDLE: "IDLE",
	states.RUNNING: "RUNNING",
	states.CROUCHING: "CROUCHING",
	states.CROUCH_WALK: "CROUCH_WALK",
	states.SLIDE: "SLIDE",
	states.JUMP: "JUMP",
	states.ATTACK1: "ATTACK1",
	states.ATTACK2: "ATTACK2",
	states.ATTACK3: "ATTACK3",
	states.FALL: "FALL",
	states.HURT: "HURT"
}
#*************************************************

var max_fall_speed: float = 600*pixel_scale
var max_run_speed: float = 250*pixel_scale
var max_crouch_walk_speed: float = 100*pixel_scale
var max_slide_speed: float = 250*pixel_scale
var x_acceleration: float = 17*pixel_scale


var is_flipped: bool = false
var horizontal_direction: float = 0
var jump_num: int = max_jump_num
var cur_lives: int = max_lives
var can_move: bool = true
var is_attack_combo: bool = false
var is_jumping: bool = false

var jump_height : float = 70*pixel_scale
var jump_time_to_peak : float = 0.4
var jump_time_to_descent : float = 0.3

var jump_velocity : float = -2.0*jump_height / jump_time_to_peak

var jump_gravity : float = 2.0*jump_height / pow(jump_time_to_peak,2)
var fall_gravity : float = 2.0*jump_height / pow(jump_time_to_descent,2)


#enum with the number of states
enum states {IDLE, RUNNING, CROUCHING, CROUCH_WALK, SLIDE, 
	JUMP, ATTACK1, ATTACK2, ATTACK3, FALL, HURT}

var cur_state: states = states.IDLE

#dictionary with each state as the key and each function name as a value
var state_functions: Dictionary = {
	states.IDLE: idle_function,
	states.RUNNING: running_function, 
	states.CROUCHING: crouching_function,
	states.CROUCH_WALK: crouch_walking_function,
	states.SLIDE: slide_function,
	states.JUMP: jump_function, 
	states.ATTACK1: attack1_function,
	states.ATTACK2: attack2_function,
	states.ATTACK3: attack3_function,
	states.FALL: fall_function,
	states.HURT: hurt_function
}

func _ready():
	jump_particles.scale_amount_max = 0;
	jump_particles.emitting = true;			#preload the particles


func _process(delta):
	#print(state_names[cur_state], " ", debug, " ", velocity.x, " can move ", can_move, " ", jump_num, " ", is_jumping)
	horizontal_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	if position.y>1000:
		position = initial_position


func _physics_process(delta):
	state_functions[cur_state].call(delta)
	if !is_on_floor() && !is_jumping:				#falling logic universal
		can_move = true
		cur_state = states.FALL
	move_and_slide()


func get_gravity() -> float:
	if velocity.y<0:
		return jump_gravity
	else:
		return fall_gravity

func handle_movement(delta) -> void:
	if can_move:
		#crouch walk speed
		if cur_state == states.CROUCH_WALK:
			velocity.x = move_toward(velocity.x, max_crouch_walk_speed * horizontal_direction, x_acceleration)
		#normal running speed
		else:
			velocity.x = move_toward(velocity.x, max_run_speed * horizontal_direction, x_acceleration)
		#logic to flip the character
		if horizontal_direction != 0:
			if horizontal_direction < 0 && !is_flipped:
				is_flipped = true
				scale.x *= -1
			elif horizontal_direction > 0 && is_flipped:
				is_flipped = false
				scale.x *= -1
	else:
		#stop
		velocity.x = move_toward(velocity.x, 0.0, x_acceleration)




func get_sprite_direction() -> int:
	if !is_flipped:	#if right returns 1
		return 1
	else:
		return -1


func jump():
	is_jumping = true
	velocity.y = jump_velocity
	cur_state = states.JUMP
	if jump_num == max_jump_num:	# Single jump
		anim.play("jump")
		jump_particles.scale_amount_max = 1;	#jumping particles
		jump_particles.emitting = true;
	else:							# Double jump
		anim.play("roll") #flip animation 
	
	jump_num -= 1


func attack():
	can_move = false
	cur_state = states.ATTACK1
	anim.play("attack1")
	look_at_mouse()


func look_at_mouse():
	pass
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && get_global_mouse_position().x<position.x && !is_flipped:
		is_flipped = true
		scale.x *= -1
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && get_global_mouse_position().x>position.x && is_flipped:
		is_flipped = false
		scale.x *= -1


#State functions *****************************************************************
#need finish
func idle_function(delta) -> void: 
	#go to conditions
	can_move = true
	if horizontal_direction!=0:									#running
		cur_state = states.RUNNING
	elif Input.is_action_just_pressed("slide"):					#sliding
		cur_state = states.SLIDE
		anim.play("slide")
	elif Input.is_action_just_pressed("crouch"):				#crouching
		cur_state = states.CROUCHING
	elif Input.is_action_just_pressed("jump") && jump_num>0:	#jumping
		jump()
	elif Input.is_action_just_pressed("attack"):				#attack1
		attack()
	else:
		jump_num = max_jump_num
		handle_movement(delta)
		anim.play("idle")
	

#need finish
func running_function(delta) -> void: 
	#go to idle
	if horizontal_direction==0:						#idle
		cur_state = states.IDLE
	elif Input.is_action_pressed("crouch"):	#crouch_walk
		cur_state = states.CROUCH_WALK
	elif Input.is_action_just_pressed("slide"):		#slide
		cur_state = states.SLIDE
		anim.play("slide")
	elif Input.is_action_just_pressed("jump"):		#jump
		jump()
	elif Input.is_action_just_pressed("attack"):	#attack1
		attack()
	elif can_move: 									#logic for movement
		handle_movement(delta)
		anim.play("run")



func crouching_function(delta) -> void:
	if !Input.is_action_pressed("crouch") && !crouch_shapecast.is_colliding(): 	#idle
		cur_state = states.IDLE
	elif horizontal_direction!=0:					#crouch_walk
		cur_state = states.CROUCH_WALK
	elif Input.is_action_just_pressed("slide"):		#slide
		cur_state = states.SLIDE
		anim.play("slide")
	elif Input.is_action_just_pressed("jump") && !crouch_shapecast.is_colliding():		#jump
		jump()
	elif Input.is_action_just_pressed("attack") && !crouch_shapecast.is_colliding():	#attack1
		attack()
	else:
		handle_movement(delta)
		anim.play("crouch_idle")



#need finish
func crouch_walking_function(delta) -> void:
	if !Input.is_action_pressed("crouch") && !crouch_shapecast.is_colliding(): 	#run #above head needs to be added
		cur_state = states.RUNNING
	elif horizontal_direction==0:					#crouch
		cur_state = states.CROUCHING
	elif Input.is_action_just_pressed("slide"):		#slide
		cur_state = states.SLIDE
		anim.play("slide")
	elif Input.is_action_just_pressed("jump") && !crouch_shapecast.is_colliding():		#jump
		jump()
	elif Input.is_action_just_pressed("attack") && !crouch_shapecast.is_colliding():	#attack1
		attack()
	elif can_move: 									#logic for movement
		handle_movement(delta)
		anim.play("crouch_walk")



#need finish
func slide_function(delta) -> void:
	if anim.current_animation=="slide":										#slide logic
		set_collision_layer_value(2, false)
		set_collision_mask_value(3, false)
		$Camera2D.position_smoothing_speed = 8
		velocity.x = max_slide_speed*get_sprite_direction()
	elif horizontal_direction==0 && Input.is_action_pressed("crouch") || crouch_shapecast.is_colliding():		#crouch
		set_collision_layer_value(2, true)
		set_collision_mask_value(3, true)
		$Camera2D.position_smoothing_speed = 4
		cur_state = states.CROUCHING
	elif horizontal_direction!=0 && Input.is_action_pressed("crouch"):		#crouch walk
		set_collision_layer_value(2, true)
		set_collision_mask_value(3, true)
		$Camera2D.position_smoothing_speed = 4
		cur_state = states.CROUCH_WALK
	elif horizontal_direction!=0 && !Input.is_action_pressed("crouch"):		#run
		set_collision_layer_value(2, true)
		set_collision_mask_value(3, true)
		$Camera2D.position_smoothing_speed = 4
		cur_state = states.RUNNING
	else:																	#idle
		set_collision_layer_value(2, true)
		set_collision_mask_value(3, true)
		$Camera2D.position_smoothing_speed = 4
		cur_state = states.IDLE



func attack1_function(delta) -> void:
	if !anim.current_animation=="attack1" && is_attack_combo: #to attack2
		cur_state = states.ATTACK2
		is_attack_combo = false
		anim.play("attack2")
	elif !anim.current_animation=="attack1" && !is_attack_combo: #to idle
		can_move = true
		cur_state = states.IDLE
	else:
		handle_movement(delta)
		anim.play("attack1")
		
		if Input.is_action_just_pressed("attack"): #bool to attack 2
			is_attack_combo = true
			look_at_mouse()



func attack2_function(delta) -> void:
	if !anim.current_animation=="attack2" && is_attack_combo: #to attack3
		cur_state = states.ATTACK3
		is_attack_combo = false
		anim.play("attack3")
	elif !anim.current_animation=="attack2" && !is_attack_combo: #to idle
		can_move = true
		cur_state = states.IDLE
	else:
		handle_movement(delta)
		anim.play("attack2")
		
		if Input.is_action_just_pressed("attack"): #bool to attack 2
			is_attack_combo = true
			look_at_mouse()



func attack3_function(delta) -> void:
	if !anim.current_animation=="attack3": #to idle
		can_move = true
		cur_state = states.IDLE
	else:
		handle_movement(delta)
		anim.play("attack3")



func jump_function(delta: float) -> void:
	#if Input.is_action_just_pressed("attack"):						#attack
		#is_jumping = false
		#attack()
	if Input.is_action_just_pressed("jump") && jump_num > 0:		#double jump
		jump()
	elif velocity.y > 0:  											#fall
		is_jumping = false
	elif velocity.y==0:												#roll to fall
		cur_state = states.FALL
		is_jumping = false
	else:															#movement
		handle_movement(delta)
		velocity.y += get_gravity() * delta



func fall_function(delta) -> void:
	if is_on_floor():											#idle
		cur_state = states.IDLE
		jump_num = max_jump_num
	#elif Input.is_action_just_pressed("attack"):				#attack1
		#attack()
	elif Input.is_action_just_pressed("jump") && jump_num>0:	#double jump
		jump()
	elif !is_on_floor():										#falling logic
		handle_movement(delta)
		
		#if jump_num == max_jump_num: #this means went airborn without jumping
		#	jump_num = max_jump_num-1
		
		velocity.y += get_gravity() * delta
		if velocity.y>max_fall_speed:
			velocity.y = max_fall_speed
		anim.play("falling")



func hurt_function(delta) -> void:
	if anim.current_animation!="hurt" && anim.current_animation!="death":
		can_move = true
		cur_state = states.IDLE



func respawn() -> void:
	can_move = true
	cur_state = states.IDLE
	cur_lives = max_lives
	position = initial_position
	velocity = Vector2(0, 0)

func hurt_player():
	if anim.current_animation!="hurt" && anim.current_animation!="death":
		can_move = false
		velocity = Vector2(0, 0)
		cur_state = states.HURT
		cur_lives -= 1
		if cur_lives < 1: 	#death
			$Death.play()
			anim.play("death") 
		else:				#hurt
			$Hurt.play()
			anim.play("hurt")

func _on_attack_area_body_entered(body):
	if body.has_method("hurt"):
		if anim.current_animation == "attack1":
			body.hurt(1)
		elif anim.current_animation == "attack2":
			body.hurt(1.5)
		elif anim.current_animation == "attack3":
			body.hurt(2.5) 

func pick_up_collectable(collectable):
	collectable.queue_free()
	# do whatever, add to score, etc.