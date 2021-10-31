extends Node

var VDIR = {}

func update(userState, userDimensions):
	var bSP = 0
	var bHO = userDimensions["sprite"]["width"] / 2 * userDimensions["sprite"]["scale"].x
	var bVVO = userDimensions["sprite"]["height"] * userDimensions["sprite"]["scale"].y
	var spHO = userDimensions["collider"]["radius"]
	VDIR = {
		"0": {
			"0": {
				"start": Vector2(bSP, bSP),
				"end": Vector2(bSP, bVVO),
				"ray": {"position": Vector2(bSP, bVVO), "length": bVVO, "offset": bVVO - spHO, "collided": false}
			},
			"1": {
				"start": Vector2(spHO, bSP),
				"end": Vector2(spHO, bVVO),
				"ray": {"position": Vector2(spHO, bVVO), "length": bVVO, "offset": bVVO - spHO, "collided": false}
			},
			"2": {
				"start": Vector2(-spHO, bSP),
				"end": Vector2(-spHO, bVVO),
				"ray": {"position": Vector2(-spHO, bVVO), "length": bVVO, "offset": bVVO - spHO, "collided": false}
			}
		},
		"1": {
			"0": {
				"start": Vector2(bSP, bSP) + userState["global_position"],
				"end": Vector2(bSP, bVVO) + userState["global_position"],
				"ray": {"position": Vector2(bSP, bVVO) + userState["global_position"], "length": bVVO, "offset": bVVO - spHO, "collided": false}
			},
			"1": {
				"start": Vector2(spHO, bSP) + userState["global_position"],
				"end": Vector2(spHO, bVVO) + userState["global_position"],
				"ray": {"position": Vector2(spHO, bVVO) + userState["global_position"], "length": bVVO, "offset": bVVO - spHO, "collided": false}
			},
			"2": {
				"start": Vector2(-spHO, bSP) + userState["global_position"],
				"end": Vector2(-spHO, bVVO) + userState["global_position"],
				"ray": {"position": Vector2(-spHO, bVVO) + userState["global_position"], "length": bVVO, "offset": bVVO - spHO, "collided": false}
			}
		}
	}
	return VDIR
