class_name Treasure
extends Control


@export var relic_handler: RelicHandler
@export var char_stats: CharacterStats
@export var treasure_relic_pool: Array[Relic]
@onready var animation_player: AnimationPlayer = %AnimationPlayer
var found_relic: Relic


func generate_relic() -> void:
	var available_relics := treasure_relic_pool.filter(
		func(relic: Relic):
			var can_appear := relic.can_appear_as_reward(char_stats)
			#可以出现
			var already_had_it := relic_handler.has_relic(relic.id)
			#是否获得
			return can_appear and not already_had_it
			#返回可以出现而且未获得的遗物
	)
	#可获得遗物
	found_relic = RNG.array_pick_random(available_relics)


# Called from the AnimationPlayer, at the
# end of the 'open' animation.
func _on_treasure_opened() -> void:
	Events.treasure_room_exited.emit(found_relic)



func _on_treasure_chest_gui_input(event: InputEvent) -> void:
	if animation_player.current_animation == "bad" or animation_player.current_animation == "open":
		return
	
	if event.is_action_pressed("left_mouse"):
		if RNG.instance.randf() < 0.5:	
			animation_player.play("bad")
			generate_relic()
		else:
			animation_player.play("open")
			
