extends Area2D

export (int) var coin_value : int = 1

func _ready() -> void:
	Global.total_coins += 1

func _on_Coin_body_entered(body: PhysicsBody2D) -> void:
	$CoinSound.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.visible = false
	Global.score += coin_value

func _on_CoinSound_finished() -> void:
	queue_free()
