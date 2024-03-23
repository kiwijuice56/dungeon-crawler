class_name Player
extends Node3D

var STEP: float = 1.0
var TURN_SPEED: float = 0.32
var MOVE_SPEED: float = 0.25
var ROLL: float = 0.04

var INPUT: Array[String] = ["up", "down", "left", "right", "turn_left", "turn_right"]
var DIR: Dictionary = {"up": Vector3(0, 0, -1), "down": Vector3(0, 0, 1), "left": Vector3(-1, 0, 0), "right": Vector3(1, 0, 0)}

var input_queue: Array[String]
var angle: float = 0
var roll: float = 0

var tween: Tween
var roll_tween: Tween

var can_move: bool = true

func _process(delta: float) -> void:
	if not can_move:
		return
	
	%Camera3D.rotation.z = lerp(%Camera3D.rotation.z, roll, delta * 12)
	
	for inp in INPUT:
		var idx: int = input_queue.find(inp)
		if Input.is_action_just_pressed(inp):
			if idx != -1:
				input_queue.remove_at(idx)
			input_queue.append(inp)
		if not Input.is_action_pressed(inp) and inp in input_queue:
			input_queue.remove_at(idx)
	
	if is_instance_valid(tween):
		return
	
	roll = 0
	
	if len(input_queue) == 0:
		return
	
	var inp: String = input_queue[-1]
	if inp in DIR:
		move(inp)
		
	if inp in ["turn_left", "turn_right"]:
		var mult: float = -1 if inp == "turn_right" else 1
		angle += 1 * mult
		turn()

func turn() -> void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation:y", PI / 2 * angle, TURN_SPEED)
	await tween.finished
	tween = null

func move(inp: String) -> void:
	var dir: Vector3 = DIR[inp].rotated(Vector3(0, 1, 0), PI / 2 * angle)
	
	%RayCast3D.target_position = DIR[inp]
	%RayCast3D.force_raycast_update()
	if %RayCast3D.is_colliding():
		return
	
	%Camera3D/AnimationPlayer.stop()
	%Camera3D/AnimationPlayer.play("bob")
	%StepPlayer.playing = true
	
	if inp == "left":
		roll = ROLL
	if inp == "right":
		roll = -ROLL
	
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", position + dir * STEP, MOVE_SPEED)
	await tween.finished
	tween = null
