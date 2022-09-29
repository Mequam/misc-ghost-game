extends GPUParticles2D



func _on_DEATHTIMER_timeout():
	queue_free()
