extends CanvasLayer

# if 0, then singleplayer will work, if 1, then multiplayer only
var winner_amount = 1

onready var win_timer = $Control/winner/win_timer
onready var winner = $Control/winner

func _ready() -> void:
	winner.hide()


func _process(delta: float) -> void:
	if Global.alive_players.size() <= winner_amount and get_tree().has_network_peer():
		if Global.alive_players[0].name == str(get_tree().get_network_unique_id()):
			winner.show()
		
		if win_timer.time_left <= 0:
			win_timer.start()
