extends Node

var player_master = null
var ui = null
var alive_players = []

var clientPhase = {
	"0": {
		"phase_name": "Movement phase",
		"length": 2,
		"start_time": null
	},
	"1": {
		"phase_name": "Weapon adjustment phase",
		"length": 2,
		"start_time": null
	},
	"2": {
		"phase_name": "Bullet simulation phase",
		"length": 2,
		"start_time": null
	},
	"3": {
		"phase_name": "Idle phase",
		"length": 2,
		"start_time": null
	}
}
var activePhase = null
var currentTime = null
var gameStart = false

func phase_update_global():
	currentTime = OS.get_time()
	if gameStart:
		if activePhase != null:
			if clientPhase[str(activePhase)]["start_time"] != null:
				if currentTime["second"] + currentTime["minute"] * 60 - clientPhase[str(activePhase)]["start_time"]["second"] - clientPhase[str(activePhase)]["start_time"]["minute"] * 60 > clientPhase[str(activePhase)]["length"]:
					if activePhase + 1 == clientPhase.size():
						clientPhase[str(activePhase)]["start_time"] = null 
						activePhase = 0
					else: 
						clientPhase[str(activePhase)]["start_time"] = null 
						activePhase += 1
			else: clientPhase[str(activePhase)]["start_time"] = currentTime
		else: activePhase = 0
		return clientPhase[str(activePhase)]
	pass

func start_game():
	gameStart = true
	pass

func get_client_phase():
	return {"clientPhase": clientPhase, "activePhase": activePhase, "gameStart": gameStart, "currentTime": currentTime}

func phase_update_puppet(phase):
	clientPhase = phase["clientPhase"]
	activePhase = phase["activePhase"]

func instance_node_at_location(node: Object, parent: Object, location: Vector2) -> Object:
	var node_instance = instance_node(node, parent)
	node_instance.global_position = location
	return node_instance


func instance_node(node: Object, parent: Object) -> Object:
	var node_instance = node.instance()
	parent.add_child(node_instance)
	return node_instance

var time

func time_input(d):
	time = d

func time_output():
	return time
