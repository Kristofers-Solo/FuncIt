extends Sprite

export(int) var damage = 25
export(int) var speed_parab = 100
var velocity = Vector2()
var player_owner = 0

var time = 0
var a_parameter = 1
var b_parameter = 0

var pos
func _ready():
	pos = Global.get("player").get_node('weaponHolder/Player-character-theme-gun').position 


func follow_parabolic_trajectory():
	if pos.x > 0:
		velocity.x = 5
		velocity.y = time*(a_parameter * time + b_parameter)
	if pos.x < 0:
		velocity.x = 5
		velocity.y = -time*(a_parameter * time + b_parameter)


func _process(delta):
	follow_parabolic_trajectory()
	time += delta
	position += velocity * speed_parab * delta


func _on_hitbox_body_entered(body):
	queue_free()
