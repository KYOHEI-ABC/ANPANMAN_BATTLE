class_name Attack
extends Area2D
var character: Character
var frame_count: int = 0

func _init(character: Character):
	self.character = character

func process() -> bool:
	frame_count += 1

	if frame_count == 20:
		add_child(Main.CustomCollisionShape2D.new(Vector2(100, 150)))
		position.x = character.size.x * 0.5 * character.direction

	if frame_count > 20:
		for area in get_overlapping_areas():
			if area is Character and area != character:
				area.velocity.x = 15 * character.direction
				area.velocity.y = -10

	return frame_count < 60