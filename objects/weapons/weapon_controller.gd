@tool

class_name WeaponController extends Node3D

signal weapon_fired
signal weapon_stop_fire
@export var state_machine: WeaponStateMachine

@export var WEAPON_TYPE: Weapons:
	set(value):
		WEAPON_TYPE = value
		#if Engine.is_editor_hint():
		load_weapon()

@export var sway_noise: NoiseTexture2D
@export var sway_speed: float = 1.2
@export var reset: bool = false:
	set(value):
		reset = value
		if Engine.is_editor_hint():
			load_weapon()

@export var ANIMATIONPLAYER: AnimationPlayer

@onready var muzzle_flash: Node3D = %MuzzleFlash
@onready var audio_stream_player: AudioStreamPlayer3D = %AudioStreamPlayer3D
@onready var blood_impact_scene: PackedScene = preload("res://objects/weapons/fx/blood_particles.tscn")
@onready var camera: Camera3D = %Camera3D

# Weapon Scene
@onready var weapon_scene: Node3D = %WeaponScene # Weapon Node container for the weapon scene
var current_weapon_instance: Node3D = null  # Reference to the weapon scene (defined in the weapon_resource)
var current_weapon_anim_player_instance: AnimationPlayer = null

# Weapon Character Scene
var current_weapon_char_instance: Node3D = null  # Reference to the weapon scene (defined in the weapon_resource)

var can_sway: bool = true
var base_position: Vector3
var base_rotation: Vector3
var base_camera_fov: float

# Aim
var aim_position: Vector3
var aim_rotation: Vector3
var aim_speed: float
var aim_fov: float
var position_tween: Tween = null
var rotation_tween: Tween = null
var fov_tween: Tween = null

# Sway
var mouse_movement: Vector2
var random_sway_x: float
var random_sway_y: float
var random_sway_amount: float
var time: float = 0.0
var idle_sway_adjustment: float
var idle_sway_rotation_strength: float
var weapon_bob_amount: Vector2 = Vector2(0, 0)

# Recoil
var recoil_amount_x: float
var recoil_amount_y: float
var recoil_snap_amount: float
var recoil_speed: float
var aim_recoil_amount_x: float
var aim_recoil_amount_y: float

var bullet_hole = preload("res://objects/weapons/bullet_hole/bullet_hole.tscn")

# Weapon Shoot FX
var muzzle_flash_position: Vector3
var bullet_trace_position: Vector3

# Weapon Shooting Properties
var dammage: int
var fire_rate: float
var shooting_type: Weapons.ShootingType

# Ammo
var max_ammo: int
var current_ammo: int

# Sounds
var shoot_sound: AudioStreamWAV
var reload_sound: AudioStreamWAV

# Character
var char_anim_type: Weapons.CharAnimType
var char_weapon_position: Vector3
var char_weapon_rotation: Vector3
var char_weapon_scale: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("character_ready", Callable(self, "display_char_weapon"))
	
	# TODO: Test Multi
	if !is_multiplayer_authority():
		return
	Global.connect("hud_ready", Callable(self, "display_weapon_icon_and_infos"))
	load_weapon()


func display_char_weapon() -> void:
	# TODO: Test Multi
	#if !is_multiplayer_authority():
		#return
	current_weapon_char_instance = WEAPON_TYPE.char_scene.instantiate()
	if Global.weapon_char_scene:
		Global.weapon_char_scene.add_child(current_weapon_char_instance)
		
		Global.weapon_char_scene.position = WEAPON_TYPE.char_weapon_position
		Global.weapon_char_scene.rotation_degrees = WEAPON_TYPE.char_weapon_rotation
		Global.weapon_char_scene.scale = WEAPON_TYPE.char_weapon_scale


func display_weapon_icon_and_infos() -> void:
	# TODO: Test Multi
	if !is_multiplayer_authority():
		return
	Global.hud_weapon_icon.texture = WEAPON_TYPE.icon_texture
	Global.hud_weapon_name.text = WEAPON_TYPE.name
	Global.hud_weapon_ammo.text = "Ammo: " + str(current_ammo) + "/" + str(WEAPON_TYPE.max_ammo)


func update_ammo_display() -> void:
	# TODO: Test Multi
	if !is_multiplayer_authority():
		return
	Global.hud_weapon_ammo.text = "Ammo: " + str(current_ammo) + "/" + str(WEAPON_TYPE.max_ammo)


func _clean_previous_weapon_instance() -> void:
	# TODO: Test Multi
	if !is_multiplayer_authority():
		return
	# Clean up previous weapon instance (FPS)
	if current_weapon_instance:
		current_weapon_instance.queue_free()
		current_weapon_instance = null

	# Clean up previous weapon instance (Character)
	if current_weapon_char_instance:
		current_weapon_char_instance.queue_free()
		current_weapon_char_instance = null


func load_weapon() -> void:
	# TODO: Test Multi
	if !is_multiplayer_authority():
		return
	_clean_previous_weapon_instance()
	
	base_position = WEAPON_TYPE.position
	base_rotation = WEAPON_TYPE.rotation
	if camera:
		base_camera_fov = camera.fov
	
	position = WEAPON_TYPE.position # Set weapon position
	rotation_degrees = WEAPON_TYPE.rotation # Set weapon rotation
	scale = WEAPON_TYPE.scale # Set weapon scale
	
	aim_position = WEAPON_TYPE.aim_position
	aim_rotation = WEAPON_TYPE.aim_rotation
	aim_speed = WEAPON_TYPE.aim_speed
	aim_fov = WEAPON_TYPE.aim_fov
	
	# Instanciate the weapon scene
	if WEAPON_TYPE.scene:
		current_weapon_instance = WEAPON_TYPE.scene.instantiate()
		for child in current_weapon_instance.get_children():
			if child is AnimationPlayer:
				current_weapon_anim_player_instance = child
		if weapon_scene:
			weapon_scene.add_child(current_weapon_instance)
	else:
		print("WeaponController need to a scene")
	
	idle_sway_adjustment = WEAPON_TYPE.idle_sway_adjustment
	idle_sway_rotation_strength = WEAPON_TYPE.idle_sway_rotation_strength
	random_sway_amount = WEAPON_TYPE.random_sway_amount
	
	recoil_amount_x = WEAPON_TYPE.recoil_amount_x
	recoil_amount_y = WEAPON_TYPE.recoil_amount_y
	recoil_snap_amount = WEAPON_TYPE.recoil_snap_amount
	recoil_speed = WEAPON_TYPE.recoil_speed
	aim_recoil_amount_x = WEAPON_TYPE.aim_recoil_amount_x
	aim_recoil_amount_y = WEAPON_TYPE.aim_recoil_amount_y
	
	if muzzle_flash:
		muzzle_flash.position = WEAPON_TYPE.muzzle_flash_position
	
	fire_rate = WEAPON_TYPE.fire_rate
	dammage = WEAPON_TYPE.dammage
	shooting_type = WEAPON_TYPE.shooting_type
	max_ammo = WEAPON_TYPE.max_ammo
	current_ammo = max_ammo
	shoot_sound = WEAPON_TYPE.shoot_sound
	reload_sound = WEAPON_TYPE.reload_sound
	
	# Character
	char_anim_type = WEAPON_TYPE.char_anim_type
	
	position = WEAPON_TYPE.position # Set weapon position
	rotation_degrees = WEAPON_TYPE.rotation # Set weapon rotation
	scale = WEAPON_TYPE.scale # Set weapon scale


# Sway weapon based on mouse movement
func sway_weapon(delta: float, isIdle: bool) -> void:
	if !can_sway:
		return

	# Clamp mouse movement
	mouse_movement = mouse_movement.clamp(WEAPON_TYPE.sway_min, WEAPON_TYPE.sway_max)
	var to_x_position: float 
	var to_y_position: float
	var to_x_rotation: float
	var to_y_rotation: float
	
	if isIdle:
		# Get random sway value from 2D noise
		var sway_random: float = get_sway_noise()
		var sway_random_adjusted: float = sway_random * idle_sway_adjustment # Adjust sway strength
		
		# Create two random waves
		time += delta * (sway_speed + sway_random)
		random_sway_x = sin(time * 1.5 + sway_random_adjusted) / random_sway_amount
		random_sway_y = sin(time - sway_random_adjusted) / random_sway_amount

		to_x_position = WEAPON_TYPE.position.x - (mouse_movement.x * WEAPON_TYPE.sway_amount_position + random_sway_x) * delta
		to_y_position = WEAPON_TYPE.position.y + (mouse_movement.y * WEAPON_TYPE.sway_amount_position + random_sway_y) * delta
		to_x_rotation = WEAPON_TYPE.rotation.x - (mouse_movement.y * WEAPON_TYPE.sway_amount_rotation + (random_sway_x * idle_sway_rotation_strength)) * delta
		to_y_rotation = WEAPON_TYPE.rotation.y + (mouse_movement.x * WEAPON_TYPE.sway_amount_rotation + (random_sway_y * idle_sway_rotation_strength)) * delta
		
		# Lerp weapon position based on mouse movement
		position.x = lerp(position.x, to_x_position, WEAPON_TYPE.sway_speed_position)
		position.y = lerp(position.y, to_y_position, WEAPON_TYPE.sway_speed_position)
		# Lerp weapon position based on mouse movement
		rotation_degrees.x = lerp(rotation_degrees.x, to_x_rotation, WEAPON_TYPE.sway_speed_rotation)
		rotation_degrees.y = lerp(rotation_degrees.y, to_y_rotation, WEAPON_TYPE.sway_speed_rotation)
	else:
		to_x_position = WEAPON_TYPE.position.x - (mouse_movement.x * WEAPON_TYPE.sway_amount_position + weapon_bob_amount.x) * delta
		to_y_position = WEAPON_TYPE.position.y + (mouse_movement.y * WEAPON_TYPE.sway_amount_position + weapon_bob_amount.y) * delta
		to_x_rotation = WEAPON_TYPE.rotation.x - (mouse_movement.y * WEAPON_TYPE.sway_amount_rotation) * delta
		to_y_rotation = WEAPON_TYPE.rotation.y + (mouse_movement.x * WEAPON_TYPE.sway_amount_rotation) * delta
	
		# Lerp weapon position based on mouse movement
		position.x = lerp(position.x, to_x_position, WEAPON_TYPE.sway_speed_position)
		position.y = lerp(position.y, to_y_position, WEAPON_TYPE.sway_speed_position)
		# Lerp weapon position based on mouse movement
		rotation_degrees.x = lerp(rotation_degrees.x, to_x_rotation, WEAPON_TYPE.sway_speed_rotation)
		rotation_degrees.y = lerp(rotation_degrees.y, to_y_rotation, WEAPON_TYPE.sway_speed_rotation)


# Get sway noise based on the player position
func get_sway_noise() -> float:
	var player_position: Vector3 = Vector3(0, 0, 0)
	
	if !Engine.is_editor_hint() and is_multiplayer_authority() and Global.player:
		player_position = Global.player.global_position
		
	return sway_noise.noise.get_noise_2d(player_position.x, player_position.y)


# Make weapon move with little bounce
func weapon_bob(delta: float, bob_speed: float, h_bob_amount: float, v_bob_amount: float) -> void:
	time += delta
	
	weapon_bob_amount.x = sin(time * bob_speed) * h_bob_amount
	weapon_bob_amount.y = abs(cos(time * bob_speed) * v_bob_amount)


func aim(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	can_sway = false
	# Annule tout tween de position précédent pour éviter les conflits
	if position_tween:
		position_tween.kill()
		position_tween = null
	if rotation_tween:
		rotation_tween.kill()
		rotation_tween = null
	if fov_tween:
		fov_tween.kill()
		fov_tween = null

	camera.fov = lerp(camera.fov, aim_fov, aim_speed * delta)
	self.position = self.position.lerp(aim_position, aim_speed * delta)
	self.rotation_degrees = self.rotation_degrees.lerp(aim_rotation, aim_speed * delta)
	Global.hud_reticle.visible = false


func reset_aim(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	if position_tween:
		position_tween.kill()
		position_tween = null
	if rotation_tween:
		rotation_tween.kill()
		rotation_tween = null
	if fov_tween:
		fov_tween.kill()
		fov_tween = null
		
	position_tween = create_tween()
	rotation_tween = create_tween()
	fov_tween = create_tween()
	
	fov_tween.tween_property(camera, "fov", base_camera_fov, 1.0 / aim_speed)
	position_tween.tween_property(self, "position", base_position, 1.0 / aim_speed)
	rotation_tween.tween_property(self, "rotation_degrees", base_rotation, 1.0 / aim_speed)

	# Connect finished signal
	rotation_tween.finished.connect(_on_aim_position_tween_finished)


func _on_aim_position_tween_finished():
	position_tween = null
	rotation_tween = null
	fov_tween = null
	can_sway = true # Activate sway only when position, rotation  and fov tween are finished
	Global.hud_reticle.visible = true
