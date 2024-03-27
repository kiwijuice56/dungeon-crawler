class_name ViewportSquisher
extends SubViewport

func _ready() -> void:
	get_parent().resized.connect(_on_resized)

func _on_resized() -> void:
	var ratio: float = get_viewport().get_window().size.y / 256.0
	size_2d_override.x = get_viewport().get_window().size.x / ratio
