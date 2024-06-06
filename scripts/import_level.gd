@tool
extends EditorScenePostImport


func _post_import(scene: Node) -> Object:
	var tree := SceneTree.new()
	tree.root.add_child(scene)
	
	for child in scene.get_children():
		if child.name == "NavMesh":
			var mesh_inst: MeshInstance3D = child
			print_debug("Processing NavMesh from %s" % get_source_file())
			mesh_inst.owner = null
			var geom_data := NavigationMeshSourceGeometryData3D.new()
			geom_data.add_mesh(mesh_inst.mesh, mesh_inst.transform)
			scene.remove_child(mesh_inst)
			var enemy_radii: PackedFloat32Array = ProjectSettings.get_setting("navigation/baking/enemy_radii", [])
			
			for i in range(enemy_radii.size()):
				var nav_region := OverlappingNavRegion3D.new()
				nav_region.index = i
				nav_region.navigation_mesh = NavigationMesh.new()
				nav_region.navigation_mesh.agent_radius = enemy_radii[i]
				nav_region.name = "OverlappingNavAgent"
				nav_region.navigation_mesh.cell_size = ProjectSettings.get_setting("navigation/3d/default_cell_size")
				nav_region.navigation_mesh.cell_height = ProjectSettings.get_setting("navigation/3d/default_cell_height")
				scene.add_child(nav_region, true)
				nav_region.owner = scene
				NavigationServer3D.bake_from_source_geometry_data(nav_region.navigation_mesh, geom_data)
			
			child.queue_free()
			print_debug("Finished processing NavMesh from %s" % get_source_file())
	
	tree.root.remove_child(scene)
	tree.free()
	return scene
