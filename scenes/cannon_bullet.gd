class_name CannonBullet
extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var max_speed = 300
var acceleration = 1000
var down_gravity = 300
var velocity := Vector2.ZERO


func _ready() -> void:
	velocity = transform.x * max_speed




func _physics_process(delta: float) -> void:
	
	velocity.y += down_gravity * delta
	
	position += velocity * delta
	
	sprite_2d.global_rotation = velocity.angle()
