extends Node2D

onready var figures = [
	preload("res://scenes/figures/cube/alive_cube.tscn"),
	preload("res://scenes/figures/rectangle/alive_rectangle.tscn"),
	preload("res://scenes/figures/z_left/alive_z_left.tscn"),
	preload("res://scenes/figures/z_right/alive_z_right.tscn"),
	preload("res://scenes/figures/t/alive_t.tscn"),
	preload("res://scenes/figures/l_left/alive_l_left.tscn"),
	preload("res://scenes/figures/l_right/alive_l_right.tscn")
]

func next_figure():
	randomize()
	var num = randi() % len(figures)
	var node = figures[num].instance()
	node.num = num
	node.position = Vector2(640, -20)
	for i in range(randi() % 4):
		node.rotate(0)
	$"figures".add_child(node)
	
func _ready():
	next_figure()
	
func _on_water_body_entered(body):
	if body is KinematicBody2D:
		body.queue_free()
		next_figure()
	elif body is RigidBody2D:
		body.queue_free()


func _on_Timer_timeout():
	next_figure()
