extends MultiplayerSpawner


@export var network_player: PackedScene
@export var spawn_points: Array[Vector3]


func _custom_spawn_player(data: Dictionary) -> Node:
	var player = network_player.instantiate()
	player.name = str(data.peer_id)
	player.global_position = data.pos
	player.set_multiplayer_authority(data.peer_id)
	return player


func _on_connected_peer(id: int) -> void:
	if !multiplayer.is_server():
		return
	var index = Global.connected_peers.size()
	Global.connected_peers.append(id)# Store the new connected peer
	var pos = spawn_points[index % spawn_points.size()]
	spawn({"peer_id": id, "pos": pos})


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = Callable(self, "_custom_spawn_player")
	multiplayer.peer_connected.connect(_on_connected_peer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
