class_name Wallet
extends SaveDataFragment


static var coins := 0
static var wizard_hats := 0


func _load_save_data(data: Dictionary) -> void:
	if "coins" in data:
		coins = data["coins"]
	if "wizard_hats" in data:
		wizard_hats = data["wizard_hats"]


func _create_save_data(data: Dictionary) -> void:
	data["coins"] = coins
	data["wizard_hats"] = wizard_hats

