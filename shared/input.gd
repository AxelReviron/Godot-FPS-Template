extends Node

var interact_key: String


## Get the key for the 'interact' action
func _get_interact_key() -> void:
	for event in InputMap.action_get_events("interact"):
		var text = event.as_text()
		var parts = text.split(" ")
		if parts.size() > 0:
			interact_key = parts[0]


## Get the icon texture associated with the 'interact' action key
func get_interact_icon_texture() -> Texture:
	var filename = "keyboard_%s.png" % interact_key.to_lower()
	var path = "res://ui/hud/assets/input_prompt/keyboard_and_mouse/" + filename
	if ResourceLoader.exists(path):
		return load(path)
	else:
		printerr("Icon not found at path: " + path)
		return load("res://ui/hud/assets/input_prompt/keyboard_and_mouse/keyboard.png") # Default keyboard icon fallback


func _ready():
	_get_interact_key()


func get_move_vector() -> Vector2:
	var input = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		input.x += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	return input.normalized()


func is_jumping() -> bool:
	return Input.is_action_just_pressed("jump")


func is_released_jump() -> bool:
	return Input.is_action_just_released("jump")


func is_sprinting() -> bool:
	return Input.is_action_pressed("sprint")


func stop_sprinting() -> bool:
	return Input.is_action_just_released("sprint")


func is_crouching() -> bool:
	return Input.is_action_pressed("crouch")


func is_exiting() -> bool:
	return Input.is_action_pressed("exit")


func is_interacting() -> bool:
	return Input.is_action_just_pressed("interact")


func is_debug() -> bool:
	return Input.is_action_just_pressed("debug")


func is_mouse_mode_captured() -> bool:
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED


#region Weapon
func is_shooting() -> bool:
	return Input.is_action_pressed("shoot")


func is_aiming() -> bool:
	return Input.is_action_pressed("aim")


func is_reloading() -> bool:
	return Input.is_action_pressed("reload")


func stop_aiming() -> bool:
	return Input.is_action_just_released("aim")

#endregion Weapon
