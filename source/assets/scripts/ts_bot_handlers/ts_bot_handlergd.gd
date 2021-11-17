extends KinematicBody2D

const GRAVITY = 5

var liftSpeed = 0
var accelerationSpeed = 2
var deccelerationSpeed = 20
var maxSpeed = 250

var worldSpace2d = null
var coreRay = {}

var desiredLocation = Vector2(0,0)
var movementVector = Vector2(0,0)
var weightVector = Vector2(0,0)
var interacting = false
var interactionRays = []
var degreeTracker

var startVector = Vector2(0,5)
var startPosition = Vector2(0,5)
var maxRay = 65
var interactionRay = null

var degreeStep = 60
var fireRate = 12
var time = 0
var rotationAmount = 0
var rand_generate = RandomNumberGenerator.new()

export(int, "Passive", "Friendly", "Agressive") var Mode

func _ready():
	desiredLocation = position
	startVector += global_position
	pass

func _physics_process(delta):
	time += delta#
	rand_generate.randomize()
	get_interaction()
	if interactionRays[0]["interacted"]: 
		if liftSpeed > 0: liftSpeed = move_toward(liftSpeed, 0, deccelerationSpeed)
	elif abs(position.y - desiredLocation.y) > 10 and not interacting: liftSpeed -= accelerationSpeed
	else: liftSpeed += GRAVITY
	liftSpeed = clamp(liftSpeed, -maxSpeed, maxSpeed)
	move_and_slide(Vector2(0,liftSpeed))
	if Mode == 0:
		$ts_bot_sprite.play("passive_idle")
		$TsBotSpriteWeaponOn.hide()
		$TsBotSpriteWeaponOff.hide()
	elif Mode == 1:
		$ts_bot_sprite.play("friendly_idle")
		$TsBotSpriteWeaponOn.hide()
		$TsBotSpriteWeaponOff.show()
	elif Mode == 2:
		$ts_bot_sprite.play("agressive_idle")
		$TsBotSpriteWeaponOn.show()
		$TsBotSpriteWeaponOff.hide()
	if time > 60 / fireRate and Mode >= 1:
		rotationAmount = rand_generate.randi_range(1,36)
		$TsBotSpriteWeaponOff.rotation = 360/rotationAmount
		$TsBotSpriteWeaponOn.rotation = 360/rotationAmount
		time = 0

func get_interaction():
	print(interacting)
	degreeTracker = 0
	interactionRays = []
	worldSpace2d = get_world_2d().direct_space_state
	interacting = false
	while degreeTracker < 360 + degreeStep:
		interactionRay = worldSpace2d.intersect_ray(startVector, Vector2(0,maxRay).rotated(deg2rad(degreeTracker)) + global_position, [self])
		var interacted = false
		if "position" in interactionRay:
			interacted = true
			Mode += 1
			interacting = true
		interactionRays.append({"start": startVector, "end": Vector2(0,maxRay).rotated(deg2rad(degreeTracker)) + global_position, "degrees": degreeTracker,"ray": interactionRay, "interacted": interacted})
		degreeTracker += degreeStep
