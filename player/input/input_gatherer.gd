extends Node
class_name PlayerInputGatherer


@export var input_mapping_context: GUIDEMappingContext

@export_group("Inputs")
@export var movement: GUIDEAction
@export var dash: GUIDEAction
@export var crouch: GUIDEAction
@export var jump: GUIDEAction

func _ready() -> void:
	GUIDE.enable_mapping_context(input_mapping_context)

class PInput extends RefCounted:
	var movement: Vector3 = Vector3.ZERO
	var dash: bool = false
	var crouch: bool = false
	var jump: bool = false

func gather_input() -> PInput:
	var input := PInput.new()
	input.movement = movement.value_axis_3d
	input.dash = dash.value_bool
	input.crouch = dash.value_bool
	input.jump = dash.value_bool
	return input
