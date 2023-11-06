extends Area2D

var max_speed = 200
var down_gravity = 400

var initial_direction = Vector2.ZERO
var speed_factor = 1

var velocity = Vector2.ZERO


@onready var sprite_2d = $Sprite2D


func _ready():
	velocity = initial_direction * max_speed * speed_factor


func _physics_process(delta):
	velocity.y += down_gravity * delta
	position += velocity * delta
	sprite_2d.rotation = velocity.angle()
	
