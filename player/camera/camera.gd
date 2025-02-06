class_name Camera
extends Camera3D

@export var body: Node3D
@export var camera_lerp_speed := 15.0
@export var stop_receiving_input := true

var sensitivity := 1.0

var roll : float: # rotation x
	set(val):
		roll = clampf(val, deg_to_rad(-60), deg_to_rad(75))
var yaw : float # rotation y
var target_basis := Basis.IDENTITY
var camera_target_basis := Basis.IDENTITY

func _input(event: InputEvent) -> void:
	if stop_receiving_input:
		return
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * (sensitivity / 180.0) * 0.5
		roll -= event.relative.y * (sensitivity / 180.0) * 0.5
		target_basis = Basis(Vector3(0,1,0), yaw)
		camera_target_basis = Basis(Vector3(1,0,0), roll)

func _process(delta: float) -> void:
	basis  = basis.slerp(camera_target_basis, camera_lerp_speed * delta)
	body.basis  = body.basis.slerp(target_basis, camera_lerp_speed * delta)

func setup(_rotation: Vector3) -> void:
	stop_receiving_input = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	yaw = _rotation.y
	roll = _rotation.x
	target_basis = Basis(Vector3(0,1,0), yaw)
	camera_target_basis = Basis(Vector3(1,0,0), roll)
	self.rotation_degrees = Vector3(0, yaw, 0)
	body.rotation_degrees = Vector3(roll, 0, 0)

#region HELPER_FUNCTIONS
func get_forward_direction() -> Basis:
	return self.basis

#endregion
