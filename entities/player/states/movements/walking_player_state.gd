class_name WalkingPlayerState extends PlayerMovementState


func enter(previous_state: State) -> void:
	if ANIMATION.is_playing() and ANIMATION.current_animation == "jump_end":
		await ANIMATION.animation_finished

	ANIMATION.play("walking", -1.0, 1.0)


func exit() -> void:
	ANIMATION.speed_scale = 1.0


func update(delta: float):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(Constants.PLAYER_SPEED, Constants.PLAYER_ACCELERATION, Constants.PLAYER_DECELERATION)
	PLAYER.update_velocity()
	
	WEAPON.sway_weapon(delta, false)
	WEAPON.weapon_bob(delta, Constants.WEAPON_WALKING_BOB_SPEED, Constants.WEAPON_WALKING_BOB_H_AMOUNT, Constants.WEAPON_WALKING_BOB_V_AMOUNT)
	
	set_animation_speed(PLAYER.velocity.length())
	if PLAYER.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
	
	if GlobalInput.is_sprinting():
		transition.emit("SprintingPlayerState")
	
	if GlobalInput.is_crouching() and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
	
	if GlobalInput.is_jumping() and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
	
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")


func set_animation_speed(speed):
	var alpha = remap(speed, 0.0, Constants.PLAYER_SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, Constants.MAX_PLAYER_WALKING_ANIM_SPEED, alpha)
