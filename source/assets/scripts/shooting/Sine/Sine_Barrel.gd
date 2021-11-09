extends StaticBody2D

onready var bullet_env = preload("res://source/entities/shooting/Sine_Trajectory/Sine_Env.tscn")

var velocity = Vector2(1, 0)
var shooting_speed = 200



func shoot():
	var bullet = bullet_env.instance()
	get_parent().get_parent().get_parent().add_child(bullet)
	bullet.global_position = $Position2D.global_position
	bullet.global_rotation = $Position2D.global_rotation
	pass
	

func _process(delta):
	if Input.is_action_just_pressed("input_shoot"):
		shoot()
