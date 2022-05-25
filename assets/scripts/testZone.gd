extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$KinematicBody2D.velocity = Vector2(1,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
