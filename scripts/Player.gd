extends CharacterBody2D

# Скорость движения игрока
var speed = 400
# Ссылка на сцену пули
@export var bullet_scene: PackedScene
# Можно ли стрелять?
var can_shoot = true
# ЗДОРОВЬЕ ИГРОКА
var health = 3

func _ready():
	# Подключаем сигнал столкновения от Hitbox
	$Hitbox.area_entered.connect(_on_area_entered)

func _process(delta):
	# Движение
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	move_and_collide(velocity * delta)
	
	# Ограничиваем позицию границами экрана
	var viewport_size = get_viewport_rect().size
	var sprite_size = $Sprite2D.texture.get_size() * $Sprite2D.scale if $Sprite2D.texture else Vector2(15, 15)
	
	position.x = clamp(position.x, sprite_size.x/2, viewport_size.x - sprite_size.x/2)
	position.y = clamp(position.y, sprite_size.y/2, viewport_size.y - sprite_size.y/2)
	
	# СТРЕЛЬБА - ДОБАВЛЕН ВЫЗОВ ФУНКЦИИ!
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	print("=== ДИАГНОСТИКА СТРЕЛЬБЫ ===")
	
	# 1. Проверка can_shoot
	print("1. can_shoot = ", can_shoot)
	if not can_shoot:
		print("❌ Не могу стрелять - перезарядка")
		return
	
	# 2. Проверка bullet_scene
	print("2. bullet_scene = ", bullet_scene)
	if bullet_scene == null:
		print("❌ bullet_scene не назначен!")
		return
	
	# 3. Создание пули
	print("3. Создаю пулю...")
	var bullet = bullet_scene.instantiate()
	print("   Пуля создана: ", bullet)
	
	# 4. Позиционирование
	bullet.position = position
	print("4. Позиция пули: ", bullet.position)
	print("   Позиция игрока: ", position)
	
	# 5. Добавление на сцену
	print("5. Добавляю пулю на сцену...")
	get_parent().add_child(bullet)
	print("   Пуля добавлена!")
	
	# 6. Визуальная проверка
	print("6. Проверяю спрайт пули...")
	if bullet.has_node("Sprite2D"):
		var sprite = bullet.get_node("Sprite2D")
		print("   Спрайт найден: ", sprite)
		print("   Текстура: ", sprite.texture)
		print("   Scale: ", sprite.scale)
	else:
		print("   ❌ Спрайт не найден!")
	
	print("=== ДИАГНОСТИКА ЗАВЕРШЕНА ===")
	
	# Перезарядка
	can_shoot = false
	await get_tree().create_timer(0.2).timeout
	can_shoot = true

# Функция обработки столкновений
func _on_area_entered(area):
	# Если в игрока врезался враг
	if area.is_in_group("enemies"):
		print("Игрок получил урон!")
		take_damage(1)
		area.queue_free()

# Функция получения урона
func take_damage(damage):
	health -= damage
	# Обновляем HUD через главную сцену
	if get_node_or_null("/root/Main"):
		get_node("/root/Main").update_health(health)
	
	if health <= 0:
		game_over()

func game_over():
	print("Игра окончена!")
	# Временно используем таймер чтобы избежать предупреждения
	await get_tree().create_timer(0.1).timeout
	get_tree().reload_current_scene()
