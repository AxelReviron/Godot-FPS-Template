## Used to share variable for all Player States
class_name PlayerStateBase extends State


var PLAYER: Player
var ANIMATION: AnimationPlayer# FPS Animation
var WEAPON: WeaponController

func _ready():
	await owner.ready
	PLAYER = owner as Player
	ANIMATION = PLAYER.ANIMATIONPLAYER
	WEAPON = PLAYER.WEAPON_CONTROLLER
