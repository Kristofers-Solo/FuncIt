extends KinematicBody2D

export var debugMode = false

var trajectory:String = 'line'
var trajectory_line = 'line'

var bullet
var username_text = load("res://source/scenes/OVERLAY/elements/username_text.tscn")
var username setget username_set
var username_text_instance = null
var hp = 100 setget set_hp
var can_shoot = true
var is_reloading = false

puppet var puppet_hp = 100 setget puppet_hp_set
puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0
puppet var puppet_username = "" setget puppet_username_set
puppet var puppet_weapon_position = Vector2()
puppet var puppet_weapon_angle = 0
puppet var puppet_direction = "left"
puppet var puppet_theme = "01"
puppet var puppet_character_states = {}
puppet var puppet_bullet_position = Vector2() setget puppet_bullet_position_set
puppet var puppet_phase = null

onready var tween = $Tween
onready var sprite = $player_sprite
onready var reload_timer = $reload_timer
onready var shoot_point = $"weaponHolder/Player-character-theme-gun/shoot_point"
onready var hit_timer = $hit_timer


var bullet_env = {
	'line' : preload("res://source/entities/shooting/Line_Trajectory/Line_Env.tscn"),
	'sine' : preload("res://source/entities/shooting/Sine_Trajectory/Sine_Env.tscn"),
	'parab' : preload("res://source/entities/shooting/Parabolic_Trajectory/Parabolic_Env.tscn"),
	'hyper' : preload("res://source/entities/shooting/Hyperbolic_Trajectory/Hyperbolic_Env.tscn")
}

var bullet_trajectory = {
	'line' : preload("res://source/entities/shooting/Line_Trajectory/Line_Barrel.tscn"),
	'sine' : preload("res://source/entities/shooting/Sine_Trajectory/Sine_Barrel.tscn"),
	'parab' : preload("res://source/entities/shooting/Parabolic_Trajectory/Parabolic_Barrel.tscn"),
	'hyper' : preload("res://source/entities/shooting/Hyperbolic_Trajectory/Hyperbolic_Barrel.tscn")
}


# Instance of data pre_processors
var VDIR_preset_pre_processor_instance = preload("res://source/assets/scripts/pre_processors/vdir_pre_processor.gd").new()
var UIN_preset_pre_processor_instance = preload("res://source/assets/scripts/pre_processors/uin_pre_processor.gd").new()

# Local class constants

# Local class variables
var VDIR = {}
var user_input = {}
var user_state = {}
var dimensions = {}

var currentMovementSpeed = 0
var maxMovementSpeed = Vector2(200,400)
var accelerationSpeed = 5
var deccelerationSpeed = 8
var rotationSpeed = 5
var currentRotation = 0
var rotationalHolder = 0
var velocityVDIR = Vector2(0,0)
var characterStates = {"onGround": false, "jumped": false, "faceDirection": true}

var reverseControls = false
var awaitingCollision = false

var direction = "left"
export var theme = "01"

var weaponRotationalStep = 2
var weaponPositionalOffset = Vector2(0,0)
var weaponPosition = Vector2(0,0)
var weaponAngle = 0

var particleTexture = ImageTexture.new()
var particleImage = Image.new()

var globalActivePhase = null
var clientPhase = null

func _ready():
	
	weaponPositionalOffset = Vector2(-$"weaponHolder/Player-character-theme-gun-na3".texture.get_width() * $"weaponHolder/Player-character-theme-gun-na3".scale.x / 2,-$"weaponHolder/Player-character-theme-gun-na3".texture.get_height() * $"weaponHolder/Player-character-theme-gun-na3".scale.y / 2) + Vector2(-$weaponHolder.get_shape().get_radius(), 0)
	$"weaponHolder/Player-character-theme-gun".position = weaponPositionalOffset
	
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	username_text_instance = Global.instance_node_at_location(username_text, PersistentNodes, global_position)
	username_text_instance.player_following = self
	update_shoot_mode(true)
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
	if rotation_degrees > 360 or rotation_degrees < -360: rotation_degrees = 0
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
	if get_tree().is_network_server():
		Global.phase_update_global()
		clientPhase = Global.get_current_phase()
		rset_unreliable("puppet_phase", clientPhase)
		print("MASTER:",clientPhase)
	else:
		if puppet_phase != null: clientPhase = puppet_phase
		Global.set_current_phase(clientPhase)
		print("SLAVE:",clientPhase)
	$"weaponHolder/Player-character-theme-gun".play(theme)
	particleImage.load("res://source/assets/sprites/character/player/theme/" + theme + "/na/Player-character-theme-particle-"+theme+".png")
	particleTexture.create_from_image(particleImage)
	$Particles2D.texture = particleTexture
	if username_text_instance != null:
		username_text_instance.name = "username" + name
	if $Particles2D.position.x > 0 and direction != "left":
		$Particles2D.position = Vector2(-$Particles2D.position.x,$Particles2D.position.y)
		$Particles2D.scale = -$Particles2D.scale
	elif $Particles2D.position.x < 0 and direction != "right":
		$Particles2D.position = Vector2(-$Particles2D.position.x,$Particles2D.position.y)
		$Particles2D.scale = -$Particles2D.scale
	user_input = UIN_preset_pre_processor_instance.update()
	user_state = get_user_state()
	dimensions = get_dimensions()
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
			if "0" in VDIR:
				if VDIR["1"]["0"]["ray"]["length"] - dimensions["collider"]["radius"] > 5:
					characterStates["onGround"] = false
				else:
					characterStates["onGround"] = true
					characterStates["jumped"] = false
				if characterStates["onGround"] and abs(velocityVDIR.x) < 5:
					if rotation_degrees > 90 or rotation_degrees < -90:
						reverseControls = true
					else:
						reverseControls = false
				if VDIR["1"]["0"]["ray"]["collided"]:
					rotationalHolder = rotation
				if characterStates["jumped"] and not VDIR["1"]["0"]["ray"]["collided"]:
					awaitingCollision = true
				elif characterStates["jumped"] and awaitingCollision and VDIR["1"]["0"]["ray"]["collided"]:
					awaitingCollision = false
					if velocityVDIR.y < 0: velocityVDIR.y = 0
				if user_input["boost"] and not characterStates["jumped"]:
					maxMovementSpeed.x = move_toward(maxMovementSpeed.x, 350, accelerationSpeed)
				else:
					maxMovementSpeed.x = move_toward(maxMovementSpeed.x, 200, accelerationSpeed)
				if characterStates["onGround"] and not characterStates["jumped"] and user_input["up"]:
					velocityVDIR.y = -maxMovementSpeed.y
					characterStates["jumped"] = true
					rotationalHolder = rotation
				if user_input["left"] and not reverseControls or user_input["right"] and reverseControls:
					if velocityVDIR.x > 0:
						velocityVDIR.x -= deccelerationSpeed
					else:
						velocityVDIR.x -= accelerationSpeed
						if not characterStates["jumped"]:
							direction = "left"
					if velocityVDIR.y < maxMovementSpeed.x and not characterStates["onGround"] and characterStates["jumped"]:
						rotation_degrees -= rad2deg(rotationSpeed*delta)
				if user_input["right"] and not reverseControls or user_input["left"] and reverseControls:
					if velocityVDIR.x < 0:
						velocityVDIR.x += deccelerationSpeed
					else:
						velocityVDIR.x += accelerationSpeed
						if not characterStates["jumped"]:
							direction = "right"
					if velocityVDIR.y < maxMovementSpeed.x and not characterStates["onGround"] and characterStates["jumped"]:
						rotation_degrees += rad2deg(rotationSpeed*delta)
				if characterStates["jumped"] and not characterStates["onGround"] and velocityVDIR.y > maxMovementSpeed.x:
					if rotation_degrees > rad2deg(rotationalHolder): rotation_degrees -= rotationSpeed / 2
					elif rotation_degrees < rad2deg(rotationalHolder): rotation_degrees = move_toward(rotation_degrees, rad2deg(rotationalHolder), rotationSpeed / 2)
				if not user_input["right"] and not user_input["left"]:
					velocityVDIR.x = move_toward(velocityVDIR.x, 0, deccelerationSpeed)
				if velocityVDIR.x != 0 and maxMovementSpeed.x == 200:
					$player_animated_sprite.play("move-speed-"+direction+"-"+theme)
				elif maxMovementSpeed.x > 200 and not characterStates["jumped"]:
					$player_animated_sprite.play("boost-speed-"+direction+"-"+theme)
					$Particles2D.set_emitting(true)
				else:
					#$player_animated_sprite.play("idle-speed-"+direction+"-"+theme)
					$Particles2D.set_emitting(false)
				if not characterStates["onGround"]:
					velocityVDIR.y += accelerationSpeed
				elif characterStates["onGround"] and velocityVDIR.y > 0:
					velocityVDIR.y -= deccelerationSpeed
				velocityVDIR = Vector2(clamp(velocityVDIR.x, -maxMovementSpeed.x, maxMovementSpeed.x), clamp(velocityVDIR.y, -maxMovementSpeed.y, maxMovementSpeed.y))
				move_and_slide(velocityVDIR.rotated(rotationalHolder))
				rotate_weapon()
				choose_trajectory()
				enable_trajectory_line(trajectory_line)
				if Input.is_action_just_released("input_shoot") and can_shoot and not is_reloading:
					rpc("shoot", trajectory, get_tree().get_network_unique_id())
					is_reloading = true
					reload_timer.start()
		else:
			rotation = lerp_angle(rotation, puppet_rotation, delta * 8)
			$"weaponHolder/Player-character-theme-gun".position = puppet_weapon_position
			weaponAngle = puppet_weapon_angle
			direction = puppet_direction

			if velocityVDIR.x != 0 and maxMovementSpeed.x == 200:
				$player_animated_sprite.play("move-speed-"+direction+"-"+theme)
			elif maxMovementSpeed.x > 200 and not characterStates["jumped"]:
				$player_animated_sprite.play("boost-speed-"+direction+"-"+theme)
				$Particles2D.set_emitting(true)
			else:
				$player_animated_sprite.play("idle-speed-"+direction+"-"+theme)
				$Particles2D.set_emitting(false)
			rotate_weapon()

			if not tween.is_active():
				pass
	if hp <= 0:
		if get_tree().is_network_server():
			rpc("destroy")


func choose_trajectory():
	if Input.is_action_just_pressed("line"):
		trajectory = 'line'
		trajectory_line = 'line'
	elif Input.is_action_just_pressed("sine"):
		trajectory = 'sine'
		trajectory_line = 'sine'
	elif Input.is_action_just_pressed("parab"):
		trajectory = 'parab'
		trajectory_line = 'parab'
	elif Input.is_action_just_pressed("hyper"):
		trajectory = 'hyper'
		trajectory_line = 'hyper'


sync func shoot(trajectory:String, id):
	bullet = bullet_env[trajectory].instance()
	add_child(bullet)
	bullet.global_position = shoot_point.global_position
	bullet.global_rotation = shoot_point.global_rotation
#	bullet.player_owner = id


func enable_trajectory_line(trajectory_line:String):
	var x = bullet_trajectory[trajectory_line].instance()
	add_child(x)
	x.global_position = shoot_point.global_position
	x.global_rotation = shoot_point.global_rotation


func _draw():
	if debugMode:
		for vector_type in VDIR:
			var v_t = str(vector_type)
			for vector in VDIR[v_t]:
				var v = str(vector)
				if v_t == "1":
					draw_line(VDIR[v_t][v]["start"] - user_state["global_position"],(VDIR[v_t][v]["ray"]["position"] - user_state["global_position"]).rotated(-rotation),Color(255,255,255,1),1)



func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()


func puppet_bullet_position_set(new_value) -> void:
	puppet_bullet_position = new_value
	tween.interpolate_property(self, "global_position", global_position, puppet_bullet_position, 0.1)
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
			rset_unreliable("puppet_rotation", rotation)
			rset_unreliable("puppet_weapon_position", weaponPosition)
			rset_unreliable("puppet_weapon_angle", weaponAngle)
			rset_unreliable("puppet_direction", direction)
			#rset_unreliable("puppet_character_states", characterStates)
			rset_unreliable("puppet_bullet_position", bullet)


sync func update_position(pos):
	global_position = pos
	puppet_position = pos


func update_shoot_mode(shoot_mode):
	can_shoot = shoot_mode


func _on_reload_timer_timeout():
	is_reloading = false


func _on_hit_timer_timeout():
	modulate = Color(1, 1, 1, 1)


func _on_hitbox_area_entered(area):
	if get_tree().is_network_server():
		if area.is_in_group("Player_damager"):
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
	$player_collider.disabled = false
	$hitbox/CollisionShape2D.disabled = false
	$weaponHolder.disabled = false

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
	$weaponHolder.disabled = true
	Global.alive_players.erase(self)

	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = null


func _exit_tree() -> void:
	Global.alive_players.erase(self)
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = null

func rotate_weapon():
	#equip_weapon()
	weaponPosition = $"weaponHolder/Player-character-theme-gun".position
	weaponPosition -= Vector2(weaponPositionalOffset.x,0).rotated(deg2rad(weaponAngle)) + Vector2(0,weaponPositionalOffset.y)
	if user_input["r_inc"]:
		weaponAngle += weaponRotationalStep
	if user_input["r_dec"]:
		weaponAngle -= weaponRotationalStep
	if direction == "right":
		if weaponAngle + weaponRotationalStep < 87.5:
			weaponAngle = 180 - weaponAngle
		weaponAngle = clamp(weaponAngle, 87.5,180)
		$"weaponHolder/Player-character-theme-gun".flip_v = true
	elif direction == "left":
		if weaponAngle - weaponRotationalStep > 92.5:
			weaponAngle = abs(weaponAngle - 180)
		weaponAngle = clamp(weaponAngle, 0, 92.5)
		$"weaponHolder/Player-character-theme-gun".flip_v = false
	weaponPosition += Vector2(weaponPositionalOffset.x,0).rotated(deg2rad(weaponAngle)) + Vector2(0,weaponPositionalOffset.y)
	$"weaponHolder/Player-character-theme-gun".position = weaponPosition
	$"weaponHolder/Player-character-theme-gun".rotation_degrees = weaponAngle
	pass



