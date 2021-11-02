extends KinematicBody2D

var hp = 100 setget set_hp

var player_bullet = load("res://source/entities/bullet/player_bullet.tscn")
var username_text = load("res://source/scenes/OVERLAY/elements/username_text.tscn")
var username setget username_set
var username_text_instance = null
export var debug_mode = false

var can_shoot = true
var is_reloading = false

puppet var puppet_hp = 100 setget puppet_hp_set
puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0
puppet var puppet_username = "" setget puppet_username_set

onready var tween = $Tween
onready var sprite = $player_sprite
onready var reload_timer = $reload_timer
onready var shoot_point = $shoot_point
onready var hit_timer = $hit_timer


# Instance of data pre_processors
var VDIR_preset_pre_processor_instance = preload("res://source/assets/scripts/pre_processors/vdir_pre_processor.gd").new()
var UIN_preset_pre_processor_instance = preload("res://source/assets/scripts/pre_processors/uin_pre_processor.gd").new()

# Local class constants

# Local class variables
var VDIR = {}
var user_input = {}
var user_state = {}
var dimensions = {}
var gravityVector = Vector2(0,0)
var movementVector = Vector2(0,0)
var movementSpeed = 0
var maxMovementSpeed = 200
var accelerationSpeed = 5
var deccelerationSpeed = 4.25
var jumpState = false
var jumpSpeed = 0
var maxJumpSpeed = 400
var time = 0
var timeOut = 1
var timedOut = true
var movementRight = false
var movementLeft = true


func _ready():
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	username_text_instance = Global.instance_node_at_location(username_text, PersistentNodes, global_position)
	username_text_instance.player_following = self
	update_shoot_mode(false)
	Global.alive_players.append(self)
	
	yield(get_tree(), "idle_frame")
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = self
	
	# Allow update process override.
	set_process(true)
	$player_animated_sprite.play("idle")


func get_user_state():
	# Create a dictionary of all variables that relate to clients' active state.
	var user_state = {
		"global_position": global_transform.origin
	}
	return user_state


func get_dimensions():
	# Create a dictionary of all (required) sizes in regards to the client.
	var dimensions = {
		"sprite": {
			"width":$player_sprite.texture.get_width(),
			"height":$player_sprite.texture.get_height(),
			"scale":$player_sprite.scale,
		},
		"collider": {
			"shape":$player_collider.get_shape(),
			"radius":$player_collider.get_shape().get_radius()
		}
	}
	return dimensions


func process_rotation():
	var VDIR_ray_positive_y = VDIR["1"]["1"]["ray"]["position"].y - user_state["global_position"].y
	var VDIR_ray_negative_y = VDIR["1"]["2"]["ray"]["position"].y - user_state["global_position"].y
	var VDIR_ray_positive_x = VDIR["1"]["1"]["ray"]["position"].x - user_state["global_position"].x
	var VDIR_ray_negative_x = VDIR["1"]["2"]["ray"]["position"].x - user_state["global_position"].x
	var VDIR_ray_offset = sqrt(VDIR_ray_positive_y * VDIR_ray_positive_y + VDIR_ray_positive_x * VDIR_ray_positive_x) - sqrt(VDIR_ray_negative_y * VDIR_ray_negative_y + VDIR_ray_negative_x * VDIR_ray_negative_x)
	if VDIR_ray_offset > 1:
		rotation_degrees += VDIR_ray_offset / 10
	if VDIR_ray_offset < 1:
		rotation_degrees += VDIR_ray_offset / 10


func _process(delta: float) -> void:
	if username_text_instance != null:
		username_text_instance.name = "username" + name

	if hp <= 0:
			if get_tree().is_network_server():
				rpc("destroy")


	user_input = UIN_preset_pre_processor_instance.update()
	user_state = get_user_state()
	dimensions = get_dimensions()
	time += delta
	VDIR = VDIR_preset_pre_processor_instance.update(user_state, dimensions)
	for vector_type in VDIR:
		var v_t = str(vector_type)
		for vector in VDIR[v_t]:
			var v = str(vector)
			if v_t == "1":
				var space_state = get_world_2d().direct_space_state
				var ray_cast = space_state.intersect_ray((VDIR[v_t][v]["start"] - user_state["global_position"]).rotated(rotation) + user_state["global_position"],(VDIR[v_t][v]["end"] - user_state["global_position"]).rotated(rotation) + user_state["global_position"],[self])
				if "position" in ray_cast:
					VDIR[v_t][v]["ray"]["position"] = ray_cast.position
					VDIR[v_t][v]["ray"]["length"] = sqrt((VDIR[v_t][v]["ray"]["position"].y - user_state["global_position"].y)*(VDIR[v_t][v]["ray"]["position"].y - user_state["global_position"].y)+(VDIR[v_t][v]["ray"]["position"].x - user_state["global_position"].x)*(VDIR[v_t][v]["ray"]["position"].x - user_state["global_position"].x))
					VDIR[v_t][v]["ray"]["offset"] = dimensions["collider"]["radius"] - VDIR[v_t][v]["ray"]["length"]
					VDIR[v_t][v]["ray"]["collided"] = true
				else:
					VDIR[v_t][v]["ray"]["position"] = (VDIR[v_t][v]["end"] - user_state["global_position"]).rotated(rotation) + user_state["global_position"]
					VDIR[v_t][v]["ray"]["length"] = sqrt((VDIR[v_t][v]["ray"]["position"].y - user_state["global_position"].y)*(VDIR[v_t][v]["ray"]["position"].y - user_state["global_position"].y)+(VDIR[v_t][v]["ray"]["position"].x - user_state["global_position"].x)*(VDIR[v_t][v]["ray"]["position"].x - user_state["global_position"].x))
					VDIR[v_t][v]["ray"]["offset"] = dimensions["collider"]["radius"] - VDIR[v_t][v]["ray"]["length"]
					VDIR[v_t][v]["ray"]["collided"] = false
	update()
	process_rotation()


func _physics_process(delta) -> void:
	if get_tree().has_network_peer():
		if is_network_master() and visible:
			#look_at(get_global_mouse_position())
			if "0" in VDIR:
				if VDIR["1"]["0"]["ray"]["length"] - dimensions["collider"]["radius"] > 2 and jumpState == false:
					gravityVector = (VDIR["1"]["0"]["ray"]["position"] - user_state["global_position"]).normalized()
				elif jumpState == false:
					gravityVector = Vector2(0,0)
				movementVector = Vector2(0,0)
				if user_input["right"] == true:
					movementVector = Vector2(1,0)
				elif user_input["left"] == true:
					movementVector = Vector2(-1,0)
				else:
					movementVector = Vector2(0,0)
				if movementVector.x == 1 and movementRight == false:
					movementRight = true
					movementLeft = false
					$player_animated_sprite.flip_h = true
				elif movementVector.x == -1 and movementLeft == false:
					movementLeft = true
					movementRight = false
					$player_animated_sprite.flip_h = false
				if movementVector != Vector2(0,0) and jumpState == false:
					movementSpeed = move_toward(movementSpeed, maxMovementSpeed, accelerationSpeed)
				elif movementVector != Vector2(0,0) and jumpState == true:
					movementSpeed = move_toward(movementSpeed, maxMovementSpeed * 2, accelerationSpeed)
				else:
					movementSpeed = move_toward(movementSpeed, 0, deccelerationSpeed)
				if timedOut == true and user_input["up"] == true and jumpState == false and VDIR["1"]["0"]["ray"]["length"] - dimensions["collider"]["radius"] < 2:
					gravityVector = (VDIR["1"]["0"]["ray"]["position"] - user_state["global_position"]).normalized() * -1
					jumpSpeed = 0
					jumpState = true
					time = 0
				if jumpState == true and jumpSpeed < maxJumpSpeed:
					rotation_degrees = move_toward(rotation_degrees, 0, accelerationSpeed/10)
					jumpSpeed = move_toward(jumpSpeed, maxJumpSpeed, accelerationSpeed * 10)
				else:
					jumpState = false
					jumpSpeed = 300
				if user_input["boost"] == true:
					maxMovementSpeed = move_toward(maxMovementSpeed,120,accelerationSpeed)
				else:
					maxMovementSpeed = move_toward(maxMovementSpeed,60,deccelerationSpeed)
				if time < timeOut:
					timedOut = false
				else:
					timedOut = true
				move_and_slide(gravityVector * jumpSpeed + movementVector.rotated(rotation).normalized() * movementSpeed)
				
				if Input.is_action_pressed("input_shoot") and can_shoot and not is_reloading:
					rpc("instance_bullet", get_tree().get_network_unique_id())
					is_reloading = true
					reload_timer.start()
		else:
			rotation = lerp_angle(rotation, puppet_rotation, delta * 8)
			
			if not tween.is_active():
				move_and_slide(puppet_velocity * movementSpeed)

func _draw():
	if debug_mode == true:
		for vector_type in VDIR:
			var v_t = str(vector_type)
			for vector in VDIR[v_t]:
				var v = str(vector)
				if v_t == "1":
					draw_line(VDIR[v_t][v]["start"] - user_state["global_position"],(VDIR[v_t][v]["ray"]["position"] - user_state["global_position"]).rotated(-rotation),Color(255,255,255,1),1)


func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight


func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference


func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()


func set_hp(new_value):
	hp = new_value
	if get_tree().has_network_peer():
		if is_network_master():
			rset("puppet_hp", hp)


func puppet_hp_set(new_value):
	puppet_hp = new_value
	if get_tree().has_network_peer():
		if not is_network_master():
			hp = puppet_hp


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
			#rset_unreliable("puppet_velocity", movementVector)
			rset_unreliable("puppet_rotation", rotation)


sync func instance_bullet(id):
	var player_bullet_instance = Global.instance_node_at_location(player_bullet, PersistentNodes, shoot_point.global_position)
	player_bullet_instance.name = "Bullet" + name + str(Network.networked_object_name_index)
	player_bullet_instance.set_network_master(id)
	player_bullet_instance.player_rotation = rotation
	player_bullet_instance.player_owner = id
	Network.networked_object_name_index += 1


sync func update_position(pos):
	global_position = pos
	puppet_position = pos


func update_shoot_mode(shoot_mode):
	can_shoot = shoot_mode


func _on_reload_timer_timeout():
	is_reloading = false


func _on_hit_timer_timeout():
	modulate = Color(1, 1, 1, 1)


func _on_Hitbox_area_entered(area):
	if get_tree().is_network_server():
		if area.is_in_group("Player_damager") and area.get_parent().player_owner != int(name):
			rpc("hit_by_damager", area.get_parent().damage)
			area.get_parent().rpc("destroy")


sync func hit_by_damager(damage):
	hp -= damage
	modulate = Color(5, 5, 5, 1)
	hit_timer.start()


sync func enable() -> void:
	hp = 100
	can_shoot = false
	update_shoot_mode(false)
	username_text_instance.visible = true
	visible = true
	$CollisionShape2D.disabled = false
	$Hitbox/CollisionShape2D.disabled = false
	
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = self
	
	if not Global.alive_players.has(self):
		Global.alive_players.append(self)


sync func destroy() -> void:
	username_text_instance.visible = false
	visible = false
	$player_collider.disabled = true
	$hitbox/CollisionShape2D.disabled = true
	Global.alive_players.erase(self)
	
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = null


func _exit_tree() -> void:
	Global.alive_players.erase(self)
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = null



