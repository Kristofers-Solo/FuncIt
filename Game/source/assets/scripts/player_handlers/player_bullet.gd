extends Sprite

export(int) var speed = 100
var velocity = Vector2(1, 0)

var time = 0
export var amplitude = 4
export var frequency = 5
var gravitile = 5


#var velocity = Vector2(1, 0)
var player_rotation

#export(int) var speed = 1400
export(int) var damage = 25

puppet var puppet_position setget puppet_position_set
puppet var puppet_velocity = Vector2(0, 0)
puppet var puppet_rotation = 0
puppet var bullet_position setget bullet_position_set

onready var initial_position = global_position

var player_owner = 0


func _ready() -> void:
	visible = false
	yield(get_tree(), "idle_frame")
	
	if get_tree().has_network_peer():
		if is_network_master():
			velocity = velocity.rotated(player_rotation)
			rotation = player_rotation
			rset("puppet_velocity", velocity)
			#rset("puppet_rotation", rotation)
			rset("puppet_position", global_position)
			rset("bullet_position", bullet_position)
	
	visible = true


func _process(delta: float) -> void:
	if get_tree().has_network_peer():
		if is_network_master():
			follow_sine_trajectory()
			time += delta
			#global_position += velocity * speed * delta
			global_position += velocity * speed * delta
		else:
			rotation = puppet_rotation
			global_position += puppet_velocity * speed * delta


func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	global_position = puppet_position


func bullet_position_set(new_value) -> void:
	bullet_position = new_value
	global_position = bullet_position 


sync func destroy() -> void:
	queue_free()


func _on_destroy_timer_timeout():
	if get_tree().has_network_peer():
		if get_tree().is_network_server():
			rpc("destroy")


func follow_line_trajectory():
	velocity = Vector2(1, 0) * 10


func follow_sine_trajectory():
	velocity.y = amplitude * cos(time * frequency)
	velocity.x = 5


func follow_parabolic_trajectory():
	velocity.x = 5
	velocity.y = 1 * time * gravitile


func follow_n_parabolic_trajectory():
	velocity.x = 5
	velocity.y = -1 * time * gravitile


func follow_hyperbolic_trajectory():
	velocity.x = gravitile * time
	velocity.y = 1


func follow_n_hyperbolic_trajectory():
	velocity.x = gravitile * time
	velocity.y = -1
