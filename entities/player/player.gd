class_name Player extends CharacterBody3D

@export var STATE_MACHINE: StateMachine

@export var TILT_LOWER_LIMIT: float = deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT: float = deg_to_rad(90.0)
@export var SLIDE_ROTATION_LIMIT: float = deg_to_rad(90.0)
@export var CAMERA_CONTROLLER: Camera3D
@export var ANIMATIONPLAYER: AnimationPlayer

var mouse_input: bool = false
var mouse_rotation: Vector3
var rotation_input: float
var tilt_input: float
var player_rotation: Vector3
var camera_rotation: Vector3
var current_rotation: float

var slide_start_rotation_y

func _update_camera(delta):
	current_rotation = rotation_input
	# Get mouse rotation (limit it on X axis)
	mouse_rotation.x += tilt_input * delta
	mouse_rotation.x = clamp(mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	
	# If player is sliding his rotation is limit on Y axis
	if STATE_MACHINE.CURRENT_STATE is SlidingPlayerState:
		mouse_rotation.y = clamp(mouse_rotation.y, slide_start_rotation_y - SLIDE_ROTATION_LIMIT, slide_start_rotation_y + SLIDE_ROTATION_LIMIT)
	
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


func update_gravity(delta) -> void:
	velocity += get_gravity() * delta


func update_input(speed: float, acceleration: float, deceleration: float) -> void:
	var move_input = GlobalInput.get_move_vector()
	var direction = (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()

	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)


func update_velocity() -> void:
	move_and_slide()


func _ready():
	# Register player node globally
	Global.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
	mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if mouse_input:
		rotation_input = -event.relative.x * Settings.MOUSE_SENSITIVITY
		tilt_input = -event.relative.y * Settings.MOUSE_SENSITIVITY
	
	if GlobalInput.is_exiting():
		get_tree().quit()


func _physics_process(delta):
	_update_camera(delta)

	# Handle Jump
	#if GlobalInput.is_jumping() and is_on_floor() and !PlayerState.is_crouching:
	#	velocity.y = Constants.PLAYER_JUMP_VELOCITY
	#	PlayerState.is_jumping = true
	#elif is_on_floor() and PlayerState.is_jumping:
	#	PlayerState.is_jumping = false
