extends Area2D

@export var summon_name : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.summon_name in GameLoader.game_data.unlocked_summons:
		self.queue_free()
	self.body_entered.connect(self.on_body_entered)
	$AnimationPlayer.play("idle")

func on_body_entered(body)->void:
	GameLoader.game_data.unlock_summon(self.summon_name)
	self.queue_free()
