class_name IdlePlayerState extends PlayerMovementState


func enter(previous_state: State) -> void:
	ANIMATION.pause()


func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(Constants.PLAYER_SPEED, Constants.PLAYER_ACCELERATION, Constants.PLAYER_DECELERATION)
	PLAYER.update_velocity()
	
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")

	if GlobalInput.is_crouching() and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
