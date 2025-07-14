extends Camera3D

@export var MAIN_CAMERA: Node3D

# Match Weapon Camera to Player Camera
func _process(delta):
	global_transform = MAIN_CAMERA.global_transform
