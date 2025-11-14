class_name Main
extends Node

var input_handler: InputHandler = InputHandler.new()

var player: Character = null
var rival: Character = null

func _ready():
	var window = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	
	var node = Node2D.new()
	add_child(node)
	node.position = window / 2

	var ground = ColorRect.new()
	ground.color = Color(0, 0.5, 0)
	ground.size = window
	ground.position.x = - window.x / 2
	node.add_child(ground)

	player = Character.new(Vector2(100, 200))
	player.position = Vector2(-200, -100)
	node.add_child(player)

	rival = Character.new(Vector2(100, 200))
	rival.position = Vector2(200, -100)
	node.add_child(rival)

	add_child(input_handler)

	input_handler.direction.connect(func(direction: Vector2) -> void:
		if direction.y != 0:
			return
		player.velocity += direction * 3
	)
	input_handler.pressed.connect(func() -> void:
		if player.position.y + player.size.y / 2 >= 0:
			player.velocity.y = -50
	)

func _process(delta: float) -> void:
	input_handler.process()
	player.process()
	rival.process()
