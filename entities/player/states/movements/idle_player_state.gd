class_name IdlePlayerState extends PlayerMovementState


func enter(previous_state: State) -> void:
	#TODO: Test Multi
	if !is_multiplayer_authority():
		return
	if ANIMATION.is_playing() and ANIMATION.current_animation == "jump_end":
		await ANIMATION.animation_finished
	
	ANIMATION.pause()


func update(delta: float):
	#TODO: Test Multi
	if !is_multiplayer_authority():
		return
	PLAYER.update_gravity(delta)
	PLAYER.update_input(Constants.PLAYER_SPEED, Constants.PLAYER_ACCELERATION, Constants.PLAYER_DECELERATION)
	PLAYER.update_velocity()
	
	WEAPON.sway_weapon(delta, true)
	
	
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")

	if GlobalInput.is_crouching() and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
	
	if GlobalInput.is_jumping() and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
	
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
