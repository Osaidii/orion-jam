extends Node2D

var coins: int
@export var required_coins := 500

@onready var required_label: Label = %Required
@onready var coins_label: Label = %Coins
@onready var player: Player = $Player
@onready var tutorial: Label = $UI/Tutorial

func _ready() -> void:
	if Shortcuts.no_tutorial:
		tutorial.visible = false
	else:
		tutorial.visible = true
	required_label.text = str(required_coins)

func _process(delta: float) -> void:
	if player:
		coins = player.stored_coins
		coins_label.text = str(coins)
		if player.player_shot_or_moved:
			tutorial.visible = false
