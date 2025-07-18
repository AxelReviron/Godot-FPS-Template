extends Node


var player: CharacterBody3D = null
var debug: PanelContainer = null


static func get_camera_state_space(camera: Camera3D) -> PhysicsDirectSpaceState3D:
	return camera.get_world_3d().direct_space_state


static func get_screen_center(viewport: Viewport) -> Vector2i:
	return viewport.size / 2


## [b]Casts a ray from the center of the screen and returns the first body hit.[b]
## [br][br]
## This function projects a ray from the center of the given [param viewport], using the provided [param camera]
## as the origin of the ray. It returns the first object hit by the ray within the specified [param max_distance].
## [br][br]
## [param camera] [i]The [Camera3D] node used to define the ray's origin and direction.[/i][br]
## [param viewport] [i]The [Viewport] instance used to determine the center of the screen.[/i][br]
## [param max_distance] [i]The maximum distance the ray can travel.[/i][br]
## [br]
## [b]Return[/b] A [Dictionary] containing information about the collision if a body was hit, or an empty Dictionary otherwise.
static func get_forward_ray_hit(camera: Camera3D, viewport: Viewport, max_distance: float) -> Dictionary:
	var screen_center: Vector2i = viewport.size / 2
	var ray_origin: Vector3 = camera.project_ray_origin(screen_center)
	var ray_direction: Vector3 = camera.project_ray_normal(screen_center)
	var ray_end: Vector3 = ray_origin + ray_direction * max_distance

	var space_state: PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_bodies = true

	return space_state.intersect_ray(query)# TODO: intersect_shape for rocket launcher, grenades...
