extends BtnHandDrawn

#this class represents a button that you can press to delete a save

class_name BtnDelete


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self.on_self_pressed)

func on_self_pressed()->void:
	$AnimationPlayer.speed_scale = 2.0
	$AnimationPlayer.play("delete_warning",0.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
