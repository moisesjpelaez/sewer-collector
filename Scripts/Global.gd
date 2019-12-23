extends Node

signal score_changed()
signal all_collected()

onready var animator : AnimationPlayer = $AnimationPlayer

var score : int = 0 setget set_score
var total_coins : int = 0
var next_level : String = ""
var can_pause : bool = true

func set_score(value : int) -> void:
	score = value
	emit_signal("score_changed")
	if score >= total_coins:
		emit_signal("all_collected")

func change_level(_level) -> void:
	reset_coins()
	next_level = _level
	animator.play("FadeIn")
	can_pause = false

func reset_coins() -> void:
	score = 0
	total_coins = 0

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "FadeIn":
		get_tree().change_scene(next_level)
		animator.play("FadeOut")
	if anim_name == "FadeOut":
		can_pause = true
