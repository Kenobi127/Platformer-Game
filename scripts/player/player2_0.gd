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


var max_speed: Vector2 = Vector2(250, 600)*pixel_scale
var max_crouch_walk_speed: float = 100*pixel_scale
var max_slide_speed: float = 250*pixel_scale
var speed_to_peak: float = 17*pixel_scale
var speed_to_stop: float = 20*pixel_scale


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

var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var jump_gravity : float = ((-2.0 * jump_height) / pow(jump_time_to_peak,2)) * -1.0
var fall_gravity : float = ((-2.0 * jump_height) / pow(jump_time_to_descent,2)) * -1.0


enum states {IDLE, RUNNING, CROUCHING, CROUCH_WALK, SLIDE, JUMP, ATTACK1, ATTACK2, ATTACK3, FALL, HURT, DEATH}
var state_functions: Dictionary = {
	states.IDLE : idle_function,
	states.RUNNING : running_function, 
	states.CROUCHING : crouching_function,
	states.CROUCH_WALK : crouch_walking_function,
	states.SLIDE : slide_function,
	states.JUMP : jump_function, 
	states.ATTACK1 : attack1_function,
	states.ATTACK2 : attack2_function,
	states.ATTACK3 : attack3_function,
	states.FALL : fall_function,
	states.HURT : hurt_function,
	states.DEATH : death_function
}
var cur_state = states.IDLE

#debug *******************************************
#get_tree().quit()
var debug: String = "not set"
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
	states.HURT: "HURT",
	states.DEATH: "DEATH"
}
#*************************************************


func _ready():
	jump_particles.scale_amount_max = 0;
	jump_particles.emitting = true;			#preload the particles


func _process(delta):
	print(state_names[cur_state], " ", debug, " ", is_on_floor(), " ", anim.current_animation)
	horizontal_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	if position.y>1000:
		position = initial_position


func _physics_process(delta):
	state_functions[cur_state].call(delta)
	if !is_on_floor() && !is_jumping:				#falling logic universal
		cur_state = states.FALL
	move_and_slide()


func get_gravity() -> float:
	if velocity.y<0:
		return jump_gravity
	else:
		return fall_gravity


func move() -> void:
	if cur_state==states.CROUCH_WALK:
		velocity.x = move_toward(velocity.x, max_crouch_walk_speed*horizontal_direction, speed_to_peak)
	else:
		velocity.x = move_toward(velocity.x, max_speed.x*horizontal_direction, speed_to_peak)
	
	#move this in or out of the else to make flipping on crouchwalk or not
	if horizontal_direction<0 && !is_flipped: 	#if direction - and looking +
		is_flipped = true
		scale.x *= -1
	elif horizontal_direction>0 && is_flipped: 	#if direction + and looking -
		is_flipped = false
		scale.x *= -1


func stop() -> void:
	velocity.x = move_toward(velocity.x, 0.0, speed_to_stop)


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
		stop()
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
		move()
		anim.play("run")
	


#need finish
func crouching_function(delta) -> void:
	if Input.is_action_just_released("crouch"): 	#idle #logic to stand needed
		cur_state = states.IDLE
	elif horizontal_direction!=0:					#crouch_walk
		cur_state = states.CROUCH_WALK
	elif Input.is_action_just_pressed("slide"):		#slide
		cur_state = states.SLIDE
		anim.play("slide")
	elif Input.is_action_just_pressed("jump"):		#jump
		jump()
	elif Input.is_action_just_pressed("attack"):	#attack1
		attack()
	else:
		stop()
		anim.play("crouch_idle")



#need finish
func crouch_walking_function(delta) -> void:
	if Input.is_action_just_released("crouch"): 	#run #above head needs to be added
		cur_state = states.RUNNING
	elif horizontal_direction==0:					#crouch
		cur_state = states.CROUCHING
	elif Input.is_action_just_pressed("slide"):		#slide
		cur_state = states.SLIDE
		anim.play("slide")
	elif Input.is_action_just_pressed("jump"):		#jump
		jump()
	elif Input.is_action_just_pressed("attack"):	#attack1
		attack()
	elif can_move: 									#logic for movement
		move()
		anim.play("crouch_walk")


#need finish
func slide_function(delta) -> void:
	if anim.current_animation=="slide":										#slide logic
		set_collision_layer_value(2, false)
		set_collision_mask_value(3, false)
		velocity.x = max_slide_speed*get_sprite_direction()
	elif horizontal_direction!=0 && !Input.is_action_pressed("crouch"):		#run
		set_collision_layer_value(2, true)
		set_collision_mask_value(3, true)
		cur_state = states.RUNNING
	elif horizontal_direction==0 && Input.is_action_pressed("crouch"):		#crouch
		set_collision_layer_value(2, true)
		set_collision_mask_value(3, true)
		cur_state = states.CROUCHING
	elif horizontal_direction!=0 && Input.is_action_pressed("crouch"):		#crouch walk
		set_collision_layer_value(2, true)
		set_collision_mask_value(3, true)
		cur_state = states.CROUCH_WALK
	else:																	#idle
		set_collision_layer_value(2, true)
		set_collision_mask_value(3, true)
		cur_state = states.IDLE




func attack1_function(delta) -> void:
	if !anim.current_animation=="attack1" && is_attack_combo: #to attack2
		cur_state = states.ATTACK2
		is_attack_combo = false
		anim.play("attack2")
	elif !anim.current_animation=="attack1" && !is_attack_combo: #to idle
		cur_state = states.IDLE
	else:
		stop()
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
		cur_state = states.IDLE
	else:
		stop()
		anim.play("attack2")
		
		if Input.is_action_just_pressed("attack"): #bool to attack 2
			is_attack_combo = true
			look_at_mouse()



func attack3_function(delta) -> void:
	if !anim.current_animation=="attack3": #to idle
		cur_state = states.IDLE
	else:
		stop()
		anim.play("attack3")



#need finish
func jump_function(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):						#attack
		is_jumping = false
		attack()
	elif Input.is_action_just_pressed("jump") && jump_num > 0:		#double jump
		jump()
	elif velocity.y > 0:  											#fall
		is_jumping = false
	elif velocity.y==0:												#roll to fall
		cur_state = states.FALL
		is_jumping = false
	else:															#movement
		if horizontal_direction!=0:
			move()
		else:
			stop()
		velocity.y += get_gravity() * delta



#need finish
func fall_function(delta) -> void:
	if is_on_floor():											#idle
		cur_state = states.IDLE
		jump_num = max_jump_num
	elif Input.is_action_just_pressed("attack"):				#attack1
		attack()
	elif Input.is_action_just_pressed("jump") && jump_num>0:	#double jump
		jump()
	elif !is_on_floor():										#falling logic
		if horizontal_direction!=0:
			move()
		else:
			stop()
		
		if jump_num == max_jump_num: #this means went airborn without jumping
			jump_num = max_jump_num-1
		
		velocity.y += get_gravity() * delta
		if velocity.y>max_speed.y:
			velocity.y = max_speed.y
		anim.play("falling")



#need finish
func hurt_function(delta) -> void:
	if cur_lives<=0:
		cur_state = states.DEATH



#need finish
func death_function(delta) -> void:
	pass




