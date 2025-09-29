class_name Player extends CharacterBody3D

@export var MOVEMENT_STATE_MACHINE: PlayerMovementStateMachine
@export var HEALTH_STATE_MACHINE: PlayerHealthStateMachine

@export var DEFAULT_HEALTH: int = 100

@export var TILT_LOWER_LIMIT: float = deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT: float = deg_to_rad(90.0)
@export var SLIDE_ROTATION_LIMIT: float = deg_to_rad(90.0)

@export var CAMERA_CONTROLLER: Camera3D
@export var ANIMATIONPLAYER: AnimationPlayer
@export var WEAPON_CONTROLLER: WeaponController


# Multiplayer
@export var spawn_points: Array[Vector3]

# AnimationTree
@export var walk_anim_val = 0
@export var walk_sides_anim_val = 0
@export var jump_anim_val = 0

# Character
#@export var character_collisions: Array[CollisionShape3D]
@export var character_skeleton: Skeleton3D
@export var first_person_arms: Node3D

@onready var anim_player: AnimationPlayer = %Character.get_node("AnimationPlayer")
@onready var anim_tree_player: AnimationTree = %Character.get_node("AnimationTree")
@onready var character_physical_bone_sim: PhysicalBoneSimulator3D = $Character/Skeleton3D/PhysicalBoneSimulator3D

var health: int

# AnimationTree
var blend_speed = 20

var mouse_input: bool = false
var mouse_rotation: Vector3

var rotation_input: float
var tilt_input: float

var player_rotation: Vector3
var camera_rotation: Vector3
var current_rotation: float
var slide_start_rotation_y: float
var interact_cast_result: Object

# Character
var char_anim_type_name: String
var self_collision_to_exclude: Array = []


# Ideas: Display body_part hit in HUD
func take_dammage(body_part: String, hit_dammage: float) -> void:
	print("Player: ", multiplayer.get_unique_id(), " take ", hit_dammage, " dammage in ", body_part)
	health -= hit_dammage


## Collisions of the character's player are gonna be excluded while shooting
func _exclude_self_collisions(node: Node, depth: int = 0, max_depth: int = 10) -> void:
	if depth > max_depth or !is_instance_valid(node):
		return
	
	if node is CollisionShape3D:
		# Reset all layers
		self_collision_to_exclude.append(node)
	
	for child in node.get_children():
		_exclude_self_collisions(child, depth + 1, max_depth)#


func _update_camera(delta):
	current_rotation = rotation_input
	# Get mouse rotation (limit it on X axis)
	mouse_rotation.x += tilt_input * delta
	mouse_rotation.x = clamp(mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	
	# If player is sliding his rotation is limit on Y axis
	if MOVEMENT_STATE_MACHINE.CURRENT_STATE is SlidingPlayerState:
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


## Project a ray cast from the center of the screen and return the object hit.
func _interact_cast() :
	var hit: Dictionary = Global.get_forward_ray_hit(CAMERA_CONTROLLER, get_viewport(), Constants.INTERACT_DISTANCE, 1, false)
	var object_hit = hit.get("collider")
	
	# If it's a different object hit
	if object_hit != interact_cast_result:
		if interact_cast_result and interact_cast_result.has_user_signal("unfocused"):
			interact_cast_result.emit_signal("unfocused")
			
		interact_cast_result = object_hit
		
		if interact_cast_result and interact_cast_result.has_user_signal("focused"):
			interact_cast_result.emit_signal("focused")


## Interact with the object hit by the ray cast
func _interact() -> void:
	if interact_cast_result and interact_cast_result.has_user_signal("interacted"):
		interact_cast_result.emit_signal("interacted")


func _define_walk_blend_char_animations(delta: float):
	var move_input = GlobalInput.get_move_vector()

	if move_input.y < 0:# Walk Forward
		walk_anim_val = lerpf(walk_anim_val, 1, blend_speed * delta)

	if move_input.y > 0:# Walk Backward
		walk_anim_val = lerpf(walk_anim_val, -1, blend_speed * delta)
		
	if move_input.x < 0:# Walk Left
		walk_sides_anim_val = lerpf(walk_sides_anim_val, 1, blend_speed * delta)

	if move_input.x > 0:# Walk Right
		walk_sides_anim_val = lerpf(walk_sides_anim_val, -1, blend_speed * delta)
		
	if move_input.y == 0 and move_input.x == 0 and is_on_floor():# Idle
		walk_anim_val = lerpf(walk_anim_val, 0, blend_speed * delta)
		walk_sides_anim_val = lerpf(walk_sides_anim_val, 0, blend_speed * delta)

	if !is_on_floor():# Idle Jump
		jump_anim_val = lerpf(jump_anim_val, 1, blend_speed * delta)
	if is_on_floor():# Idle Jump
		jump_anim_val = lerpf(jump_anim_val, 0, blend_speed * delta)
	
	#TODO: Only if player is not in PlayerDeadState
	# All players apply theses values
	%AnimationTree.set("parameters/PistolWalk/WalkToward/blend_amount", walk_anim_val)
	%AnimationTree.set("parameters/PistolWalk/WalkSides/blend_amount", walk_sides_anim_val)
	%AnimationTree.set("parameters/PistolWalk/Jump/blend_amount", jump_anim_val)
	
	%AnimationTree.set("parameters/RifleWalk/WalkToward/blend_amount", walk_anim_val)
	%AnimationTree.set("parameters/RifleWalk/WalkSides/blend_amount", walk_sides_anim_val)
	%AnimationTree.set("parameters/RifleWalk/Jump/blend_amount", jump_anim_val)


func _setup_camera_layers() -> void:
	if not character_skeleton:
		return
	
	#TODO: Is Weapon Camera useless ??
	set_layer_recursive(character_skeleton, 3)# Hide his character (Layer 3)
	#if first_person_arms:
		#set_layer_recursive(first_person_arms, 2)# See his arms and weapons (Layer 2)
	CAMERA_CONTROLLER.cull_mask = 0b011# See on layers 1 and 2 (not 3)
		#if first_person_arms:
			#set_layer_recursive(first_person_arms, 3)# Hide others players arms and weapon (Layer 3)


func set_layer_recursive(node: Node, layer: int, depth: int = 0, max_depth: int = 10):
	if depth > max_depth or !is_instance_valid(node):
		return
	
	if node is MeshInstance3D:
		# Reset all layers
		for i in range(1, 21):
			node.set_layer_mask_value(i, false)
		# Activate only one layer
		node.set_layer_mask_value(layer, true)
	
	for child in node.get_children():
		set_layer_recursive(child, layer, depth + 1, max_depth)


func _ready():
	# TODO: Check this
	#CAMERA_CONTROLLER.current = is_multiplayer_authority()
	_setup_camera_layers()
	
	health = DEFAULT_HEALTH
	
	#_exclude_self_collisions(character_physical_bone_sim)

	# Define the character weapon animation type for the AnimationTree StateMachine
	var enum_keys = Weapons.CharAnimType.keys()
	char_anim_type_name = enum_keys[WEAPON_CONTROLLER.WEAPON_TYPE.char_anim_type]

	Global.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
	mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if mouse_input:
		rotation_input = -event.relative.x * Settings.MOUSE_SENSITIVITY
		tilt_input = -event.relative.y * Settings.MOUSE_SENSITIVITY
	
	if GlobalInput.is_exiting():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if GlobalInput.is_interacting():
		#_interact_cast()
		_interact()


func _physics_process(delta):
	_update_camera(delta)
	_interact_cast()
	_define_walk_blend_char_animations(delta)


#func _set_spawn_point():
	#print('_set_spawn_point')
	#var index = Global.connected_peers.size() - 1
	#if index >= spawn_points.size():
		#print("No available spawn point for player ", self.name)
		#index = 0 # fallback
		#
	#var spawn_point: Vector3 = spawn_points[index]
	#global_position = spawn_point
