extends CanvasLayer

@onready var time_left_text = $Win/TimerText
@onready var timer_scene
@onready var timerValue = 0
var pause = false


# Called when the node enters the scene tree for the first time.
func _ready():
	await "start_pressed"
	timer_scene=load("res://scenes/other/timer_layer.tscn").instantiate()
	add_child(timer_scene)
	hide()

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (visible == true):
		if pause == false:
			pause = true
			get_tree().paused = true
			timerValue = timer_scene.get_time_left()
			print(timerValue)
			var new_timer_text = "Time: " + str(ceil(timerValue))
			time_left_text.text = new_timer_text
			
			timer_scene.free()
		
