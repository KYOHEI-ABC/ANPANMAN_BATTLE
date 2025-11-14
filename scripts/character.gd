class_name Character
extends Area2D

class CustomCollisionShape2D extends CollisionShape2D:
	func _init(size: Vector2):
		self.shape = RectangleShape2D.new()
		self.shape.size = size

		var color_rect = ColorRect.new()
		add_child(color_rect)
		color_rect.color = Color.from_hsv(randf(), 1, 1, 0.5)
		color_rect.size = size
		color_rect.position = - size / 2

var velocity: Vector2 = Vector2.ZERO
var size: Vector2 = Vector2.ZERO

func _init(size: Vector2):
	self.size = size
	add_child(CustomCollisionShape2D.new(size))

func process():
	position += velocity

	velocity.y += 5
	velocity.x = clamp(velocity.x * 0.5, -10, 10)

	if position.y + size.y / 2 > 0:
		position.y = - size.y / 2
		velocity.y = 0
	position.x = clamp(position.x, -800 + size.x / 2, 800 - size.x / 2)