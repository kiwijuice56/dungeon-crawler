extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(summon)

func summon() -> void:
	var person: Person =  preload("res://main/room/train_station/person.tscn").instantiate()
	add_child(person)
	person.position.z += 1.7 * (randf() - 0.5)
	$Timer.start(randf() + 0.2)
