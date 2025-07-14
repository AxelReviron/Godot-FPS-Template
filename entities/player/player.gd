extends CharacterBody3D


@export var TILT_LOWER_LIMIT: float = deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT: float = deg_to_rad(90.0)
@export var CAMERA_CONTROLLER: Camera3D
@export var ANIMATIONPLAYER: AnimationPlayer
@export var CROUCH_SHAPECAST: ShapeCast3D

var mouse_input: bool = false
var mouse_rotation: Vector3
var rotation_input: float
var tilt_input: float
var player_rotation: Vector3
var camera_rotation: Vector3
var speed: float = Constants.PLAYER_SPEED

func _update_camera(delta):
	# Get mouse rotation (limit it on X axis)
	mouse_rotation.x += tilt_input * delta
	mouse_rotation.x = clamp(mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	mouse_rotation.y += rotation_input * delta
	
	# Get player rotation on Y axis
	player_rotation = Vector3(0.0, mouse_rotation.y, 0.0)
	# Get camera rotation on X axis
	camera_rotation = Vector3(mouse_rotation.x, 0.0, 0.0)
	
	# Update camera rotation only on X and Y axis
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	# Update player rotation
	global_transform.basis = Basis.from_euler(player_rotation)
	
	# Reset mouse input to rotate the camera once per frame
	rotation_input = 0.0
	tilt_input = 0.0


func _toggle_crouch():
	if PlayerState.is_crouching and !CROUCH_SHAPECAST.is_colliding():
		ANIMATIONPLAYER.play('crouch', -1, -Constants.PLAYER_CROUCH_SPEED, true)
	elif !PlayerState.is_crouching and !PlayerState.is_jumping:
		ANIMATIONPLAYER.play('crouch', -1, Constants.PLAYER_CROUCH_SPEED)


func _on_animation_player_animation_started(anim_name):
	PlayerState.is_crouching = !PlayerState.is_crouching


func _ready():
	# Register player node globally
	Global.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Add exception for the player to the crouch ShapeCast3D
	CROUCH_SHAPECAST.add_exception($".")


func _unhandled_input(event):
	mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if mouse_input:
		rotation_input = -event.relative.x * Settings.MOUSE_SENSITIVITY
		tilt_input = -event.relative.y * Settings.MOUSE_SENSITIVITY
	
	if GlobalInput.is_exiting():
		get_tree().quit()
	
	if GlobalInput.is_crouching():
		_toggle_crouch()


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	_update_camera(delta)

	# Handle Jump
	if GlobalInput.is_jumping() and is_on_floor() and !PlayerState.is_crouching:
		velocity.y = Constants.PLAYER_JUMP_VELOCITY
		PlayerState.is_jumping = true
	elif is_on_floor() and PlayerState.is_jumping:
		PlayerState.is_jumping = false

	var move_input = GlobalInput.get_move_vector()
	var direction = (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()

	#var current_speed: float
	#if GlobalInput.is_sprinting() and !PlayerState.is_crouching:
		#current_speed = Constants.PLAYER_SPRINT_SPEED
	#elif PlayerState.is_crouching:
		#current_speed = Constants.PLAYER_CROUCH_SPEED
	#else:
		#current_speed = Constants.PLAYER_SPEED

	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, Constants.PLAYER_ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * speed, Constants.PLAYER_ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, Constants.PLAYER_DECELERATION)
		velocity.z = move_toward(velocity.z, 0, Constants.PLAYER_DECELERATION)

	move_and_slide()
	
	# Add Debug example
	# Global.debug.add_property("MovementSpeed", speed, 1)
	
