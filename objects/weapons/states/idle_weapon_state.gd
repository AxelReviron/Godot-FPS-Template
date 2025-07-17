class_name IdleWeaponState extends WeaponState


func enter(previous_state: State) -> void:
	#TODO: ANIMATION.pause()
	pass


func update(delta: float):
	if GlobalInput.is_shooting():
		transition.emit("ShootingWeaponState")


func _input(event) -> void:# TODO: Move to GlobalInput (also in player.gd)
	if event is InputEventMouseMotion:
		WEAPON.mouse_movement = event.relative
