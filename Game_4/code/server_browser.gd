extends Control

onready var server_listener = $server_listener
onready var server_ip_text_edit = $background_panel/server_ip_text_edit
onready var server_container = $background_panel/VBoxContainer
onready var manual_setup_button = $background_panel/manual_setup


func _ready() -> void:
	server_ip_text_edit.hide()
	

func _on_server_listener_new_server(serverInfo):
	var server_node = Global.instance_node(load("res://scenes/server_display.tscn"), server_container)
	server_node.text = "%s - %s" % [serverInfo.ip, serverInfo.name]
	server_node.ip_address = str(serverInfo.ip)


func _on_server_listener_remove_server(serverIp):
	for serverNode in server_container.get_children():
		if serverNode.is_in_group("server_display"):
			if serverNode.ip_address == serverIp:
				serverNode.queue_free()
				break


func _on_manual_setup_pressed():
	if manual_setup_button.text != "exit setup":
		server_ip_text_edit.show()
		manual_setup_button.text = "exit setup"
		server_container.hide()
		server_ip_text_edit.call_deferred("grab_focus")
	else:
		server_ip_text_edit.text = ""
		server_ip_text_edit.hide()
		server_container.show()


func _on_join_server_pressed():
	Network.ip_address = server_ip_text_edit.text
	hide()
	Network.join_server()


func _on_go_back_pressed():
	get_tree().reload_current_scene()
