extends Control


@export_group("Maps")
@export var shooting_range: PackedScene
@export var arena: PackedScene


#@onready var client_btn: Button = %Client
@onready var multi_btn: Button = %Multiplayer
@onready var training_btn: Button = %Training
@onready var options_btn: Button = %Options
@onready var quit_btn: Button = %Quit


#func _on_client_btn_pressed() -> void:
	#NetworkHandler.create_client()
	#client_btn.visible = false

func _hide_main_menu() -> void:
	visible = false


func _on_multi_btn_pressed() -> void:
	_hide_main_menu()
	var arena_instance = arena.instantiate()
	get_tree().root.add_child(arena_instance)


func _on_training_btn_pressed() -> void:
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
	#client_btn.pressed.connect(_on_client_btn_pressed)
	multi_btn.pressed.connect(_on_multi_btn_pressed)
	training_btn.pressed.connect(_on_training_btn_pressed)
	options_btn.pressed.connect(_on_options_btn_pressed)
	quit_btn.pressed.connect(_on_quit_btn_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
