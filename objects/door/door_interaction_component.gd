class_name DoorInteractionComponent extends InteractionComponent

@export var position_target: Vector3
@export var opening_speed: float

@export var open_door_context: String = "Open Door"
@export var close_door_context: String = "Close Door"

@export var new_icon: Texture2D


var base_position: Vector3
var is_open: bool = false
var player_interacted: bool = false
var is_animating: bool = false
var door_position_tween: Tween = null


func _on_door_position_tween_finished() -> void:
	is_open = !is_open
	is_animating = false
	SignalBus.interacton_unfocused.emit()
	
	if door_position_tween:
		door_position_tween.kill()
		door_position_tween = null


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	base_position = parent.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if player_interacted:
		player_interacted = false
		is_animating = true
		if door_position_tween:
			door_position_tween.kill()
			door_position_tween = null
		door_position_tween = create_tween()
		
		var target = base_position if is_open else position_target
		door_position_tween.tween_property(parent, "position", target, opening_speed)
		door_position_tween.finished.connect(_on_door_position_tween_finished)


## Run when something is hit by raycast
func on_focus() -> void:
	var context: String = close_door_context if is_open else open_door_context
	var icon: Texture2D = new_icon if new_icon else null
	SignalBus.interacton_focused.emit(context, icon)


## Run when something is hit by raycast
func on_unfocus() -> void:
	SignalBus.interacton_unfocused.emit()


## Load the new weapon
func on_interact() -> void:
	if !is_animating:
		player_interacted = true
