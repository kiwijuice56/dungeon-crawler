class_name Player
extends Node3D

var STEP: float = 1.0
var TURN_SPEED: float = 0.32
var MOVE_SPEED: float = 0.25
var ROLL: float = 0.04

var INPUT: Array[String] = ["up", "down", "left", "right", "turn_left", "turn_right"]
var DIR: Dictionary = {"up": Vector3(0, 0, -1), "down": Vector3(0, 0, 1), "left": Vector3(-1, 0, 0), "right": Vector3(1, 0, 0)}

var queued_input: String = ""
var angle: float = 0
var roll: float = 0

var tween: Tween
var roll_tween: Tween

var can_move: bool = true

func _process(delta: float) -> void:
	%Camera3D.rotation.z = lerp(%Camera3D.rotation.z, roll, delta * 12)
	var input: String = ""
	
	if is_instance_valid(tween):
		for inp in INPUT:
			if Input.is_action_just_pressed(inp):
				queued_input = inp
	else:
		if queued_input != "":
			input = queued_input
			queued_input = ""
		else:
			for inp in INPUT:
				if Input.is_action_pressed(inp):
					input = inp
	
	if input == "" or not can_move or is_instance_valid(tween):
		return
	
	roll = 0
	
	if input in DIR:
		move(input)
		
	if input in ["turn_left", "turn_right"]:
		var mult: float = -1 if input == "turn_right" else 1
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
