extends CharacterBody3D
class_name Player




@export_group("References")
@export var camera: Camera
@export var player_input_gatherer: PlayerInputGatherer


func _ready() -> void:
	_init_state_machine()
	camera.setup(global_rotation)

var states: Array[MovementState] = [
	Idle.new(),
	Run.new()
]
var current_state : MovementState = states[0]

var state_name_mapping : Dictionary[String, MovementState]

var hsm: LimboHSM
func _init_state_machine() -> void:
	hsm = LimboHSM.new()
	add_child(hsm)
	
	for state: MovementState in states:
		state.fsm = hsm
		state.gatherer = player_input_gatherer
		state.camera = camera
		state.player = self
		hsm.add_child(state)
		state_name_mapping[state.name] = state
		
	## hsm transitions
	hsm.add_transition(state_name_mapping["Idle"], state_name_mapping["Run"], &"movement_started")
	hsm.add_transition(state_name_mapping["Run"], state_name_mapping["Idle"], &"movement_ended")
	
	hsm.initial_state = current_state
	hsm.initialize(self)
	hsm.set_active(true)

class Idle extends MovementState:
	func _ready() -> void:
		name = "Idle"
	
	func enter(input: PlayerInputGatherer.PInput) -> void:
		print("entered idle")
	
	func update(delta: float, input: PlayerInputGatherer.PInput) -> void:
		if input.movement != Vector3.ZERO:
			fsm.dispatch("movement_started")
		
		player.velocity = player.velocity.move_toward(Vector3.ZERO, delta * 10)
		player.move_and_slide()

	
	func exit(input: PlayerInputGatherer.PInput) -> void:
		pass

class Run extends MovementState:
	func _ready() -> void:
		name = "Run"
	
	func enter(input: PlayerInputGatherer.PInput) -> void:
		print("entered run")
	
	func update(delta: float, input: PlayerInputGatherer.PInput) -> void:
		if input.movement == Vector3.ZERO:
			fsm.dispatch("movement_ended")
		
		player.velocity = player.basis * input.movement * 5.0
		player.move_and_slide()
	
	func exit(input: PlayerInputGatherer.PInput) -> void:
		pass
