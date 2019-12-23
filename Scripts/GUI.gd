extends Control

onready var score_label : Label = $InGame/CoinsContainer/Score
onready var game_interface : VBoxContainer = $InGame
onready var pause_interface : ColorRect = $Paused

var paused : bool = false setget set_paused

func set_paused(value) -> void:
	paused = value
	game_interface.visible = !paused
	pause_interface.visible = paused
	get_tree().paused = paused

func _ready() -> void:
	Global.connect("score_changed", self, "_on_Global_score_changed")
	update_score()

func update_score() -> void:
	score_label.text = "%s/%s" % [Global.score, Global.total_coins]
	
func _on_Global_score_changed() -> void:
	update_score()
	
func _unhandled_input(event: InputEvent) -> void:
	if !Global.can_pause:
		return
		
	if event.is_action_pressed("pause"):
		self.paused = !paused

func _on_Continue_button_up() -> void:
	self.paused = false
