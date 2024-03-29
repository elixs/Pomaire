class_name SpawnComponent
extends Marker2D


@export var item_scene: PackedScene
@export var parent_node: Node
@export var use_rotation: bool
@export var local: bool

func spawn():
	if !item_scene:
		printerr("Missing item")
		return
		
	var item = item_scene.instantiate()
	
	var canvas_item = item as CanvasItem
	var node_2d = item as Node2D
	
	if not local and canvas_item:
		canvas_item.top_level = true
	if node_2d and use_rotation:
		node_2d.global_rotation = global_rotation
	if parent_node:
		parent_node.add_child(item)
	else:
		add_child(item)
	if node_2d:
		node_2d.global_position = global_position
		if use_rotation:
			node_2d.global_rotation = global_rotation


func spawn_deferred() -> Node:
	if !item_scene:
		printerr("Missing item")
		return null
		
	var item = item_scene.instantiate()
	var canvas_item = item as CanvasItem
	if not local and canvas_item:
		canvas_item.top_level = true
	return item


func finish_spawn(item):
	if parent_node:
		parent_node.add_child(item)
	else:
		add_child(item)
	var node_2d = item as Node2D
	if node_2d:
		node_2d.global_position = global_position
		if use_rotation:
			node_2d.global_rotation = global_rotation
