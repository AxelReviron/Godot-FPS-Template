extends Control

@onready var server_tree = %ServerTree

var udp := PacketPeerUDP.new()
var servers = []

#region network
func _setup_server_discover() -> void:
	var err = udp.bind(0)  # Random local port
	if err != OK:
		print("Impossible to bind UDP client: %s" % err)
		return
	udp.set_broadcast_enabled(true)


func _send_ping():
	udp.set_dest_address("255.255.255.255", 42068)
	udp.put_packet("ping".to_utf8_buffer())

func _start_server_discover() -> void:
	while udp.get_available_packet_count() > 0:
		var packet = udp.get_packet()
		var msg = packet.get_string_from_utf8()
		var from_ip = udp.get_packet_ip()
		var from_port = udp.get_packet_port()

		if msg.begins_with("pong:"):
			print('pong received')
			var info = msg.substr(5, msg.length())
			var parts = info.split(";")
			if parts.size() >= 2:
				var name = parts[0]
				var players = parts[1]
				var ip =  parts[2] if parts.size() >= 3 else from_ip

				# Check igf it's not already added
				var already = servers.any(func(s): return s.ip == ip)
				if not already:
					var data = {
						"name": name,
						"players": players,
						"ip": ip,
					}
					servers.append(data)
					print("Serveur découvert:", data)
					_populate_server_list() # update display
#endregion


#region User interaction
# TODO: Bloquer la connection si le nombre max de joueur est atteint
func _on_server_selected():
	var selected = server_tree.get_selected()
	if !selected:
		return

	var server_data = selected.get_metadata(0)
	if server_data and server_data.has("ip"):
		NetworkHandler.create_client(server_data["ip"])
		visible = false # Hide menu
#endregion


#region Display
func _setup_tree_columns():
	server_tree.clear()
	server_tree.set_columns(3)
	server_tree.set_column_titles_visible(true)
	server_tree.set_column_title(0, "Server")
	server_tree.set_column_title(1, "Players")
	server_tree.set_column_title(2, "IP")


func _apply_style_to_columns() -> void:
	server_tree.set_column_expand(0, true) # Nom
	server_tree.set_column_expand(1, false) # Players
	server_tree.set_column_expand(2, false) # IP

	server_tree.set_column_custom_minimum_width(1, 80)
	server_tree.set_column_custom_minimum_width(2, 120)


func _populate_server_list():
	var root = server_tree.create_item()
	for server in servers:
		var item = server_tree.create_item(root)
		item.set_text(0, server.name)
		item.set_text(1, server.players)
		item.set_text(2, server.ip)
		item.set_metadata(0, server)
#endregion


func _ready():
	_setup_server_discover()
	_setup_tree_columns()
	_apply_style_to_columns()
	_populate_server_list()
	_send_ping()
	server_tree.connect("item_selected", Callable(self, "_on_server_selected"))


func _process(_delta):
	_start_server_discover()
