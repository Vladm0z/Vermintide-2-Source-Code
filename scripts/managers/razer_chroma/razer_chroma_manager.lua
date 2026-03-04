-- chunkname: @scripts/managers/razer_chroma/razer_chroma_manager.lua

require("scripts/settings/razer_chroma_settings")

RazerChromaManager = class(RazerChromaManager)
RAZER_ADD_ANIMATION_TYPE = {
	REPLACE = 2,
	QUEUE = 3,
	DO_NOTHING = 1
}

function RazerChromaManager.init(arg_1_0)
	arg_1_0._initialized = false
	arg_1_0._current_animations = {}
	arg_1_0._is_playing = false
	arg_1_0._default_keys = {}
	arg_1_0.current_animation = ""
	arg_1_0._progress = 0
end

function RazerChromaManager.destroy(arg_2_0)
	arg_2_0:unload_packages()
end

function RazerChromaManager.load_packages(arg_3_0)
	if not rawget(_G, "RazerChroma") or not GameSettingsDevelopment.use_razer_chroma or arg_3_0._initialized then
		return
	end

	Managers.package:load("resource_packages/razer_chroma", "RazerChroma", callback(arg_3_0, "cb_load_chroma_files"), true, false)
end

function RazerChromaManager.unload_packages(arg_4_0)
	if not arg_4_0._initialized then
		return
	end

	arg_4_0:stop_animation()
	arg_4_0.reset_keyboard()
	RazerChroma.close_all_chroma_files()
	Managers.package:unload("resource_packages/razer_chroma", "RazerChroma")

	arg_4_0._initialized = false
end

function RazerChromaManager.cb_load_chroma_files(arg_5_0)
	for iter_5_0, iter_5_1 in pairs(RazerChromaSettings) do
		local var_5_0 = iter_5_1.file_path
		local var_5_1 = RazerChroma.load_chroma_file(var_5_0)

		fassert(var_5_1 >= 0, "Failed to load chroma animation: " .. var_5_0)
	end

	arg_5_0._initialized = true

	arg_5_0:lit_keybindings(true)
end

function RazerChromaManager.update(arg_6_0, arg_6_1)
	if not arg_6_0._initialized or not GameSettingsDevelopment.use_razer_chroma then
		return
	end

	arg_6_0:_check_should_play_conditions()
	arg_6_0:_update_current_animations(arg_6_1)
end

function RazerChromaManager._check_should_play_conditions(arg_7_0)
	local var_7_0
	local var_7_1
	local var_7_2

	for iter_7_0, iter_7_1 in pairs(RazerChromaSettings) do
		if iter_7_1.condition_play_func then
			local var_7_3, var_7_4, var_7_5 = iter_7_1.condition_play_func(arg_7_0)
			local var_7_6 = var_7_5
			local var_7_7 = var_7_4

			if var_7_3 then
				arg_7_0:play_animation(iter_7_0, var_7_7, var_7_6)
			end
		end
	end
end

function RazerChromaManager._get_button_name(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1[arg_8_0][2]

	return var_8_0 ~= "unassigned_keymap" and Keyboard.button_name(var_8_0) or nil
end

function RazerChromaManager.lit_keybindings(arg_9_0, arg_9_1)
	if not arg_9_0._initialized then
		return
	end

	if arg_9_1 then
		local var_9_0 = Managers.input:keymaps_data("PlayerControllerKeymaps").win32.keymaps
		local var_9_1 = {
			arg_9_0._get_button_name("move_forward", var_9_0),
			arg_9_0._get_button_name("move_left", var_9_0),
			arg_9_0._get_button_name("move_back", var_9_0),
			arg_9_0._get_button_name("move_right", var_9_0),
			arg_9_0._get_button_name("action_career", var_9_0),
			arg_9_0._get_button_name("weapon_reload", var_9_0),
			arg_9_0._get_button_name("interact", var_9_0),
			arg_9_0._get_button_name("jump_1", var_9_0),
			arg_9_0._get_button_name("jump_only", var_9_0),
			arg_9_0._get_button_name("crouch", var_9_0),
			arg_9_0._get_button_name("dodge_hold", var_9_0),
			arg_9_0._get_button_name("dodge", var_9_0),
			arg_9_0._get_button_name("wield_1", var_9_0),
			arg_9_0._get_button_name("wield_2", var_9_0),
			arg_9_0._get_button_name("wield_3", var_9_0),
			arg_9_0._get_button_name("wield_4", var_9_0),
			arg_9_0._get_button_name("wield_5", var_9_0)
		}

		arg_9_0._default_keys = {}

		for iter_9_0, iter_9_1 in pairs(var_9_1) do
			local var_9_2 = arg_9_0:_string_to_key_mapping(iter_9_1)

			arg_9_0._default_keys[#arg_9_0._default_keys + 1] = var_9_2
		end
	end

	arg_9_0.reset_keyboard()
	arg_9_0:set_keys_color(arg_9_0._default_keys, 255, 0, 0)
end

function RazerChromaManager._update_current_animations(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._current_animations[1]

	if not var_10_0 then
		return
	elseif not arg_10_0._is_playing then
		arg_10_0:_start_animation(var_10_0)
	end

	arg_10_0._progress = arg_10_0._progress + arg_10_1

	local var_10_1 = arg_10_0._progress >= var_10_0.length
	local var_10_2 = var_10_0.condition_stop_func and var_10_0.condition_stop_func(arg_10_0)

	if var_10_1 or var_10_2 then
		if not var_10_2 and var_10_0.loop and #arg_10_0._current_animations <= 1 then
			arg_10_0._progress = 0

			return
		end

		local var_10_3

		table.remove(arg_10_0._current_animations, 1)

		arg_10_0._is_playing = false

		if #arg_10_0._current_animations == 0 then
			arg_10_0:lit_keybindings()

			arg_10_0.current_animation = ""
		end
	end
end

function RazerChromaManager.set_keyboard_color(arg_11_0, arg_11_1, arg_11_2)
	RazerChroma.set_keyboard_color(arg_11_0, arg_11_1, arg_11_2)
end

function RazerChromaManager.set_mouse_color(arg_12_0, arg_12_1, arg_12_2)
	RazerChroma.set_mouse_color(arg_12_0, arg_12_1, arg_12_2)
end

function RazerChromaManager.reset_keyboard()
	RazerChroma.set_keyboard_color(0, 0, 0)
end

function RazerChromaManager.reset_mouse()
	RazerChroma.set_mouse_color(0, 0, 0)
end

function RazerChromaManager.play_animation(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if not arg_15_0._initialized then
		return
	end

	fassert(arg_15_1 ~= nil, "chroma can not be nil")

	local var_15_0 = RazerChromaSettings[arg_15_1]

	if not var_15_0 then
		Application.warning("[RazerChromaManager] No chroma '" .. arg_15_1 .. "' exists")

		return
	end

	arg_15_2 = arg_15_2 or false
	arg_15_3 = arg_15_3 or RAZER_ADD_ANIMATION_TYPE.QUEUE

	local var_15_1 = arg_15_0._is_playing
	local var_15_2 = arg_15_0._current_animations
	local var_15_3 = {
		name = arg_15_1,
		file_path = var_15_0.file_path,
		length = var_15_0.length,
		loop = arg_15_2,
		on_play_func = var_15_0.on_play_func,
		condition_stop_func = var_15_0.condition_stop_func
	}

	if not var_15_1 then
		var_15_2[#var_15_2 + 1] = var_15_3
	elseif arg_15_3 == RAZER_ADD_ANIMATION_TYPE.DO_NOTHING then
		return
	elseif arg_15_3 == RAZER_ADD_ANIMATION_TYPE.QUEUE then
		var_15_2[#var_15_2 + 1] = var_15_3

		return
	elseif arg_15_3 == RAZER_ADD_ANIMATION_TYPE.REPLACE then
		arg_15_0:stop_animation()

		var_15_2[1] = var_15_3
	else
		fassert(false, "Invalid action value: " .. arg_15_3)
	end

	arg_15_0:_start_animation(var_15_3)
end

function RazerChromaManager._start_animation(arg_16_0, arg_16_1)
	if arg_16_1.on_play_func then
		arg_16_1.on_play_func(arg_16_0)
	else
		RazerChroma.play_animation(arg_16_1.file_path, arg_16_1.loop)
	end

	arg_16_0.current_animation = arg_16_1.name
	arg_16_0._is_playing = true
	arg_16_0._progress = 0
end

function RazerChromaManager.stop_animation(arg_17_0)
	local var_17_0 = arg_17_0._current_animations[1]

	if not var_17_0 then
		return
	end

	RazerChroma.stop_animation(var_17_0.file_path)
	table.remove(arg_17_0._current_animations, 1)

	arg_17_0._is_playing = false
end

function RazerChromaManager._string_to_key_mapping(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1

	if tonumber(var_18_0) then
		var_18_0 = "KEY" .. var_18_0
	else
		local var_18_1 = string.find(var_18_0, " ")

		if var_18_1 then
			var_18_0 = string.sub(arg_18_1, 0, 1) .. string.sub(arg_18_1, var_18_1 + 1)
		end
	end

	return RazerChroma[string.upper(var_18_0)]
end

function RazerChromaManager.set_keys_color(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	assert(type(arg_19_1) == "table")

	for iter_19_0, iter_19_1 in pairs(arg_19_1) do
		if type(iter_19_1) ~= "number" then
			iter_19_1 = arg_19_0:_string_to_key_mapping(iter_19_1)
		end

		RazerChroma.set_key_color(iter_19_1, arg_19_2, arg_19_3, arg_19_4)
	end
end
