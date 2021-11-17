extends Node2D

var time = 0
var first_transitioned = false
var transitioned = false

func _ready():
	$FunCitGameLogoDarkTransparent.modulate[3] = 0
	$Fb_Geo_Game.modulate[3] = 0
	pass

func _process(delta):
	time += delta
	if time > 0.01 and $Fb_Geo_Game.modulate[3] < 1.1 and not first_transitioned:
		$Fb_Geo_Game.modulate[3] += 0.01
		time = 0
	if $Fb_Geo_Game.modulate[3] > 1 and time > 2:
		first_transitioned = true
		time = 0
	if first_transitioned and $Fb_Geo_Game.modulate[3] > 0 and time > 0.01:
		$Fb_Geo_Game.modulate[3] -= 0.01
		time = 0
	if time > 0.01 and $FunCitGameLogoDarkTransparent.modulate[3] < 1.1 and first_transitioned and not transitioned:
		$FunCitGameLogoDarkTransparent.modulate[3] += 0.01
		time = 0
	if $FunCitGameLogoDarkTransparent.modulate[3] > 1 and time > 2:
		transitioned = true
		time = 0
	if transitioned and $FunCitGameLogoDarkTransparent.modulate[3] > 0 and time > 0.01:
		$FunCitGameLogoDarkTransparent.modulate[3] -= 0.01
		time = 0
	if transitioned and $FunCitGameLogoDarkTransparent.modulate[3] <= 0:
		#change scene to menu
		pass
