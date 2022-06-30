extends Node2D

onready var experience_label = $CanvasLayer/MarginContainer/VBoxContainer/CurrentXP
onready var snake_label = $CanvasLayer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/SnakeInitialSizeLabel
onready var snake_button = $CanvasLayer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/SnakeInitialSizeButton
onready var pellet_label = $CanvasLayer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/PelletValueLabel
onready var pellet_button = $CanvasLayer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/PelletValueButton

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		load_world()

signal world
func load_world():
	emit_signal("world", cur_exp, cur_stats)

var cur_exp
var cur_stats
func setup_menu(experience, stats):
	cur_exp = experience
	cur_stats = stats
	$CanvasLayer/MarginContainer/VBoxContainer/CurrentXP.set_text("CURRENT XP: " + str(experience))
	$CanvasLayer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/SnakeInitialSizeLabel.set_text("(Current: " + str(stats["snake_starting_size"]) + ")")
	$CanvasLayer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/SnakeInitialSizeButton.set_text("Buy (Cost: " + str(snake_size_cost(stats["snake_starting_size"])) + " XP)")
	$CanvasLayer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/PelletValueLabel.set_text("(Current: " + str(stats["white_pellet_value"]) + ")")
	$CanvasLayer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/PelletValueButton.set_text("Buy (Cost: " + str(pellet_value_cost(stats["white_pellet_value"])) + " XP)")

func update_menu():
	experience_label.set_text("CURRENT XP: " + str(cur_exp))
	snake_label.set_text("(Current: " + str(cur_stats["snake_starting_size"]) + ")")
	snake_button.set_text("Buy (Cost: " + str(snake_size_cost(cur_stats["snake_starting_size"])) + " XP)")
	pellet_label.set_text("(Current: " + str(cur_stats["white_pellet_value"]) + ")")
	pellet_button.set_text("Buy (Cost: " + str(pellet_value_cost(cur_stats["white_pellet_value"])) + " XP)")

func snake_size_cost(level):
	return round((pow(level-5, 1.2) + 10))

func pellet_value_cost(level):
	return round(100 * pow(level-1, 1.2) + 100)

func _on_SnakeInitialSizeButton_pressed():
	if cur_exp >= snake_size_cost(cur_stats["snake_starting_size"]):
		cur_exp -= snake_size_cost(cur_stats["snake_starting_size"])
		cur_stats["snake_starting_size"] += 1
		update_menu()

func _on_PelletValueButton_pressed():
	if cur_exp >= pellet_value_cost(cur_stats["white_pellet_value"]):
		cur_exp -= pellet_value_cost(cur_stats["white_pellet_value"])
		cur_stats["white_pellet_value"] += 1
		update_menu()
