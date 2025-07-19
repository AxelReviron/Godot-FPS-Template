extends Node


func get_move_vector() -> Vector2:
	var input = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		input.x += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	return input.normalized()


func is_jumping() -> bool:
	return Input.is_action_just_pressed("jump")


func is_released_jump() -> bool:
	return Input.is_action_just_released("jump")


func is_sprinting() -> bool:
	return Input.is_action_pressed("sprint")


func stop_sprinting() -> bool:
	return Input.is_action_just_released("sprint")


func is_crouching() -> bool:
	return Input.is_action_pressed("crouch")


func is_exiting() -> bool:
	return Input.is_action_pressed("exit")


func is_interacting() -> bool:
	return Input.is_action_just_pressed("interact")


func is_debug() -> bool:
	return Input.is_action_pressed("debug")


func is_mouse_mode_captured() -> bool:
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED


func is_shooting() -> bool:
	return Input.is_action_pressed("shoot")


func is_aiming() -> bool:
	return Input.is_action_pressed("aim")


func stop_aiming() -> bool:
	return Input.is_action_just_released("aim")
