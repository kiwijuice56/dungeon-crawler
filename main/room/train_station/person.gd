class_name Person
extends Sprite3D

@export var colors: Array[Color]
@onready var speed: float = (0.5 + randf() * 0.3) * (-1 if randf() < 0.5 else 1)

func _ready() -> void:
	var x: float = randf()
	if x < 0.3:
		texture = preload("res://main/room/train_station/person.png")
	elif x < 0.6:
		texture = preload("res://main/room/train_station/person2.png")
	else:
		texture = preload("res://main/room/train_station/person3.png")
	modulate = colors.pick_random()

func _process(delta: float) -> void:
	position.x += speed * delta * 2
	
	if global_position.x < -32 or global_position.x > 32:
		queue_free()
