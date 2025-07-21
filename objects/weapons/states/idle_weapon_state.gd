class_name IdleWeaponState extends WeaponState


func enter(previous_state: State) -> void:
	#TODO: ANIMATION.pause()
	if previous_state.name == "ShootingWeaponState":
		WEAPON.emit_signal("weapon_stop_fire")


func update(delta: float):
	if GlobalInput.is_aiming():
		WEAPON.aim(delta)
	
	if GlobalInput.stop_aiming():
		WEAPON.reset_aim(delta)

	if GlobalInput.is_shooting():
		transition.emit("ShootingWeaponState")
	
	if GlobalInput.is_reloading():
		transition.emit("ReloadingWeaponState")


func _input(event) -> void:# TODO: Move to GlobalInput (also in player.gd)
	if event is InputEventMouseMotion:
		WEAPON.mouse_movement = event.relative
