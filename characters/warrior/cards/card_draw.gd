extends Card

@export var cardnum := 2


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var card_draw_effect := CardDrawEffect.new()
	card_draw_effect.cards_to_draw = cardnum
	card_draw_effect.sound=sound
	card_draw_effect.execute(targets)
	
