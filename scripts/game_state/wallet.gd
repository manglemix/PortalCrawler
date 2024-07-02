class_name Wallet
extends SaveDataFragment


static var coins := 0


func _load_save_data(data: Dictionary) -> void:
	if "coins" in data:
		coins = data["coins"]


func _create_save_data(data: Dictionary) -> void:
	data["coins"] = coins


