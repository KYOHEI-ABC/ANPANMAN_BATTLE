class_name Baikin
extends Character

func _init() -> void:
	attack_infos[3] = Attack.Info.new([8, 8, 32], Vector2(50, 0), Vector2(100, 100), 30, Vector2(16, -32), 32, 32)
	super._init(Vector2(100, 150))


class BaikinModel extends Model:
	pass