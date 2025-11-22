extends Node2D

# Ссылка на сцену врага
@export var enemy_scene: PackedScene
# Интервал спавна (секунды)
var spawn_interval = 2.0

func _ready():
	# Запускаем спавн врагов
	start_spawning()

func start_spawning():
	while true:
		# Ждем указанное время
		await get_tree().create_timer(spawn_interval).timeout
		# Создаем врага
		spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	# Случайная позиция по X вверху экрана
	var x_pos = randf_range(50, get_viewport_rect().size.x - 50)
	enemy.position = Vector2(x_pos, -50)
	# Добавляем врага на сцену
	add_child(enemy)
