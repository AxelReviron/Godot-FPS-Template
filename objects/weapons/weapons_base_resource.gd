class_name Weapons extends Resource

## Should match the key in the WeaponDatabase, used in the WeaponInteractionComponenent to load weapon
@export var name: StringName
@export_group("Weapon Orientation")
@export var position: Vector3
@export var rotation: Vector3
@export var scale: Vector3

@export_group("Visual Settings")
@export var scene: PackedScene
@export var icon_texture: Texture2D
@export var aim_position: Vector3
@export var aim_rotation: Vector3
@export var aim_speed: float = 8.0
@export var aim_fov: float = 50

@export_group("Weapon Sway")
@export var sway_min: Vector2 = Vector2(-20.0, -20.0)
@export var sway_max: Vector2 = Vector2(20.0, 20.0)
@export_range(0, 0.2, 0.01) var sway_speed_position: float = 0.07
@export_range(0, 0.2, 0.01) var sway_speed_rotation: float = 0.1
@export_range(0, 0.25, 0.01) var sway_amount_position: float = 0.1
@export_range(0, 50, 0.1) var sway_amount_rotation: float = 30.0
@export_subgroup("Idle Sway")
@export var idle_sway_adjustment: float = 10.0
@export var idle_sway_rotation_strength: float = 300.0
@export_range(0.1, 10.0, 0.1) var random_sway_amount: float = 5.0

@export_group("Weapon Recoil")
@export_range(0, 1, 0.01) var recoil_amount_x: float
@export_range(0, 1, 0.01) var recoil_amount_y: float
@export_range(0, 10, 1.0) var recoil_snap_amount: float
@export_range(0, 10, 1.0) var recoil_speed: float
@export_range(0, 10, 0.01) var aim_recoil_amount_x: float
@export_range(0, 1, 0.01) var aim_recoil_amount_y: float

@export_group("Weapon Muzzle Flash")
@export var muzzle_flash_position: Vector3


@export_group("Weapon Shooting Properties")
@export var fire_rate: float
enum ShootingType { AUTO, ONCE }
@export var shooting_type: ShootingType = ShootingType.ONCE

@export_group("Weapon Ammo")
@export var max_ammo: int

# TODO: Audio
@export_group("Weapon Sound")
@export var shoot_sound: AudioStreamWAV

static func get_shooting_type_name(value: int) -> String:
	for name in ShootingType.keys():
		if ShootingType[name] == value:
			return name
	return "UNKNOWN"
