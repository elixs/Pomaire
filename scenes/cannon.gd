extends Sprite2D

@onready var spawn_component := $SpawnComponent as SpawnComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2


var tween: Tween

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

func fire(factor):
	var bullet = spawn_component.spawn_deferred() as CannonBullet
	if bullet:
		bullet.max_speed *= 2 * factor
	spawn_component.finish_spawning(bullet)
