extends Sprite2D

@onready var spawn_component := $SpawnComponent as SpawnComponent

@export var bullet: PackedScene

func fire():
	spawn_component.spawn()
