class_name Anpan
extends Character

func _init() -> void:
	super._init(Vector2(100, 150))
	
func unique_process(attack: Attack) -> void:
	if state == State.SPECIAL:
		if attack.is_preparing():
			velocity = Vector2.ZERO
		elif attack.is_active():
			position.x += 12 * direction
			velocity = Vector2.ZERO
	super.unique_process(attack)


class AnpanModel extends Model:
	pass
