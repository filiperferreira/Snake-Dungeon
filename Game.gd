extends Node2D

const WORLD = preload("res://World2.tscn")
const UPGRADE_MENU = preload("res://BuyMenu.tscn")

var experience = 0
func add_to_exp(value):
	experience += value
var stats = {"snake_starting_size": 5, "white_pellet_value": 1}

var menu
var world
func _ready():
	load_world(experience, stats)

func load_upgrade_menu():
	remove_child(world)
	world.queue_free()
	menu = UPGRADE_MENU.instance()
	menu.connect("world", self, "load_world")
	menu.setup_menu(experience, stats)
	add_child(menu)

func load_world(cur_exp, cur_stats):
	experience = cur_exp
	stats = cur_stats
	if menu != null:
		remove_child(menu)
		menu.queue_free()
		menu = null
	world = WORLD.instance()
	world.connect("upgrade", self, "load_upgrade_menu")
	world.connect("reload", self, "reload_world")
	world.connect("exp_gain", self, "add_to_exp")
	world.set_stats(stats)
	add_child(world)

func reload_world():
	remove_child(world)
	world.queue_free()
	load_world(experience, stats)
