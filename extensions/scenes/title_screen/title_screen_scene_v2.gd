extends "res://scenes/title_screen/title_screen_scene_v2.gd"

const MOD_ID = "ZackeryRSmith-ParentalControls"
const LOG_NAME = "ZackeryRSmith-ParentalControls:TitleScreen"


func _ready():
	var parental_controls = get_node("/root/ModLoader/" + MOD_ID)
	if not is_instance_valid(parental_controls):
		return
	parental_controls.reload_config.connect(_apply_config)
	
	super()
	
	var profile = ModLoaderUserProfile.get_current()
	if MOD_ID not in profile.mod_list:
		ModLoaderLog.fatal("Mod not found in profiles mod list!", LOG_NAME)
		return
	
	var config_name = profile.mod_list[MOD_ID].get("current_config")
	var config = ModLoaderConfig.get_config(MOD_ID, config_name)
	_apply_config(config)


func _set_disabled(button_suffix: String, truthy: bool):
	var button: Button = button_manager.get_node("button_%s" % button_suffix)
	if is_instance_valid(button):
		button.disabled = truthy


func _apply_config(config: ModConfig):
	var data = config.data
	
	_set_disabled("start", !data.main_menu.button_start)
	_set_disabled("hardmode", !data.main_menu.button_hardmode)
	_set_disabled("challenge", !data.main_menu.button_challenge)
	_set_disabled("mods", !data.main_menu.button_mods)
	_set_disabled("options", !data.main_menu.button_options)
	_set_disabled("exit", !data.main_menu.button_exit)
	
	var external_buttons_vbox: VBoxContainer = get_node(
		"CanvasLayer/ui_layer/external_buttons/VBoxContainer"
	)
	
	var external_steam: Button = external_buttons_vbox.get_node("external_steam")
	var external_ftp: Button = external_buttons_vbox.get_node("external_ftp")
	var external_discord: Button = external_buttons_vbox.get_node("HBoxContainer/external_discord")
	if is_instance_valid(external_steam):
		external_steam.disabled = !data.main_menu.social.external_steam
	if is_instance_valid(external_ftp):
		external_ftp.disabled = !data.main_menu.social.external_ftp
	if is_instance_valid(external_discord):
		external_discord.disabled = !data.main_menu.social.external_discord
