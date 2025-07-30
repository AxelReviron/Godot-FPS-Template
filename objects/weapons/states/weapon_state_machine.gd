class_name WeaponStateMachine extends StateMachine


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	# TODO: Test Multi
	if !is_multiplayer_authority():
		return


func _physics_process(delta):
	super._physics_process(delta)


func _switch_state(new_state_name: StringName) -> void:
	super._switch_state(new_state_name)
