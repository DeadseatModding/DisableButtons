extends Node

#region signals
signal reload_config(config: ModConfig)
#endregion

const MOD_DIR := "ZackeryRSmith-ParentalControls"
const LOG_NAME := "ZackeryRSmith-ParentalControls:Main"

var mod_dir_path := ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)
var extensions_dir_path = mod_dir_path.path_join("extensions")

func _init() -> void:
	ModLoaderMod.install_script_extension(
		extensions_dir_path.path_join("scenes/title_screen/title_screen_scene_v2.gd")
	)

func _ready() -> void:
	ModLoader.current_config_changed.connect(_on_config_changed)
	ModLoaderLog.info("Ready!", LOG_NAME)

func _on_config_changed(config: ModConfig):
	if config.mod_id != MOD_DIR:
		return
	_apply_config(config)

func _apply_config(config: ModConfig):
	assert(config.mod_id == MOD_DIR)  # sanity check
	var data = config.data
	
	reload_config.emit(config)
