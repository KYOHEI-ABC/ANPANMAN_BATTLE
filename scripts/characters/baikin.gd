class_name Baikin
extends Character

func _init() -> void:
	attack_infos[3] = Attack.Info.new([4, 24, 8], Vector2(96, 0), Vector2(64, 64), 30, Vector2(32, -32), 20, 20)
	super._init(Vector2(100, 150))

func unique_process(attack: Attack) -> void:
	if state != State.SPECIAL:
		return
	if attack.frame_count == attack.info.counts[2] + attack.info.counts[1]:
		if is_jumping():
			velocity = Vector2(direction * 8, 16)
		else:
			velocity = Vector2(direction * 8, -24)

class BaikinModel extends Model:
	pass