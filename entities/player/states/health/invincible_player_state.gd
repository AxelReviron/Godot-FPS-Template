class_name InvinciblePlayerState extends PlayerStateBase

var player_movement_state: State
var player_weapon_state: State


func enter(previous_state: State) -> void:
	player_movement_state = PLAYER.MOVEMENT_STATE_MACHINE.CURRENT_STATE
	player_weapon_state = PLAYER.WEAPON_CONTROLLER.state_machine.CURRENT_STATE


func update(delta: float):
	# If player move or shoot -> transition to AliveState
	# TODO: Add timer
	if !player_movement_state is IdlePlayerState or !player_weapon_state is IdleWeaponState:
		transition.emit("AlivePlayerState")
