extends Node2D

@onready var pause_menu = $PauseMenu
var paused = false
var timer_running = true
var start_time = 0
var elapsed_time = 0

func _ready():
	pause_menu.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	if timer_running:
		elapsed_time += delta

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
		timer_running = true
		print("Timer started.")
	else:
		pause_menu.show()
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
