class_name Main
extends Node

@onready var room: Room = $Room
var first_loaded: bool = false

func _ready() -> void:
	load_room(preload("res://main/room/baby_room/baby_room.tscn"), "Root")

func load_room(new_room: PackedScene, origin: String) -> void:
	Ref.player.can_move = false
	
	if first_loaded:
		await Ref.ui.trans_in()
	first_loaded = true
	
	if is_instance_valid(room):
		room.queue_free()
	room = new_room.instantiate()
	add_child(room)
	Ref.player.global_position = room.get_node("Origins").get_node(origin).global_position
	# Ref.player.global_rotation = room.get_node("Origins").get_node(origin).global_rotation
	Ref.player.get_node("StepPlayer").stream = room.step_sound
	
	await Ref.ui.trans_out()
	Ref.player.can_move = true
