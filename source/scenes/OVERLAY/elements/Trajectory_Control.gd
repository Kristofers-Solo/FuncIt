extends Control

var on_line_pressed = false
var on_sine_pressed = false
var on_parab_pressed = false
var on_hyper_pressed = false

func _ready():
	Global.set('control', self)
	


func _on_line_pressed():
	Global.get('player').enable_trajectory_line('line')
	pass # Replace with function body.


func _on_parabol_pressed():
	on_parab_pressed = true
	pass # Replace with function body.


func _on_hyperbol_pressed():
	on_hyper_pressed = true
	pass # Replace with function body.


func _on_sine_pressed():
	on_sine_pressed = true
	pass # Replace with function body.
