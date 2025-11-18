class_name Character
extends Area2D

var id: int
var model: Model
var size: Vector2
var direction: int = 1

var velocity: Vector2 = Vector2.ZERO

var rival: Character

var is_walking: bool = false

func _init(id: int, size: Vector2):
	self.id = id
	self.size = size
	add_child(Main.CustomCollisionShape2D.new(size))
	model = Model.new(self)
	add_child(model)

func jump() -> void:
	if on_ground():
		velocity.y = -30
		position.y += velocity.y

func walk(walk_direction: int) -> void:
	if walk_direction == 0:
		is_walking = false
	else:
		is_walking = true
		position.x += walk_direction * 8

func on_ground() -> bool:
	return position.y + size.y / 2 >= 0

func process():
	if position.x < rival.position.x:
		direction = 1
	else:
		direction = -1


	if on_ground():
		position.y = - size.y / 2
		velocity.y = 0
	else:
		position.y += velocity.y
		velocity.y += 2

	position.x = clamp(position.x, -800, 800)

	model.process()
