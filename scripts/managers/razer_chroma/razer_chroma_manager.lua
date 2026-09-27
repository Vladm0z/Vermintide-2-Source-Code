-- chunkname: @scripts/managers/razer_chroma/razer_chroma_manager.lua

require("scripts/settings/razer_chroma_settings")

RazerChromaManager = class(RazerChromaManager)
RAZER_ADD_ANIMATION_TYPE = {
	REPLACE = 2,
	QUEUE = 3,
	DO_NOTHING = 1
}

RazerChromaManager.init = function (self)
	-- function 1
	self._initialized = false
	self._current_animations = {}
	self._is_playing = false
	self._default_keys = {}
	self.current_animation = ""
	self._progress = 0
end

RazerChromaManager.destroy = function (self)
	-- function 2
	self:unload_packages()
end

RazerChromaManager.load_packages = function (self)
	-- function 3
	if not rawget(_G, "RazerChroma") and not GameSettingsDevelopment.use_razer_chroma and not self._initialized then
		return
	end

	Managers.package:load("resource_packages/razer_chroma", "RazerChroma", callback(self, "cb_load_chroma_files"), true, false)
end

RazerChromaManager.unload_packages = function (self)
	-- function 4
	if not self._initialized then
		return
	end

	self:stop_animation()
	self.reset_keyboard()
	RazerChroma.close_all_chroma_files()
	Managers.package:unload("resource_packages/razer_chroma", "RazerChroma")

	self._initialized = false
end

RazerChromaManager.cb_load_chroma_files = function (self)
	-- function 5
	for k, v in pairs(RazerChromaSettings) do
		local file_path = v.file_path
		local load_chroma_file = RazerChroma.load_chroma_file(file_path)

		fassert(load_chroma_file >= 0, "Failed to load chroma animation: " .. file_path)
	end

	self._initialized = true

	self:lit_keybindings(true)
end

RazerChromaManager.update = function (self, arg_6_1)
	-- function 6
	if not (not self._initialized and GameSettingsDevelopment.use_razer_chroma) then
		return
	end

	self:_check_should_play_conditions()
	self:_update_current_animations(arg_6_1)
end

RazerChromaManager._check_should_play_conditions = function (self)
	-- function 7
	local var_7_0
	local var_7_1
	local var_7_2

	for k, v in pairs(RazerChromaSettings) do
		if not v.condition_play_func then
			local condition_play_func, var_7_4, var_7_5 = v.condition_play_func(self)
			local var_7_6 = var_7_5
			local var_7_7 = var_7_4

			if not condition_play_func then
				self:play_animation(k, var_7_7, var_7_6)
			end
		end
	end
end

RazerChromaManager._get_button_name = function (arg_8_0, arg_8_1)
	-- function 8
	local var_8_0 = arg_8_1[arg_8_0][2]
	local button_name

	if var_8_0 ~= "unassigned_keymap" then
		button_name = Keyboard.button_name(var_8_0)

		if not button_name then
			-- Nothing
		end
	end

	button_name = nil

	::label_8_0::

	return button_name
end

RazerChromaManager.lit_keybindings = function (self, arg_9_1)
	-- function 9
	if not self._initialized then
		return
	end

	if not arg_9_1 then
		local keymaps = Managers.input:keymaps_data("PlayerControllerKeymaps").win32.keymaps
		local tbl = {
			self._get_button_name("move_forward", keymaps),
			self._get_button_name("move_left", keymaps),
			self._get_button_name("move_back", keymaps),
			self._get_button_name("move_right", keymaps),
			self._get_button_name("action_career", keymaps),
			self._get_button_name("weapon_reload", keymaps),
			self._get_button_name("interact", keymaps),
			self._get_button_name("jump_1", keymaps),
			self._get_button_name("jump_only", keymaps),
			self._get_button_name("crouch", keymaps),
			self._get_button_name("dodge_hold", keymaps),
			self._get_button_name("dodge", keymaps),
			self._get_button_name("wield_1", keymaps),
			self._get_button_name("wield_2", keymaps),
			self._get_button_name("wield_3", keymaps),
			self._get_button_name("wield_4", keymaps),
			self._get_button_name("wield_5", keymaps)
		}

		self._default_keys = {}

		for k, v in pairs(tbl) do
			local _string_to_key_mapping = self:_string_to_key_mapping(v)

			self._default_keys[#self._default_keys + 1] = _string_to_key_mapping
		end
	end

	self.reset_keyboard()
	self:set_keys_color(self._default_keys, 255, 0, 0)
end

RazerChromaManager._update_current_animations = function (self, arg_10_1)
	-- function 10
	local var_10_0 = self._current_animations[1]

	if not var_10_0 then
		return
	elseif not self._is_playing then
		self:_start_animation(var_10_0)
	end

	self._progress = self._progress + arg_10_1

	local flag = self._progress >= var_10_0.length
	local condition_stop_func = var_10_0.condition_stop_func

	condition_stop_func = not condition_stop_func and var_10_0.condition_stop_func(self)

	if flag or not condition_stop_func then
		if not ((condition_stop_func or not var_10_0.loop) and not (#self._current_animations <= 1)) then
			self._progress = 0

			return
		end

		local var_10_3

		table.remove(self._current_animations, 1)

		self._is_playing = false

		if #self._current_animations == 0 then
			self:lit_keybindings()

			self.current_animation = ""
		end
	end
end

RazerChromaManager.set_keyboard_color = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	RazerChroma.set_keyboard_color(arg_11_0, arg_11_1, arg_11_2)
end

RazerChromaManager.set_mouse_color = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	RazerChroma.set_mouse_color(arg_12_0, arg_12_1, arg_12_2)
end

RazerChromaManager.reset_keyboard = function ()
	-- function 13
	RazerChroma.set_keyboard_color(0, 0, 0)
end

RazerChromaManager.reset_mouse = function ()
	-- function 14
	RazerChroma.set_mouse_color(0, 0, 0)
end

RazerChromaManager.play_animation = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	if not self._initialized then
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

	local _is_playing = self._is_playing
	local _current_animations = self._current_animations
	local tbl = {
		name = arg_15_1,
		file_path = var_15_0.file_path,
		length = var_15_0.length,
		loop = arg_15_2,
		on_play_func = var_15_0.on_play_func,
		condition_stop_func = var_15_0.condition_stop_func
	}

	if not _is_playing then
		_current_animations[#_current_animations + 1] = tbl
	elseif arg_15_3 == RAZER_ADD_ANIMATION_TYPE.DO_NOTHING then
		return
	elseif arg_15_3 == RAZER_ADD_ANIMATION_TYPE.QUEUE then
		_current_animations[#_current_animations + 1] = tbl

		return
	elseif arg_15_3 == RAZER_ADD_ANIMATION_TYPE.REPLACE then
		self:stop_animation()

		_current_animations[1] = tbl
	else
		fassert(false, "Invalid action value: " .. arg_15_3)
	end

	self:_start_animation(tbl)
end

RazerChromaManager._start_animation = function (self, arg_16_1)
	-- function 16
	if not arg_16_1.on_play_func then
		arg_16_1.on_play_func(self)
	else
		RazerChroma.play_animation(arg_16_1.file_path, arg_16_1.loop)
	end

	self.current_animation = arg_16_1.name
	self._is_playing = true
	self._progress = 0
end

RazerChromaManager.stop_animation = function (self)
	-- function 17
	local var_17_0 = self._current_animations[1]

	if not var_17_0 then
		return
	end

	RazerChroma.stop_animation(var_17_0.file_path)
	table.remove(self._current_animations, 1)

	self._is_playing = false
end

RazerChromaManager._string_to_key_mapping = function (arg_18_0, arg_18_1)
	-- function 18
	local var_18_0 = arg_18_1

	if not tonumber(var_18_0) then
		var_18_0 = "KEY" .. var_18_0
	else
		local find = string.find(var_18_0, " ")

		if not find then
			var_18_0 = string.sub(arg_18_1, 0, 1) .. string.sub(arg_18_1, find + 1)
		end
	end

	return RazerChroma[string.upper(var_18_0)]
end

RazerChromaManager.set_keys_color = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	assert(type(arg_19_1) == "table")

	for k, v in pairs(arg_19_1) do
		if type(v) ~= "number" then
			v = self:_string_to_key_mapping(v)
		end

		RazerChroma.set_key_color(v, arg_19_2, arg_19_3, arg_19_4)
	end
end
