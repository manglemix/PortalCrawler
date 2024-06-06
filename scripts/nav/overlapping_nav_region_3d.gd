class_name OverlappingNavRegion3D
extends NavigationRegion3D


@export var index: int

var region_rid: RID


func _ready() -> void:
	var maps := NavigationServer3D.get_maps()
	
	if maps.size() <= index:
		for _i in range(index - maps.size() + 1):
			NavigationServer3D.map_create()
		maps = NavigationServer3D.get_maps()
	
	#region_rid = NavigationServer3D.region_create()
	#NavigationServer3D.region_set_navigation_mesh(region_rid, navigation_mesh)
	#NavigationServer3D.region_set_map(region_rid, maps[index])
	set_navigation_map(maps[index])


#func _exit_tree() -> void:
	#NavigationServer3D.free_rid(region_rid)
