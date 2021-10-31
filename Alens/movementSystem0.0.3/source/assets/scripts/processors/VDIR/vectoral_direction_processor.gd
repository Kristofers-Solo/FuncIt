extends Node

func _ready():
	pass

func process(userState, vectoralDirectionPreset,scale,spaceState,ignorable):
	var clientOffset = userState["node_global_position"]
	for vectorType in vectoralDirectionPreset:
		var vT = str(vectorType)
		for vector in vectoralDirectionPreset[vT]:
			var v = str(vector)
			var Ray = spaceState.intersect_ray(vectoralDirectionPreset[vT][v]["start"].rotated(deg2rad(userState["rotation"])) + clientOffset,(vectoralDirectionPreset[vT][v]["end"].rotated(deg2rad(userState["rotation"])) + clientOffset),ignorable)
			if "position" in Ray and vT == "0": 
				vectoralDirectionPreset[vT][v]["ray"] = {"position":Ray.position - clientOffset, "length":(Ray.position - clientOffset).y,"offset":(Ray.position - clientOffset).y - vectoralDirectionPreset[vT]["3"]["start"].x, "collided": true}
				if "vT" in vectoralDirectionPreset[vT][v]: vectoralDirectionPreset[vT][v] = {"start": vectoralDirectionPreset[vT][v]["start"]*scale,"end": vectoralDirectionPreset[vT][v]["end"]*scale,"ray": {"position": vectoralDirectionPreset[vT][v]["ray"]["position"]*scale,"length": vectoralDirectionPreset[vT][v]["ray"]["length"],"offset": vectoralDirectionPreset[vT][v]["ray"]["offset"], "collided": true}}
			elif vT == "0": vectoralDirectionPreset[vT][v]["ray"] = {"position":vectoralDirectionPreset[vT][v]["ray"]["position"], "length":vectoralDirectionPreset[vT][v]["ray"]["length"],"offset":vectoralDirectionPreset[vT][v]["ray"]["offset"], "collided": false}
	return vectoralDirectionPreset
