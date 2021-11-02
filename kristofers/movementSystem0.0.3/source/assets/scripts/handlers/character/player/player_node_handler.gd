extends Node2D

var username_text = load("res://scenes/username_text.tscn")
var username setget username_set
var username_text_instance = null

puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
puppet var puppet_velocity = Vector2()
puppet var puppet_rotaion = 0
puppet var puppet_username = "" setget puppet_username_set

onready var tween = $Tween


func _ready():
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	username_text_instance = Global.instance_node_at_location(username_text, PersistentNodes, global_position)
	
	username_text_instance.player_following = self


func _process(delta: float) -> void:
	if username_text_instance != null:
		username_text_instance.name = "username" + name


func statePassback():
	return {"node_global_position": transform.origin, "rotation": null}


func set_scale(scale) -> void:
	$player_body/player_sprite_na.scale = Vector2(scale, scale)
	$player_body/player_sprite.scale = Vector2(scale, scale)
	$player_body/player_collider.scale = Vector2(scale, scale)
	pass


func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()


func username_set(new_value) -> void:
	username = new_value
	if is_network_master() and username_text_instance != null:
		username_text_instance.text = username
		rset("puppet_username", username)


func puppet_username_set(new_value) -> void:
	puppet_username = new_value
	if not is_network_master() and username_text_instance != null:
		username_text_instance.text = puppet_username


func _network_peer_connected(id) -> void:
	rset_id(id, "puppet_username", username)


func _on_network_tick_rate_timeout():
	if get_tree().has_network_peer():
		if is_network_master():
			rset_unreliable("puppet_position", global_position)
			#rset_unreliable("puppet_velocity", velocity)
			rset_unreliable("puppet_rotation", rotation_degrees)


sync func update_position(pos):
	global_position = pos
	puppet_position = pos


sync func destroy() -> void:
	username_text_instance.visible = false
	visible = false
	$CollisionShape2D.disabled = true
	$Hitbox/CollisionShape2D.disabled = true
	Global.alive_players.erase(self)
	
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = null


func _exit_tree() -> void:
	Global.alive_players.erase(self)
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = null
