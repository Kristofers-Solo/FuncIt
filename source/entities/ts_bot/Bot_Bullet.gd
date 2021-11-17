extends Sprite

export(int) var damage = 25
export var speed_line = 1000
var velocity = Vector2()
var player_owner = 0

var time = 0

var bot_rotation = Global.get('bot_weapon').rotationAmount



func follow_line_trajectory():
	velocity = Vector2(cos(360/bot_rotation + 90), sin(360/bot_rotation + 90))
	pass


func _process(delta):
	print(bot_rotation)
	follow_line_trajectory()
	time += delta
	position += velocity * speed_line * delta


	
func _on_hitbox_body_entered(body):
	if body.is_in_group('bot'):
		pass
	else:
		queue_free()
