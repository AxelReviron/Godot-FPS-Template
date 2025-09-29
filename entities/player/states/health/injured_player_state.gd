class_name InjuredPlayerState extends PlayerStateBase


# Ideas :
# Add Blood spread effect (Subviewport)
# Add Tunnel vision effect (Subviewport)
# Add Deep breath sound effect
# Move slowly (optional)
func enter(previous_state: State) -> void:
	pass


# Ideas :
# Regain health (optional) and decrease visual and sound effects
# Or decrease health slowly and increase visual and sound effects
func update(delta: float):
	if PLAYER.health <= 0:
		transition.emit("DeadPlayerState")
