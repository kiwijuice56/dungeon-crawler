class_name Teleporter
extends Node3D

@export var target: PackedScene
@export var origin: String

func _ready() -> void:
	$Area3D.area_entered.connect(_on_player_entered)

func _on_player_entered(area: Area3D) -> void:
	Ref.player.get_node("TeleportPlayer").playing = true
	Ref.main.load_room(target, origin)
