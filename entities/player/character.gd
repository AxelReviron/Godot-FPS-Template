extends Node3D

@onready var weapon_char_scene: Node3D = %CharWeaponScene


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.weapon_char_scene = weapon_char_scene
	Global.emit_signal("character_ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
