class_name SlidingPlayerState extends PlayerMovementState

@onready var CROUCH_SHAPECAST: ShapeCast3D = %ShapeCast3D
@export var ANIM_SPEED: float = Constants.MAX_PLAYER_SLIDING_ANIM_SPEED

# TODO: Cancel slide with jump
# TODO: Add FallingState
func enter(previous_state: State) -> void:
	PLAYER.slide_start_rotation_y = PLAYER.mouse_rotation.y
	set_tilt(PLAYER.current_rotation)
	ANIMATION.get_animation("sliding").track_set_key_value(4, 0, PLAYER.velocity.length())
	ANIMATION.speed_scale = 1.0
	ANIMATION.play("sliding", -1.0, Constants.MAX_PLAYER_SLIDING_ANIM_SPEED)


func update(delta: float):
	PLAYER.update_gravity(delta)
	PLAYER.update_velocity()


func set_tilt(player_rotation) -> void:
	var tilt = Vector3.ZERO
	# Define how the camera will tilt based on current_rotation
	tilt.z = clamp(Constants.PLAYER_SLID_TILT_AMOUNT * player_rotation, -0.1, 0.1)
	if tilt.z == 0.0:
		tilt.z = 0.05
	ANIMATION.get_animation("sliding").track_set_key_value(3, 1, tilt)
	ANIMATION.get_animation("sliding").track_set_key_value(3, 2, tilt)


func finish():
	transition.emit("CrouchingPlayerState")
