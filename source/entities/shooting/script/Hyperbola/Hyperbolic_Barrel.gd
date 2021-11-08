extends StaticBody2D # Y = aX

onready var bullet = preload("res://Hyperbolic_Trajectory/Hyperbolic_Env.tscn")


func shoot():
	var b = bullet.instance()
	get_parent().get_parent().get_parent().add_child(b)
	b.global_position = $Position2D.global_position
	b.global_rotation = $Position2D.global_rotation
	
	

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()
