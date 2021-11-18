extends CanvasLayer

onready var lose_screen = $lose_screen
var green = Color("61d6a8")
var red = Color("dd6673") 


func _ready() -> void:
	lose_screen.hide()


func _process(_delta: float) -> void:
	if Global.killed_players.size() >= 1:
		lose_screen.show()
	else:
		lose_screen.hide()
