extends KinematicBody2D

# Node-Debug-Settings {} Debug element


# != Node Exportable settings
export var debugMode = false
export var onGround = false
export var rotationalStep = 1
export var rotationalQuotient = 1.35
export var movementSpeedQuotient = 50
export var exponQuotient = 4

# !!= Node Importables
export var gravityQuotient = 25
export var materialFrictionQuotient = 75
export var environmentAirFrictionQuotient = 100

# != Node settings and trackers
var nodeVectoralOffset = 0
var nodeVectoralmax = 0
var nodeActiveRotation = 0
var nodeDebug = {"vectors":{"casts":{}}}
var velocityVector = Vector2()
var maximumMovementSpeed = 120
var colliderRotation = 0

func _ready():
	# Acquire and set definitive settings
	nodeVectoralOffset = $player_body_sprite.texture.get_width() / 2 * $player_body_sprite.scale.x
	nodeVectoralmax = $player_body_sprite.texture.get_height() * $player_body_sprite.scale.y
	set_process(true) # {} Debug element

# warning-ignore:unused_argument
func _process(d):
	var client = acquire_client()
	var vdir = acquire_vdir(client)
	# Update the canvas {} Debug element
	update()
	if onGround == false:
		for type in range(0,vdir.size()):
			for vector in range(vdir[str(type)].size()):
				if "onGround" in vdir[str(type)][str(vector)]["ray"]:
					onGround = false
				else:
					onGround = true

func acquire_client():
	var state = {
		"globalPos": global_transform.origin,
		"rotation": nodeActiveRotation
	}
	return state

# Requires an Client element to process
func acquire_vdir(client):
	var vdir = {
		"0": {
			"0": {
				"start": Vector2(0,0)+client["globalPos"],
				"end": Vector2(0,nodeVectoralmax).rotated(deg2rad(nodeActiveRotation))+client["globalPos"]
			},
			"1": {
				"start": Vector2(nodeVectoralOffset,0).rotated(deg2rad(nodeActiveRotation))+client["globalPos"],
				"end": Vector2(nodeVectoralOffset,nodeVectoralmax).rotated(deg2rad(nodeActiveRotation))+client["globalPos"]
			},
			"2": {
				"start": Vector2(-nodeVectoralOffset,0).rotated(deg2rad(nodeActiveRotation))+client["globalPos"],
				"end": Vector2(-nodeVectoralOffset,nodeVectoralmax).rotated(deg2rad(nodeActiveRotation))+client["globalPos"]
			}
		}
	}
	var sState = get_world_2d().direct_space_state
	for type in range(0,vdir.size()):
		for vector in range(vdir[str(type)].size()):
			vdir[str(type)][str(vector)]["ray"] = sState.intersect_ray(vdir[str(type)][str(vector)]["start"], vdir[str(type)][str(vector)]["end"], [self])
			if "position" in vdir[str(type)][str(vector)]["ray"]:
				ray_prcs(vdir[str(type)][str(vector)], str(vector), client)
			else:
				vdir[str(type)][str(vector)]["ray"] = {"position":Vector2(0,nodeVectoralmax).rotated(deg2rad(nodeActiveRotation)) + vdir[str(type)][str(vector)]["start"], "onGround": false}
				ray_prcs(vdir[str(type)][str(vector)], str(vector), client)
	adj_rot(vdir, client)
	return vdir

func get_inpt():
	var inpt = {
		"up": false,
		"down": false,
		"left": false,
		"left-f": 0,
		"right": false,
		"right-f": 0
	}
	if Input.is_action_pressed("inpt_up"):
		inpt["up"] = true
	if Input.is_action_pressed("inpt_down"):
		inpt["down"] = true
	if Input.is_action_pressed("inpt_left"):
		inpt["left"] = true
		inpt["left-f"] = Input.get_action_strength("inpt_left")
	if Input.is_action_pressed("inpt_right"):
		inpt["right"] = true
		inpt["right-f"] = Input.get_action_strength("inpt_right")
	return inpt

func _physics_process(delta):
	var naturalInput = get_inpt()
	var movementDirection = naturalInput["right-f"] - naturalInput["left-f"]
	var movementSpeed = movementDirection * movementSpeedQuotient
	var movementResistanceQuotient = materialFrictionQuotient + environmentAirFrictionQuotient
	if onGround == true:
		if abs(movementSpeed) < movementSpeedQuotient * 0.1:
			velocityVector.x = move_toward(velocityVector.x, 0, movementResistanceQuotient * delta)
		else:
			velocityVector.x += movementSpeed * delta * exponQuotient
		velocityVector.x = clamp(velocityVector.x, -maximumMovementSpeed, maximumMovementSpeed)
		velocityVector.y += gravityQuotient * delta
		velocityVector.y = clamp(velocityVector.y, -maximumMovementSpeed, maximumMovementSpeed)
		move_and_slide(velocityVector.rotated(deg2rad(nodeActiveRotation)))
		sprite_rot()
	else:
		gravityQuotient = gravityQuotient * exponQuotient
		velocityVector.y += gravityQuotient * delta
		velocityVector.y = clamp(velocityVector.y, -maximumMovementSpeed, maximumMovementSpeed)
		if movementDirection == 0:
			nodeActiveRotation = move_toward(nodeActiveRotation, 0, rotationalStep)
		else:
			nodeActiveRotation += rotationalStep * movementDirection
		move_and_slide(velocityVector.rotated(deg2rad(0)))
		sprite_rot()
	pass

func adj_rot(vdir, client):
	var positiveNodeRayl = (vdir["0"]["1"]["start"] - vdir["0"]["1"]["ray"].position).distance_to(vdir["0"]["1"]["start"] - client["globalPos"])
	var negativeNodeRayl = (vdir["0"]["2"]["start"] - vdir["0"]["2"]["ray"].position).distance_to(vdir["0"]["1"]["start"] - client["globalPos"])
	var nodeRayDiff = positiveNodeRayl - negativeNodeRayl
	if nodeRayDiff > rotationalQuotient:
		nodeActiveRotation += rotationalStep
	if nodeRayDiff < -rotationalQuotient:
		nodeActiveRotation -= rotationalStep
	pass

func ray_prcs(vdirel, id, client):
	nodeDebug["vectors"]["casts"][id] = {"start": vdirel["start"]-client["globalPos"],"end":vdirel["ray"].position-client["globalPos"]}
	pass

func sprite_rot():
	var spriteOffsetDistance = sqrt(pow($player_body_sprite.position.x,2) + pow($player_body_sprite.position.y,2))
	var spriteOffsetVector = Vector2(0,spriteOffsetDistance).rotated(deg2rad(nodeActiveRotation))
	$player_body_sprite.position = spriteOffsetVector
	$player_body_sprite.rotation_degrees = nodeActiveRotation
	pass

func _draw(): # {} Debug element
	if debugMode == true:
		for vector in range(0,nodeDebug["vectors"]["casts"].size()):
			draw_line(nodeDebug["vectors"]["casts"][str(vector)]["start"], nodeDebug["vectors"]["casts"][str(vector)]["end"], Color(255,255,255), 1)
	pass
