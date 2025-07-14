class_name FallingPlayerState extends PlayerMovementState

var DOUBLE_JUMP: bool = false


func enter(previous_state: State) -> void:
	ANIMATION.pause()


func exit() -> void:
	pass


func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_input(Constants.PLAYER_SPEED, Constants.PLAYER_ACCELERATION, Constants.PLAYER_DECELERATION)
	PLAYER.update_velocity()
	
	if Constants.CAN_DOUBLE_JUMP and GlobalInput.is_jumping() and !DOUBLE_JUMP:
		DOUBLE_JUMP = true
		PLAYER.velocity.y = Constants.PLAYER_JUMP_VELOCITY
	
	if PLAYER.is_on_floor():
		ANIMATION.play("jump_end")
		transition.emit("IdlePlayerState")
