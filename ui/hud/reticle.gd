extends CenterContainer

@export var RETICLE_LINES: Array[Line2D]
@export var RETICLE_SPEED: float = 0.25
@export var RETICLE_DISTANCE: float = 2.0
@export var DOT_RADIUS: float = 1.0
@export var DOT_COLOR: Color = Color.WHITE

@onready var reticle: CenterContainer = %Reticle

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.hud_reticle = reticle
	queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Global.player:
		return

	_adjust_reticle_lines()


func _draw():
	draw_circle(Vector2(0, 0), DOT_RADIUS, DOT_COLOR)


func _adjust_reticle_lines():
	if Global.player:
		var player_velocity = Global.player.get_real_velocity()
		var origin = Vector3(0, 0, 0)
		var position = Vector2(0, 0)
		var speed = origin.distance_to(player_velocity)
		
		RETICLE_LINES[0].position = lerp(RETICLE_LINES[0].position, position + Vector2(0, -speed * RETICLE_DISTANCE), RETICLE_SPEED)
		RETICLE_LINES[1].position = lerp(RETICLE_LINES[1].position, position + Vector2(speed * RETICLE_DISTANCE, 0), RETICLE_SPEED)
		RETICLE_LINES[2].position = lerp(RETICLE_LINES[2].position, position + Vector2(0, speed * RETICLE_DISTANCE), RETICLE_SPEED)
		RETICLE_LINES[3].position = lerp(RETICLE_LINES[3].position, position + Vector2(-speed * RETICLE_DISTANCE, 0), RETICLE_SPEED)
