class_name JumpingPlayerState extends PlayerMovementState

var DOUBLE_JUMP: bool = false


func enter(previous_state: State) -> void:
	PLAYER.velocity.y += Constants.PLAYER_JUMP_VELOCITY
	ANIMATION.play("jump_start")


func exit() -> void:
	DOUBLE_JUMP = false


func update(delta: float):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(Constants.PLAYER_SPRINT_SPEED * Constants.PLAYER_JUMP_INPUT_MULTIPLIER, Constants.PLAYER_ACCELERATION, Constants.PLAYER_DECELERATION)
	PLAYER.update_velocity()
	
	# Adjust jump strength based on when user released the jump key
	if GlobalInput.is_released_jump():
		if PLAYER.velocity.y > 0:
			PLAYER.velocity.y = PLAYER.velocity.y / 2.0
	
	if Constants.CAN_DOUBLE_JUMP and GlobalInput.is_jumping() and !DOUBLE_JUMP:
		DOUBLE_JUMP = true
		PLAYER.velocity.y = Constants.PLAYER_JUMP_VELOCITY
	
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
	
	if PLAYER.is_on_floor():
		ANIMATION.play("jump_end")
		transition.emit("IdlePlayerState")
