extends Relic

var member_var := 0


func initialize_relic(_owner: RelicUI) -> void:
	print("this happens once when we gain a new relic")


func activate_relic(_owner: RelicUI) -> void:
	print("this happens at specific times based on the Relic.Type property")


func deactivate_relic(_owner: RelicUI) -> void:
	print("this gets called when a RelicUI is exiting the SceneTree i.e. getting deleted")
	print("Event-based Relics should disconnect from the EventBus here.")


#我们可以为每个遗物提供独特的工具提示
func get_tooltip() -> String:
	return tooltip
