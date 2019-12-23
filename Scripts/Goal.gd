extends Area2D

export var next_level : String = ""

func _ready() -> void:
	Global.connect("all_collected", self, "_on_Global_all_collected")

func _on_Goal_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		body.deactivate()
		$CollisionShape2D.set_deferred("disabled", true)
		$Sounds/NextLevel.play()
		
func change_level() -> void:
	Global.change_level(next_level)
	
func _on_Global_all_collected() -> void:
	$AnimationPlayer.play("ShowUp")

func _on_NextLevel_finished() -> void:
	change_level()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "ShowUp":
		$AnimationPlayer.play("Arrow")
