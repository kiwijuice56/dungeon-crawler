class_name Main
extends Node

func _ready() -> void:
	$Player.can_move = false
	await $UI.show_text("Hi. Do I know you? I don't think so.", false)
	match (await $UI.show_options(["yeah...", "no!!!"])):
		0: 
			await $UI.show_text("Hi. Hi. Hi  .  Hi..   Hi. Ohhhh...")
			await $UI.show_text("I remember now!!! What are you   doing here?", false)
			match (await $UI.show_options(["i dont know...", "whats ot to you!!!", "bye"])):
				0:
					await $UI.show_text("oh... okay")
				1:
					pass
				2:
					pass
		1:
			pass
	$Player.can_move = true
