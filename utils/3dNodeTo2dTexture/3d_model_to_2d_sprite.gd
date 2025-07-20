extends SubViewport

@onready var sub_viewport = $"."

@export var node_to_snapshot: Node3D
@export var snapshot_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	await RenderingServer.frame_post_draw
	var img = sub_viewport.get_viewport().get_texture().get_image()
	var image_path = "res://core/3dNodeTo2dTexture/textures/%s.png" % snapshot_name
	img.save_png(image_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
