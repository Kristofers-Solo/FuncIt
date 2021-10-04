extends KinematicBody2D

const JUMP_FORCE = 500
const GRAVITY = 700
const MAX_SPEED = 10000

var speed = 15
var velocity = Vector2()
var fly = false

puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
puppet var puppet_velocity = Vector2()
puppet var puppet_rotaion = 0
onready var tween = $Tween


func _physics_process(delta):
	if is_network_master():
		mode_switch(delta)
		screen_wrap()


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
	
	if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right") and is_on_floor():
		velocity.x = 0

	velocity.y += GRAVITY * delta
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y -= JUMP_FORCE
	velocity = move_and_slide(velocity, Vector2.UP)


func flying():
	speed = 1000
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
	print(velocity)


func screen_wrap():
	if position.x <= -10:
		position.x = get_viewport_rect().size.x
	if position.x >= get_viewport_rect().size.x + 10:
		position.x = 0


func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	tween.inturpolate_polarity(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()


func _on_network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
		rset_unreliable("puppet_velocity", velocity)
