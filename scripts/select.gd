class_name Select extends Node


const SPRITES: Array[Texture2D] = [
	preload("res://assets/a_edited.png"),
	preload("res://assets/b_edited.png"),
	preload("res://assets/a_edited.png"),
	preload("res://assets/a_edited.png"),
	preload("res://assets/a_edited.png"),
	preload("res://assets/a_edited.png"),
	preload("res://assets/a_edited.png"),
	preload("res://assets/a_edited.png"),
]

var sprites: Array[Sprite2D]
var cursor: ColorRect
func _init() -> void:
	var center: Vector2 = Vector2.ZERO
	for i in range(SPRITES.size()):
		sprites.append(Sprite2D.new())
		add_child(sprites.back())
		sprites.back().scale = Vector2(1, 1)
		sprites.back().texture = SPRITES[i]
		sprites.back().position = Vector2(i % 4 * 160, 160 * int(i / 4))
		center += sprites.back().position / SPRITES.size()
	for sprite in sprites:
		sprite.position += Main.WINDOW / 2 - center

	cursor = ColorRect.new()
	add_child(cursor)
	cursor.color = Color.from_hsv(0, 1, 1)
	cursor.size = Vector2(150, 145)
	cursor.position = sprites[0].position - cursor.size / 2
	cursor.z_index = -1

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		var rect: Rect2 = Rect2(cursor.position, cursor.size)
		if rect.has_point(event.position):
			print("selected")
