extends Sprite

export(int) var damage = 25
export var speed_line = 1000
var velocity = Vector2()
var player_owner = 0

var time = 0
var a_parameter

func _ready():
	if Global.get("user_input") != null:
		a_parameter = -Global.get("user_input").a_param_line
	else:
		a_parameter = 0


func follow_line_trajectory():
	velocity.x = time
	velocity.y = time*a_parameter


func _process(delta):
	follow_line_trajectory()
	time += delta
	position += velocity * speed_line * delta


func _on_hitbox_body_entered(body):
	queue_free()
	
	if body.is_in_group('bot'):
		body.hit_by_damager(damage, get_parent().global_rotation, velocity)

