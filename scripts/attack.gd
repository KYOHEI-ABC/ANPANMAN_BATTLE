class_name Attack
extends Area2D

var character: Character
var frame_count: int = 0

func _init(character: Character):
	self.character = character

class Normal extends Attack:
	func process() -> bool:
		frame_count += 1

		var model = character.model

		if frame_count < 20:
			model.right_arm.rotation_degrees.x = -90
			model.left_arm.rotation_degrees.x = 45
			model.right_leg.rotation_degrees.x = 90
			model.left_leg.rotation_degrees.x = -90

		if frame_count == 20:
			add_child(Main.CustomCollisionShape2D.new(Vector2(100, 150)))
			position.x = character.size.x * 0.5 * character.direction
			model.right_arm.rotation_degrees.x = 90
			model.right_arm.scale = Vector3(2, 2, 2)
			model.left_arm.rotation_degrees.x = -45
			model.right_leg.rotation_degrees.x = -90
			model.left_leg.rotation_degrees.x = 90

		if frame_count > 20:
			for area in get_overlapping_areas():
				if area is Character and area != character:
					area.velocity.x = 15 * character.direction
					area.velocity.y = -10
					Main.PAUSE_COUNT = 1

		return frame_count < 60
