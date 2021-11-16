extends Control

var a_param_line = 0

var a_param_parab = 1
var b_param_parab = 0

var a_param_hyper = 1
var b_param_hyper = 1

var freq = 5
var amp = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.set('user_input', self)
	pass # Replace with function body.




func _on_LineEdit_text_entered(new_text):
	a_param_line = int(new_text)
	Global.get('player').enable_trajectory_line('line')
	Global.get('player').trajectory = 'line'
	pass # Replace with function body.


func _on_a_param_LineEdit_text_entered(new_text):
	a_param_parab = int(new_text)
	Global.get('player').enable_trajectory_line('parab')
	Global.get('player').trajectory = 'parab'
	pass # Replace with function body.


func _on_b_param_LineEdit_text_entered(new_text):
	b_param_parab = int(new_text)
	Global.get('player').enable_trajectory_line('parab')
	Global.get('player').trajectory = 'parab'
	pass # Replace with function body.


func _on_a_param_h_LineEdit_text_entered(new_text):
	a_param_hyper = int(new_text)
	Global.get('player').enable_trajectory_line('hyper')
	Global.get('player').trajectory = 'hyper'
	pass # Replace with function body.


func _on_b_param_h_LineEdit_text_entered(new_text):
	b_param_hyper = int(new_text)
	if b_param_hyper != 0:
		Global.get('player').enable_trajectory_line('hyper')
		Global.get('player').trajectory = 'hyper'
	
	pass # Replace with function body.


func _on_amp_text_entered(new_text):
	amp = int(new_text)
	Global.get('player').enable_trajectory_line('sine')
	Global.get('player').trajectory = 'sine'
	pass # Replace with function body.


func _on_freq_text_entered(new_text):
	freq = int(new_text)
	Global.get('player').enable_trajectory_line('sine')
	Global.get('player').trajectory = 'sine'
	pass # Replace with function body.
