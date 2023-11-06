extends CharacterBody2D

@export var speed = 200
@export var jump_speed = 200
var acceleration = 1000
var gravity = 300
@onready var cannon = %Cannon
@onready var cannon_pivot = $Pivot/CannonPivot

var health = 100:
	set(value):
		health = value
		if hud:
			hud.set_health(health)
var max_health = 100


var current_pickable: Pickable = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")

@onready var pivot: Node2D = $Pivot
@onready var bullet_spawn: Marker2D = $Pivot/BulletSpawn
@onready var shots_counter: MarginContainer = $CanvasLayer/ShotsCounter
@onready var hud: MarginContainer = $CanvasLayer/HUD

@onready var dust_spawn = $DustSpawn

@export var bullet_scene: PackedScene
@export var dust_scene: PackedScene
@onready var sprite_2d = $Pivot/Sprite2D

@onready var pickable_area: PickableArea = $Pivot/PickableArea

@onready var pickable_marker = $Pivot/PickableMarker
@onready var pickable_drop_marker = $Pivot/PickableDropMarker

@onready var cannon: Sprite2D = $Pivot/CannonPivot/Cannon
@onready var cannon_pivot: Node2D = $Pivot/CannonPivot


var was_on_floor = false

func _ready() -> void:
	animation_tree.active = true
	hud.set_health(health)
#	health = guardado


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
	
	if Input.is_action_just_pressed("fire"):
		cannon.charge()
	
	if Input.is_action_just_released("fire"):
		cannon.fire()
	
	if Input.is_action_just_pressed("interact"):
		interact()
	
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
	
	# particles
	if not was_on_floor and is_on_floor():
		spawn_dust()
	was_on_floor = is_on_floor()
	
	cannon_pivot.global_rotation = (get_global_mouse_position() - global_position).angle()


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
	
	var tween = create_tween()
	tween.tween_property(sprite_2d, "scale", Vector2.ONE * 4, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(sprite_2d, "position:y", -19, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(sprite_2d, "scale", Vector2.ONE * 2, 0.1)
	tween.parallel().tween_property(sprite_2d, "position:y", -3, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
func take_damage():
	if health > 0:
		health = max(health - 10, 0)


func spawn_dust():
	if not dust_scene:
		return
	var dust = dust_scene.instantiate()
	add_child(dust)
	dust.global_position = dust_spawn.global_position

func interact():
	var pickable: Pickable = pickable_area.get_pickable()
	if current_pickable:
		current_pickable.drop(get_parent(), pickable_drop_marker.global_position)
		current_pickable = null
	elif pickable:
		current_pickable = pickable
		pickable.pick(pivot, pickable_marker.global_position)

