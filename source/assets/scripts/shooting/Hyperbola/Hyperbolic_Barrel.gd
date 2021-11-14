extends Line2D

export var speed_hyper = 100
var velocity = Vector2(0, 0)
var dot_position = Vector2(0, 0)

var x = 10

var time = 0.05
var a_parameter = 1
var b_parameter = 1

var pos
func _ready():
	pos = Global.get("player").get_node('weaponHolder/Player-character-theme-gun').position 


func _draw():
	update()
	if pos.x > 0:
		if dot_position.x < 1000:
			velocity.x = 10
			velocity.y = a_parameter/(time*b_parameter) 
			dot_position += velocity * speed_hyper * 0.06944
			draw_circle(dot_position, 2, Color(225, 225, 225))
			time += 0.06944
	if pos.x < 0:
		if dot_position.x < 1000:
			velocity.x = 10
			velocity.y = -a_parameter/(time*b_parameter) 
			dot_position += velocity * speed_hyper * 0.06944
			draw_circle(dot_position, 2, Color(225, 225, 225))
			time += 0.06944
			

func _process(_delta):
	update()
