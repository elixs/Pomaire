extends Area2D

var speed = 300

@export var dust_scene: PackedScene
@onready var ray_cast_2d = $RayCast2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D):
	
	queue_free()
	
	if ray_cast_2d.is_colliding():
		var pos = ray_cast_2d.get_collision_point()
		var normal = ray_cast_2d.get_collision_normal()
		spawn_dust(pos, normal.angle() + PI / 2)
		

func spawn_dust(pos, rot):
	if not dust_scene:
		return
	var dust = dust_scene.instantiate()
	get_parent().add_child(dust)
	dust.global_position = pos
	dust.global_rotation = rot

