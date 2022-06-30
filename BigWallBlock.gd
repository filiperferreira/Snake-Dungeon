extends Area2D

func _draw():
	draw_rect(Rect2(Vector2(-96/2,-96/2), Vector2(96,96)), Color(0,0,0))

func identify():
	return "wall"
