extends Area2D

@onready var message = $Message

var launch_speed = 250

var characters_inside: Array[CharacterBody2D] = []

func _ready():
	message.hide()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _input(event):
	if event.is_action_pressed("interact"):
		for body in characters_inside:
			launch_character(body)

func _on_body_entered(body: Node):
	if body is CharacterBody2D:
		characters_inside.append(body)
		if not message.visible:
			message.show()


func _on_body_exited(body: Node):
	characters_inside.erase(body)
	if characters_inside.is_empty():
		message.hide()

func launch_character(character: CharacterBody2D):
	var direction = Vector2(4 * randf_range(-1, 1), randf_range(-1, 0))
	character.velocity = direction * launch_speed
