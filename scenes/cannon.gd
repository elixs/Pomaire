extends Sprite2D

@onready var spawn_component := $SpawnComponent as SpawnComponent

@export var bullet: PackedScene

@onready var animation_player = $AnimationPlayer

var charge_time = 0
var max_charge_time = 0.5

var charging = false

func _physics_process(delta):
	if charging:
		charge_time = min(charge_time + delta, max_charge_time)


func charge():
	animation_player.play("charge")
	charging = true

func fire():
	animation_player.play("fire")
	charging = false
	
	var item = spawn_component.spawn_deferred()
	item.initial_direction = global_transform.x
	item.speed_factor = 1 + (charge_time / max_charge_time) * 2
	spawn_component.finish_spawn(item)
	charge_time = 0
