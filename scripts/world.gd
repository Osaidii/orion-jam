extends Node2D

var coins: int
@export var required_coins := 500

@onready var required_label: Label = %Required
@onready var coins_label: Label = %Coins
@onready var player: Player = $Player
@onready var tutorial: Label = $UI/Tutorial
@export var MAIN_MENU = load("uid://dx7h1rxfqof3v")

func _ready() -> void:
	if Shortcuts.no_tutorial:
		tutorial.visible = false
	else:
		tutorial.visible = true
	required_label.text = str(required_coins)

func _process(_delta: float) -> void:
	if player:
		coins = player.stored_coins
		coins_label.text = str(coins)
		if player.player_shot_or_moved:
			tutorial.visible = false

func _on_exit_pressed() -> void:
	Shortcuts.game_over = false
	Shortcuts.coins = 0
	Shortcuts.no_tutorial = false
	get_tree().change_scene_to_packed(MAIN_MENU)

func _on_replay_pressed() -> void:
	Shortcuts.game_over = false
	Shortcuts.coins = 0
	Shortcuts.no_tutorial = false
	get_tree().reload_current_scene()
