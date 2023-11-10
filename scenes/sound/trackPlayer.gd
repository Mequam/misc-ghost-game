extends Node2D

signal finished_measure
signal finished_beat

var flags : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.playing = true

func on_tween_end():
	$AudioStreamPlayer.playing = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("JUMP"):
		var tween = get_tree().create_tween()
		tween.tween_property($AudioStreamPlayer,"volume_db",-10,1)
		tween.tween_callback(on_tween_end)
