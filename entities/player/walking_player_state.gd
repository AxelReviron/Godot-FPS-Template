class_name WalkingPlayerState extends State

@export var ANIMATION: AnimationPlayer


func enter() -> void:
	ANIMATION.play("walking", -1.0, 1.0)
	Global.player.speed = Constants.PLAYER_SPEED


func update(delta):
	set_animation_speed(Global.player.velocity.length())
	if Global.player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")


func physics_update(delta: float) -> void:
	if GlobalInput.is_sprinting():
		transition.emit("SprintingPlayerState")


func set_animation_speed(speed):
	var alpha = remap(speed, 0.0, Constants.PLAYER_SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, Constants.MAX_PLAYER_WALKING_ANIM_SPEED, alpha)
