extends Node


signal crouch_toggled(is_crouching: bool)


func emit_crouch_toggled(is_crouching: bool) -> void:
	emit_signal("crouch_toggled", is_crouching)
