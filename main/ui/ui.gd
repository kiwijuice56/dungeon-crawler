class_name UI
extends CanvasLayer

var idx: int = 0
var selecting: bool = false
var options_len: int = 3

signal accepted(choice)

func _input(event: InputEvent) -> void:
	var old_idx: int = idx
	
	if event.is_action_pressed("ui_accept"):
		%AcceptPlayer.playing = true
		accepted.emit(idx)
	if event.is_action_pressed("up", false):
		idx -= 1
	if event.is_action_pressed("down", false):
		idx += 1
	
	if idx < 0:
		idx += options_len
	if idx >= options_len:
		idx = options_len - idx
	
	if selecting and idx != old_idx:
		%SelectPlayer.playing = true
		%VBoxContainer.get_child(old_idx).text = %VBoxContainer.get_child(old_idx).text.substr(2)
		%VBoxContainer.get_child(idx).text = "> " + %VBoxContainer.get_child(idx).text

func show_text(text: String, accept: bool = true, speed: float = 0.03) -> void:
	%Text.visible_characters = 0
	%Text.text = text
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(%Text, "visible_characters", len(text), speed * len(text))
	await tween.finished
	
	if accept:
		set_process_input(true)
		%Accept/AnimationPlayer.play("flicker")
		await accepted
		%Accept/AnimationPlayer.stop()
		%Accept.visible = false
		set_process_input(false)
		%Text.visible_characters = 0

func show_options(options: Array, speed: float = 0.03) -> int:
	for i in range(len(options), 3):
		%VBoxContainer.get_child(i).visible_characters = 0
	for i in range(len(options) - 1, -1, -1):
		var tween: Tween = get_tree().create_tween()
		%VBoxContainer.get_child(i).text = options[i]
		%VBoxContainer.get_child(i).visible_characters = 0
		tween.tween_property(%VBoxContainer.get_child(i), "visible_characters", len(options[i]), speed * len(options[i]))
		await tween.finished
		%VBoxContainer.get_child(i).visible_characters = -1
	options_len = len(options)
	idx = 0
	selecting = true
	%VBoxContainer.get_child(idx).text = "> " + %VBoxContainer.get_child(idx).text
	set_process_input(true)
	var out: int = await accepted
	for i in range(0, 3):
		%VBoxContainer.get_child(i).visible_characters = 0
	%Text.visible_characters = 0
	
	set_process_input(false)
	selecting = false
	
	return out
