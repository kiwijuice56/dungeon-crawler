class_name Player
extends Node3D

var STEP: float = 1.0
var TURN_SPEED: float = 0.35
var MOVE_SPEED: float = 0.2

var INPUT: Array[String] = ["up", "down", "left", "right", "turn_left", "turn_right"]
var DIR: Dictionary = {"up": Vector3(0, 0, -1), "down": Vector3(0, 0, 1), "left": Vector3(-1, 0, 0), "right": Vector3(1, 0, 0)}

var input_queue: Array[String]
var angle: float = 0

var tween: Tween

func _process(delta: float) -> void:
	for inp in INPUT:
		var idx: int = input_queue.find(inp)
		if Input.is_action_just_pressed(inp):
			if idx != -1:
				input_queue.remove_at(idx)
			input_queue.append(inp)
		if not Input.is_action_pressed(inp) and inp in input_queue:
			input_queue.remove_at(idx)
	if len(input_queue) == 0:
		return
	if is_instance_valid(tween):
		return
	var inp: String = input_queue[-1]
	if inp in DIR:
		move(DIR[inp])
	if inp == "turn_left":
		angle += 1
		turn()
	if inp == "turn_right":
		angle -= 1
		turn()

func turn() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(self, "rotation:y", PI / 2 * angle, TURN_SPEED)
	await tween.finished
	tween = null

func move(relative_dir: Vector3) -> void:
	var dir = relative_dir.rotated(Vector3(0, 1, 0), PI / 2 * angle)
	
	%RayCast3D.target_position = relative_dir
	%RayCast3D.force_raycast_update()
	if %RayCast3D.is_colliding():
		return
	
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", position + dir * STEP, MOVE_SPEED)
	await tween.finished
	tween = null
