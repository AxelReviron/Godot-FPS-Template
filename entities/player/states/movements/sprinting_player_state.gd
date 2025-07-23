class_name SprintingPlayerState extends PlayerMovementState


func enter(previous_state: State) -> void:
	if ANIMATION.is_playing() and ANIMATION.current_animation == "jump_end":
		await ANIMATION.animation_finished

	ANIMATION.play("sprinting", 0.5, 1.0)


func exit() -> void:
	ANIMATION.speed_scale = 1.0


func update(delta: float):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(Constants.PLAYER_SPRINT_SPEED, Constants.PLAYER_ACCELERATION, Constants.PLAYER_DECELERATION)
	PLAYER.update_velocity()
	
	WEAPON.sway_weapon(delta, false)
	WEAPON.weapon_bob(delta, Constants.WEAPON_SPRINTING_BOB_SPEED, Constants.WEAPON_SPRINTING_BOB_H_AMOUNT, Constants.WEAPON_SPRINTING_BOB_V_AMOUNT)
	
	set_animation_speed(PLAYER.velocity.length())
	
	if GlobalInput.stop_sprinting():
		transition.emit("WalkingPlayerState")
	
	# If player is crouching and has enought velocity he can slide
	if GlobalInput.is_crouching() and PLAYER.velocity.length() > 6:
		transition.emit("SlidingPlayerState")

	if GlobalInput.is_jumping() and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
	
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")


func set_animation_speed(speed):
	var alpha = remap(speed, 0.0, Constants.PLAYER_SPRINT_SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, Constants.MAX_PLAYER_SPRINTING_ANIM_SPEED, alpha)
