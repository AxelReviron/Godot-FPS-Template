extends PanelContainer


@onready var property_container: VBoxContainer = %VBoxContainer

var debug_properties := {}
var update_timer := 0.0
var update_interval := 1.0  # Update each sec


func _get_gpu_memory_infos() -> String:
	var device := RenderingServer.get_rendering_device()
	var result = "Unavailable"
	
	if device:
		var gpu_memory := device.get_memory_usage(RenderingDevice.MemoryType.MEMORY_TOTAL)
		if gpu_memory > 0:
			var gpu_memory_gb := "%.2f" % (float(gpu_memory) / 1073741824.0)
			result = "GPU Memory usage: " + gpu_memory_gb + " Go"
	return result


func _get_memory_infos() -> String:
	var memory_info := OS.get_memory_info()
	var total = memory_info.get("physical", -1)
	var available = memory_info.get("available", -1)
	var result

	if total > 0 and available > 0:
		var used = total - available
		var percent_used := int(float(used) / float(total) * 100)

		var used_gb := "%.2f" % (float(used) / 1073741824.0)
		var total_gb := "%.2f" % (float(total) / 1073741824.0)

		return used_gb + " / " + total_gb + " Go (" + str(percent_used) + "%)"
	else:
		return "Unavailable"



func _ready():
	Global.debug = self
	if !is_multiplayer_authority():
		visible = false
	
	add_property("device_header", "---- User Device ----", "", 2)
	add_property("os", "OS: ", OS.get_distribution_name() + OS.get_version(), 3)
	add_property("locale", "Locale: ", OS.get_locale(), 4)
	add_property("cpu", "CPU: ", OS.get_processor_name(), 5)
	add_property("gpu_name", "GPU: ", RenderingServer.get_video_adapter_name(), 7)
	add_property("gpu_driver", "GPU Drivers: ", OS.get_video_adapter_driver_info(), 8)
	add_property("separator", "", "", 10)
	
	add_property("state_header", "---- Game State ----", "", 11)


func _process(delta: float) -> void:
	# TODO: Test Multi
	if !is_multiplayer_authority():
		return
	if GlobalInput.is_debug():
		visible = !visible

	if !visible:
		return
	
	add_property("fps", "FPS: ", Engine.get_frames_per_second(), 1)
	update_timer += delta
	if update_timer >= update_interval:
		update_timer = 0.0
		add_property("memory", "Memory: ", _get_memory_infos(), 6)
		add_property("gpu_memory", "GPU Memory usage: ", _get_gpu_memory_infos(), 9)

	if Global.player:
		add_property('player_state', "Player State: ", Global.player.STATE_MACHINE.CURRENT_STATE.name, 12)
		add_property('weapon_state', "Weapon State: ", Global.player.WEAPON_CONTROLLER.state_machine.CURRENT_STATE.name, 13)


func add_property(key: String, label: String, value, order):
	if !is_multiplayer_authority():
		return
	
	var target: RichTextLabel = property_container.find_child(key, true, false) # Find existing Label Node by key
	var display_text: String = "[b]" + label + "[/b]" + str(value)
	
	if !target:# If it doesn't exist yet, create it
		target = RichTextLabel.new()
		target.name = key
		target.bbcode_enabled = true
		#target.text = display_text
		
		target.fit_content = true
		target.scroll_active = false
		target.autowrap_mode = TextServer.AUTOWRAP_OFF
		target.set_v_size_flags(Control.SIZE_SHRINK_BEGIN)
		property_container.add_child(target)
	#elif visible:# Else if debug is visible, update it
		#target.text = display_text
	
	target.parse_bbcode(display_text)
	property_container.move_child(target, order)
