extends Node2D

var arrowMovementGoal = -100
signal zone_entered

func _ready():
	pass

func _process(delta):
	if $TutorialTargetZoneArrow.position.y == -85: arrowMovementGoal = -100
	elif $TutorialTargetZoneArrow.position.y == -100: arrowMovementGoal = -85
	$TutorialTargetZoneArrow.position.y = move_toward($TutorialTargetZoneArrow.position.y, arrowMovementGoal, 0.2)


func _on_tutorialTargetZone_body_entered(body):
	emit_signal("zone_entered")
