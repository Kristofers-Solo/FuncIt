extends KinematicBody2D

const JUMP_FORCE = 500
const GRAVITY = 700
const MAX_SPEED = 10000

var speed = 15
var velocity = Vector2()
var fly = false


func _ready():
	pass

remote func _set_pos(position):
	global_transform.origin = position


func _physics_process(delta):
	if is_network_master():
		mode_switch(delta)
		screen_wrap()
		rpc_unreliable("_set_pos", global_transform.origin)


func mode_switch(delta):
	if Input.is_action_just_pressed("mode_switch") and fly == false:
		fly = true
	elif Input.is_action_just_pressed("mode_switch") and fly == true:
		fly = false

	if fly == false:
		movement(delta)
	elif fly == true:
		flying()


func movement(delta):
	if Input.is_action_just_pressed("stop"):
		velocity.x = 0
		velocity.y = 0
	if Input.is_action_pressed("move_left"):
		if velocity.x > -MAX_SPEED:
			velocity.x -= speed
	elif Input.is_action_pressed("move_right"):
		if velocity.x < MAX_SPEED:
			velocity.x += speed
	
	#if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right") and is_on_floor():
	#	velocity.x = 0

	velocity.y += GRAVITY * delta
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y -= JUMP_FORCE
	velocity = move_and_slide(velocity, Vector2.UP)


func flying():
	speed = 500
	var velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	
	velocity = move_and_slide(velocity)


func screen_wrap():
	if position.x <= -10:
		position.x = get_viewport_rect().size.x
	if position.x >= get_viewport_rect().size.x + 10:
		position.x = 0


