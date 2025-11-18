class_name InputController
extends Node2D

var drag_area: Rect2
var drag_start_position: Vector2 = Vector2.ZERO
var relative_position: Vector2 = Vector2.ZERO

signal pressed()
signal drag(direction: Vector2)

func _init():
	var window = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	position = - window / 2
	drag_area = Rect2(Vector2.ZERO, window)
	drag_area.size.x = window.x * 0.8

func _input(input_event: InputEvent) -> void:
	if input_event is InputEventKey and input_event.pressed:
		if input_event.keycode == KEY_SPACE or input_event.keycode == KEY_ENTER:
			emit_signal("pressed")
	if input_event is InputEventScreenTouch and input_event.pressed:
		if not drag_area.has_point(input_event.position):
			emit_signal("pressed")

	if input_event is InputEventScreenTouch:
		if drag_area.has_point(input_event.position):
			if input_event.pressed:
				drag_start_position = input_event.position
			relative_position = Vector2.ZERO

	elif input_event is InputEventScreenDrag:
		if drag_area.has_point(input_event.position):
			relative_position = input_event.position - drag_start_position
			if relative_position.y < -64:
				drag_start_position.y = input_event.position.y
				emit_signal("drag", Vector2(0, -1))

func process() -> void:
	if relative_position.x > 8:
		emit_signal("drag", Vector2(1, 0))
	elif relative_position.x < -8:
		emit_signal("drag", Vector2(-1, 0))