class_name ReloadingWeaponState extends WeaponState

var is_reloading: bool = false


func reload() -> void:
	if !is_reloading and WEAPON.current_ammo != WEAPON.max_ammo:
		is_reloading = true
		if WEAPON.current_weapon_anim_player_instance:
			var duration = WEAPON.current_weapon_anim_player_instance.get_animation("reload").length
			if !WEAPON.audio_stream_player.playing:
				WEAPON.audio_stream_player.play()
			WEAPON.current_weapon_anim_player_instance.play("reload")
			await get_tree().create_timer(1).timeout
			WEAPON.current_weapon_anim_player_instance.stop()
			
		WEAPON.current_ammo = WEAPON.max_ammo
		WEAPON.update_ammo_display()
		is_reloading = false


func enter(previous_state: State) -> void:
	WEAPON.audio_stream_player.stream = WEAPON.reload_sound
	reload()


func update(delta: float):
	if GlobalInput.is_shooting() and !is_reloading:
		transition.emit("ShootingWeaponState")
	
	if !is_reloading:
		transition.emit("IdleWeaponState")
