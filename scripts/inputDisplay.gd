extends Node2D
d 
@export var action = "jump"
@export var default_controller = "xbox"

# map actions to sprite names
var input_devices = ["keyboard", "xbox", "playstation", "nintendo"]
var actions = {
	"jump": ["keyboard_space", "xbox_button_a", "playstation_button_cross", "switch_button_b"],
	"attack": ["mouse_right", "xbox_button_x", "playstation_button_square", "switch_button_y"],
	"slide": ["keyboard_shift", "xbox_rb", "playstation_trigger_r1", "switch_button_r"],
	"crouch": ["keyboard_c", "xbox_button_b", "playstation_button_circle", "switch_button_x"],
	"left": ["keyboard_a", "xbox_dpad_left", "playstation_dpad_left", "switch_dpad_left"],
	"right": ["keyboard_d", "xbox_dpad_right", "playstation_dpad_right", "switch_dpad_right"],
	"up": ["keyboard_w", "xbox_dpad_up", "playstation_dpad_up", "switch_dpad_up"],
	"down": ["keyboard_s", "xbox_dpad_down", "playstation_dpad_down", "switch_dpad_down"]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	# load in correct image for action
	$InputSprite.texture = load("res://assets/textures/inputs/" + actions[action][1] + ".png")

func _input(event):
	if event is InputEventKey || event is InputEventMouseButton:
		$InputSprite.texture = load("res://assets/textures/inputs/" + actions[action][0] + ".png")
		if(action == "jump" || action == "slide"):
			# resize as needed
			$InputSprite.scale = Vector2(0.15, 0.15)
			# and reposition
			$InputSprite.position = Vector2(0, -.5)
	elif event is InputEventJoypadButton || event is InputEventJoypadMotion:
		if event is InputEventJoypadMotion:
			# check if axis value is between -0.5 and 0.5
			if event.axis_value > -.5 && event.axis_value < .5:
				return
		$InputSprite.texture = load("res://assets/textures/inputs/" + actions[action][1] + ".png")
		# resize as needed
		$InputSprite.scale = Vector2(0.1, 0.1)
		# and reposition
		$InputSprite.position = Vector2(0, 0)