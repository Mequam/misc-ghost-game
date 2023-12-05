extends Node

class_name AchievementManager

const A_PATH : String = "achievements"

static func add_achievement(achievement : String)->void:
	if not any_achievement():
		GameLoader.game_data.game_variables.has[A_PATH] = {}
	GameLoader.game_data.game_variables[A_PATH][achievement] = true

static func any_achievement()->bool:
	return GameLoader.game_data.game_variables.has(A_PATH)

static func has_achivement(achievement : String)->bool:
	var data = GameLoader.game_data.game_variables
	return any_achievement() and data[A_PATH].has(achievement) and data[A_PATH][achievement]
