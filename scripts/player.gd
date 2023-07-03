extends CharacterBody2D

@onready var animated_sprite = get_node("AnimatedSprite2D")

const SPEED = 400
const JUMP_SPEED = 200
const GRAVITY = 200

func _physics_process(delta: float) -> void:
	handle_input(delta)
	apply_movement(delta)

func handle_input(delta: float) -> void:
	var is_moving = false
	velocity.x = 0
	
	if Input.is_action_pressed("attack"):
		play_attack_animation("attack")
		is_moving = true

	elif Input.is_action_pressed("double_attack"):
		play_attack_animation("double_attack")
		is_moving = true

	elif Input.is_action_pressed("move_right"):
		play_running_animation(false)
		velocity.x += SPEED
		is_moving = true

	elif Input.is_action_pressed("move_left"):
		play_running_animation(true)
		velocity.x -= SPEED
		is_moving = true

	if Input.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y -= JUMP_SPEED
		animated_sprite.play("jump")

	if not is_moving and not is_playing_attack():
		play_idle_or_falling_animation()

	velocity.y += GRAVITY * delta

func play_attack_animation(attack_name: String) -> void:
	animated_sprite.play(attack_name)
	velocity.x = 0

func play_running_animation(is_flipped: bool) -> void:
	animated_sprite.flip_h = is_flipped
	if is_on_floor_only():
		animated_sprite.play("run")

func play_idle_or_falling_animation() -> void:
	if is_on_floor_only():
		animated_sprite.play("idle")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")

func is_playing_attack() -> bool:
	return false
	# return (animated_sprite.animation == "attack" or animated_sprite.animation == "double_attack") and animated_sprite.frame < 7

func apply_movement(delta: float) -> void:
	move_and_slide()
