class_name CrouchingPlayerState extends PlayerMovementState

@onready var CROUCH_SHAPECAST: ShapeCast3D = %ShapeCast3D


func enter() -> void:
	ANIMATION.play("crouching", -1.0, Constants.PLAYER_CROUCH_SPEED)


func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(Constants.PLAYER_CROUCH_SPEED, Constants.PLAYER_ACCELERATION, Constants.PLAYER_DECELERATION)
	PLAYER.update_velocity()
	
	if GlobalInput.is_crouching():
		uncrouch()


func uncrouch():
	if !CROUCH_SHAPECAST.is_colliding():
		ANIMATION.play("crouching", -1.0, -Constants.PLAYER_CROUCH_SPEED * 1.5, true)
		if ANIMATION.is_playing():
			await ANIMATION.animation_finished
		transition.emit("IdlePlayerState")
	elif CROUCH_SHAPECAST.is_colliding():
		await get_tree().create_timer(0.1).timeout
		uncrouch()
