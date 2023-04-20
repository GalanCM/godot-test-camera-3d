@tool
extends EditorPlugin


func _enable_plugin():
	var create_default_key = func(physical_keycode: int) -> InputEventKey:
		var default_key = InputEventKey.new()
		default_key.ctrl_pressed = true
		default_key.alt_pressed = true
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

func _enter_tree():
	add_autoload_singleton("TestCameraManager", "res://addons/test_camera_3d/test_camera_manager.gd")

func _exit_tree():
	remove_autoload_singleton("TestCameraManager")
