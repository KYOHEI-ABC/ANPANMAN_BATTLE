class_name Baikin
extends Character

func _init() -> void:
	attack_infos[3] = Attack.Info.new([4, 8, 16], Vector2(64, 0), Vector2(64, 64), 30, Vector2(8, -32), 30, 10)
	super._init(Vector2(100, 150))

func unique_process(attack: Attack) -> void:
	if state == State.SPECIAL:
		if attack.frame_count == attack.info.counts[1] + attack.info.counts[2]:
			velocity = Vector2(direction * 8, jump_velocity)
	super.unique_process(attack)

class BaikinModel extends Model:
	pass