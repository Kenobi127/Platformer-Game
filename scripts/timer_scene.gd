extends CanvasLayer

@onready var timer = $TimerControl/Timer
@onready var timerLabel = $TimerControl/TimerLabel
var timerValue = 0
var clear

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()
	clear = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if clear == false:
		timerValue = ceil(timer.time_left)
		timerLabel.text = str(timerValue)

func return_timer_value():
	return 300 - timerValue

func stop_timer():
	clear = true
	timer.stop()
