class_name AlivePlayerState extends PlayerStateBase


func enter(previous_state: State) -> void:
	pass
	#PLAYER.health = PLAYER.DEFAULT_HEALTH


func update(delta: float):
	pass
	
	if PLAYER.health < PLAYER.DEFAULT_HEALTH:
		print('transition')
		transition.emit("InjuredPlayerState")
