extends Node2D

@onready var pause_screen = $pause_screen
@onready var player = $Player
@onready var tile_map = $TileMap
@onready var moving_platform = $"Moving Platforms"
var paused = false
var timer_running = true
var start_time = 0
var elapsed_time = 0

func _ready():
	pause_screen.hide()
	Engine.time_scale = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	if timer_running:
		elapsed_time += delta

func pauseMenu():
	if paused:
		pause_screen.hide()
		player.show()
		tile_map.show()
		moving_platform.show()
		Engine.time_scale = 1
		timer_running = true
		print("Timer started.")
	else:
		pause_screen.show()
		player.hide()
		tile_map.hide()
		moving_platform.hide()
		Engine.time_scale = 0
		timer_running = false
		print("Timer stopped.")
		print("Elapsed time:", elapsed_time, "seconds.")
	
	paused = !paused

func _start_timer():
	start_time = 0
	elapsed_time = 0
	timer_running = true
	$Timer.start()  # Start the timer when the scene is accessed



func _input(event):
	if Input.is_action_just_pressed("timer"):
		if timer_running:
			timer_running = false
			print("Timer stopped.")
			print("Elapsed time:", elapsed_time, "seconds.")
		else:
			timer_running = true
			print("Timer started.")
