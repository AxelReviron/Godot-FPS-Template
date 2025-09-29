class_name DeadPlayerState extends PlayerStateBase


func enter(previous_state: State) -> void:
	# TODO: Play death animation or ragdoll character
	# TODO: Respawn player
	# TODO: Transition to InvincibleState
	
	PLAYER.anim_player.stop()
	PLAYER.character_physical_bone_sim.physical_bones_start_simulation()
	await get_tree().create_timer(3.0).timeout
	transition.emit("InvinciblePlayerState")

func update(delta: float):
	pass
