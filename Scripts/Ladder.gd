extends Area2D

func _on_Ladder_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		body.set_climbing()

func _on_Ladder_body_exited(body: PhysicsBody2D) -> void:
	if body is Player:
		body.unset_climbing()
