extends Position2D

var rotation_speed = 2
var rotation_dir = 0
var time = 0

func gun_rotation():
	if Input.is_action_just_pressed("gun_up"):
		rotation_dir -= 1
	if Input.is_action_just_pressed("gun_down"):
		rotation_dir += 1
	if Input.is_action_just_released("gun_up"):
		rotation_dir = 0
	if Input.is_action_just_released("gun_down"):
		rotation_dir = 0

func _process(delta):
	time += delta
	#if self.rotation_degrees > -45 and self.rotation_degrees < 15:
		#gun_rotation()
		#rotation += rotation_speed * rotation_dir * delta
	#else:
		#gun_rotation()
		#rotation += rotation_speed * rotation_dir * delta
	look_at(get_global_mouse_position())
	pass
