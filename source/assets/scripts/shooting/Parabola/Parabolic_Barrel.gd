extends Line2D

var speed_parab = 100
var velocity = Vector2(0, 0)
var dot_position = Vector2(0, 0)

var time = 0
var a_parameter = -Global.get('user_input').a_param_parab
var b_parameter = Global.get('user_input').b_param_parab

var pos_diff = []

var pos
var rot
func _ready():
	pos = Global.get("player").get_node('weaponHolder/Player-character-theme-gun').position 
	rot = Global.get("player").get_node('weaponHolder/Player-character-theme-gun').rotation


func trajectory(delta):
	while dot_position.x < 2000:
		if pos.x > 0:
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
			
	
func _process(delta):
	trajectory(delta)
	update()
	


