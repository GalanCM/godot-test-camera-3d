@tool
extends EditorPlugin

enum CameraAngles {
	DEFAULT,
	POSITIVE_X,
	NEGATIVE_X,
	POSITIVE_Y,
	NEGATIVE_Y,
	POSITIVE_Z,
	NEGATIVE_Z,
}


func _enable_plugin():
	var create_default_key := func(physical_keycode: int, include_shift: bool = false) -> InputEventKey:
		var default_key = InputEventKey.new()
		default_key.ctrl_pressed = true
		default_key.alt_pressed = true
		if include_shift == true:
			default_key.shift_pressed = true
		default_key.physical_keycode = physical_keycode
		return default_key

	if not ProjectSettings.has_setting("input/testcamera_up"):
		ProjectSettings.set_setting("input/testcamera_up", {"deadzone": 0.5, "events": [create_default_key.call(KEY_UP)]})
	if not ProjectSettings.has_setting("input/testcamera_down"):
		ProjectSettings.set_setting("input/testcamera_down", {"deadzone": 0.5, "events": [create_default_key.call(KEY_DOWN)]})
	if not ProjectSettings.has_setting("input/testcamera_left"):
		ProjectSettings.set_setting("input/testcamera_left", {"deadzone": 0.5, "events": [create_default_key.call(KEY_LEFT)]})
	if not ProjectSettings.has_setting("input/testcamera_right"):
		ProjectSettings.set_setting("input/testcamera_right", {"deadzone": 0.5, "events": [create_default_key.call(KEY_RIGHT)]})
	if not ProjectSettings.has_setting("input/testcamera_in"):
		ProjectSettings.set_setting("input/testcamera_in", {"deadzone": 0.5, "events": [create_default_key.call(KEY_UP, true)]})
	if not ProjectSettings.has_setting("input/testcamera_out"):
		ProjectSettings.set_setting("input/testcamera_out", {"deadzone": 0.5, "events": [create_default_key.call(KEY_DOWN, true)]})
	if not ProjectSettings.has_setting("input/testcamera_follow_toggle"):
		ProjectSettings.set_setting("input/testcamera_follow_toggle", {"deadzone": 0.5, "events": [create_default_key.call(KEY_QUOTELEFT)]})

	var quick_inflect = func(keys: Array):
		var inflected: PackedStringArray = []
		for string in keys:
			string = string as String
			var words := string.split("_") as Array
			var capitalized_words := words.map(func(value: String): return value.capitalize())

			inflected.push_back(" ".join(capitalized_words))

		return inflected

	if not ProjectSettings.has_setting("test_camera_3d/starting_angle"):
		ProjectSettings.set_setting("test_camera_3d/starting_angle", CameraAngles.DEFAULT)
		ProjectSettings.set_initial_value("test_camera_3d/starting_angle", CameraAngles.DEFAULT)
		ProjectSettings.add_property_info({
			"name": "test_camera_3d/starting_angle",
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(quick_inflect.call(CameraAngles.keys()))
		})

	ProjectSettings.save.call_deferred()


func _enter_tree():
	add_autoload_singleton("TestCameraManager", "res://addons/test_camera_3d/test_camera_manager.gd")


func _exit_tree():
	remove_autoload_singleton("TestCameraManager")
