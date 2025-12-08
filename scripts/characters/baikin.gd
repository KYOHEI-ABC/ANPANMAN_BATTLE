class_name Baikin
extends Character

func _init() -> void:
	attack_infos[3] = Attack.Info.new([8, 2, 16], Vector2(50, 0), Vector2(100, 100), 30, Vector2(64, -64), 32, 8)
	super._init(Vector2(100, 150))

func unique_process(attack: Attack) -> void:
	if state == State.SPECIAL:
		if attack.frame_count == attack.total_frame_count() - attack.info.counts[0]:
			velocity = Vector2(8 * direction, -32)

class BaikinModel extends Model:
	pass