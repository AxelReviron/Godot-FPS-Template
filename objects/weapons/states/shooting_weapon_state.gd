class_name ShootingWeaponState extends WeaponState


func enter(previous_state: State) -> void:
	if WEAPON.shooting_type == Weapons.ShootingType.ONCE:
		WEAPON.shoot()
	#TODO: ANIMATION.pause()


func update(delta: float):
	match WEAPON.shooting_type:
		Weapons.ShootingType.ONCE:
			if !GlobalInput.is_shooting():
				transition.emit("IdleWeaponState")
		
		Weapons.ShootingType.AUTO:
			if GlobalInput.is_shooting():
				WEAPON.shoot()
			else:
				transition.emit("IdleWeaponState")

	# TODO: Check for mag
	#if WEAPON.is_mag_empty():
		#transition.emit("ReloadingWeaponState")
	#elif not GlobalInput.is_shooting():
		#transition.emit("IdleWeaponState")


func _input(event) -> void:# TODO: Move to GlobalInput (also in player.gd)
	if event is InputEventMouseMotion:
		WEAPON.mouse_movement = event.relative
