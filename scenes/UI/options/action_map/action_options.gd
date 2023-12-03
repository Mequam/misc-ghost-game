extends Control

#reference to a control scene that can be used to re map
#and display controls
@export var actionReMapper : PackedScene
#contains each of the remapper nodes
@export var reMapperContainer : Control 
#padding for the remapper list, used to set the minimum size for the control
@export var padding : Control

@export var action_renamer : InputNamer

#creates a section of input re map controlls in the input remapper container
#returns the number of inputs added in that section for convinence
#note the filter is used to determine witch inputs are placed into the section 
func add_section(header : String, filter : Callable = func(action_name) : return true)->void:

	var lblSectionHeading = Label.new()
	lblSectionHeading.text = header
	
	reMapperContainer.add_child(lblSectionHeading)

	for act_name in InputMap.get_actions():
		if not filter.call(act_name): continue

		var re_mapper = actionReMapper.instantiate()
		re_mapper.set_action(act_name,self.action_renamer)

		reMapperContainer.add_child(re_mapper)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	#note this might need to change based on platform,
	#looking at you mac os >_>
	self.add_section("gameplay controls",
							func (x): return x.split("_")[0] != "ui")

	self.add_section("ui controls",
							func (x): return x.split("_")[0] == "ui" and not x.contains("macos"))

	padding.custom_minimum_size = reMapperContainer.size * Vector2(1,reMapperContainer.get_child_count()/5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
