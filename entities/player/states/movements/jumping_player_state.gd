class_name JumpingPlayerState extends PlayerMovementState


func enter(previous_state: State) -> void:
	PLAYER.velocity.y += Constants.PLAYER_JUMP_VELOCITY
	ANIMATION.pause()


func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(Constants.PLAYER_SPRINT_SPEED * Constants.PLAYER_JUMP_INPUT_MULTIPLIER, Constants.PLAYER_ACCELERATION, Constants.PLAYER_DECELERATION)
	PLAYER.update_velocity()
	
	if PLAYER.is_on_floor() and PLAYER.velocity.length() == 0:
		transition.emit("IdlePlayerState")
	
	if PLAYER.is_on_floor() and PLAYER.velocity.length() > 6:
		transition.emit("SprintingPlayerState")
	
	if PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")
