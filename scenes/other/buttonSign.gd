extends Node2D

@export var action = "jump"
@onready var display: Node2D = $InputDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	display.action = action


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
