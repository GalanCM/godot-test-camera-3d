extends Camera3D

var focus_point_x := Node3D.new()
var focus_point_y := Node3D.new()

var turn_speed = 1.3


func _ready():
	focus_point_x.name = "TestCameraFocusX"
	focus_point_y.name = "TestCameraFocusY"

	await(get_tree().physics_frame)
	get_parent().add_child(focus_point_x)
	focus_point_x.add_child(focus_point_y)
	get_parent().remove_child(self)
	focus_point_y.add_child(self)

	focus_point_x.rotate(Vector3(0, 1, 0), TAU / 16)
	focus_point_y.rotate(Vector3(1, 0, 0), TAU / -8)

	%"UpInput".text = ", ".join(InputMap.action_get_events("testcamera_up").map(func(event): return event.as_text()))
	%"DownInput".text = ", ".join(InputMap.action_get_events("testcamera_down").map(func(event): return event.as_text()))
	%"LeftInput".text = ", ".join(InputMap.action_get_events("testcamera_left").map(func(event): return event.as_text()))
	%"RightInput".text = ", ".join(InputMap.action_get_events("testcamera_right").map(func(event): return event.as_text()))


func _process(delta: float) -> void:
	var orbit_motion = Vector2.ZERO

	if Input.is_action_pressed("testcamera_left", true):
		orbit_motion.x -= 1
	if Input.is_action_pressed("testcamera_right", true):
		orbit_motion.x += 1
	if Input.is_action_pressed("testcamera_up", true):
		orbit_motion.y -= 1
	if Input.is_action_pressed("testcamera_down", true):
		orbit_motion.y += 1

	focus_point_x.rotate(Vector3(0, 1, 0), orbit_motion.x * delta * turn_speed)
	focus_point_y.rotate(Vector3(1, 0, 0), orbit_motion.y * delta * turn_speed)


func set_orbit_radius(radius: int) -> void:
	position = Vector3(0, 0, radius)
