extends Node3D

@export var weapon: WeaponController
@export var flash_time: float = 0.05 #TODO: Move into weapon_resource
@onready var light: OmniLight3D = %OmniLight3D
@onready var emitter: GPUParticles3D = %GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready():
	weapon.weapon_fired.connect(add_muzzle_flash)


func add_muzzle_flash() -> void:
	light.visible = true
	emitter.emitting = true
	await get_tree().create_timer(Global.player.WEAPON_CONTROLLER.fire_rate).timeout
	emitter.emitting = false
	light.visible = false
