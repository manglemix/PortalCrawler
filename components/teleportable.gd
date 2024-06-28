@tool
class_name Teleportable
extends Node


signal teleported


func _get_configuration_warnings() -> PackedStringArray:
	if name != "Teleportable":
		return ["Name must be Teleportable"]
	return []


func _ready() -> void:
	if Engine.is_editor_hint():
		renamed.connect(update_configuration_warnings)

static func get_teleportable_component(node: Node) -> Teleportable:
	if node == null:
		return null
	return node.get_node_or_null("Teleportable")
	
	
func _teleported(Portal1: Portal, Portal2: Portal):
	# portal 1 is always the portal this object is entering
	if (get_parent().name == "Player"):
		if (Portal1.facing == 'l'):
			if (Portal2.facing == 'l'):
				get_parent().leftheld = true
				get_parent().set_input_change(false, true, false)
			elif (Portal2.facing == 'r'):
				pass
			elif (Portal2.facing == 'u'):
				get_parent().leftheld = true
				get_parent().set_input_change(true, true, true)
			elif (Portal2.facing == 'd'):
				get_parent().leftheld = true
				get_parent().set_input_change(true, false, false)
		elif (Portal1.facing == 'r'):
			if (Portal2.facing == 'l'):
				pass
			elif (Portal2.facing == 'r'):
				get_parent().rightheld = true
				get_parent().set_input_change(false, true, false)
			elif (Portal2.facing == 'u'):
				get_parent().rightheld = true
				get_parent().set_input_change(true, false, false)
			elif (Portal2.facing == 'd'):
				get_parent().rightheld = true
				get_parent().set_input_change(true, true, true)
		elif (Portal1.facing == 'u'):
			if (Portal2.facing == 'l'):
				get_parent().upheld = true
				get_parent().set_input_change(true, true, true)
			elif (Portal2.facing == 'r'):
				get_parent().upheld = true
				get_parent().set_input_change(true, false, false)
			elif (Portal2.facing == 'u'):
				get_parent().upheld = true
				get_parent().set_input_change(false, false, true)
			elif (Portal2.facing == 'd'):
				pass
		elif (Portal1.facing == 'd'):
			if (Portal2.facing == 'l'):
				get_parent().downheld = true
				get_parent().set_input_change(true, false, false)
			elif (Portal2.facing == 'r'):
				get_parent().downheld = true
				get_parent().set_input_change(true, true, true)
			elif (Portal2.facing == 'u'):
				pass
			elif (Portal2.facing == 'd'):
				get_parent().downheld = true
				get_parent().set_input_change(false, false, true)
		
	else:
		if (Portal1.facing == 'l'):
			if (Portal2.facing == 'l'):
				get_parent().rotation.y += PI
			elif (Portal2.facing == 'r'):
				pass
			elif (Portal2.facing == 'u'):
				get_parent().rotation.y += PI / 2
			elif (Portal2.facing == 'd'):
				get_parent().rotation.y -= PI / 2
		elif (Portal1.facing == 'r'):
			if (Portal2.facing == 'l'):
				pass
			elif (Portal2.facing == 'r'):
				get_parent().rotation.y += PI
			elif (Portal2.facing == 'u'):
				get_parent().rotation.y -= PI / 2
			elif (Portal2.facing == 'd'):
				get_parent().rotation.y += PI / 2
		elif (Portal1.facing == 'u'):
			if (Portal2.facing == 'l'):
				get_parent().rotation.y -= PI / 2
			elif (Portal2.facing == 'r'):
				get_parent().rotation.y += PI / 2
			elif (Portal2.facing == 'u'):
				get_parent().rotation.y += PI
			elif (Portal2.facing == 'd'):
				pass
		elif (Portal1.facing == 'd'):
			if (Portal2.facing == 'l'):
				get_parent().rotation.y += PI / 2
			elif (Portal2.facing == 'r'):
				get_parent().rotation.y -= PI / 2
			elif (Portal2.facing == 'u'):
				pass
			elif (Portal2.facing == 'd'):
				get_parent().rotation.y += PI
	
	teleported.emit()
