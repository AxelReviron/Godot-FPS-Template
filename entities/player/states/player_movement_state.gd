class_name PlayerMovementState extends State


var PLAYER: Player
var ANIMATION: AnimationPlayer
var WEAPON: WeaponController

func _ready():
	#TODO: Test Multi
	if !is_multiplayer_authority():
		return
	await owner.ready
	PLAYER = owner as Player
	ANIMATION = PLAYER.ANIMATIONPLAYER
	WEAPON = PLAYER.WEAPON_CONTROLLER
