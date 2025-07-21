class_name Ennemy extends CharacterBody3D

@onready var navigation_agent: NavigationAgent3D = %NavigationAgent3D
@onready var ray_obstacle_low: RayCast3D = %RayCastLow
@onready var ray_obstacle_high: RayCast3D = %RayCastHigh

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func look_at_player():
	var target_pos = Global.player.global_position
	target_pos.y = global_position.y
	
	look_at(target_pos, Vector3.UP)


func _physics_process(delta):
	# update target_position with player position
	navigation_agent.target_position = Global.player.global_position # global_transform.origin
	
	look_at_player()
	
	if navigation_agent.is_navigation_finished():
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump
	if is_on_floor():
		var collider = ray_obstacle_low.get_collider()
		if ray_obstacle_low.is_colliding() and not ray_obstacle_high.is_colliding() and collider != Global.player:
			velocity.y = JUMP_VELOCITY

	# Update velocity
	var next_location = navigation_agent.get_next_path_position()
	var current_location = global_transform.origin
	var new_velocity = (next_location - current_location).normalized() * SPEED

	velocity = velocity.move_toward(Vector3(new_velocity.x, velocity.y, new_velocity.z), 0.25)
	move_and_slide()
