extends Node

var vectoralState = {}

func getState(userState):
	vectoralState = {
		"0": { # Source (Client) positional rotation vectors
			"0": { # Primary source positional vector
				"start": Vector2(0,0),
				"end": Vector2(0,0),
				"ray": Vector2(0,0)
			},
			"1": { # Secondary source positional vector (Negative)
				"start": Vector2(0,0),
				"end": Vector2(0,0),
				"ray": Vector2(0,0)
			},
			"2": { # Secondary source positional vector (Positive)
				"start": Vector2(0,0),
				"end": Vector2(0,0),
				"ray": Vector2(0,0)
			},
			"3": { # Secondary source positional vector (Negative) [R]
				"start": Vector2(0,0),
				"end": Vector2(0,0),
				"ray": Vector2(0,0)
			},
			"4": { # Secondary source positional vector (Positive) [R]
				"start": Vector2(0,0),
				"end": Vector2(0,0),
				"ray": Vector2(0,0)
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
