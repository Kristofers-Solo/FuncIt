extends KinematicBody2D

# Instance of data pre-processors
var VDIR_preset_pre_processor_instance = preload("res://source/assets/scripts/pre-processors/vdir_pre-processor.gd").new()
var UIN_preset_pre_processor_instance = preload("res://source/assets/scripts/pre-processors/uin_pre-processor.gd").new()

# Local class constants

# Local class variables
var VDIR = {}
var user_input = {}
var user_state = {}
var dimensions = {}
var gravityVector = Vector2(0,0)
var movementVector = Vector2(0,0)
var movementSpeed = 0
var maxMovementSpeed = 60 
var accelerationSpeed = 3.5
var deccelerationSpeed = 4.25
var jumpState = false
var jumpSpeed = 0
var maxJumpSpeed = 500
var time = 0
var timeOut = 1
var timedOut = true

func _ready():
	# Allow update process override.
	set_process(true)
	$"player-animated-sprite".play("idle")
	pass

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
			"width":$"player-sprite".texture.get_width(),
			"height":$"player-sprite".texture.get_height(),
			"scale":$"player-sprite".scale,
		},
		"collider": {
			"shape":$"player-collider".get_shape(),
			"radius":$"player-collider".get_shape().get_radius()
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

func _process(delta):
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

func _physics_process(delta):
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
			print(jumpSpeed)
			jumpSpeed = move_toward(jumpSpeed, maxJumpSpeed, accelerationSpeed * 10)
		else:
			jumpState = false
			jumpSpeed = 350
		if user_input["boost"] == true:
			maxMovementSpeed = move_toward(maxMovementSpeed,120,accelerationSpeed)
		else:
			maxMovementSpeed = move_toward(maxMovementSpeed,60,deccelerationSpeed)
		if time < timeOut:
			timedOut = false
		else:
			timedOut = true
		move_and_slide(gravityVector * jumpSpeed + movementVector.rotated(rotation).normalized() * movementSpeed)

func _draw():
	for vector_type in VDIR:
		var v_t = str(vector_type)
		for vector in VDIR[v_t]:
			var v = str(vector)
			if v_t == "1":
				draw_line(VDIR[v_t][v]["start"] - user_state["global_position"],(VDIR[v_t][v]["ray"]["position"] - user_state["global_position"]).rotated(-rotation),Color(255,255,255,1),1)
