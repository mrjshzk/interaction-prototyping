
class_name MovementState extends LimboState

var fsm: LimboHSM
var gatherer: PlayerInputGatherer
var player: Player
var camera: Camera

func _enter() -> void:
	enter(gatherer.gather_input())

func enter(_input: PlayerInputGatherer.PInput) -> void:
	pass




func _update(delta: float) -> void:
	update(delta, gatherer.gather_input())

func update(delta:float, input: PlayerInputGatherer.PInput) -> void:
	pass


func _exit() -> void:
	exit(gatherer.gather_input())

func exit(_input: PlayerInputGatherer.PInput) -> void:
	pass
