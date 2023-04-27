extends Node

@onready var camera := preload("res://addons/test_camera_3d/test_camera.tscn").instantiate()
@onready var test_grid := preload("res://addons/test_camera_3d/test_grid.tscn").instantiate()


func _ready():
	if get_viewport().get_camera_3d() != null:
		return

	var visual_instances := get_tree().current_scene.find_children(
		"*", "VisualInstance3D", true, false
	)
	if get_tree().current_scene is VisualInstance3D:
		visual_instances.push_front(get_tree().current_scene)

	if visual_instances.size() == 0:
		return

	get_tree().get_root().add_child.call_deferred(camera, true, INTERNAL_MODE_BACK)

	var scene_aabb := AABB()

	for visual_instance in visual_instances:
		var instance_global_aabb: AABB = (
			Transform3D.IDENTITY.translated(visual_instance.global_position)
			* visual_instance.get_aabb()
		)
		scene_aabb = scene_aabb.merge(instance_global_aabb)

	camera.set_orbit_radius(scene_aabb.get_longest_axis_size() * 1.5)

	var default_environment_path := ProjectSettings.get_setting(
		"rendering/environment/defaults/default_environment"
	)
	if default_environment_path != "":
		camera.environment = load(default_environment_path)
		camera.get_node("PhysicalSkyLight").show()

	test_grid.camera = camera
	camera.set_grid_display(false)


func _input(event: InputEvent) -> void:
	if not camera.is_inside_tree():
		return

	if event.is_action_pressed("testcamera_grid_toggle", false, true):
		if not test_grid.is_inside_tree():
			get_tree().root.add_child(test_grid)
			camera.set_grid_display(true)
		else:
			get_tree().root.remove_child(test_grid)
			camera.set_grid_display(false)
