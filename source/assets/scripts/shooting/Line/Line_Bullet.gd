extends Sprite

export(int) var damage = 25
export var speed_line = 1000
var velocity = Vector2()
var player_owner = 0

var time = 0
var a_parameter =  0



func follow_line_trajectory():
	a_parameter = -Global.get('user_input').a_param_line
	velocity.x = time
	velocity.y = time*a_parameter


func _process(delta):
	follow_line_trajectory()
	time += delta
	position += velocity * speed_line * delta


func _on_hitbox_body_entered(_body):
	queue_free()
