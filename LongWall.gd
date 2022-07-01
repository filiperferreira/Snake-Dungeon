extends Area2D

func _draw():
	draw_rect(Rect2(Vector2(-48/2,-144/2), Vector2(48,144)), Color(0,0,0))

func identify():
	return "wall"
