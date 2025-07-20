class_name ContextComponent extends CenterContainer

@onready var icon: TextureRect = %ContextIcon
@onready var context: Label = %ContextLabel
@export var default_icon: Texture


func reset() -> void:
	icon.texture = null
	context.text = ""


## Update text and image on the ContextComponent 
func update(text: String, image: Texture2D = null) -> void:
	icon.texture = image if image else default_icon
	context.text = text


# Called when the node enters the scene tree for the first time.
func _ready():
	#Global.ui_context = self
	SignalBus.interacton_focused.connect(update)
	SignalBus.interacton_unfocused.connect(reset)
	default_icon = GlobalInput.get_interact_icon_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
