class_name Character
extends Area2D

var id: int
var model: Model
var size: Vector2
var direction: int = 1

var velocity: Vector2 = Vector2.ZERO

var rival: Character

var attack: Attack

var stun_count: int = 0

var jump_count: int = 0

func _init(id: int, size: Vector2):
	self.id = id
	self.size = size
	add_child(Main.CustomCollisionShape2D.new(size))
	model = Model.new(self)
	add_child(model)


func attack_action() -> void:
	if stun_count > 0:
		return
	if attack == null:
		attack = Attack.Normal.new(self)
		add_child(attack)

func damage(vector: Vector2) -> void:
	stun_count = 15
	velocity += vector
	if attack != null:
		attack.queue_free()
		attack = null

func jump() -> void:
	if stun_count > 0:
		return
	if jump_count == 0:
		jump_count += 1
		velocity.y = -15

func walk(_walk_direction: int) -> void:
	if stun_count > 0:
		return
	position.x += _walk_direction * 8

func on_ground() -> bool:
	return position.y + size.y / 2 >= 0

func process():
	if stun_count > 0:
		stun_count -= 1

	if on_ground():
		jump_count = 0

	if attack != null:
		if not attack.process():
			attack.queue_free()
			attack = null

	if position.x < rival.position.x:
		direction = 1
	else:
		direction = -1

	position.x += velocity.x
	velocity.x *= 0.9

	position.y += velocity.y
	velocity.y += 0.5


	position.x = clamp(position.x, -800, 800)
	if on_ground():
		position.y = - size.y / 2
		velocity.y = 0

	model.process()
