extends Node
## Solar panel: E = P_peak * (G / 1000) * PR * dt (README 4.1)
## Test daylight curve util real weather data is added

const PEAK_KW := 5.0
const PERFORMANCE_RATIO := 0.8
const SUNRISE := 6.0
const SUNSET := 20.0
const MAX_IRRADIANCE := 1000.0

func _process(delta: float) -> void:
	var hour := delta * GameClock.time_scale / 3600.0
	var hour_of_day := fmod(GameClock.game_hours, 24.0)
	var g := get_irradiance(hour_of_day)
	var power_kw := PEAK_KW * (g / 1000.0) * PERFORMANCE_RATIO
	Economy.energy_kwh += power_kw * hour * Economy.solar_panels
	
func get_irradiance(hour: float) -> float:
	if hour < SUNRISE or hour > SUNSET:
		return 0.0
	var t := (hour - SUNRISE) / (SUNSET - SUNRISE)
	return MAX_IRRADIANCE * sin(PI * t)
