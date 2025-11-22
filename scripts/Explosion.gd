extends Node2D

func _ready():
	# Ждем 0.5 секунды и удаляем
	await get_tree().create_timer(0.5).timeout
	queue_free()
