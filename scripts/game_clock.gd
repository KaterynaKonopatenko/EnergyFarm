extends Node 
# GameClock: count in-game time for the whole game
# By default 1 real hour - 1 game hour (time_scale = 1.0)
# Speed buyyons (x2,x5...) will change time_scaler
const START_HOUR := 6         # game start at 6:00
const SECOND_PER_HOUR := 3600.0    # real second in one hour
const ALLOWED_SPEEDS := [1.0,2.0,5.0,10.0]  # speed button values

var time_scale := 1.0    # current speed multiplier
var game_hours := float(START_HOUR)  # total game hours since start

func _process(delta: float) -> void: 
	# delta = real seconds since the last frame 
	# Convert real seconds to game hours, taking speed into account
	game_hours += delta * time_scale / SECOND_PER_HOUR

func set_speed(new_speed: float) -> void:
	# Called by speed buttons. Only allowed values are accepted
	if new_speed in ALLOWED_SPEEDS:
		time_scale = new_speed

func get_time_text() -> String:
	# Return time of day as "HH:MM", for example "06:00"
	var hour := int(game_hours) % 24
	var minute := int((game_hours - floor(game_hours)) * 60.0)
	return "%02d:%02d" % [hour,minute]

 
