class_name StateMachine extends Node
## Manages a collection of [State] nodes and handles state transitions.
##
## This class maintains a dictionary of child states, monitors the current active state,
## and routes the update and physics process calls to it. It listens for transition
## signals emitted by states to switch between them.[br]
##[br]
## Usage:[br]
## - Create a [annotation State] class that extends [annotation StateMachine]. Attach the [annotation State] class to a Node[br]
## - The [param CURRENT_STATE] variable tracks the active state and need to be set on the editor.[br]
## - States must emit a `transition` signal with the target state name to trigger transitions.[br]
##[br]
## This class is designed to be extended for more specific state machine implementations,
## such as player or weapon state machines.[br]
##
## See [annotation State].


## The current state
@export var CURRENT_STATE: State
## Contains all the states loaded by [member _switch_state]
var states: Dictionary[String, State] = {}


## Called when the node enters the scene tree for the first time.
## [br][br]
## Initializes the dictionary of states by scanning child nodes,
## connects their `transition` signals to [member StateMachine._switch_state], and waits for the owner to be ready.
func _ready():
	# TODO: Test Multi
	if !is_multiplayer_authority():
		return
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(_switch_state)
		else:
			push_warning("State machine contains incompatible child node")
	
	await owner.ready


## Called every frame.
## [br][br]
## Delegates the update call to the current state and registers
## the current state's name in a global debug property for monitoring.
## [param delta] Frame time elapsed since last frame.
func _process(delta):
	# TODO: Test Multi
	if !is_multiplayer_authority():
		return
	CURRENT_STATE.update(delta)


## Called every physics frame.
## [br][br]
## Delegates the physics update call to the current state.
## [param delta] Time elapsed since last physics frame.
func _physics_process(delta):
	# TODO: Test Multi
	if !is_multiplayer_authority():
		return
	CURRENT_STATE.physics_update(delta)


## Handles switching from the current state to a new state.
## [br][br]
## Called when a state emits a [member State.transition] signal.[br]
## - Looks up the target state by name.[br]
## - Calls [member State.exit] on the current state and [member enter] on the new state.[br]
## - Updates [member StateMachine.CURRENT_STATE] reference.
## [br][br]
## [param new_state_name] The name of the target state to switch to.
func _switch_state(new_state_name: StringName) -> void:
	var new_state: State = states.get(new_state_name)
	if new_state != null:
		if new_state != CURRENT_STATE:
			CURRENT_STATE.exit()
			new_state.enter(CURRENT_STATE)
			CURRENT_STATE = new_state
	else:
		push_warning("State doesn't exist")
