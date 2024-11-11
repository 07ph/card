extends Card

@export var heal_acount := 0

 

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var heal_effect := HealEffect.new()
	heal_effect.amount = heal_acount
	heal_effect.sound = sound
	heal_effect.execute(targets)
