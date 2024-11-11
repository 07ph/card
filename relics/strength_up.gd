extends Relic

signal status_applied(status: Status)

const MUSCLE_STATUS = preload("res://statuses/muscle.tres")
 


func activate_relic(owner: RelicUI) -> void:
	Events.player_hand_drawn.connect(_add_strength.bind(owner), CONNECT_ONE_SHOT)


func _add_strength(owner: RelicUI) -> void:
	print("applied true str form")
	var target=owner.get_tree().get_first_node_in_group("player") as Player
	var status_effect := StatusEffect.new()
	var muscle := MUSCLE_STATUS.duplicate()
	muscle.stacks = 1
	status_effect.status = muscle
	status_effect.execute([target])
	
	status_applied.emit(self)
	owner.flash()
