extends CharacterBody2D

@onready var animation_tree = $AnimationTree

var move_inputs = []

func _physics_process(delta):
	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(300 * move_input, 1000 * delta)
	if move_input:
		move_inputs.push_back(move_input)
		if move_inputs.size() > 10:
			move_inputs.pop_front()
		animation_tree.set("parameters/move/blend_position", move_inputs[0])
	else:
		if !move_inputs.is_empty():
			move_inputs.clear()
	move_and_slide()
