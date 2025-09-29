extends PhysicalBoneSimulator3D

@onready var skeleton: Skeleton3D = %Skeleton3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# TODO: Fix ragdoll
	#physical_bones_start_simulation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
