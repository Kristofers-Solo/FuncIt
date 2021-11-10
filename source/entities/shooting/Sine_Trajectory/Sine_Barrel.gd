extends Line2D


export var speed = 100
var velocity = Vector2(0, 0)
var dot_position = Vector2(0, 0)
var dot_array:PoolVector2Array = []

var time = 0
export var amplitude = 4
export var frequency = 5

var maxpoints = 15


func follow_sine_trajectory(time):
	for x in range(maxpoints):
		velocity.y = amplitude * cos(time * frequency)
		velocity.x = 5
		dot_position += velocity 
		dot_array.append(dot_position)
	return dot_array
	
func construct_a_line():
	clear_points()
	for x in range(maxpoints):
		add_point(follow_sine_trajectory(x))
	pass

func _process(delta):
	time += delta
	self.points = follow_sine_trajectory(time)
	pass
