extends StaticBody2D

onready var bullet = preload("res://Sine_Trajectory/Sine_Env.tscn")

var velocity = Vector2(1, 0)
var shooting_speed = 200



func shoot():
	var b = bullet.instance()
	get_parent().get_parent().get_parent().add_child(b)
	b.global_position = $Position2D.global_position
	b.global_rotation = $Position2D.global_rotation
	pass
	

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()
