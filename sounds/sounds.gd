extends Node2D

@onready var island = get_node("/root/root/Island")

@onready var _explosion: AudioStreamPlayer2D = $explosion
@onready var _cannon: AudioStreamPlayer2D = $cannon
@onready var _water_splash: AudioStreamPlayer2D = $water_splash
@onready var _pickup: AudioStreamPlayer2D = $pickup
@onready var _score: AudioStreamPlayer2D = $score
@onready var _build: AudioStreamPlayer2D = $build
@onready var _drop_plank: AudioStreamPlayer2D = $drop_plank
@onready var _drop_gem: AudioStreamPlayer2D = $drop_gem
@onready var _ocean: AudioStreamPlayer2D = $ocean
@onready var start_ocean_sound_volume = _ocean.volume_db

# Define a max distance at which the ocean sound will be silent.
const MAX_DISTANCE: float = 3000.0


func modulate_ocean_sound():
	var distance = island.closest_water_tile_distance
	if distance == null:
		return
	var volume_scale = clamp(1.0 - (distance / MAX_DISTANCE), 0.0, 1.0)

	# Convert the scale from 0 to 1 to dB range. For example: 0 might be -80dB (almost silent) and 1 would be 0dB (full volume).
	_ocean.volume_db = lerp(-80.0, start_ocean_sound_volume, volume_scale)
	if !_ocean.playing:
		_ocean.play()


func _process(delta):
	modulate_ocean_sound()


func explosion():
	_explosion.play()


func cannon():
	_cannon.play()


func water_splash():
	_water_splash.play()


func pickup():
	_pickup.play()


func score():
	_score.play()


func build():
	_build.play()


func drop_plank():
	_drop_plank.play()


func drop_gem():
	_drop_gem.play()
