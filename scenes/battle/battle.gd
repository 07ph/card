class_name Battle
extends Node2D

@export var battle_stats: BattleStats
@export var char_stats: CharacterStats
@export var music: AudioStream
@export var relics: RelicHandler

@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var player: Player = $Player

#初始化变量

func _ready() -> void:
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	#敌人回合事件
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	#玩家回合事件
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	#玩家手牌丢弃事件信号连接到敌人回合开始
	Events.player_died.connect(_on_player_died)
	#玩家死亡事件
#事件链接

func start_battle() -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	
	battle_ui.char_stats = char_stats
	player.stats = char_stats
	player_handler.relics = relics
	enemy_handler.setup_enemies(battle_stats)
	enemy_handler.reset_enemy_actions()
	#初始化敌人，玩家，遗物
	
	relics.relics_activated.connect(_on_relics_activated)
	relics.activate_relics_by_type(Relic.Type.START_OF_COMBAT)
	#战斗开始生效类遗物生效


func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0 and is_instance_valid(relics):
		relics.activate_relics_by_type(Relic.Type.END_OF_COMBAT)
		#战斗后生效类遗物生效


func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	#玩家处理器开始运行
	enemy_handler.reset_enemy_actions()
	#敌人处理器重置行动

func _on_player_died() -> void:
	Events.battle_over_screen_requested.emit("你死了!", BattleOverPanel.Type.LOSE)
	SaveGame.delete_data()
	#游戏存档清除


func _on_relics_activated(type: Relic.Type) -> void:
	match type:
		Relic.Type.START_OF_COMBAT:
			player_handler.start_battle(char_stats)
			battle_ui.initialize_card_pile_ui()
		Relic.Type.END_OF_COMBAT:
			Events.battle_over_screen_requested.emit("你获得了胜利!", BattleOverPanel.Type.WIN)
