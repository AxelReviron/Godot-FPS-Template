extends Node3D

@export var weapon: WeaponController
@export var flash_time: float = 0.05 #TODO: Move into weapon_resource
@onready var muzzle_flash_light: OmniLight3D = %OmniLight3D
@onready var muzzle_flash_emitter: GPUParticles3D = %MuzzleFashParticles
@onready var bullet_trace_emitter: GPUParticles3D = %BulletTraceParticle

# Called when the node enters the scene tree for the first time.
func _ready():
	if weapon:
		weapon.weapon_fired.connect(add_muzzle_flash)
	else:
		print("WeaponController is not attached to MuzzleFlash")


func add_muzzle_flash() -> void:
	muzzle_flash_light.visible = true
	muzzle_flash_emitter.emitting = true
	bullet_trace_emitter.emitting = true
	
	await get_tree().create_timer(Global.player.WEAPON_CONTROLLER.fire_rate).timeout
	
	muzzle_flash_emitter.emitting = false
	muzzle_flash_light.visible = false
	bullet_trace_emitter.emitting = false
