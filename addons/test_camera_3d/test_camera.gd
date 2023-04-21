extends Camera3D


var position_offset := Transform3D.IDENTITY
var rotation_around_x := Transform3D.IDENTITY
var rotation_around_y := Transform3D.IDENTITY


var turn_speed = 1.3


func _ready():
	const CameraAngles := preload("res://addons/test_camera_3d/test_camera_plugin.gd").CameraAngles

	match ProjectSettings.get_setting("test_camera_3d/starting_angle", 0):
		CameraAngles.DEFAULT:
			rotation_around_y = rotation_around_y.rotated(Vector3(0, 1, 0), TAU / 8)
			rotation_around_x = rotation_around_x.rotated(Vector3(1, 0, 0), TAU / -8)
		CameraAngles.POSITIVE_X:
			rotation_around_y = rotation_around_y.rotated(Vector3(0, 1, 0), TAU / 4)
		CameraAngles.NEGATIVE_X:
			rotation_around_y = rotation_around_y.rotated(Vector3(0, 1, 0), TAU / -4)
		CameraAngles.POSITIVE_Y:
			rotation_around_x = rotation_around_x.rotated(Vector3(1, 0, 0), -TAU / 4)
		CameraAngles.NEGATIVE_Y:
			rotation_around_x = rotation_around_x.rotated(Vector3(1, 0, 0), -TAU / -4)
		CameraAngles.POSITIVE_Z:
			pass
		CameraAngles.NEGATIVE_Z:
			rotation_around_y = rotation_around_y.rotated(Vector3(0, 1, 0), TAU / 2)


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

	rotation_around_y = rotation_around_y.rotated(Vector3(0, 1, 0), orbit_motion.x * delta * turn_speed)
	rotation_around_x = rotation_around_x.rotated(Vector3(1, 0, 0), orbit_motion.y * delta * turn_speed)

	assert(get_tree().current_scene is Node3D)
	var scene_root_offset := Transform3D(Basis.IDENTITY, get_tree().current_scene.transform.origin)
	transform = scene_root_offset * rotation_around_y * rotation_around_x * position_offset


func set_orbit_radius(radius: int) -> void:
	position_offset = position_offset.translated( Vector3(0, 0, radius) )
