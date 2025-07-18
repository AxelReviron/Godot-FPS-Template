class_name InteractionComponent extends Node


const MAX_RECURSION_DEPTH := 10

## Object detected by raycast
var parent: StaticBody3D
var meshes: Array[MeshInstance3D] = []
var highlight_material = preload("res://objects/interactable_highlight.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	connect_parent()
	_set_default_meshes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


## Run when something is hit by raycast
func on_focus() -> void:
	_apply_highlight_material()


## Run when something is hit by raycast
func on_unfocus() -> void:
	_clear_highlight_material()


## Run when something is hit by raycast
func on_interact() -> void:
	print(parent.name)


## Create signals to the parent Node
func connect_parent() -> void:
	parent.add_user_signal("focused")
	parent.add_user_signal("unfocused")
	parent.add_user_signal("interacted")
	
	parent.connect("focused", Callable(self, "on_focus"))
	parent.connect("unfocused", Callable(self, "on_unfocus"))
	parent.connect("interacted", Callable(self, "on_interact"))


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
