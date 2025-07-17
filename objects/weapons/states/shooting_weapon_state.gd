class_name ShootingWeaponState extends WeaponState


func enter(previous_state: State) -> void:
	WEAPON.shoot()
	#TODO: ANIMATION.pause()


func update(delta: float):
	if not GlobalInput.is_shooting():
		transition.emit("IdleWeaponState")
	
	# TODO: Check for mag
	#if WEAPON.is_mag_empty():
		#transition.emit("ReloadingWeaponState")
	#elif not GlobalInput.is_shooting():
		#transition.emit("IdleWeaponState")


func _input(event) -> void:# TODO: Move to GlobalInput (also in player.gd)
	if event is InputEventMouseMotion:
		WEAPON.mouse_movement = event.relative
