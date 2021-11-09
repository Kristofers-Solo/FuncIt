extends AnimatedSprite

var trajectory:String = 'line'

var bullet_trajectory = {
	'line' : preload("res://source/entities/shooting/Line_Trajectory/Line_Env.tscn"),
	'sine' : preload("res://source/entities/shooting/Sine_Trajectory/Sine_Env.tscn"),
	'parab' : preload("res://source/entities/shooting/Parabolic_Trajectory/Parabolic_Env.tscn"),
	'hyper' : preload("res://source/entities/shooting/Hyperbolic_Trajectory/Hyperbolic_Env.tscn")
}

func choose_trajectory():
	if Input.is_action_just_pressed("line"):
		trajectory = 'line'
	elif Input.is_action_just_pressed("sine"):
		trajectory = 'sine'
	elif Input.is_action_just_pressed("parab"):
		trajectory = 'parab'
	elif Input.is_action_just_pressed("hyper"):
		trajectory = 'hyper'
		

func shoot(trajectory:String):
	var bullet = bullet_trajectory[trajectory].instance()
	get_parent().get_parent().get_parent().add_child(bullet)
	bullet.global_position = $Position2D.global_position
	bullet.global_rotation = $Position2D.global_rotation
	pass
	

func _process(delta):
	choose_trajectory()
	if Input.is_action_just_pressed("input_shoot"):
		shoot(trajectory)
