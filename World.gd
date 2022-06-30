extends Node2D

const WINDOW_HEIGHT = 512
const WINDOW_WIDTH = 512

onready var snake = $Snake

var dead = false

func _process(_delta):
	set_snake_size_label(snake.get_size())
	set_red_color_label(snake.get_color(1))
	set_green_color_label(snake.get_color(2))
	set_blue_color_label(snake.get_color(3))
	if dead:
		if Input.is_action_just_pressed("restart"):
			restart_game()
		elif Input.is_action_just_pressed("upgrade"):
			load_upgrade_menu()

func _ready():
	randomize()
	set_snake_size_label(snake.get_size())

signal exp_gain
func _on_Snake_death(experience):
	emit_signal("exp_gain", experience)
	$CanvasLayer/Label.set_visible(true)
	dead = true

func set_stats(stats):
	$Snake.set_starting_size(stats["snake_starting_size"])
	$Snake.set_food_value(0, stats["white_pellet_value"])

signal reload
func restart_game():
	emit_signal("reload")

signal upgrade
func load_upgrade_menu():
	emit_signal("upgrade")

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
