extends Control


func _ready():
	Global.set('control', self)
	


func _on_line_pressed():
	Global.get('user_input').get_node('line').visible = true
	Global.get('user_input').get_node('parabol').visible = false
	Global.get('user_input').get_node('hyperbol').visible = false
	Global.get('user_input').get_node('sin').visible = false
	Global.get('player').enable_trajectory_line('line')
	Global.get('player').trajectory = 'line'
	pass # Replace with function body.


func _on_parabol_pressed():
	Global.get('user_input').get_node('parabol').visible = true
	Global.get('user_input').get_node('line').visible = false
	Global.get('user_input').get_node('hyperbol').visible = false
	Global.get('user_input').get_node('sin').visible = false
	Global.get('player').enable_trajectory_line('parab')
	Global.get('player').trajectory = 'parab'
	pass # Replace with function body.


func _on_hyperbol_pressed():
	Global.get('user_input').get_node('hyperbol').visible = true
	Global.get('user_input').get_node('sin').visible = false
	Global.get('user_input').get_node('line').visible = false
	Global.get('user_input').get_node('parabol').visible = false
	Global.get('player').enable_trajectory_line('hyper')
	Global.get('player').trajectory = 'hyper'
	pass # Replace with function body.


func _on_sine_pressed():
	Global.get('user_input').get_node('sin').visible = true
	Global.get('user_input').get_node('line').visible = false
	Global.get('user_input').get_node('hyperbol').visible = false
	Global.get('user_input').get_node('parabol').visible = false
	Global.get('player').enable_trajectory_line('sine')
	Global.get('player').trajectory = 'sine'
	pass # Replace with function body.
