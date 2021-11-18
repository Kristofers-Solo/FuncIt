extends Control

var FuncItline = 'line'

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
	


func _on_line_SpinBox_value_changed(value):
	a_param_line = value
	FuncItline = 'line'
	Global.get('player').enable_trajectory_line('line')
	Global.get('player').trajectory = 'line'


func _on_a_param_SpinBox_value_changed(value):
	a_param_parab = value
	FuncItline = 'parab'
	Global.get('player').enable_trajectory_line('parab')
	Global.get('player').trajectory = 'parab'


func _on_b_param_SpinBox_value_changed(value):
	b_param_parab = value
	FuncItline = 'parab'
	Global.get('player').enable_trajectory_line('parab')
	Global.get('player').trajectory = 'parab'


func _on_b_param_h_SpinBox_value_changed(value):
	b_param_hyper = value
	FuncItline = 'hyper'
	if b_param_hyper != 0:
		Global.get('player').enable_trajectory_line('hyper')
		Global.get('player').trajectory = 'hyper'
	


func _on_a_param_h_SpinBox_value_changed(value):
	a_param_hyper = value
	FuncItline = 'hyper'
	Global.get('player').enable_trajectory_line('hyper')
	Global.get('player').trajectory = 'hyper'


func _on_amp_SpinBox_value_changed(value):
	amp = value
	FuncItline = 'sine'
	Global.get('player').enable_trajectory_line('sine')
	Global.get('player').trajectory = 'sine'


func _on_freq_SpinBox_value_changed(value):
	freq = value
	FuncItline = 'sine'
	Global.get('player').enable_trajectory_line('sine')
	Global.get('player').trajectory = 'sine'
	














