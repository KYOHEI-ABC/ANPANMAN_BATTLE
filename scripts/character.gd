class_name Character
extends Area2D

var size: Vector2
var velocity: Vector2 = Vector2.ZERO
var direction: int = 1

var attack_counts: Array[int] = []
var attack_area: AttackArea

var frame_count: int = -1

var characters: Array[Character] = []

var model: Model

var hp: int = 100
var jump_power: float = 32.0
var custom_gravity: float = 2.0
var walk_acceleration: float = 2.0
var max_x_velocity: float = 16.0
var velocity_x_decay: float = 0.8
var one_attack_duration: int = 24
var special_duration: int = 60


enum State {
	IDLE,
	ATTACKING,
	SPECIAL,
	FREEZE,
}
var state: State = State.IDLE

var attack_info: AttackArea.AttackInfo = AttackArea.AttackInfo.new(Vector2(50, 0), Vector2(100, 100), 0, Vector2.ZERO, 15, 0, 0)


func _init(characters: Array[Character], size: Vector2):
	self.characters = characters

	self.size = size
	add_child(Main.CustomCollisionShape2D.new(size))

	position.y = - size.y / 2

	match self.get_script():
		Anpan:
			model = Anpan.AnpanModel.new(self)
		Baikin:
			model = Baikin.BaikinModel.new(self)

	add_child(model)


func walk(walk_direction: int) -> void:
	if state != State.IDLE:
		return
	direction = walk_direction
	add_x_velocity(direction * walk_acceleration)

func add_x_velocity(x_velocity: float) -> void:
	velocity.x += x_velocity
	velocity.x = clamp(velocity.x, -max_x_velocity, max_x_velocity)

func is_jumping() -> bool:
	return position.y + size.y / 2 < 0

func jump():
	if state != State.IDLE:
		return
	if is_jumping():
		return
	velocity.y = - jump_power

func attack():
	if state == State.ATTACKING:
		pass
	elif state != State.IDLE:
		return

	if attack_counts.size() >= 3:
		return
	if attack_counts.size() == 0:
		attack_counts.append(one_attack_duration)
		frame_count = 1000 * 1000
		state = State.ATTACKING
		return
	if attack_counts[attack_counts.size() - 1] < one_attack_duration / 2:
		attack_counts.append(one_attack_duration)
		state = State.ATTACKING
		
func attack_process(progress: float, combo_count: int) -> void:
	pass
	
func special():
	if state != State.IDLE:
		return
	state = State.SPECIAL
	frame_count = special_duration

func special_process(progress: float) -> void:
	pass


func process():
	if state == State.ATTACKING:
		for i in range(attack_counts.size()):
			if attack_counts[i] >= 0:
				attack_process(float(one_attack_duration - attack_counts[i]) / one_attack_duration, i + 1)
			attack_counts[i] -= 1
			if attack_counts[i] >= 0:
				break
			frame_count = -1
	elif state == State.SPECIAL:
		special_process(float(special_duration - frame_count) / special_duration)

	frame_count -= 1
	if frame_count < 0:
		if state != State.IDLE:
			idle()

	physics_process()

	clamp_position()

	model.process()

func idle() -> void:
	state = State.IDLE

	velocity = Vector2.ZERO

	attack_counts.clear()

	if attack_area != null:
		attack_area.queue_free()
		attack_area = null

	model.idle()

func physics_process():
	position += velocity

	velocity.x *= velocity_x_decay

	if is_jumping():
		velocity.y += custom_gravity
	else:
		velocity.y = 0
		position.y = - size.y / 2

func clamp_position():
	position.x = clamp(position.x, -800, 800)
	position.y = clamp(position.y, -400, -size.y / 2)


class AttackArea extends Area2D:
	var character: Character
	var attack_info: AttackInfo
	var frame_count: int = 0

	class AttackInfo:
		var position: Vector2
		var size: Vector2
	
		var amount: int = 0
		var vector: Vector2 = Vector2.ZERO

		var existing_count: int = 0
		var stun_count: int = 0
		var hit_stop_count: int = 0

		func _init(position: Vector2, size: Vector2, amount: int, vector: Vector2,
					existing_count: int, stun_count: int, hit_stop_count: int):
			self.position = position
			self.size = size
			self.amount = amount
			self.vector = vector
			self.existing_count = existing_count
			self.stun_count = stun_count
			self.hit_stop_count = hit_stop_count


	func _init(character: Character, attack_info: AttackInfo):
		self.character = character
		self.attack_info = attack_info
		self.position = attack_info.position
		self.position.x = abs(attack_info.position.x) * character.direction
		add_child(Main.CustomCollisionShape2D.new(attack_info.size))
		self.attack_info.vector.x = abs(attack_info.vector.x) * character.direction

	func process() -> void:
		frame_count += 1

		for area in get_overlapping_areas():
			for other_character in attack_info.character.characters:
				if other_character == attack_info.character:
					continue
				if area == other_character:
					pass
