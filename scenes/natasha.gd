extends CharacterBody2D

var speed = 100
var acceleration = 500
var gravity = 300

@onready var pivot = $Pivot
@onready var floor_ray_cast = $Pivot/FloorRayCast


func _physics_process(delta):
	velocity.x = move_toward(velocity.x, pivot.scale.x * speed, acceleration * delta)
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor() and not floor_ray_cast.is_colliding():
		pivot.scale.x *= -1
	
	move_and_slide()
