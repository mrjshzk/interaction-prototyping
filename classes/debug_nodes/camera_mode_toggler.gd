extends Node
class_name DebugMouseModeToggler

@onready var camera : Camera = get_parent()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_toggle_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			camera.stop_receiving_input = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			camera.stop_receiving_input = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
