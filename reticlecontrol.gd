extends Control


const SPEED = 5
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	var center_screen = get_viewport_rect().size / 2
	position = center_screen

func _process(delta: float) -> void:

	#var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		position.x += SPEED
	if Input.is_action_pressed("move_left"):
		position.x -= SPEED
	if Input.is_action_pressed("move_down"):
		position.y += SPEED
	if Input.is_action_pressed("move_up"):
		position.y -= SPEED

	#if velocity.length() > 0:
		#velocity = velocity.normalized() * SPEED
		#move_toward(velocity.x, delta, SPEED)
