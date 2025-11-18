class_name InputController
extends Node2D

var area: Rect2
var pressed_position: Vector2 = Vector2.ZERO
var relative_position: Vector2 = Vector2.ZERO

signal pressed()
signal released()
signal drag(direction: Vector2)

func _init():
	var window = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))

	position = - window / 2

	area = Rect2(Vector2.ZERO, window)
	area.size.x = window.x * 0.8

func _input(input_event: InputEvent) -> void:
	if input_event is InputEventScreenTouch:
		if area.has_point(input_event.position):
			if input_event.pressed:
				pressed_position = input_event.position
				# emit_signal("pressed")
			else:
				emit_signal("released")
			relative_position = Vector2.ZERO
		elif input_event.pressed:
			emit_signal("pressed")


	elif input_event is InputEventScreenDrag:
		if area.has_point(input_event.position):
			relative_position = input_event.position - pressed_position
			if relative_position.y > 64:
				pressed_position.y = input_event.position.y
				emit_signal("drag", Vector2(0, 1))
			elif relative_position.y < -64:
				pressed_position.y = input_event.position.y
				emit_signal("drag", Vector2(0, -1))

func process() -> void:
	if relative_position.x > 8:
		emit_signal("drag", Vector2(1, 0))
	elif relative_position.x < -8:
		emit_signal("drag", Vector2(-1, 0))