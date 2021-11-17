extends Node

var player_master = null
var ui = null
var alive_players = []
var player
var global
var control 
var user_input

var clientPhase = {
	"0": {
		"phase_id": 0,
		"phase_name": "Movement phase",
		"length": 2,
		"start_time": null
	},
	"1": {
		"phase_id": 1,
		"phase_name": "Weapon adjustment phase",
		"length": 2,
		"start_time": null
	},
	"2": {
		"phase_id": 2,
		"phase_name": "Bullet simulation phase",
		"length": 2,
		"start_time": null
	},
	"3": {
		"phase_id": 3,
		"phase_name": "Idle phase",
		"length": 2,
		"start_time": null
	},
	"active": null
}
var activePhaseTracker = null
var currentTime = null
var gameStart = false


func phase_update_global():
	currentTime = OS.get_time()
	if gameStart:
		if activePhaseTracker != null:
			if clientPhase[str(activePhaseTracker)]["start_time"] != null:
				if currentTime["second"] + currentTime["minute"] * 60 - clientPhase[str(activePhaseTracker)]["start_time"]["second"] - clientPhase[str(activePhaseTracker)]["start_time"]["minute"] * 60 > clientPhase[str(activePhaseTracker)]["length"]:
					if activePhaseTracker == clientPhase.size() - 3:
						clientPhase[str(activePhaseTracker)]["start_time"] = null 
						activePhaseTracker = 0
					else: 
						clientPhase[str(activePhaseTracker)]["start_time"] = null 
						activePhaseTracker += 1
			else: clientPhase[str(activePhaseTracker)]["start_time"] = currentTime
		else: activePhaseTracker = 0
		clientPhase["active"] = clientPhase[str(activePhaseTracker)]
	else:
		clientPhase["active"] = null
		activePhaseTracker = null
	pass


func start_game(value) -> void:
	gameStart = value


func get_current_phase():
	return clientPhase


func set_current_phase(phase) -> void:
	clientPhase = phase


func instance_node_at_location(node: Object, parent: Object, location: Vector2) -> Object:
	var node_instance = instance_node(node, parent)
	node_instance.global_position = location
	return node_instance


func instance_node(node: Object, parent: Object) -> Object:
	var node_instance = node.instance()
	parent.add_child(node_instance)
	return node_instance
