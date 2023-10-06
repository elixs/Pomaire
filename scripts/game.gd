extends Node

signal shots_changed

var meh = Vector2(13.5, 56.98)

var owo = 12


var shots = 0:
	set(value):
		shots = value
		shots_changed.emit()

func save_game():
#	var file = FileAccess.open_encrypted_with_pass("user://game.save", FileAccess.WRITE, "meh")
	var file = FileAccess.open("user://game.data", FileAccess.WRITE)
#	var data = get_data()
#	var data_string = JSON.stringify(data)
#	file.store_string(data_string)
	file.store_32(shots)
	file.store_16(owo)
	file.store_float(meh.x)
	file.store_float(meh.y)


func load_game():
#	var file = FileAccess.open_encrypted_with_pass("user://game.save", FileAccess.READ, "meh")
	var file = FileAccess.open("user://game.data", FileAccess.READ)
#	var data_string = file.get_as_text()
#	var data = JSON.parse_string(data_string)
#	set_data(data)
	shots = file.get_32()
	owo = file.get_16()
	meh.x = file.get_float()
	meh.y = file.get_float()


func get_data():
	return {
		"shots": shots,
		"meh_x": meh.x,
		"meh_y": meh.y
	}

func set_data(data):
	shots = data.shots
	meh = Vector2(data.meh_x, data.meh_y)

func _input(event):
	if event.is_action_pressed("test"):
		save_game()
	if event.is_action_pressed("test2"):
		load_game()
