extends Node3D


func set_player(player: Player) -> void:
	for spawner: Spawner in get_tree().get_nodes_in_group("EnemySpawners"):
		if !is_ancestor_of(spawner):
			continue
		spawner.spawned.connect(
			func(enemy: Enemy):
				enemy.set_player(player)
		)
	
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemies"):
		if !is_ancestor_of(enemy):
			continue
		enemy.set_player(player)
