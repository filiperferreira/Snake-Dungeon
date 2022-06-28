extends Area2D

var type = 0
func set_type(value):
	type = value
	update()

func _draw():
	if type == 0:
		draw_circle(Vector2(0,0), 8.0, Color(1,1,1))
	elif type == 1:
		draw_circle(Vector2(0,0), 8.0, Color(1,0,0))
	elif type == 2:
		draw_circle(Vector2(0,0), 8.0, Color(0,1,0))
	elif type == 3:
		draw_circle(Vector2(0,0), 8.0, Color(0,0,1))

func identify():
	return "food"

signal eaten
func get_eaten(snake):
	snake.gain(type)
	if type == 0:
		snake.grow()
	emit_signal("eaten", self)

signal in_wall
func _on_Food_area_entered(area):
	if area.identify() == "wall" or area.identify() == "self":
		emit_signal("in_wall")
		queue_free()
