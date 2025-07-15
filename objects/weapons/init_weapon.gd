@tool

extends Node3D

@export var WEAPON_TYPE: Weapons:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint():
			load_weapon()

@onready var weapon_mesh: MeshInstance3D = %WeaponMesh
@onready var weapon_shadow: MeshInstance3D

var mouse_movement: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_weapon()


func _input(event) -> void:
	if event is InputEventMouseMotion:
		mouse_movement = event.relative


func _physics_process(delta) -> void:
	sway_weapon(delta)


func load_weapon() -> void:
	position = WEAPON_TYPE.position # Set weapon position
	rotation_degrees = WEAPON_TYPE.rotation # Set weapon rotation
	if weapon_mesh:
		weapon_mesh.mesh = WEAPON_TYPE.mesh # Set weapon mesh
	if weapon_shadow:
		weapon_shadow.visible = WEAPON_TYPE.shadow # Turn shadow on/off


# Sway weapon based on mouse movement
func sway_weapon(delta: float) -> void:
	# Clamp mouse movement
	mouse_movement = mouse_movement.clamp(WEAPON_TYPE.sway_min, WEAPON_TYPE.sway_max)
	# Lerp weapon position based on mouse movement
	position.x = lerp(position.x, WEAPON_TYPE.position.x - (mouse_movement.x * WEAPON_TYPE.sway_amount_position) * delta, WEAPON_TYPE.sway_speed_position)
	position.y = lerp(position.y, WEAPON_TYPE.position.y + (mouse_movement.y * WEAPON_TYPE.sway_amount_position) * delta, WEAPON_TYPE.sway_speed_position)
	
	# Lerp weapon rotation based on mouse movement
	rotation_degrees.x = lerp(rotation_degrees.x, WEAPON_TYPE.rotation.x - (mouse_movement.y * WEAPON_TYPE.sway_amount_rotation) * delta, WEAPON_TYPE.sway_speed_rotation)
	rotation_degrees.y = lerp(rotation_degrees.y, WEAPON_TYPE.rotation.y + (mouse_movement.x * WEAPON_TYPE.sway_amount_rotation) * delta, WEAPON_TYPE.sway_speed_rotation)
