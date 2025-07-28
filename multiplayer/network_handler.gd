extends Node

const IP_ADDRESS: String = "localhost"
const PORT: int = 42069
const MAX_CLIENTS: int = 10

var peer: ENetMultiplayerPeer


func create_server() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer


func create_client() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer


# Called when the node enters the scene tree for the first time.
func _ready():
	var args = OS.get_cmdline_args()
	var is_server = "--server" in args
	if is_server:
		NetworkHandler.create_server()
		print("Started server on %s:%d" % [IP_ADDRESS, PORT])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
