extends Node

@onready var draw_debug: MeshInstance3D = $MeshInstance3D


func draw_line(origin: Vector3, target: Vector3, color: Color = Color.GREEN) -> void:
	if origin.is_equal_approx(target):
		return
	
	if draw_debug.mesh is ImmediateMesh:
		draw_debug.mesh.surface_begin(Mesh.PRIMITIVE_LINES)
		draw_debug.mesh.surface_set_color(color)
		
		draw_debug.mesh.surface_add_vertex(origin)
		draw_debug.mesh.surface_add_vertex(target)
		
		draw_debug.mesh.surface_end()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
