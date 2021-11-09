extends StaticBody2D # Y = aX

onready var bullet_env = preload("res://source/entities/shooting/Parabolic_Trajectory/Parabolic_Env.tscn")


func shoot():
	var bullet = bullet_env.instance()
	get_parent().get_parent().get_parent().add_child(bullet)
	bullet.global_position = $Position2D.global_position
	bullet.global_rotation = $Position2D.global_rotation
	
	

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()
