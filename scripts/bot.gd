class_name Bot
extends Node

var character: Character
var rival: Character

var is_chasing: bool = false

func _init(character: Character, rival: Character) -> void:
	self.character = character
	self.rival = rival

func attack() -> void:
	character.attack()
func special() -> void:
	character.special()

func process() -> void:
	if character.state == Character.State.ATTACKING:
		attack()

	var distance = rival.position.x - character.position.x
	if abs(distance) > 500:
		is_chasing = true
	elif abs(distance) < 200:
		is_chasing = false

	if is_chasing:
		character.walk(character.direction)

	if character.state == Character.State.IDLE:
		if randf() < 0.08:
			if randf() < 0.3:
				attack()
			else:
				special()

	if randf() < 0.08:
		character.jump()
