class_name ContextComponent extends CenterContainer

@onready var icon: TextureRect = %ContextIcon
@onready var context: Label = %ContextLabel
@export var default_icon: Texture


func reset() -> void:
	icon.texture = null
	context.text = ""


func update_icon(image: Texture2D = null) -> void:
	if image:
		icon.texture = image
	else:
		icon.texture = default_icon


func update_content(text: String) -> void:
	context.text = text


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.ui_context = self
	default_icon = GlobalInput.get_interact_icon_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
