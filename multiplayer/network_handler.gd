extends Node


const IP_ADDRESS: String = "localhost"
const PORT: int = 42069
const MAX_CLIENTS: int = 10

var peer: ENetMultiplayerPeer
var udp := PacketPeerUDP.new()


## Use for server discover in multiplayer menu
func create_udp_server() -> void:
	var err = udp.bind(42068) # Discover Port
	if err != OK:
		print("Impossible to bind UDP: %s" % err)
		return
	udp.set_broadcast_enabled(true)


func ping_response(delta: float):
	while udp.get_available_packet_count() > 0:
		var packet = udp.get_packet()
		var msg = packet.get_string_from_utf8()
		var from_ip = udp.get_packet_ip()
		var from_port = udp.get_packet_port()

		if msg == "ping":
			var reply = "pong:MyGameServer;%s/%d;localhost" % [Global.connected_peers.size(), MAX_CLIENTS]
			udp.set_dest_address(from_ip, from_port)
			udp.put_packet(reply.to_utf8_buffer())


func create_server() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer


func create_client(ip: String = "localhost") -> void:
	var peer = ENetMultiplayerPeer.new()
	var err := peer.create_client(ip, PORT)
	
	if err != OK:
		print("Client can't connect to server :", err)
		return
		
	multiplayer.multiplayer_peer = peer
	# Debug
	#multiplayer.connected_to_server.connect(func(): print("Client connected to server"))
	#multiplayer.connection_failed.connect(func(): print("Connection to server fail"))
	#multiplayer.server_disconnected.connect(func(): print("Server disconnected"))


# Called when the node enters the scene tree for the first time.
func _ready():
	var args = OS.get_cmdline_args()
	var is_server = "--server" in args
	if is_server:
		create_server()
		create_udp_server()
		print("Started server on %s:%d" % [IP_ADDRESS, PORT])
		get_tree().change_scene_to_file("res://levels/arena/arena.tscn")# TODO: Refacto pour pouvoir changer de map facilement
	else:
		get_tree().change_scene_to_file("res://levels/main/main.tscn")  
	print("NetworkHandler ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	ping_response(delta)
