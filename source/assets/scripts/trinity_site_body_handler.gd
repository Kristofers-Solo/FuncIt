extends StaticBody2D

onready var clouds = $scene/trinity_site_level_layout_level_design_z_index_1

func _process(delta):
	if clouds.rotation_degrees < -58:
		clouds.rotation_degrees = 0
	clouds.rotation_degrees += -0.01
	pass
