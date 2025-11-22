extends Node2D

var score = 0
@onready var hud = $HUD

func _ready():
	# Устанавливаем размер окна
	get_window().size = Vector2i(1152, 648)
	# Центрируем окно
	get_window().position = DisplayServer.screen_get_size() / 2 - get_window().size / 2
	
	# Масштабируем фон под размер экрана
	if has_node("Background"):
		var viewport_size = get_viewport_rect().size
		var bg_texture = $Background.texture
		if bg_texture:
			var bg_size = bg_texture.get_size()
			var scale_x = viewport_size.x / bg_size.x
			var scale_y = viewport_size.y / bg_size.y
			$Background.scale = Vector2(scale_x, scale_y)
	
	# Обновляем HUD
	hud.update_score(score)
	hud.update_health(3)

func add_score(points):
	score += points
	hud.update_score(score)

func update_health(health):
	hud.update_health(health)
