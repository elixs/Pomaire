extends Sprite2D

@onready var spawn_component := $SpawnComponent as SpawnComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2

@onready var animation_player = $AnimationPlayer

var charge_time = 0
var max_charge_time = 0.5

var charging = false

var tween: Tween

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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		animation_player.play("load")
		tween = create_tween().set_parallel(true)
		tween.tween_property(gpu_particles_2d.process_material, "initial_velocity_min", 30, animation_player.current_animation_length)
		tween.tween_property(gpu_particles_2d.process_material, "initial_velocity_max", 30, animation_player.current_animation_length)
		tween.tween_property(gpu_particles_2d_2.process_material, "initial_velocity_min", 30, animation_player.current_animation_length)
		tween.tween_property(gpu_particles_2d_2.process_material, "initial_velocity_max", 30, animation_player.current_animation_length)
	if event.is_action_released("fire"):
		var factor = animation_player.current_animation_position / animation_player.current_animation_length
		animation_player.play("fire")
		if tween:
			tween.kill()
		tween = create_tween().set_parallel(true)
		tween.tween_property(gpu_particles_2d.process_material, "initial_velocity_min", 1, 0.1)
		tween.tween_property(gpu_particles_2d.process_material, "initial_velocity_max", 1, 0.1)
		tween.tween_property(gpu_particles_2d_2.process_material, "initial_velocity_min", 1, 0.1)
		tween.tween_property(gpu_particles_2d_2.process_material, "initial_velocity_max", 1, 0.1)
		fire(factor)