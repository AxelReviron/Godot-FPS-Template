extends SubViewport

var screen_size: Vector2

# Set viewport to windows size
func _ready():
	screen_size = get_window().size
	size = screen_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
