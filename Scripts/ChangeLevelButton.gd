extends Button

export var next_level : String = ""

func _on_ChangeLevelButton_button_up() -> void:
	get_tree().paused = false
	Global.change_level(next_level)
