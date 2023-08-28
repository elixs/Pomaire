extends MarginContainer

@onready var health_bar: ProgressBar = $VBoxContainer/HBoxContainer/HealthBar

func set_health(value):
	health_bar.value = value
