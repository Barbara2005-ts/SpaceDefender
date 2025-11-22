extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var health_label = $HealthLabel

func update_score(value):
	score_label.text = "Очки: " + str(value)
	
func update_health(value):
	health_label.text = "Здоровье: " + str(value)
