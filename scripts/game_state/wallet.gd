class_name Wallet
extends SaveDataFragment


static var wallet_instance := WalletInstance.new()
static var coins := 0:
	set(x):
		coins = x
		wallet_instance.coins_changed.emit()
static var wizard_hats := 0:
	set(x):
		wizard_hats = x
		wallet_instance.wizard_hats_changed.emit()


func _load_save_data(data: Dictionary) -> void:
	if "coins" in data:
		coins = data["coins"]
	if "wizard_hats" in data:
		wizard_hats = data["wizard_hats"]


func _create_save_data(data: Dictionary) -> void:
	data["coins"] = coins
	data["wizard_hats"] = wizard_hats


class WalletInstance:
	signal coins_changed
	signal wizard_hats_changed
