class_name InteractionComponent extends Node


## Object detected by raycast
var parent: StaticBody3D


## Called when the node enters the scene tree for the first time.
## [br][br]
## Add parent signals and connect them
func _ready():
	parent = get_parent()
	connect_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass


## Run when something is hit by raycast
func on_focus() -> void:
	pass


## Run when something is hit by raycast
func on_unfocus() -> void:
	pass


## Run when something is hit by raycast
func on_interact() -> void:
	pass


## Create signals to the parent Node
func connect_parent() -> void:
	parent.add_user_signal("focused")
	parent.add_user_signal("unfocused")
	parent.add_user_signal("interacted")
	
	parent.connect("focused", Callable(self, "on_focus"))
	parent.connect("unfocused", Callable(self, "on_unfocus"))
	parent.connect("interacted", Callable(self, "on_interact"))
