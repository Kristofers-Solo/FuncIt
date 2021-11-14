extends Line2D

var speed_parab = 100
var velocity = Vector2(0, 0)
var dot_position = Vector2(0, 0)

var time = 0
var a_parameter = 1
var b_parameter = 0

var pos
func _ready():
	pos = Global.get("player").get_node('weaponHolder/Player-character-theme-gun').position 

#func _draw():
#	if pos.x > 0:
#		if dot_position.x < 1000:
#			velocity.y = time*(a_parameter * time + b_parameter)
#			velocity.x = 5
#			dot_position += velocity * speed_parab * 0.06944
#			draw_circle(dot_position, 2, Color(225, 225, 225))
#			time += 0.06944
#	if pos.x < 0:
#		if dot_position.x < 1000:
#			velocity.y = -time*(a_parameter * time + b_parameter)
#			velocity.x = 5
#			dot_position += velocity * speed_parab * 0.06944
#			draw_circle(dot_position, 2, Color(225, 225, 225))
#			time += 0.06944
#
#func _process(_delta):
#	update()

func update_trajectory(delta):
	clear_points()
	
	while dot_position.x < 1000:
		if pos.x >= 0:
			add_point(dot_position)
			velocity.y = time*(a_parameter * time + b_parameter)
			velocity.x = 5
			dot_position += velocity * speed_parab * delta
			time += delta
		if pos.x < 0:
			add_point(dot_position)
			velocity.y = -time*(a_parameter * time + b_parameter)
			velocity.x = 5
			dot_position += velocity * speed_parab * delta
			time += delta
	


			
func _physics_process(delta):
	update_trajectory(delta)
	


