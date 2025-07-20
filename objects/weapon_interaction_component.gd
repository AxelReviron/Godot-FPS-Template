class_name WeaponInteractionComponent extends InteractionComponent


const MAX_RECURSION_DEPTH := 10

## Reference the weapon resource in the [annotation WeaponDatabase]
@export var weapon_key: String

## Weapon Resource
var weapon_res: Resource = null
var current_equipped_weapon: Weapons = null

## Object detected by raycast
var meshes: Array[MeshInstance3D] = []
var highlight_material = preload("res://objects/interactable_highlight.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_set_default_meshes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass


## Run when something is hit by raycast
func on_focus() -> void:
	_apply_highlight_material()


## Run when something is hit by raycast
func on_unfocus() -> void:
	_clear_highlight_material()


## Load the new weapon
func on_interact() -> void:	
	if Global.player and Global.player.WEAPON_CONTROLLER:
		current_equipped_weapon = Global.player.WEAPON_CONTROLLER.WEAPON_TYPE
	
	# If player interact with the same weapon equiped, do nothing
	if current_equipped_weapon and current_equipped_weapon == weapon_res:
		return
	
	weapon_res = WeaponDatabase.get_weapon(weapon_key)
	
	if Global.player and Global.player.WEAPON_CONTROLLER and weapon_res:
		Global.player.WEAPON_CONTROLLER.WEAPON_TYPE = weapon_res
		Global.player.WEAPON_CONTROLLER.display_weapon_icon_and_infos()


## Finds and stores all MeshInstance3D children of the parent node
## so we can later modify their materials (e.g., for highlighting).
func _set_default_meshes() -> void:
	if meshes.size() > 0:
		print("Meshes Already initialized")
		return

	_find_meshes_recursive(parent)
	
	if meshes.is_empty():
		push_warning("No MeshInstance3D found in %s" % parent.name)


func _find_meshes_recursive(node: Node, depth: int = 0) -> void:
	if depth > MAX_RECURSION_DEPTH:
		push_warning("Max recursion depth reached when searching for meshes in %s" % node.name)
		return

	if !node or !node.has_method("get_children"):
		return

	for child in node.get_children():
		if child is MeshInstance3D:
			meshes.append(child)
		elif child.get_child_count() > 0:
			_find_meshes_recursive(child, depth + 1)


func _apply_highlight_material() -> void:
	for mesh in meshes:
		mesh.material_overlay = highlight_material


func _clear_highlight_material() -> void:
	for mesh in meshes:
		mesh.material_overlay = null
