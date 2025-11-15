class_name Main
extends Node

var input_handler: InputHandler = InputHandler.new()

var player: Character = null
var rival: Character = null

var bot: Bot = null

func _ready():
	RenderingServer.set_default_clear_color(Color.from_hsv(0.5, 1, 0.8))

	var window = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	
	var camera = Camera3D.new()
	add_child(camera)
	var light = DirectionalLight3D.new()
	camera.add_child(light)
	light.shadow_enabled = false
	camera.position = Vector3(0, 0, 8)
	camera.rotation_degrees = Vector3(0, 0, 0)
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = 8
	
	var node = Node2D.new()
	add_child(node)
	node.position = window / 2

	var ground = MeshInstance3D.new()
	ground.mesh = QuadMesh.new()
	ground.mesh.size = Vector2(16, 5.5)
	ground.position = Vector3(0, -2, -1)
	node.add_child(ground)
	ground.material_override = StandardMaterial3D.new()
	ground.material_override.albedo_color = Color(0, 0.5, 0)

	player = Character.new(0, Vector2(100, 150))
	player.position = Vector2(-200, -100)
	node.add_child(player)

	rival = Character.new(1, Vector2(100, 150))
	rival.position = Vector2(200, -100)
	node.add_child(rival)
	rival.direction = -1

	bot = Bot.new(rival, player)
	add_child(bot)

	add_child(input_handler)

	input_handler.direction.connect(func(direction: Vector2) -> void:
		if direction.y != 0:
			return
		player.walk(direction.x)
		
	)
	input_handler.pressed.connect(func(position: Vector2) -> void:
		if position.y < ProjectSettings.get_setting("display/window/size/viewport_height") * 0.5:
			player.jump()
		else:
			player.execute_attack()
	)
