class_name State extends Node
## Base class for all individual states in a state machine.
##
## Each state should be added as a child of a [annotation StateMachine] Node, and should
## emit the [signal transition] signal to request switching to another state.[br]
## This class is designed to be inherited and overridden with custom logic.
##[br][br]
## Usage:[br]
## - Extend [annotation State] and implement your custom logic in the provided methods.[br]
## - Add your custom state node as a child of the [annotation StateMachine].[br]
## - Set the [member CURRENT_STATE] in the editor to define the initial state.[br]
## - Use the [signal transition] to switch to another state by its node name.

## Emitted to request a transition to a different state.
## [param new_state_name] The name of the target state to switch to.
signal transition(new_state_name: StringName)


## [b]Called when the state becomes active.[/b]
## [br]
## Implement logic that should run when entering this state.
## [br][br]
## [u]Examples:[/u]
## [br]
## [i]- Start an animation.[/i]
## [br]
## [i]- Play a sound using AudioStreamPlayer.[/i]
## [br][br]
## [param previous_state] The state that was active before this one.
func enter(previous_state: State) -> void:
	pass


## [b]Called when the state is about to be exited.[/b]
## [br]
## Implement cleanup or transition logic before leaving this state.
## [br][br]
## [u]Examples:[/u]
## [br]
## [i]- Stop or queue_free instantiated nodes.[/i]
## [br]
## [i]- Reset temporary variables.[/i]
func exit() -> void:
	pass


## [b]Called every frame.[/b]
## [br]
## Implement logic that should update with each frame.
## [br][br]
## [u]Examples:[/u]
## [br]
## [i]- Handle player input or smooth camera transitions.[/i]
## [br][br]
## [param delta] Time elapsed since the last frame.
func update(delta: float) -> void:
	pass


## [b]Called every physics frame.[/b]
## [br]
## Implement physics-related logic such as movement or collision.
## [br][br]
## [u]Examples:[/u]
## [br]
## [i]- Move characters with physics-based movement.[/i]
## [br]
## [i]- Apply gravity or detect collisions.[/i]
## [br][br]
## [param delta] Time elapsed since the last physics frame.
func physics_update(delta: float) -> void:
	pass
