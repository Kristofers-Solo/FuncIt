extends Control



func _ready():
	
	Global.set('line_button', self)
	Global.set('sine_button', self)
	Global.set('parab_button', self)
	Global.set('hyper_button', self)


func _on_Line_pressed():
	Global.set('control', self)
	return true
	pass # Replace with function body.


func _on_Sine_pressed():
	Global.set('sine_button', self)
	pass # Replace with function body.
