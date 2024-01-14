extends DialogComponent

class_name DialogBubble

#animation player for the reveal animation
@export var animation_player : AnimationPlayer
#the timer used to type out our display
@export var typeing_timer : Timer
#label used to display our text
@export var lblRich : RichTextLabel

#the text that we are going to type out into the display
@export_multiline var text : String

#if true we do not hide automatically
@export var auto_display : bool = false

#pointer into the text where we are currently focused
var text_idx : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#we do NOT start off as displayed
	if not self.auto_display: self.undisplay()
	typeing_timer.timeout.connect(self.type_letter)
	animation_player.animation_finished.connect(on_anim_finished)

func displayed()->bool:
	return super.displayed() and typeing_timer.time_left == 0


#types a single letter out into the dialog bubble
#connected to a timer to symulate typing
func type_letter()->void:
	if text_idx >= len(text): 
		typeing_timer.stop()
		if self.displayed(): on_displayed.emit(self) #tell everyone else were done
		return

	#if there is a backslash type what follows,
	#no questions asked
	if text[text_idx] == '\\':
		text_idx += 1
	elif text[text_idx] == '[': #chunk together []
		while text[text_idx] != ']':
			lblRich.text += text[text_idx]
			text_idx += 1
	
	lblRich.text += text[text_idx]
	text_idx += 1

func display()->void:
	#if we get asked to display while typing,
	#just finish typing
	if self.typeing_timer.time_left > 0:
		lblRich.text = self.text
		self.typeing_timer.stop()
		on_displayed.emit(self) #tell the parent that we are displayed
		return
	text_idx = 0
	lblRich.text = ""
	typeing_timer.start() #begin typing
	animation_player.play("apear",1,1,true)
	visible = true

func undisplay()->void:
	text_idx = 0
	typeing_timer.stop()
	#clear out the text
	lblRich.text = ""
	#play the animation backwords so we disapear
	disapear = true #mark that we do not want to appear when the anim finishes
	animation_player.play("apear",1,-2,true)

#indicates that we do not want to be visible after an animation
var disapear = false
func on_anim_finished(anim_name : StringName)->void:
	if disapear:
		self.visible = false
		super.undisplay()
		disapear = false

