@tool

class_name WeaponController extends Node3D

signal weapon_fired


@export var WEAPON_TYPE: Weapons:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint():
			load_weapon()

@export var sway_noise: NoiseTexture2D
@export var sway_speed: float = 1.2
@export var reset: bool = false:
	set(value):
		reset = value
		if Engine.is_editor_hint():
			load_weapon()

@export var ANIMATIONPLAYER: AnimationPlayer

@onready var weapon_mesh: MeshInstance3D = %WeaponMesh
@onready var weapon_shadow: MeshInstance3D

# Weapon Scene
@onready var weapon_scene: Node3D = %WeaponScene # Weapon Node container for the weapon scene
var current_weapon_instance: Node3D = null  # Reference to the weapon scene (defined in the weapon_resource)

# Sway
var mouse_movement: Vector2
var random_sway_x: float
var random_sway_y: float
var random_sway_amount: float
var time: float = 0.0
var idle_sway_adjustment: float
var idle_sway_rotation_strength: float
var weapon_bob_amount: Vector2 = Vector2(0, 0)

# Recoil
var recoil_amount_x: float
var recoil_amount_y: float
var recoil_snap_amount: float
var recoil_speed: float

var bullet_hole = preload("res://objects/weapons/bullet_hole/bullet_hole.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_weapon()


#func _input(event) -> void:# TODO: Move to GlobalInput (also in player.gd)
	#if event is InputEventMouseMotion:
		#mouse_movement = event.relative


func load_weapon() -> void:
	position = WEAPON_TYPE.position # Set weapon position
	rotation_degrees = WEAPON_TYPE.rotation # Set weapon rotation
	scale = WEAPON_TYPE.scale # Set weapon scale
	
	# Instanciate the weapon mesh or the weapon scene
	if WEAPON_TYPE.mesh:
		weapon_mesh.mesh = WEAPON_TYPE.mesh # Set weapon mesh
	elif WEAPON_TYPE.scene:
		current_weapon_instance = WEAPON_TYPE.scene.instantiate()
		if weapon_scene:
			weapon_scene.add_child(current_weapon_instance)
	else:
		print("WeaponController need to have a mesh or a scene")
	
	if WEAPON_TYPE.shadow:
		weapon_shadow.visible = WEAPON_TYPE.shadow # Turn shadow on/off
	
	idle_sway_adjustment = WEAPON_TYPE.idle_sway_adjustment
	idle_sway_rotation_strength = WEAPON_TYPE.idle_sway_rotation_strength
	random_sway_amount = WEAPON_TYPE.random_sway_amount
	
	recoil_amount_x = WEAPON_TYPE.recoil_amount_x
	recoil_amount_y = WEAPON_TYPE.recoil_amount_y
	recoil_snap_amount = WEAPON_TYPE.recoil_snap_amount
	recoil_speed = WEAPON_TYPE.recoil_speed


# Sway weapon based on mouse movement
func sway_weapon(delta: float, isIdle: bool) -> void:
	# Clamp mouse movement
	mouse_movement = mouse_movement.clamp(WEAPON_TYPE.sway_min, WEAPON_TYPE.sway_max)
	var to_x_position: float 
	var to_y_position: float
	var to_x_rotation: float
	var to_y_rotation: float
	
	if isIdle:
		# Get random sway value from 2D noise
		var sway_random: float = get_sway_noise()
		var sway_random_adjusted: float = sway_random * idle_sway_adjustment # Adjust sway strength
		
		# Create two random waves
		time += delta * (sway_speed + sway_random)
		random_sway_x = sin(time * 1.5 + sway_random_adjusted) / random_sway_amount
		random_sway_y = sin(time - sway_random_adjusted) / random_sway_amount

		to_x_position = WEAPON_TYPE.position.x - (mouse_movement.x * WEAPON_TYPE.sway_amount_position + random_sway_x) * delta
		to_y_position = WEAPON_TYPE.position.y + (mouse_movement.y * WEAPON_TYPE.sway_amount_position + random_sway_y) * delta
		to_x_rotation = WEAPON_TYPE.rotation.x - (mouse_movement.y * WEAPON_TYPE.sway_amount_rotation + (random_sway_x * idle_sway_rotation_strength)) * delta
		to_y_rotation = WEAPON_TYPE.rotation.y + (mouse_movement.x * WEAPON_TYPE.sway_amount_rotation + (random_sway_y * idle_sway_rotation_strength)) * delta
		
		# Lerp weapon position based on mouse movement
		position.x = lerp(position.x, to_x_position, WEAPON_TYPE.sway_speed_position)
		position.y = lerp(position.y, to_y_position, WEAPON_TYPE.sway_speed_position)
		# Lerp weapon position based on mouse movement
		rotation_degrees.x = lerp(rotation_degrees.x, to_x_rotation, WEAPON_TYPE.sway_speed_rotation)
		rotation_degrees.y = lerp(rotation_degrees.y, to_y_rotation, WEAPON_TYPE.sway_speed_rotation)
	else:
		to_x_position = WEAPON_TYPE.position.x - (mouse_movement.x * WEAPON_TYPE.sway_amount_position + weapon_bob_amount.x) * delta
		to_y_position = WEAPON_TYPE.position.y + (mouse_movement.y * WEAPON_TYPE.sway_amount_position + weapon_bob_amount.y) * delta
		to_x_rotation = WEAPON_TYPE.rotation.x - (mouse_movement.y * WEAPON_TYPE.sway_amount_rotation) * delta
		to_y_rotation = WEAPON_TYPE.rotation.y + (mouse_movement.x * WEAPON_TYPE.sway_amount_rotation) * delta
	
		# Lerp weapon position based on mouse movement
		position.x = lerp(position.x, to_x_position, WEAPON_TYPE.sway_speed_position)
		position.y = lerp(position.y, to_y_position, WEAPON_TYPE.sway_speed_position)
		# Lerp weapon position based on mouse movement
		rotation_degrees.x = lerp(rotation_degrees.x, to_x_rotation, WEAPON_TYPE.sway_speed_rotation)
		rotation_degrees.y = lerp(rotation_degrees.y, to_y_rotation, WEAPON_TYPE.sway_speed_rotation)


# Get sway noise based on the player position
func get_sway_noise() -> float:
	var player_position: Vector3 = Vector3(0, 0, 0)
	
	if !Engine.is_editor_hint():
		player_position = Global.player.global_position
		
	return sway_noise.noise.get_noise_2d(player_position.x, player_position.y)


# Make weapon move with little bounce
func weapon_bob(delta: float, bob_speed: float, h_bob_amount: float, v_bob_amount: float) -> void:
	time += delta
	
	weapon_bob_amount.x = sin(time * bob_speed) * h_bob_amount
	weapon_bob_amount.y = abs(cos(time * bob_speed) * v_bob_amount)


func shoot() -> void:
	weapon_fired.emit()
	var camera: Camera3D = Global.player.CAMERA_CONTROLLER
	var space_state: PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state
	var screen_center: Vector2i = get_viewport().size / 2
	
	var ray_origin: Vector3 = camera.project_ray_origin(screen_center)# Center of the screen is the origin for the raycast
	var ray_distance: float = 1000.0
	var ray_end = ray_origin + camera.project_ray_normal(screen_center) * ray_distance
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_bodies = true # Make raycast collide with physic bodies
	var result: Dictionary = space_state.intersect_ray(query) # intersect_shape for rocket launcher, grenades...
	if result:
		_display_bullet_hole(result.get("position"), result.get("normal"))


# normal is the direction that the surface shooted is pointing
# With the normal we can adjust the rotation of the bullet_hole 
func _display_bullet_hole(position: Vector3, normal: Vector3) -> void:
	# Add bulet hole decal to the scene
	var bullet_hole_instance: Node3D = bullet_hole.instantiate()
	get_tree().root.add_child(bullet_hole_instance)
	bullet_hole_instance.global_position = position

	# Bullet shooted into walls
	if normal != Vector3.UP and normal != Vector3.DOWN:
		bullet_hole_instance.look_at(position + normal, Vector3.UP)
		bullet_hole_instance.rotate_object_local(Vector3.RIGHT, deg_to_rad(90))

	# Bullet shooted into floor or ceiling
	elif normal == Vector3.UP or normal == Vector3.DOWN:
		bullet_hole_instance.look_at(position + normal, Vector3.UP)
		bullet_hole_instance.rotate_object_local(Vector3.RIGHT, deg_to_rad(90))

	await get_tree().create_timer(2).timeout
	var fade = get_tree().create_tween()
	fade.tween_property(bullet_hole_instance, "modulate:a", 0, 0.5)
	
	await get_tree().create_timer(0.5).timeout
	bullet_hole_instance.queue_free()
