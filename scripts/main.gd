class_name Main
extends Node

var player: Character
var rival: Character
var bot: Bot
var input_controller: InputController

func _ready():
	camera()
	stage()

	player = Anpan.new()
	add_child(player)
	player.position.x = -200

	rival = Baikin.new()
	add_child(rival)
	rival.position.x = 200
	rival.direction = -1

	player.rival = rival
	rival.rival = player

	bot = Bot.new(rival)
	add_child(bot)

	var window: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	input_controller = InputController.new()
	add_child(input_controller)
	input_controller.pressed.connect(func(position: Vector2):
		if position.x < window.x / 2:
			if position.y < window.y / 2:
				player.jump()
			else:
				player.swith_direction()
		else:
			if position.y < window.y / 2:
				player.special()
			else:
				player.attack()
	)
	
	
func _process(delta: float) -> void:
	player.process()
	rival.process()

	bot.process()

func camera() -> void:
	RenderingServer.set_default_clear_color(Color(0, 0.4, 0.8))

	var camera_3d = Camera3D.new()
	add_child(camera_3d)
	camera_3d.position = Vector3(0, 0, 8)
	camera_3d.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera_3d.size = 8
	var light = DirectionalLight3D.new()
	camera_3d.add_child(light)
	light.shadow_enabled = false

	var camera_2d = Camera2D.new()
	add_child(camera_2d)

func stage() -> void:
	var stage = MeshInstance3D.new()
	stage.mesh = QuadMesh.new()
	stage.mesh.size = Vector2(16, 16)
	stage.position = Vector3(0, -8, -1)
	add_child(stage)
	stage.material_override = StandardMaterial3D.new()
	stage.material_override.albedo_color = Color(0, 0.5, 0)

class CustomCollisionShape2D extends CollisionShape2D:
	func _init(size: Vector2):
		self.shape = RectangleShape2D.new()
		self.shape.size = size

		var color_rect = ColorRect.new()
		add_child(color_rect)
		color_rect.color = Color.from_hsv(randf(), 1, 1, 0.0)
		color_rect.size = size
		color_rect.position = - size / 2
