extends RespawnLamp

class_name CanLamp

var forward : bool = true

func _ready()->void:
	super._ready()
	var s = get_sprite2D()
	s.play("default")
	s.frame_changed.connect(on_frame_changed)
	s.animation_looped.connect(on_anim_looped)



func on_anim_looped()->void:
	forward = not forward

func on_frame_changed()->void:
	#if forward:
	$pivot.rotation_degrees = remap(float(get_sprite2D().frame),2,3,5,-5)
	#else:
	#	$pivot.rotation_degrees = remap(float(get_sprite2D().frame),2,3,-5,5)
