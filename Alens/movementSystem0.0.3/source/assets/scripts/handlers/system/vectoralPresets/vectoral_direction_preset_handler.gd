extends Node

var vectoralState = {}

func getState(userState,objectDimensions):
	print(objectDimensions)
	var bSP = 0
	var bHO = objectDimensions["sprite-width"] / 2
	var bVVO = objectDimensions["sprite-height"]
	var spHO = objectDimensions["collider-radius"]
	vectoralState = {
		"0": { # Source (Client) positional rotation vectors
			"0": { # Primary source positional vector
				"start": Vector2(bSP,bSP),
				"end": Vector2(bSP,bVVO),
				"ray": {"position": Vector2(bSP,bVVO),"length": bVVO,"offset":bVVO-spHO, "collided": false},
				"vT": true
			},
			"1": { # Secondary source positional vector (Negative)
				"start": Vector2(bHO,bSP),
				"end": Vector2(bHO,bVVO),
				"ray": {"position": Vector2(bHO,bVVO),"length": bVVO,"offset":bVVO-spHO, "collided": false},
				"vT": true
			},
			"2": { # Secondary source positional vector (Positive)
				"start": Vector2(-bHO,bSP),
				"end": Vector2(-bHO,bVVO),
				"ray": {"position": Vector2(-bHO,bVVO),"length": bVVO,"offset":bVVO-spHO, "collided": false},
				"vT": true
			},
			"3": { # Secondary source positional vector (Negative) [R]
				"start": Vector2(spHO,bSP),
				"end": Vector2(spHO,bVVO),
				"ray": {"position": Vector2(spHO,bVVO),"length": bVVO,"offset":bVVO-spHO, "collided": false},
				"vT": true
			},
			"4": { # Secondary source positional vector (Positive) [R]
				"start": Vector2(-spHO,bSP),
				"end": Vector2(-spHO,bVVO),
				"ray": {"position": Vector2(-spHO,bVVO),"length": bVVO,"offset":bVVO-spHO, "collided": false},
				"vT": true
			}
		},
		"1": { # Source (Client) force vectors
			"0": {
				"start": Vector2(0,0),
				"end": Vector2(0,0)
			},
			"1": {
				"start": Vector2(0,0),
				"end": Vector2(0,0)
			},
			"2": {
				"start": Vector2(0,0),
				"end": Vector2(0,0)
			},
			"3": {
				"start": Vector2(0,0),
				"end": Vector2(0,0)
			}
		},
		"2": { # Source (Client) positional vectors
			"0": {
				"start": Vector2(0,0),
				"end": Vector2(0,0)
			}
		}
	}
	return vectoralState
