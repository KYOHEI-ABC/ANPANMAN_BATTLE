class_name Bot
extends Node

var character: Character
var bot_attack: BotAttack

var is_chasing: bool = false
var cool_count: int = 0

func _init(character: Character) -> void:
	self.character = character

func process() -> void:
	if cool_count > 0:
		cool_count -= 1
		return

	if bot_attack == null and cool_count == 0:
		bot_attack = BotAttack.new(self)
		character.add_child(bot_attack)
	else:
		if not bot_attack.process():
			bot_attack.queue_free()
			bot_attack = null
			cool_count = randi_range(40, 60)
	
	var position_diff_x = abs(character.rival.position.x - character.position.x)
	if position_diff_x > 600:
		is_chasing = true
	elif position_diff_x < 125:
		is_chasing = false

	if is_chasing:
		if character.position.x < character.rival.position.x:
			character.walk(1)
		else:
			character.walk(-1)

class BotAttack extends Node:
	var bot: Bot
	var frame_count: int = randi_range(10, 50)
	func _init(bot: Bot):
		self.bot = bot
		bot.character.jump()
		bot.is_chasing = true
	
	func process() -> bool:
		if frame_count == 0 and bot.character.attack == null:
			return false

		if frame_count > 0:
			frame_count -= 1

		if frame_count == 0:
			bot.character.attack_action()

		return true
