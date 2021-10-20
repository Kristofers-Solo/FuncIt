extends KinematicBody2D

const JUMP_FORCE = 500
const GRAVITY = 500
const MAX_SPEED = 5000
const ACCELERATION = 10

var speed = 50
var velocity = Vector2()
var fly = false

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
	username_text_instance = Global.instance_node_at_location(username_text, Players, global_position)
	username_text_instance.player_following = self


func _process(delta: float) -> void:
	if username_text_instance != null:
		username_text_instance.name = "username" + name


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
	
	#if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right") and is_on_floor():
	#	velocity.x = 0

	velocity.y += GRAVITY * delta
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y -= JUMP_FORCE
	velocity = move_and_slide(velocity, Vector2.UP)


func flying():
	var fly_speed = 1000
	var velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * fly_speed
	
	velocity = move_and_slide(velocity)


func screen_wrap():
	if position.x <= -10:
		position.x = get_viewport_rect().size.x
	if position.x >= get_viewport_rect().size.x + 10:
		position.x = 0


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
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
		rset_unreliable("puppet_velocity", velocity)
		rset_unreliable("puppet_rotation", rotation_degrees)
