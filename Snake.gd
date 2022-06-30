extends Node2D

const SQUARE_SIZE = 16.0
const AREA_SCRIPT = preload("res://PlayerArea.gd")
const HEAD_SCRIPT = preload("res://HeadArea.gd")

var max_size = 1
var cur_size = 1
var red_count = 0
var snake_array = []
func get_size():
	return max_size
func set_starting_size(starting_size):
	max_size = starting_size
	colors[BLANK] = starting_size

enum {BLANK, RED, GREEN, BLUE}
var colors = {BLANK: max_size, RED: 0, GREEN: 0, BLUE: 0}
func get_color(type):
	return colors[type]

var food_value = {BLANK: 1, RED: 1, GREEN: 1, BLUE: 1}
func set_food_value(type, value):
	food_value[type] = value

func spend_color(type, amount):
	if type != 0:
		colors[type] -= amount
		if type == 1:
			remove_colors(Color(1,0,0), amount)
		elif type == 2:
			remove_colors(Color(0,1,0), amount)
		elif type == 3:
			remove_colors(Color(0,0,1), amount)

var color_stack = []
func remove_colors(color, amount):
	var left = amount
	var i = snake_array.size()
	while left > 0 and i >= 0:
		i -= 1
		if snake_array[i]["color"] == color:
			snake_array[i]["color"] = Color(0.9,0.9,0.9)
			left -= 1
		elif snake_array[i]["color"] != Color(0.9,0.9,0.9):
			color_stack.push_back(snake_array[i]["color"])

func move_colors():
	for i in range(snake_array.size() - 1, 0, -1):
		if snake_array[i]["color"] == Color(0.9,0.9,0.9):
			if snake_array[i-1]["color"] != Color(0.9,0.9,0.9):
				snake_array[i]["color"] = snake_array[i-1]["color"]
				snake_array[i-1]["color"] = Color(0.9,0.9,0.9)

var dead = false

func create_new_collision_area(pos, is_head = false):
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	
	collision.set_shape(RectangleShape2D.new())
	collision.shape.set_extents(Vector2(SQUARE_SIZE/2.0 - 2, SQUARE_SIZE/2.0 - 2))
	collision.set_position(pos)
	
	$Parts.add_child(area)
	if (is_head):
		area.set_script(HEAD_SCRIPT)
		area.connect("area_entered", self, "overlap")
	else:
		area.set_script(AREA_SCRIPT)
	area.add_child(collision)
	
	return collision

func _ready():
	var snake_dict
	var collision = create_new_collision_area(Vector2(0,0), true)
	snake_dict = {"position": Vector2(0,0), "collision": collision, "color": Color(0.9,0.9,0.9)}
	snake_array.push_back(snake_dict)

func pause():
	if Input.is_action_just_pressed("pause"):
		$MoveTimer.set_paused(!$MoveTimer.is_paused())

var input_queue = []
var movement_direction = Vector2(0,0)
func set_movement_direction():
	if Input.is_action_just_pressed("up"):
		if movement_direction != Vector2(0,0):
			input_queue.push_back(Vector2(0,-1))
		else:
			movement_direction = Vector2(0,-1)
	if Input.is_action_just_pressed("down"):
		if movement_direction != Vector2(0,0):
			input_queue.push_back(Vector2(0,1))
		else:
			movement_direction = Vector2(0,1)
	if Input.is_action_just_pressed("left"):
		if movement_direction != Vector2(0,0):
			input_queue.push_back(Vector2(-1,0))
		else:
			movement_direction = Vector2(-1,0)
	if Input.is_action_just_pressed("right"):
		if movement_direction != Vector2(0,0):
			input_queue.push_back(Vector2(1,0))
		else:
			movement_direction = Vector2(1,0)

func _process(_delta):
	if $MoveTimer.is_stopped() and !dead and movement_direction != Vector2(0,0):
		$MoveTimer.start()
	if !$MoveTimer.is_paused():
		set_movement_direction()
	pause()

func _draw():
	for square in snake_array:
		draw_rect(Rect2(square["position"] - Vector2(SQUARE_SIZE/2, SQUARE_SIZE/2), Vector2(SQUARE_SIZE, SQUARE_SIZE)), Color(1,1,1))
		draw_rect(Rect2(square["position"] - Vector2(SQUARE_SIZE/2, SQUARE_SIZE/2) + Vector2(1,1), Vector2(SQUARE_SIZE - 2, SQUARE_SIZE - 2)), square["color"])

#var previous_move
func move():
	while input_queue.size() != 0:
		var next_move = input_queue.pop_front()
		if next_move != movement_direction * -1:
			movement_direction = next_move
			break
#	previous_move = movement_direction
	var previous_snake_part
#	if cur_size > max_size:
#		for i in cur_size - max_size:
#			var piece = snake_array.pop_back()
#			piece["collision"].queue_free()
#		cur_size = max_size
#		var i = max_size
#		while color_stack.size() > 0:
#			i -= 1
#			snake_array[i]["color"] = color_stack.pop_back()
	move_colors()
	for i in cur_size:
		if i == 0:
			previous_snake_part = snake_array[i].duplicate()
			previous_snake_part["collision"] = previous_snake_part["collision"].duplicate()
			snake_array[i]["position"] += movement_direction * SQUARE_SIZE
			snake_array[i]["collision"].position += movement_direction * SQUARE_SIZE
		else:
			var temp = snake_array[i].duplicate()
			temp["collision"] = temp["collision"].duplicate()
			snake_array[i]["position"] = previous_snake_part["position"]
			snake_array[i]["collision"].position = previous_snake_part["collision"].position
			previous_snake_part["collision"].free()
			previous_snake_part = temp
	if cur_size != max_size:
		var collision = create_new_collision_area(previous_snake_part["collision"].position)
		var snake_dict = {"position": previous_snake_part["position"], "collision": collision, "color":Color(0.9,0.9,0.9)}
		snake_array.push_back(snake_dict)
		cur_size += 1
	previous_snake_part["collision"].free()
	update()

signal move_camera
func overlap(area):
	if area.identify() == "wall" or area.identify() == "self":
		die()
	elif area.identify() == "door":
		print("door")
		if area.can_pass(self):
			pass
		else:
			die()
	elif area.identify() == "food":
		print("eat")
		area.get_eaten(self)
	elif area.identify() == "floor":
		emit_signal("move_camera", area.get_global_position())
	else:
		pass

var experience = 0
var exp_multiplier = 0
func set_exp_multiplier(value):
	exp_multiplier = value
func grow(type):
	max_size += food_value[type]
	experience += exp_multiplier

func gain(type):
	if type == 0:
		colors[type] += food_value[type]
	elif sum_of_colors() < max_size:
		var new_color = Color(0.9, 0.9, 0.9)
		if type == 1:
			new_color = Color(1,0,0)
		elif type == 2:
			new_color = Color(0,1,0)
		elif type == 3:
			new_color = Color(0,0,1)
		snake_array[0]["color"] = new_color
		colors[type] += food_value[type]

func sum_of_colors():
	return colors[1] + colors[2] + colors[3]

func remove_door(area):
	if area.identify() == "door":
		pass

signal death
func die():
	print("dead")
	dead = true
	$MoveTimer.stop()
	emit_signal("death", experience)

func _on_MoveTimer_timeout():
	move()
