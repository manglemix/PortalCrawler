class_name EncounterSetter
extends Node


@export var encounter_name: StringName


func _ready() -> void:
	if encounter_name.is_empty():
		push_warning("encounter_name is empty")
	else:
		if not encounter_name in Encountered:
			push_error("%s not in Encountered" % encounter_name)
		else:
			Encountered.set(encounter_name, true)
