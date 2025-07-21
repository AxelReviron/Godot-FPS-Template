class_name ReloadingWeaponState extends WeaponState

var is_reloading: bool = true


func enter(previous_state: State) -> void:
	pass
	# TODO:
	# Start reloading animation
	# wait for finish
	WEAPON.reload()
	is_reloading = false


func update(delta: float):
	if GlobalInput.is_shooting():
		transition.emit("ShootingWeaponState")
	
	if !is_reloading:
		transition.emit("IdleWeaponState")
