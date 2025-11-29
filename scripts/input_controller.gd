class_name InputController
extends Node

signal pressed(position: Vector2)

func _input(input: InputEvent) -> void:
	if input is InputEventKey:
		if input.pressed:
			if input.keycode == KEY_SPACE:
				pressed.emit(Vector2(-9999, 9999))
			if input.keycode == KEY_CTRL:
				pressed.emit(Vector2(-9999, -9999))
			if input.keycode == KEY_ENTER:
				pressed.emit(Vector2(9999, -9999))
			if input.keycode == KEY_SHIFT:
				pressed.emit(Vector2(9999, 9999))
	if input is InputEventScreenTouch:
		if input.pressed:
			pressed.emit(input.position)
