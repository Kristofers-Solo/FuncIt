extends AnimatedSprite

var trajectory:String = 'line'
var trajectory_line = 'line'

var bullet_trajectory = {
	'line' : preload("res://source/entities/shooting/Line_Trajectory/Line_Env.tscn"),
	'sine' : preload("res://source/entities/shooting/Sine_Trajectory/Sine_Env.tscn"),
	'parab' : preload("res://source/entities/shooting/Parabolic_Trajectory/Parabolic_Env.tscn"),
	'hyper' : preload("res://source/entities/shooting/Hyperbolic_Trajectory/Hyperbolic_Env.tscn")
}

func choose_trajectory():
	trajectory
	trajectory_line
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
		

func shoot(trajectory:String):
	var bullet = bullet_trajectory[trajectory].instance()
	get_parent().get_parent().get_parent().add_child(bullet)
	bullet.global_position = $Shooting_Point.global_position
	bullet.global_rotation = $Shooting_Point.global_rotation
	pass
	
	
func enable_trajectory_line(trajectory_line:String):
	var x = bullet_trajectory[trajectory_line].instance()
	get_parent().get_parent().get_parent().add_child(x)
	x.global_position = $Shooting_Point.global_position
	x.global_rotation = $Shooting_Point.global_rotation



func _process(delta):
	choose_trajectory()
	enable_trajectory_line(trajectory_line)
	if Input.is_action_just_pressed("input_shoot"):
		pass
	elif Input.is_action_just_released("input_shoot"):
		shoot(trajectory)
