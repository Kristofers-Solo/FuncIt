extends Line2D

var speed_parab = 100
var velocity = Vector2(0, 0)
var dot_position = Vector2(0, 0)

var time = 0
var a_parameter = -Global.get('user_input').a_param_parab
var b_parameter = Global.get('user_input').b_param_parab

var pos_diff = []

var pos
func _ready():
	pos = Global.get("player").get_node('weaponHolder/Player-character-theme-gun').position 


func trajectory():
	while dot_position.x < 1000:
		if pos.x > 0:
			add_point(dot_position)
			velocity.y = time*(a_parameter * time + b_parameter)
			velocity.x = 5
			dot_position += velocity * speed_parab * 0.06944
			time += 0.06944
		if pos.x < 0:
			add_point(dot_position)
			velocity.y = -time*(a_parameter * time + b_parameter)
			velocity.x = 5
			dot_position += velocity * speed_parab * 0.06944
			time += 0.06944
			

func is_flipped():
	while len(pos_diff) < 2:
		pos_diff.append(pos)
		
	if pos_diff[1].x/pos_diff[0].x < 0:
		return true
	
func _process(_delta):
	#if is_flipped():
		#clear_points()
	trajectory()
	update()
	


