extends Control

var a_param_line = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_LineEdit_text_entered(new_text):
	a_param_line = new_text
	Global.get('player').enable_trajectory_line('line')
	Global.get('player').trajectory = 'line'
	pass # Replace with function body.
