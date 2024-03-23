extends Sprite3D


func _ready() -> void:
	$Timer.timeout.connect(flicker)
	$Timer.start(3.0 + 6.0 * randf())

func flicker() -> void:
	visible = false
	var e: float = $OmniLight3D.light_energy
	$OmniLight3D.light_energy = 0
	await get_tree().create_timer(0.2).timeout
	$OmniLight3D.light_energy = e
	visible = true
	$Timer.start(3.0 + 6.0 * randf())
