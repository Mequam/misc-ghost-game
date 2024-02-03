extends Node

#simple system that takes a screenshot ah dur

func screenshot()->void:
	print_debug("making a screenshot")
	if not DirAccess.dir_exists_absolute('user://screenshots'):
		DirAccess.make_dir_absolute('user://screenshots')
	var time_string : String = Time.get_date_string_from_system() + "_" + Time.get_time_string_from_system()
	time_string = time_string.replace(":","-")
	print_debug("constructing the screenshot!")
	self.get_viewport().get_texture().get_image().save_png("user://screenshots/screenshot_%s.png" % [time_string])
