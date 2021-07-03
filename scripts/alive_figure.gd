extends KinematicBody2D

export(float) var speed = 80 # default 80
var alive = true
var num = 0
onready var dead_figures = [
	preload("res://scenes/figures/cube/dead_cube.tscn"),
	preload("res://scenes/figures/rectangle/dead_rectangle.tscn"),
	preload("res://scenes/figures/z_left/dead_z_left.tscn"),
	preload("res://scenes/figures/z_right/dead_z_right.tscn"),
	preload("res://scenes/figures/t/dead_t.tscn"),
	preload("res://scenes/figures/l_left/dead_l_left.tscn"),
	preload("res://scenes/figures/l_right/dead_l_right.tscn")
]
var i = 0

func rotate(side):
	$"ColorRect".visible = not $"ColorRect".visible 
	$"ColorRect2".visible = not $"ColorRect2".visible
	if side: # left
		rotation_degrees -= 90
		if "alive_z" in name or "alive_t" in name or "alive_l" in name:
			match int(round(rotation_degrees)):
				0, 360:
					position.x -= 2 * int(editor_description)
					$"ColorRect2".rect_position.y -= int(editor_description)
				90, -270:
					$"ColorRect2".rect_position.y += int(editor_description)
				180, -180:
					position.x += 2 * int(editor_description)
					$"ColorRect2".rect_position.y += int(editor_description)
				270, -90:
					$"ColorRect2".rect_position.y -= int(editor_description)
		else:
			match int(round(rotation_degrees)):
				0, 360: 
					position.x -= int(editor_description)
				90, -270: 
					position.x -= int(editor_description)
				180, -180:
					position.x += int(editor_description)
				270, -90:
					position.x += int(editor_description)
		$"ColorRect".rect_rotation += 90
		$"ColorRect2".rect_rotation += 90
	else: # right
		rotation_degrees += 90
		if "alive_z" in name or "alive_t" in name or "alive_l" in name:
			match int(round(rotation_degrees)):
				0, 360:
					$"ColorRect2".rect_position.y += int(editor_description)
				90, -270:
					position.x += 2 * int(editor_description)
					$"ColorRect2".rect_position.y += int(editor_description)
				180, -180:
					$"ColorRect2".rect_position.y -= int(editor_description)
				270, -90:
					position.x -= 2 * int(editor_description)
					$"ColorRect2".rect_position.y -= int(editor_description)
		else:
			match int(round(rotation_degrees)):
				0, 360: 
					position.x -= int(editor_description)
				90, -270: 
					position.x += int(editor_description)
				180, -180:
					position.x += int(editor_description)
				270, -90:
					position.x -= int(editor_description)
		$"ColorRect".rect_rotation -= 90
		$"ColorRect2".rect_rotation -= 90
		
func _physics_process(delta):
	i += 1
	var velocity = speed
	if Input.is_action_pressed("ui_down"):
		velocity = speed * 3
	if Input.is_action_pressed("ui_left"):
		if position.x > $"ColorRect".rect_size.x / 2 - int(editor_description) and i % 3 == 0:
			position.x -= 20
	if Input.is_action_pressed("ui_right") and i % 3 == 0:
		if position.x < 1280 - $"ColorRect".rect_size.x / 2 - int(editor_description):
			position.x += 20
	if Input.is_action_just_pressed("rot_left"):
		rotate(1)
	if Input.is_action_just_pressed("rot_right"):
		rotate(0)
	move_and_slide(Vector2(0, velocity * delta * 100), Vector2.UP)


func _on_Area2D_body_entered(body):
	if body != $"." and alive:
		if position.y < 100:
			get_tree().change_scene("res://main.tscn")
		alive = false
		var node = dead_figures[num].instance()
		node.position = position
		node.rotation_degrees = rotation_degrees
		$"..".add_child(node)
		$"../../Timer".start()
		queue_free()
