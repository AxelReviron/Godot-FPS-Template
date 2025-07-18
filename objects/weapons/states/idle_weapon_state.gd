class_name IdleWeaponState extends WeaponState


func enter(previous_state: State) -> void:
	#TODO: ANIMATION.pause()
	if previous_state.name == "ShootingWeaponState":
		WEAPON.emit_signal("weapon_stop_fire")


func update(delta: float):
	if GlobalInput.is_shooting():
		transition.emit("ShootingWeaponState")


func _input(event) -> void:# TODO: Move to GlobalInput (also in player.gd)
	if event is InputEventMouseMotion:
		WEAPON.mouse_movement = event.relative
