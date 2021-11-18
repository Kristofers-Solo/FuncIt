extends CanvasLayer

onready var lose_screen = $lose_screen


func _ready() -> void:
	Global.killed_players.clear()
	lose_screen.hide()


func _process(_delta: float) -> void:
	if Global.killed_players.size() >= 1 and not $win_lose_screen.is_visible_in_tree():
		lose_screen.show()
	else:
		lose_screen.hide()
	
