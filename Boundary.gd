extends Area2D

const WINDOW_HEIGHT = 512
const WINDOW_WIDTH = 512

const FOOD = preload("res://Food.tscn")

export var food_type = 0

func _ready():
	randomize()
	spawn_food()

func spawn_food():
	var food_x_pos = (randi() % ((WINDOW_WIDTH - 64)/16)) * 16 - (WINDOW_WIDTH - 64)/2
	var food_y_pos = (randi() % ((WINDOW_HEIGHT - 64)/16)) * 16 - (WINDOW_HEIGHT - 64)/2
	
	var new_food = FOOD.instance()
	new_food.set_type(food_type)
	new_food.set_position(Vector2(food_x_pos, food_y_pos))
	new_food.connect("eaten", self, "eat_food")
	new_food.connect("in_wall", self, "respawn_food")
	call_deferred("add_child", new_food)

func respawn_food():
	spawn_food()

func eat_food(food):
	remove_child(food)
	food.queue_free()
	spawn_food()

func _draw():
	draw_rect(Rect2(Vector2(WINDOW_WIDTH/2 - WINDOW_WIDTH - 8, WINDOW_HEIGHT/2 - WINDOW_HEIGHT - 8), Vector2(32, WINDOW_HEIGHT/2 - 16)), Color(0,0,0))
	draw_rect(Rect2(Vector2(WINDOW_WIDTH/2 - 24, WINDOW_HEIGHT/2 - WINDOW_HEIGHT - 8), Vector2(32, WINDOW_HEIGHT/2 - 16)), Color(0,0,0))
	
	draw_rect(Rect2(Vector2(WINDOW_WIDTH/2 - WINDOW_WIDTH - 8, WINDOW_HEIGHT/2 - WINDOW_HEIGHT - 8), Vector2(WINDOW_WIDTH/2 - 16, 32)), Color(0,0,0))
	draw_rect(Rect2(Vector2(24, WINDOW_HEIGHT/2 - WINDOW_HEIGHT - 8), Vector2(WINDOW_WIDTH/2, 32)), Color(0,0,0))
	
	draw_rect(Rect2(Vector2(WINDOW_WIDTH/2 - WINDOW_WIDTH - 8, 24), Vector2(32, WINDOW_HEIGHT/2 - 16)), Color(0,0,0))
	draw_rect(Rect2(Vector2(WINDOW_WIDTH/2 - 24, 24), Vector2(32, WINDOW_HEIGHT/2 - 16)), Color(0,0,0))
	
	draw_rect(Rect2(Vector2(WINDOW_WIDTH/2 - WINDOW_WIDTH - 8, WINDOW_HEIGHT/2 - 24), Vector2(WINDOW_WIDTH/2 - 16, 32)), Color(0,0,0))
	draw_rect(Rect2(Vector2(24, WINDOW_HEIGHT/2 - 24), Vector2(WINDOW_WIDTH/2, 32)), Color(0,0,0))

func identify():
	return "wall"
