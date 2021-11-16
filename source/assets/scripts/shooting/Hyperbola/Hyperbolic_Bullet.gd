extends Sprite

export(int) var damage = 25
var velocity = Vector2()
var speed_hyper = 100
var time = 0.05

var a_parameter = Global.get('user_input').a_param_hyper
var b_parameter = Global.get('user_input').b_param_hyper

var player_owner = 0

var pos
func _ready():
	pos = Global.get("player").get_node('weaponHolder/Player-character-theme-gun').position 


func follow_hyperbolic_trajectory():
	if pos.x > 0:
		velocity.x = 5
		velocity.y = a_parameter/(time*b_parameter)
	if pos.x < 0:
		velocity.x = 5
		velocity.y = -a_parameter/(time*b_parameter)


func _process(delta):
	follow_hyperbolic_trajectory()
	time += delta
	position += velocity * speed_hyper * delta


func _on_hitbox_body_entered(_body):
	queue_free()
