extends Node


func _ready():
	if get_viewport().get_camera_3d() != null:
		return

	var visual_instances := get_tree().current_scene.find_children(
		"*", "VisualInstance3D", true, false
	)

	if visual_instances.size() == 0:
		return

	var camera := preload("res://addons/test_camera_3d/test_camera.tscn").instantiate()
	get_tree().current_scene.add_child(camera, true, INTERNAL_MODE_BACK)

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
