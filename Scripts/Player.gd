extends KinematicBody2D
class_name Player

export (int) var acceleration : int = 512
export (int) var max_speed : int = 64
export (float) var friction : float = 0.25
export (float) var ground_friction : float = 0.25
export (float) var ladder_friction : float = 1
export (int) var gravity : int = 256
export (int) var jump_impulse : int = 128

var motion : Vector2 = Vector2.ZERO
var floor_normal : Vector2 = Vector2.UP
var is_climbing : bool = false

onready var sprite : Sprite = $Sprite
onready var animator : AnimationPlayer = $AnimationPlayer
onready var jump_sound : AudioStreamPlayer2D = $Sounds/Jump
onready var land_sound : AudioStreamPlayer2D = $Sounds/Land

func _physics_process(delta: float) -> void:
	var was_on_floor : bool = is_on_floor()
	var horizontal_input : float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var vertical_input : float = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if horizontal_input != 0:
		motion.x += horizontal_input * acceleration * delta
		motion.x = clamp(motion.x, -max_speed, max_speed)
		sprite.scale.x = sign(motion.x)
		animator.play("Run") if is_on_floor() else ""
	if horizontal_input == 0 && (is_on_floor() || is_climbing):
		motion.x = lerp(motion.x, 0, friction)
		animator.play("Idle") if is_on_floor() else animator.stop(false)
	
	if is_on_floor():
		motion.y = 10
		if Input.is_action_just_pressed("jump"):
			motion.y = -jump_impulse
			jump_sound.play()
	else:
		if Input.is_action_just_released("jump") && motion.y < 0:
			motion.y = 0
			
	if !is_on_floor() && !is_climbing:
		animator.play("Jump")
		motion.y += gravity * delta
	
	if is_climbing:
		if vertical_input != 0:
			motion.y += vertical_input * acceleration * delta
			motion.y = clamp(motion.y, -max_speed, max_speed)
			animator.play("Ladder")
		else:
			motion.y = lerp(motion.y, 0, friction)
			if !is_on_floor():
				animator.play("Ladder", -1, 0.0)
	
	motion = move_and_slide(motion, floor_normal)
	
	if !was_on_floor && is_on_floor():
		animator.play("Land")
		land_sound.play()
	
func set_climbing() -> void:
	is_climbing = true
	floor_normal = Vector2.ZERO
	friction = ladder_friction

func unset_climbing() -> void:
	is_climbing = false
	floor_normal = Vector2.UP
	friction = ground_friction
	
func deactivate() -> void:
	set_physics_process(false)
	animator.stop()
