class_name WeaponStateMachine extends StateMachine


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
	var debug_label: String = owner.name + "Current State"
	Global.debug.add_property(debug_label, CURRENT_STATE.name, 2)
	
	var type_int: Weapons.ShootingType = Global.player.WEAPON_CONTROLLER.shooting_type
	var type_str: String = Weapons.get_shooting_type_name(type_int)
	Global.debug.add_property("Shooting Type", type_str, 3)
	Global.debug.add_property("Max Ammo", Global.player.WEAPON_CONTROLLER.max_ammo, 3)



func _physics_process(delta):
	super._physics_process(delta)


func _switch_state(new_state_name: StringName) -> void:
	super._switch_state(new_state_name)
