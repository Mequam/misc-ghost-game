extends VBoxContainer

@export var gg_color_mapper : PackedScene
@export var btn_add_color_map_rule : Button


# Called when the node enters the scene tree for the first time.
func _ready():
	btn_add_color_map_rule.pressed.connect(self.on_btn_add_color_pressed)

func on_btn_add_color_pressed()->void:
	add_child(gg_color_mapper.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
