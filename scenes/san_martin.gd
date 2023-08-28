extends CharacterBody2D

@export var speed = 200
@export var jump_speed = 200
var acceleration = 1000
var gravity = 300

var health = 100:
	set(value):
		health = value
		if hud:
			hud.set_health(health)
var max_health = 100

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")

@onready var pivot: Node2D = $Pivot
@onready var bullet_spawn: Marker2D = $Pivot/BulletSpawn
@onready var shots_counter: MarginContainer = $CanvasLayer/ShotsCounter
@onready var hud: MarginContainer = $CanvasLayer/HUD


@export var bullet_scene: PackedScene


func _ready() -> void:
	animation_tree.active = true
	hud.set_health(health)


func _physics_process(delta: float) -> void:
	var move_input = Input.get_axis("move_left", "move_right")
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
		Debug.dprint("jump")
	
	
	velocity.x = move_toward(velocity.x, speed * move_input, acceleration * delta)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("fire"):
		fire()
	
	# animation
	
	if move_input != 0:
		pivot.scale.x = sign(move_input)
	
	
	if is_on_floor():
		if abs(velocity.x) > 10 or move_input != 0:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		if velocity.y < 0:
			playback.travel("jump")
		else:
			playback.travel("fall")
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		print("test")


func fire():
	if not bullet_scene:
		return
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = bullet_spawn.global_position
	bullet.rotation = bullet_spawn.global_position.direction_to(get_global_mouse_position()).angle()
	Game.shots += 1

func take_damage():
	if health > 0:
		health = max(health - 10, 0)
