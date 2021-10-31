extends KinematicBody2D

# Instance of data handlers
var userInputInstance = preload("res://source/assets/scripts/handlers/system/input/user_input_handler.gd").new()
var vectoralDirectionPresetInstance = preload("res://source/assets/scripts/handlers/system/vectoralPresets/vectoral_direction_preset_handler.gd").new()
var userStateInstance = preload("res://source/assets/scripts/handlers/system/state/user_state_handler.gd").new()

# Instance of data processors
var VDIRprocessorInstance = preload("res://source/assets/scripts/processors/VDIR/vectoral_direction_processor.gd").new()
var CRprocessorInstance = preload("res://source/assets/scripts/processors/CR/client_rotation_processor.gd").new()

# Instance of game controllers
var canvasManagerInstance = preload("res://source/assets/scripts/controllers/managers/canvas_manager.gd").new()
var physicsManagerInstance = preload("res://source/assets/scripts/controllers/managers/physics_manager.gd").new()

# Local class variables
var rotationalOffsets = {"0":0,"1":0,"2":0,"3":0,"4":0}
var vectoralDirectionPreset
var userInput
var userState
var VDIR

func _ready():
	set_process(true)
	vectoralDirectionPreset = vectoralDirectionPresetInstance.getState(userStateInstance.update(global_transform.origin),{"sprite-width": $player_sprite_na.texture.get_width(),"sprite-height":$player_sprite_na.texture.get_height(),"collider-radius":$player_collider.get_shape().get_radius()})

func _process(delta):
	# Update data-handler returned states
	userInput = userInputInstance.update()
	userState = userStateInstance.update(global_transform.origin)
	# Send the returned states through processors
	VDIR = VDIRprocessorInstance.process(userState, vectoralDirectionPreset, $player_sprite_na.scale, get_world_2d().direct_space_state,[self])
	# Give the resulting data to game controllers
	physicsManagerInstance.update(userStateInstance)
	physics_process(delta, VDIR)
	if userInput["down"] == true:
		move_and_slide(Vector2(0,75))
	elif userInput["left"] == true:
		move_and_slide(Vector2(-50,0))
	elif userInput["right"] == true:
		move_and_slide(Vector2(50,0))
	elif userInput["debug"] == true:
		userStateInstance.rotateBy(1)
	else:
		$player_sprite.play("idle")
	update()
	print(userState["rotation"])
	pass

func physics_process(delta, VDIR):
	for vectorType in VDIR:
		var vT = str(vectorType)
		for vector in VDIR[vT]:
			var v = str(vector)
			if vT == "0": rotationalOffsets[v] = {"offset":VDIR[vT][v]["ray"]["offset"],"collided":VDIR[vT][v]["ray"]["collided"]}
	CRprocessorInstance.update(rotationalOffsets, userStateInstance, delta)
	rotation_degrees = userState["rotation"]

func _draw():
	for vectorType in vectoralDirectionPreset:
		var vT = str(vectorType)
		for vector in vectoralDirectionPreset[vT]:
			var v = str(vector)
			if vT == "0": draw_line(vectoralDirectionPreset[vT][v]["start"],vectoralDirectionPreset[vT][v]["ray"]["position"],Color(255,255,255),1)
