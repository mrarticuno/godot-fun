extends CharacterBody2D

@onready var animated_sprite = get_node("AnimatedSprite2D")

const SPEED = 400
const JUMP_SPEED = 800  # Double the sprite's height
const GRAVITY = 400

var fallMultiplier = 1

var input_map = {
	"attack": self.attack,
	"double_attack": self.double_attack,
	"ultimate": self.ultimate,
	"move_right": self.move_right,
	"move_left": self.move_left,
	"jump": self.jump
}

var attack_animations = { 
	"attack": true,
	"air_attack": true,
	"double_attack": true,
	"ultimate": true
}

func _physics_process(delta: float) -> void:
	handle_input(delta)
	apply_movement(delta)

func handle_input(_delta: float) -> void:
	var is_moving = false
	for action in input_map.keys():
		if Input.is_action_pressed(action):
			input_map[action].call(_delta)
			is_moving = true

	if not is_moving and not is_playing_attack():
		stop_moving()
		if is_on_floor():
			animated_sprite.play("idle")
		else:
			if velocity.y > 0:
				animated_sprite.play("fall")

func stop_moving() -> void:
	velocity.x = 0

func attack(_delta: float) -> void:
	if velocity.y != 0:
		play_attack_animation("air_attack")
	else:
		play_attack_animation("attack")

func double_attack(_delta: float) -> void:
	play_attack_animation("double_attack")

func ultimate(_delta: float) -> void:
	play_attack_animation("ultimate")

func move_right(_delta: float) -> void:
	if not is_playing_attack() or animated_sprite.animation == "air_attack":
		play_running_animation(false)
		velocity.x = SPEED

func move_left(_delta: float) -> void:
	if not is_playing_attack() or animated_sprite.animation == "air_attack":
		play_running_animation(true)
		velocity.x = -SPEED

func jump(_delta: float) -> void:
	if Input.is_action_pressed("jump") and not is_playing_attack():
		if is_on_floor():
			velocity.y = -JUMP_SPEED
		animated_sprite.play("jump")

func play_attack_animation(attack_name: String) -> void:
	animated_sprite.play(attack_name)
	velocity.x = 0

func play_running_animation(is_flipped: bool) -> void:
	animated_sprite.flip_h = is_flipped
	if is_on_floor() and not is_playing_attack():
		animated_sprite.play("run")

func is_playing_attack() -> bool:
	var current_frame = animated_sprite.get_frame()
	var current_progress = animated_sprite.get_frame_progress()
	if attack_animations.has(animated_sprite.animation):
		if current_frame > 0 and current_progress == 1:
			return false
		return true
	return false

func apply_movement(delta: float) -> void:
	velocity.y += fallMultiplier * GRAVITY * delta
	if velocity.y == 0:
		fallMultiplier = 2
	if velocity.y > 0 and fallMultiplier < 4:
		fallMultiplier += 0.25
	move_and_slide()
