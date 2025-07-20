extends Control

@onready var weapon_icon_container: TextureRect = %TextureRect
@onready var weapon_name_container: Label = %WeaponName
@onready var weapon_ammo_container: Label = %Ammo

# Called when the node enters the scene tree for the first time.
func _ready():
	# Texture rect will contains weapon icon, define in the weapon_controller script
	Global.hud_weapon_icon = weapon_icon_container
	Global.hud_weapon_name = weapon_name_container
	Global.hud_weapon_ammo = weapon_ammo_container
	Global.emit_signal("hud_ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
