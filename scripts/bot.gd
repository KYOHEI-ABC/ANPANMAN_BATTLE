class_name Bot
extends Node

var player: Character
var rival: Character

var is_chasing: bool = false

func _init(player: Character, rival: Character) -> void:
	self.player = player
	self.rival = rival

func process() -> void:
	if randf() < 0.007:
		rival.jump()

	if abs(rival.position.x - player.position.x) > 600:
		is_chasing = true
	if abs(rival.position.x - player.position.x) < 250:
		is_chasing = false

	if is_chasing:
		rival.is_walking = true
		rival.direction = 1 if player.position.x > rival.position.x else -1
	else:
		rival.is_walking = false
