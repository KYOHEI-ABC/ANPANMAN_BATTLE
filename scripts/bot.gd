class_name Bot
extends Node

var character: Character
var rival: Character

func _init(character: Character):
	self.character = character
	self.rival = character.rival

func attack() -> void:
	if character.attack_counts.size() != 0:
		return
	character.attack_counts.append(character.one_attack_duration)
	character.attack_counts.append(character.one_attack_duration)
	character.attack_counts.append(character.one_attack_duration)

	character.frame_count = 1000 * 1000
	character.state = Character.State.ATTACKING
	character.enable_physics = false
		
func process() -> void:
	if randf() < 0.008:
		character.swith_direction()
	elif randf() < 0.008:
		character.jump()
	elif randf() < 0.008:
		attack()
	elif randf() < 0.004:
		character.special()
