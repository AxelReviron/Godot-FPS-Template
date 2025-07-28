extends Control


@onready var client_btn: Button = %Client


func _on_client_btn_pressed() -> void:
	NetworkHandler.create_client()
	client_btn.visible = false


# Called when the node enters the scene tree for the first time.
func _ready():
	client_btn.pressed.connect(_on_client_btn_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
