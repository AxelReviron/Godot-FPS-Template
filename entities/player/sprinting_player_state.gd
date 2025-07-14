class_name SprintingPlayerState extends PlayerMovementState


func enter() -> void:
	ANIMATION.play("sprinting", 0.5, 1.0)


func exit() -> void:
	ANIMATION.speed_scale = 1.0


func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(Constants.PLAYER_SPRINT_SPEED, Constants.PLAYER_ACCELERATION, Constants.PLAYER_DECELERATION)
	PLAYER.update_velocity()
	
	set_animation_speed(PLAYER.velocity.length())
	
	if GlobalInput.stop_sprinting():
		transition.emit("WalkingPlayerState")


func set_animation_speed(speed):
	var alpha = remap(speed, 0.0, Constants.PLAYER_SPRINT_SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, Constants.MAX_PLAYER_SPRINTING_ANIM_SPEED, alpha)
