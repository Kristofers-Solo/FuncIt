extends Control

var on_line_pressed = false
var on_sine_pressed = false
var on_parab_pressed = false
var on_hyper_pressed = false

func _ready():
	Global.set('control', self)
	


func _on_line_pressed():
	Global.get('player').enable_trajectory_line('line')
	#Global.get('player').choose_trajectory('line')
	pass # Replace with function body.


func _on_parabol_pressed():
	Global.get('player').enable_trajectory_line('parab')
	#Global.get('player').choose_trajectory('parab')
	pass # Replace with function body.


func _on_hyperbol_pressed():
	Global.get('player').enable_trajectory_line('hyper')
	#Global.get('player').trajectory_line = 'hyper'
	pass # Replace with function body.


func _on_sine_pressed():
	Global.get('player').enable_trajectory_line('sine')
	#Global.get('player').trajectory_line = 'sine'
	pass # Replace with function body.
