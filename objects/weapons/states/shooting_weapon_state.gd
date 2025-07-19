class_name ShootingWeaponState extends WeaponState


var fade_time: float = 0.4  # secondes
var fade_timer: float = 0.0
var is_fading: bool = false


func start_fade_out():
	if !is_fading:
		is_fading = true
		fade_timer = 0.0


func enter(previous_state: State) -> void:
	# Add shoot sound to AudioStream
	WEAPON.audio_stream_player.stream = WEAPON.shoot_sound
	if WEAPON.shooting_type == Weapons.ShootingType.ONCE:
		if !WEAPON.audio_stream_player.playing:
			WEAPON.audio_stream_player.play()
		WEAPON.shoot()
	#TODO: ANIMATION.pause()


func update(delta: float):
	match WEAPON.shooting_type:
		Weapons.ShootingType.ONCE:
			if !GlobalInput.is_shooting():
				transition.emit("IdleWeaponState")
		
		Weapons.ShootingType.AUTO:
			if GlobalInput.is_shooting():
				if !WEAPON.audio_stream_player.playing:
					WEAPON.audio_stream_player.play()
				WEAPON.shoot()
			else:
				start_fade_out()

	# TODO: Check for mag
	#if WEAPON.is_mag_empty():
		#transition.emit("ReloadingWeaponState")
	#elif not GlobalInput.is_shooting():
		#transition.emit("IdleWeaponState")


func _input(event) -> void:# TODO: Move to GlobalInput (also in player.gd)
	if event is InputEventMouseMotion:
		WEAPON.mouse_movement = event.relative


func _process(delta: float):
	if is_fading:
		fade_timer += delta
		var t = clamp(fade_timer / fade_time, 0.0, 1.0)
		WEAPON.audio_stream_player.volume_db = lerp(0.0, -60.0, t)  # Atténuation progressive

		if t >= 1.0:
			is_fading = false
			WEAPON.audio_stream_player.stop()
			WEAPON.audio_stream_player.volume_db = 0.0
			transition.emit("IdleWeaponState")
