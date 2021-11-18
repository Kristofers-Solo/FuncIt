extends Control

onready var server_listener = $server_listener
onready var server_ip_text_edit = $popup_screen/panel/server_ip_text_edit
onready var server_container = $controls/background_panel/VBoxContainer
onready var popup_screen = $popup_screen


func _ready() -> void:
	popup_screen.hide()


func _process(delta):
	if Input.is_action_just_pressed("esc") and popup_screen.is_visible_in_tree():
		popup_screen.hide()
		$controls.show()
	elif Input.is_action_just_pressed("esc") and not popup_screen.is_visible_in_tree():
		_on_return_pressed()


func _on_server_listener_new_server(serverInfo):
	var server_node = Global.instance_node(load("res://source/scenes/GUI/server_handlers/server_display.tscn"), server_container)
	server_node.text = "%s - %s" % [serverInfo.ip, serverInfo.name]
	server_node.ip_address = str(serverInfo.ip)


func _on_server_listener_remove_server(serverIp):
	for serverNode in server_container.get_children():
		if serverNode.is_in_group("Server_display"):
			if serverNode.ip_address == serverIp:
				serverNode.queue_free()
				break


func _on_manual_setup_pressed():
	$controls.hide()
	popup_screen.show()
	server_ip_text_edit.call_deferred("grab_focus")


func _on_join_server_pressed():
	if server_ip_text_edit.text != "":
		Network.ip_address = server_ip_text_edit.text
	hide()
	Network.join_server()


func _on_return_pressed():
	get_tree().reload_current_scene()
