extends Camera3D

var zoom_offset := Transform3D.IDENTITY

var rotation_around_x := Transform3D.IDENTITY
var rotation_around_y := Transform3D.IDENTITY

var initial_zoom := 0

var follow_scene_root := true:
	set(value):
		follow_scene_root = value
		%FollowToggle.text = "Unfollow Scene Root" if value == true else "Follow Scene Root"
var last_follow_position := Vector3.ZERO

var center: Transform3D:
	get:
		return (
			Transform3D(Basis.IDENTITY, get_tree().current_scene.transform.origin)
			if follow_scene_root
			else Transform3D.IDENTITY.translated(last_follow_position)
		)

var turn_speed = 1.3


func _ready():
	# set starting camera rotation
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

	# Set input guide text
	%UpInput.text = ", ".join(
		InputMap.action_get_events("testcamera_up").map(func(event): return event.as_text())
	)
	%DownInput.text = ", ".join(
		InputMap.action_get_events("testcamera_down").map(func(event): return event.as_text())
	)
	%LeftInput.text = ", ".join(
		InputMap.action_get_events("testcamera_left").map(func(event): return event.as_text())
	)
	%RightInput.text = ", ".join(
		InputMap.action_get_events("testcamera_right").map(func(event): return event.as_text())
	)
	%ZoomInInput.text = ", ".join(
		InputMap.action_get_events("testcamera_in").map(func(event): return event.as_text())
	)
	%ZoomOutInput.text = ", ".join(
		InputMap.action_get_events("testcamera_out").map(func(event): return event.as_text())
	)
	%FollowToggleInput.text = ", ".join(
		InputMap.action_get_events("testcamera_follow_toggle").map(
			func(event): return event.as_text()
		)
	)
	%GridToggleInput.text = ", ".join(
		InputMap.action_get_events("testcamera_grid_toggle").map(
			func(event): return event.as_text()
		)
	)


func _process(delta: float) -> void:
	# calculate orbit
	var orbit_motion = Vector2.ZERO

	if Input.is_action_pressed("testcamera_left", true):
		orbit_motion.x -= 1
	if Input.is_action_pressed("testcamera_right", true):
		orbit_motion.x += 1
	if Input.is_action_pressed("testcamera_up", true):
		orbit_motion.y -= 1
	if Input.is_action_pressed("testcamera_down", true):
		orbit_motion.y += 1

	rotation_around_y = rotation_around_y.rotated(
		Vector3(0, 1, 0), orbit_motion.x * delta * turn_speed
	)
	rotation_around_x = rotation_around_x.rotated(
		Vector3(1, 0, 0), orbit_motion.y * delta * turn_speed
	)

	# calculate zoom
	var zoom_change := 0.0

	if Input.is_action_pressed("testcamera_in", true):
		zoom_change += -initial_zoom * 0.75 * delta
	if Input.is_action_pressed("testcamera_out", true):
		zoom_change += initial_zoom * 0.75 * delta

	zoom_offset = zoom_offset.translated(Vector3(0, 0, zoom_change))
	zoom_offset.origin.z = clamp(zoom_offset.origin.z, initial_zoom * 0.1, initial_zoom * 2)

	# apply camera transform
	assert(get_tree().current_scene is Node3D)

	transform = center * rotation_around_y * rotation_around_x * zoom_offset


func _input(event: InputEvent) -> void:
	# toggle follow/unfollow
	if event.is_action_pressed("testcamera_follow_toggle", false, true):
		follow_scene_root = not follow_scene_root
		last_follow_position = get_tree().current_scene.transform.origin


func set_orbit_radius(radius: int) -> void:
	initial_zoom = radius
	zoom_offset = zoom_offset.translated(Vector3(0, 0, radius))


func set_grid_display(is_visible: bool) -> void:
	%GridToggle.text = "Hide Grid" if is_visible == true else "Show Grid"
