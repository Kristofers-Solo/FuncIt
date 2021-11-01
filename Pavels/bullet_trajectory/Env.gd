extends Node2D

onready var bullet = preload("res://Bullet.tscn")
var time = 0


func trigger():
	var b = bullet.instance()
	add_child(b)


func _process(delta):
	time += delta
	if time > 17:
		queue_free()
