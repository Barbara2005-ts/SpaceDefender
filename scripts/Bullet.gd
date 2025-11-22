extends Area2D

# Скорость пули
var speed = 800

func _process(delta):
	# Пуля летит вверх
	position.y -= speed * delta
	# Удаляем пулю если улетела за экран
	if position.y < -100:
		queue_free()
