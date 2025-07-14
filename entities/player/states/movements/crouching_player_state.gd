class_name CrouchingPlayerState extends PlayerMovementState

@onready var CROUCH_SHAPECAST: ShapeCast3D = %ShapeCast3D

var RELEASED: bool = false

func enter(previous_state: State) -> void:
	ANIMATION.speed_scale = 1.0
	# If player was not sliding, play crouch aimation as usual
	if previous_state.name != "SlidingPlayerState":
		ANIMATION.play("crouching", -1.0, Constants.PLAYER_CROUCH_SPEED)
	# If player was sliding, play crouch animation from the end
	elif previous_state.name == "SlidingPlayerState":
		ANIMATION.current_animation = "crouching"
		ANIMATION.seek(1.0, true)

func exit() -> void:
	RELEASED = false


func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(Constants.PLAYER_CROUCH_SPEED, Constants.PLAYER_ACCELERATION, Constants.PLAYER_DECELERATION)
	PLAYER.update_velocity()
	
	if !GlobalInput.is_crouching() and !RELEASED:
		RELEASED = true
		uncrouch()


func uncrouch():
	if !CROUCH_SHAPECAST.is_colliding():
		ANIMATION.play("crouching", -1.0, -Constants.PLAYER_CROUCH_SPEED, true)
		await ANIMATION.animation_finished
		# When animation is finished and player is not moving, he goes to idle State
		if PLAYER.velocity.length() == 0:
			transition.emit("IdlePlayerState")
		else:
			transition.emit("WalkingPlayerState")
	elif CROUCH_SHAPECAST.is_colliding():
		await get_tree().create_timer(0.1).timeout
		uncrouch()
