extends Position2D

var trajectories = {
	'line' : preload("res://source/entities/shooting/Line_Trajectory/Line_Barrel.tscn"),
	'sine' : preload("res://source/entities/shooting/Sine_Trajectory/Sine_Barrel.tscn"),
	'parab' : preload("res://source/entities/shooting/Parabolic_Trajectory/Parabolic_Barrel.tscn"),
	'hyper' : preload("res://source/entities/shooting/Hyperbolic_Trajectory/Hyperbolic_Barrel.tscn")
}


func equip_gun(gun_type:String):
	for gun in get_children():	#if there is gun remove it
		gun.queue_free()
		
	var gun = trajectories[gun_type].instance()
	add_child(gun)



func _process(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("line"):
		equip_gun('line')
	if Input.is_action_just_pressed("sine"):
		equip_gun('sine')
	if Input.is_action_just_pressed("parab"):
		equip_gun('parab')
	if Input.is_action_just_pressed("hyper"):
		equip_gun('hyper')
	pass
