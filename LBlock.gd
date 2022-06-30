extends Area2D

func _draw():
	draw_rect(Rect2(Vector2(0,0), Vector2(48,48)), Color(0,0,0))
	draw_rect(Rect2(Vector2(-48,0), Vector2(48,48)), Color(0,0,0))
	draw_rect(Rect2(Vector2(-48,-48), Vector2(48,48)), Color(0,0,0))

func identify():
	return "wall"
