extends KinematicBody2D

onready var env = preload("res://Env.tscn")
export var speed = 400
var movement = Vector2(0, 0)

func shoot():
	var b = env.instance()
	get_parent().add_child(b)
	b.global_transform = $Gun.global_transform
	
func get_input():
	movement = Vector2()
	if Input.is_action_pressed("ui_right"):
		movement.x += 10
	if Input.is_action_pressed("ui_left"):
		movement.x -= 10
	if Input.is_action_pressed("ui_down"):
		movement.y += 10
	if Input.is_action_pressed("ui_up"):
		movement.y -= 10
	if Input.is_action_pressed("shoot"):
		shoot()
		
func _physics_process(delta):
	get_input()
	position += movement.normalized() * speed * delta
