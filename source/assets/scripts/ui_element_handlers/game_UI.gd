extends CanvasLayer

# if 0, then singleplayer will work, if 1, then multiplayer only
var winner_amount = 1

onready var win_timer = $win_lose_screen/win_timer
onready var label = $win_lose_screen/Panel/Label
onready var win_lose_screen = $win_lose_screen
var green = Color("61d6a8")
var red = Color("dd6673") 


func _ready() -> void:
	win_lose_screen.hide()


func _process(_delta: float) -> void:
	if Global.alive_players.size() <= winner_amount and get_tree().has_network_peer():
		if Global.alive_players[0].name == str(get_tree().get_network_unique_id()):
			label.text = "You won!"
			label.add_color_override("font_color", green)
			win_lose_screen.show()
		else:
			label.text = "You died!"
			label.add_color_override("font_color", red)
			win_lose_screen.show()
		
		if win_timer.time_left <= 0:
			win_timer.start()
