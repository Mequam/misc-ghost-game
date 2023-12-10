extends Control

class_name DialogBubble

@export var animation_player : AnimationPlayer
#represents the next bubbles in the chain, if null we use the next child
@export var next_bubble : DialogBubble
#the timer used to type out our display
@export var typeing_timer : Timer


@export var lblRich : RichTextLabel
#the text that we are going to type out into the display
@export_multiline var text : String

#pointer into the text where we are currently focused
var idx : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	typeing_timer.timeout.connect(self.type_letter)

func type_letter()->void:
	if idx >= len(text): 
		typeing_timer.stop()
		return

	if  text[idx] == '\\':
		idx += 1
	elif text[idx] == '[':
		while text[idx] != ']':
			lblRich.text += text[idx]
			idx += 1
	
	lblRich.text += text[idx]
	idx += 1


func get_next_bubble()->Node:
	if next_bubble != null: return next_bubble
	return get_child(1)

func display_bubble()->void:
	idx = 0
	lblRich.text = ""
	typeing_timer.start() #begin typing
	animation_player.play("apear")
	visible = true

#show the next bubble in the chain, can be
#called from ANY bubble in the chain and still
#allow the next to show
func next()->void:
	if not visible:
		#show the bubble
		display_bubble()
	elif get_next_bubble():
		get_next_bubble().next()


