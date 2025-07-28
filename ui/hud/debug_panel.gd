extends PanelContainer


var debug_properties := {}
@onready var property_container: VBoxContainer = %VBoxContainer


func _ready():
	Global.debug = self
	if !is_multiplayer_authority():
		visible = false


func _process(delta: float) -> void:
	# TODO: Test Multi
	if !is_multiplayer_authority():
		return
	if GlobalInput.is_debug():
		visible = !visible

	if !visible:
		return
	
	add_property("FPS", Engine.get_frames_per_second(), 1)

func add_property(title: String, value, order):
	if !is_multiplayer_authority():
		return
	
	var target = property_container.find_child(title, true, false) # Find existing Label Node by name
	if !target:# If it doesn't exist yet, create it
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:# Else if debug is visible, update it
		target.text = title + ": " + str(value)
		property_container.move_child(target, order)
