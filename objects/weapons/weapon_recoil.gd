extends Node3D

const MAX_RECOIL_X: float = 0.0015
const MAX_RECOIL_Y: float = 0.0020


@export var weapon: WeaponController

var current_position: Vector3
var target_position: Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	weapon.weapon_fired.connect(add_recoil)


# Reset the weapon postion each frames
func _process(delta) ->void :
	target_position = lerp(target_position, Vector3.ZERO, weapon.recoil_speed * delta)
	current_position = lerp(current_position, target_position, weapon.recoil_snap_amount * delta)
	position = current_position


func add_recoil() -> void:
	if GlobalInput.is_aiming():
		target_position += Vector3(
			-weapon.aim_recoil_amount_x * 0.5, # Weapon goes close to the player
			weapon.aim_recoil_amount_y  * 0.5, # # Weapon goes up
			0.0
		)
	else:
		target_position += Vector3(
			-weapon.recoil_amount_x * 0.5, # Weapon goes close to the player
			weapon.recoil_amount_y  * 0.5, # # Weapon goes up
			0.0
		)
