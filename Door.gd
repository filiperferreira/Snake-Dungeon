extends Area2D

export var type = 0
export var door_size = 10

var broken = false

func _ready():
	$UpLabel.set_text(str(door_size))
	$DownLabel.set_text(str(door_size))
	$RightLabel.set_text(str(door_size))
	$LeftLabel.set_text(str(door_size))

func _draw():
	if !broken:
		if type == 0:
			draw_rect(Rect2(Vector2(-24,-24), Vector2(48,48)), Color(1,1,1))
		elif type == 1:
			draw_rect(Rect2(Vector2(-24,-24), Vector2(48,48)), Color(1,0,0))
		elif type == 2:
			draw_rect(Rect2(Vector2(-24,-24), Vector2(48,48)), Color(0,1,0))
		elif type == 3:
			draw_rect(Rect2(Vector2(-24,-24), Vector2(48,48)), Color(0,0,1))

func identify():
	return "door"

func open_door():
	broken = true
	update()
	$UpLabel.set_visible(false)
	$DownLabel.set_visible(false)
	$RightLabel.set_visible(false)
	$LeftLabel.set_visible(false)

func can_pass(snake):
	if broken:
		return true
	elif snake.get_size() >= door_size and snake.get_color(type) >= door_size:
		snake.spend_color(type, door_size)
		open_door()
		return true
	else:
		print("block")
		return false
