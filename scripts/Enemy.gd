extends Area2D

# Скорость врага
var speed = 150

func _ready():
	# Подключаем сигнал столкновения
	area_entered.connect(_on_area_entered)

func _process(delta):
	# Враг летит ВНИЗ (к игроку)
	position.y += speed * delta
	# Удаляем если улетел за экран
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()

func _on_area_entered(area):
	# Если в врага врезалась пуля
	if area.is_in_group("bullets"):
		# 1. СНАЧАЛА добавляем очки
		get_node("/root/Main").add_score(10)
		
		# 2. СОЗДАЕМ ВЗРЫВ
		var explosion = preload("res://scenes/Explosion.tscn").instantiate()
		explosion.position = position
		get_parent().add_child(explosion)
		
		# 3. УДАЛЯЕМ ПУЛЮ
		area.queue_free()
		
		# 4. УДАЛЯЕМ ВРАГА
		queue_free()
