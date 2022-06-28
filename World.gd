extends Node2D

const WINDOW_HEIGHT = 512
const WINDOW_WIDTH = 512

const FOOD = preload("res://Food.tscn")
var dead = false

func _process(delta):
	set_snake_size_label($Snake.get_size())
	set_red_color_label($Snake.get_color(1))
	set_green_color_label($Snake.get_color(2))
	set_blue_color_label($Snake.get_color(3))
	if dead and Input.is_action_just_pressed("restart"):
		restart_game()

func _ready():
	randomize()
	set_snake_size_label($Snake.get_size())

func _on_Snake_death():
	$CanvasLayer/Label.set_visible(true)
	dead = true

func restart_game():
	get_tree().reload_current_scene()

func set_snake_size_label(value):
	$CanvasLayer/SnakeSize.text = "Snake size: " + str(value)

func set_red_color_label(value):
	if !$CanvasLayer/RedColor.is_visible() and value != 0:
		$CanvasLayer/RedColor.set_visible(true)
	$CanvasLayer/RedColor.text = "Red: " + str(value)

func set_green_color_label(value):
	if !$CanvasLayer/GreenColor.is_visible() and value != 0:
		$CanvasLayer/GreenColor.set_visible(true)
	$CanvasLayer/GreenColor.text = "Green: " + str(value)

func set_blue_color_label(value):
	if !$CanvasLayer/BlueColor.is_visible() and value != 0:
		$CanvasLayer/BlueColor.set_visible(true)
	$CanvasLayer/BlueColor.text = "Blue: " + str(value)

func _on_Door_cam_move(direction):
	var offset = direction * 512
	$Camera2D.offset += offset

func _on_Snake_move_camera(cam_position):
	$Camera2D.offset = cam_position
