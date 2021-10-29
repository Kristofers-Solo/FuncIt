extends Node2D

onready var bullet = preload("res://Bullet.tscn")
var time = 0

#func _ready():
#	connect("body_entered", self, "_on_Bullet_body_entered")
	


func trigger():
	var b = bullet.instance()
	add_child(b)


func _process(delta):
	time += delta
	if time > 10:
		queue_free()
