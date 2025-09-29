class_name ShootingWeaponState extends WeaponState


var fade_time: float = 0.4  # secondes
var fade_timer: float = 0.0
var is_fading: bool = false
var can_shoot: bool = true


# Ideas :
# Shoot in the hands or the arms -> Impossible to shoot or to aim
# Shoot in the legs or feet -> Slow movement speed
func _calculate_hit_dammage_for_body_part(body_part: String) -> float:
	body_part = body_part.to_lower()
	var hit_dammage = WEAPON.dammage
	
	if body_part == "head":
		return hit_dammage * 3.4 # 1 Ak bullet need to kill | 2 Pistol bullets need to kill
	elif body_part == "torso":
		return hit_dammage * 1.4 # 3 Ak bullets need to kill
	else:
		return hit_dammage # 4 AK bullets need to kill 


func _find_player_node_from_collider(collider) -> CharacterBody3D:
	var current = collider
	while current != null:
		if current is CharacterBody3D:
			return current
		current = current.get_parent()
	return null


func _shoot() -> void:
	if !can_shoot or WEAPON.current_ammo == 0:
		return
	
	if WEAPON.current_weapon_anim_player_instance:
		WEAPON.current_weapon_anim_player_instance.play("shoot")

	can_shoot = false
	WEAPON.current_ammo -= 1
	WEAPON.update_ammo_display()
	WEAPON.weapon_fired.emit()
	# Handle ammo
	
	var camera: Camera3D = Global.player.CAMERA_CONTROLLER
	var viewport: Viewport = get_viewport()

	var hit = Global.get_forward_ray_hit(camera, get_viewport(), 1000.0, 2, true, [Global.player.character_physical_bone_sim])# Collision Mask 2 (only for shoot)
	var collider = hit.get("collider")
	print(collider)
	
	if collider:
		_display_bullet_hole(hit.get("position"), hit.get("normal"))
		print("collider: ", collider.name)
	
		if collider is Area3D:
			var hit_dammage = _calculate_hit_dammage_for_body_part(collider.name)
			var player_hit: Player = _find_player_node_from_collider(collider)
			player_hit.take_dammage.rpc(collider.name, hit_dammage)
			_emit_blood_particles(hit.get("position"), hit.get("normal"))
	
	await get_tree().create_timer(WEAPON.fire_rate).timeout
	can_shoot = true
	
	if WEAPON.current_weapon_anim_player_instance:
		WEAPON.current_weapon_anim_player_instance.stop()


func _emit_blood_particles(position: Vector3, normal: Vector3) -> void:
	var impact_instance = WEAPON.blood_impact_scene.instantiate() as GPUParticles3D
	self.add_child(impact_instance)
	
	impact_instance.global_transform.origin = position
	# Oriente la particule pour "regarder" dans la direction de la normale
	impact_instance.global_transform.basis = Basis().looking_at(position - normal, Vector3.UP)
	impact_instance.emitting = true

	await get_tree().create_timer(1.0).timeout
	impact_instance.queue_free()


# normal is the direction that the surface shooted is pointing
# With the normal we can adjust the rotation of the bullet_hole 
func _display_bullet_hole(position: Vector3, normal: Vector3) -> void:
	# Add bulet hole decal to the scene
	var bullet_hole_instance: Node3D = WEAPON.bullet_hole.instantiate()
	get_tree().root.add_child(bullet_hole_instance)
	bullet_hole_instance.global_position = position

	# Bullet shooted into walls
	if normal != Vector3.UP and normal != Vector3.DOWN:
		bullet_hole_instance.look_at(position + normal, Vector3.UP)
		bullet_hole_instance.rotate_object_local(Vector3.RIGHT, deg_to_rad(90))

	# Bullet shooted into floor or ceiling
	elif normal == Vector3.UP or normal == Vector3.DOWN:
		bullet_hole_instance.look_at(position + normal, Vector3.UP)
		bullet_hole_instance.rotate_object_local(Vector3.RIGHT, deg_to_rad(90))

	await get_tree().create_timer(2).timeout
	var fade = get_tree().create_tween()
	fade.tween_property(bullet_hole_instance, "modulate:a", 0, 0.5)
	
	await get_tree().create_timer(0.5).timeout
	bullet_hole_instance.queue_free()


func start_fade_out():
	if !is_fading:
		is_fading = true
		fade_timer = 0.0


func enter(previous_state: State) -> void:
	#_exclude_self_collisions()
	#print(self_collision_to_exclude)
	if WEAPON.current_ammo > 0:
		# Add shoot sound to AudioStream
		WEAPON.audio_stream_player.stream = WEAPON.shoot_sound
		if WEAPON.shooting_type == Weapons.ShootingType.ONCE:
			if !WEAPON.audio_stream_player.playing:
				WEAPON.audio_stream_player.play()
			_shoot()
		#TODO: ANIMATION.pause()


func update(delta: float):
	if WEAPON.current_ammo == 0:
		transition.emit("IdleWeaponState")

	if GlobalInput.is_aiming():
		WEAPON.aim(delta)
	
	if GlobalInput.stop_aiming():
		WEAPON.reset_aim(delta)

	match WEAPON.shooting_type:
		Weapons.ShootingType.ONCE:
			if !GlobalInput.is_shooting():
				transition.emit("IdleWeaponState")
		
		Weapons.ShootingType.AUTO:
			if GlobalInput.is_shooting() and WEAPON.current_ammo > 0:
				if !WEAPON.audio_stream_player.playing:
					WEAPON.audio_stream_player.play()
				_shoot()
			else:
				start_fade_out()


func _input(event) -> void:# TODO: Move to GlobalInput (also in player.gd)
	if event is InputEventMouseMotion:
		WEAPON.mouse_movement = event.relative


func _process(delta: float):
	if is_fading:
		fade_timer += delta
		var t = clamp(fade_timer / fade_time, 0.0, 1.0)
		WEAPON.audio_stream_player.volume_db = lerp(0.0, -60.0, t)

		if t >= 1.0:
			is_fading = false
			WEAPON.audio_stream_player.stop()
			WEAPON.audio_stream_player.volume_db = 0.0
			transition.emit("IdleWeaponState")
