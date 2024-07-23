class_name Shop
extends Sprite3D


signal purchased
signal force_close

enum PriceType { COINS, WIZARD_HATS }

const POISON_SWORD: Texture2D = preload("res://player/upgrade icons/poison-sword.png")
const KILL_ALL: Texture2D = preload("res://player/upgrade icons/kill all spell upgrade icon.png")
const SHIELD: Texture2D = preload("res://player/upgrade icons/shield upgrade icon.png")
const FORTUNE: Texture2D = preload("res://player/upgrade icons/fortune cookie icon.png")
const FORTUNE_TOOLTIP: String = "Reveals your fortune"

var slot1_texture: Texture2D
var slot2_texture: Texture2D
var slot3_texture: Texture2D

var slot1_price_type: PriceType
var slot2_price_type: PriceType
var slot3_price_type: PriceType

var slot1_price: int
var slot2_price: int
var slot3_price: int

var slot1_tooltip: String
var slot2_tooltip: String
var slot3_tooltip: String

var _player: Player
var _first_time := true


func _on_body_entered(player: Player) -> void:
	_player = player
	if _first_time:
		var slot_textures: Array[Texture2D] = []
		var slot_price_types: Array[PriceType] = []
		var slot_prices: Array[int] = []
		var slot_tooltips: Array[String] = []
		
		if player.poison_count == 0:
			slot_textures.append(POISON_SWORD)
			slot_price_types.append(PriceType.COINS)
			slot_prices.append(30)
			slot_tooltips.append("Adds poison to your sword")
		if !player.has_kill_all_spell:
			slot_textures.append(KILL_ALL)
			slot_price_types.append(PriceType.COINS)
			slot_prices.append(30)
			slot_tooltips.append("Kills all enemies (except boss). Single Use")
		if Health.get_health_component(player).shield < 3:
			slot_textures.append(SHIELD)
			slot_price_types.append(PriceType.COINS)
			slot_prices.append(10)
			slot_tooltips.append("Adds 1 armor")
		while slot_textures.size() < 3:
			slot_textures.append(FORTUNE)
			slot_price_types.append(PriceType.COINS)
			slot_prices.append(5)
			slot_tooltips.append(FORTUNE_TOOLTIP)
		
		slot1_texture = slot_textures[0]
		slot2_texture = slot_textures[1]
		slot3_texture = slot_textures[2]
		slot1_price_type = slot_price_types[0]
		slot2_price_type = slot_price_types[1]
		slot3_price_type = slot_price_types[2]
		slot1_price = slot_prices[0]
		slot2_price = slot_prices[1]
		slot3_price = slot_prices[2]
		slot1_tooltip = slot_tooltips[0]
		slot2_tooltip = slot_tooltips[1]
		slot3_tooltip = slot_tooltips[2]
		
		_first_time = false
	player.open_shop(self)


@warning_ignore("shadowed_variable_base_class")
func _on_texture_pressed(texture: Texture2D) -> void:
	var price: int
	var price_type: PriceType
	
	if texture == slot1_texture:
		price = slot1_price
		price_type = slot1_price_type
	elif texture == slot2_texture:
		price = slot2_price
		price_type = slot2_price_type
	else:
		price = slot3_price
		price_type = slot3_price_type
	
	match price_type:
		PriceType.COINS:
			if price > Wallet.coins:
				return
			Wallet.coins -= price
		PriceType.WIZARD_HATS:
			if price > Wallet.wizard_hats:
				return
			Wallet.wizard_hats -= price
	
	if texture == POISON_SWORD:
		_player.poison_count += 50
	elif texture == KILL_ALL:
		_player.has_kill_all_spell = true
	elif texture == SHIELD:
		Health.get_health_component(_player).shield += 1
	else:
		force_close.emit()
		_player.open_fortune_cookie()
	
	if texture == slot1_texture:
		slot1_texture = FORTUNE
		slot1_price_type = PriceType.COINS
		slot1_price = 5
		slot1_tooltip = FORTUNE_TOOLTIP
	elif texture == slot2_texture:
		slot2_texture = FORTUNE
		slot2_price_type = PriceType.COINS
		slot2_price = 5
		slot2_tooltip = FORTUNE_TOOLTIP
	else:
		slot3_texture = FORTUNE
		slot3_price_type = PriceType.COINS
		slot3_price = 5
		slot3_tooltip = FORTUNE_TOOLTIP
	
	purchased.emit()
