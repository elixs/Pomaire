extends MarginContainer

@onready var shots_label: Label = $HBoxContainer/Shots

func _ready() -> void:
	_update_shots()
	Game.shots_changed.connect(_update_shots)


func _update_shots():
	shots_label.text = str(Game.shots)
	
