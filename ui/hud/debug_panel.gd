extends PanelContainer


var debug_properties := {}
@onready var property_container = %VBoxContainer


func _ready():
	add_debug_property("FPS")
	add_debug_property("Player Position")


func _process(delta):
	if GlobalInput.is_debug():
		visible = !visible

	if !visible or !Global.player:
		return

	update_debug_property("FPS", "%.2f" % Engine.get_frames_per_second())
	update_debug_property("Player Speed", "%.2f" % Global.player.get_real_velocity().length())
	update_debug_property("Player Position", str(Global.player.global_position))


func add_debug_property(title: String):
	var label := Label.new()
	label.name = title
	property_container.add_child(label)
	debug_properties[title] = label


func update_debug_property(title: String, value: String):
	if debug_properties.has(title):
		debug_properties[title].text = title + ": " + value
