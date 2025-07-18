extends Node

var weapons: Dictionary = {}

func _ready():
	weapons["ak47"] = preload("res://objects/weapons/ak47/ak47_resource.tres")
	weapons["pistol"] = preload("res://objects/weapons/pistol/pistol_resource.tres")

func get_weapon(key: String) -> Resource:
	return weapons.get(key)
