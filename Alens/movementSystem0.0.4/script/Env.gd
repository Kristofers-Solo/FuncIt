extends Node2D

onready var bullet = preload("res://Bullet.tscn")
var time = 0

func _draw():
	draw_line(Vector2(0, 0), Vector2(1000, 0), 1)

func _process(delta):
	time += delta
	if time > 17:
		queue_free()
