extends Control


@export_group("Maps")
@export var shooting_range: PackedScene
@export var arena: PackedScene


#@onready var client_btn: Button = %Client
@onready var play_btn: Button = %Play
@onready var options_btn: Button = %Options
@onready var quit_btn: Button = %Quit


func _hide_main_menu() -> void:
	visible = false


func _on_play_btn_pressed() -> void:
	_hide_main_menu()
	var shooting_range_instance = shooting_range.instantiate()
	get_tree().root.add_child(shooting_range_instance)


func _on_options_btn_pressed() -> void:
	#TODO: Create Option scene
	pass


func _on_quit_btn_pressed() -> void:
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	play_btn.pressed.connect(_on_play_btn_pressed)
	options_btn.pressed.connect(_on_options_btn_pressed)
	quit_btn.pressed.connect(_on_quit_btn_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
