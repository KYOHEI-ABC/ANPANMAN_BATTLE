class_name Anpan
extends Character

func _init():
	super._init(Vector2(100, 150))

func unique_process(is_special: bool, combo_count: int, progress: float):
	if is_special:
		if progress == 0:
			model.punch(2.0)
			if attack_areas.size() == 0:
				attack_areas.append(AttackArea.new(Vector2(100, 100)))
				add_child(attack_areas[-1])
				attack_areas[-1].position.x = direction * 100
				attack_areas[-1].vector = Vector2(direction * 32, -32)
		elif progress == 1.0:
			if attack_areas.size() > 0:
				attack_areas[-1].queue_free()
				attack_areas.clear()
		position.x += direction * 8

	else:
		if progress == 0:
			model.punch(1 + (combo_count - 1) * 0.5)
		elif progress < 0.5:
			pass
		elif progress < 1.0:
			if attack_areas.size() == 0:
				attack_areas.append(AttackArea.new(Vector2(100, 100)))
				add_child(attack_areas[-1])
				attack_areas[-1].position.x = direction * 100
				attack_areas[-1].vector = Vector2(direction * 2, -8 * combo_count)
		elif progress == 1.0:
			if attack_areas.size() > 0:
				attack_areas[-1].queue_free()
				attack_areas.clear()

	if combo_count == 3:
		if attack_areas.size() > 0:
			attack_areas[-1].position.x += direction * 16

	for area in attack_areas:
		area.process(self)
		
class AnpanModel extends Model:
	pass
