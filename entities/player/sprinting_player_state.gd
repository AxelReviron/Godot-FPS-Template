class_name SprintingPlayerState extends State

@export var ANIMATION: AnimationPlayer


func enter() -> void:
	ANIMATION.play("sprinting", 0.5, 1.0)
	Global.player.speed = Constants.PLAYER_SPRINT_SPEED


func update(delta):
	set_animation_speed(Global.player.velocity.length())


func physics_update(delta: float) -> void:
	if GlobalInput.stop_sprinting():
		transition.emit("WalkingPlayerState")


func set_animation_speed(speed):
	var alpha = remap(speed, 0.0, Constants.PLAYER_SPRINT_SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, Constants.MAX_PLAYER_SPRINTING_ANIM_SPEED, alpha)
