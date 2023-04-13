extends Spatial

func shoot():
	show()
	$Timer.start()

func _on_Timer_timeout():
	hide() # Replace with function body.
