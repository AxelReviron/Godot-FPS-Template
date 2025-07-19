extends Node3D

const MAX_RECOIL_X: float = 0.5

@export var weapon: WeaponController

var current_rotation: Vector3
var target_rotation: Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	weapon.weapon_fired.connect(add_recoil)


# Reset the recoil each frames
func _process(delta) ->void :
	# Return lerp
	target_rotation = lerp(target_rotation, Vector3.ZERO, weapon.recoil_speed * delta)
	current_rotation = lerp(current_rotation, target_rotation, weapon.recoil_snap_amount * delta)
	basis = Quaternion.from_euler(current_rotation)


func add_recoil() -> void:
	if GlobalInput.is_aiming():
		target_rotation += Vector3(
			clamp(weapon.aim_recoil_amount_x, -MAX_RECOIL_X, MAX_RECOIL_X), # Recoil up
			randf_range(-weapon.aim_recoil_amount_y, weapon.aim_recoil_amount_y), # Recoil sides
			0.0
		)
	else :
		target_rotation += Vector3(
			clamp(weapon.recoil_amount_x, -MAX_RECOIL_X, MAX_RECOIL_X), # Recoil up
			randf_range(-weapon.recoil_amount_y, weapon.recoil_amount_y), # Recoil sides
			0.0
		)
