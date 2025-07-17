class_name WeaponState extends State


var WEAPON: WeaponController
var ANIMATION: AnimationPlayer

func _ready():
	await owner.ready
	WEAPON = owner as WeaponController
	ANIMATION = WEAPON.ANIMATIONPLAYER
