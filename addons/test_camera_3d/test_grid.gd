extends MeshInstance3D

const TestCamera = preload("res://addons/test_camera_3d/test_camera.gd")

var camera: TestCamera


func _ready() -> void:
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh.get_mesh_arrays())

	var mesh_data := MeshDataTool.new()
	mesh_data.create_from_surface(array_mesh, 0)

	for vertex_index in range(mesh_data.get_vertex_count()):
		var vertex := mesh_data.get_vertex(vertex_index)
		mesh_data.set_vertex_color(vertex_index, Color(1,1,1, ease(1 - vertex.length() / 70, 10)))

	array_mesh.clear_surfaces()
	mesh_data.commit_to_surface(array_mesh)
	array_mesh.surface_set_material(0, mesh.material)
	mesh = array_mesh

func _process(_delta: float) -> void:
	if camera == null:
		return

	# Scaling

	# the power of ten that the grid should scale to
	var grid_scale := 1.0

	var camera_zoom := camera.zoom_offset.origin.z
	if camera_zoom >= 1.0:
		var zeros = str(camera_zoom).split(".")[0].length() - 1
		grid_scale = floor(10.0 ** int(zeros))
	else:
		var zeros = step_decimals(camera_zoom)
		grid_scale = 10.0 ** -int(zeros)

	scale = Vector3.ONE * grid_scale

	global_position = camera.center.origin.snapped(Vector3.ONE * grid_scale)

	# Rotation

	var camera_vector := camera.get_camera_transform().origin.direction_to(camera.center.origin)

	var min_angles := Vector3(
		min(camera_vector.angle_to(Vector3.RIGHT), camera_vector.angle_to(Vector3.LEFT)),
		min(camera_vector.angle_to(Vector3.UP), camera_vector.angle_to(Vector3.DOWN)),
		min(camera_vector.angle_to(Vector3.BACK), camera_vector.angle_to(Vector3.FORWARD))
	)
	var smallest_angle := min_angles.x
	var smallest_angle_vector := Vector3.RIGHT
	if min_angles.y < smallest_angle:
		smallest_angle = min_angles.y
		smallest_angle_vector = Vector3.UP
	if min_angles.z < smallest_angle:
		smallest_angle = min_angles.z
		smallest_angle_vector = Vector3.BACK

	match smallest_angle_vector:
		Vector3.RIGHT:
			rotation = Vector3.BACK * (TAU / 4)
		Vector3.UP:
			rotation = Vector3.ZERO
		Vector3.BACK:
			rotation = Vector3.RIGHT * (TAU / 4)