extends CanvasLayer

onready var lose_screen = $lose_screen
var green = Color("61d6a8")
var red = Color("dd6673") 


func _ready() -> void:
	lose_screen.hide()


func _process(_delta: float) -> void:
#	print(Global.alive_players.size())
	if Global.alive_players.size() <= 1 and get_tree().has_network_peer():
		if Global.alive_players[1].name == str(get_tree().get_network_unique_id()):
			lose_screen.show()
