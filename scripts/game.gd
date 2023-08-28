extends Node

signal shots_changed

var shots = 0:
	set(value):
		shots = value
		shots_changed.emit()
