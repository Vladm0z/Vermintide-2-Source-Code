-- chunkname: @scripts/managers/light_fx/light_fx_manager.lua

if not script_data.debug_lightfx then
	local LightFX = LightFX

	LightFX = LightFX or {}
	LightFX = LightFX

	LightFX.set_color_in_cube = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		-- function 1
		LightFX.color = {
			arg_1_0,
			arg_1_1,
			arg_1_2,
			arg_1_3,
			arg_1_4
		}

		print(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	end
end

require("scripts/settings/light_fx_settings")

LightFXManager = class(LightFXManager)

LightFXManager.init = function (self)
	-- function 2
	if not rawget(_G, "LightFX") then
		return
	end

	self._color_value = {}

	self:set_lightfx_color_scheme("loading")
end

LightFXManager.set_lightfx_color_scheme = function (self, arg_3_1)
	-- function 3
	fassert(type(arg_3_1) == "string", "wrong indata in set_lightfx_color_scheme")

	if not rawget(_G, "LightFX") then
		return
	end

	if arg_3_1 == self._color_scheme then
		return
	end

	self._color_scheme = arg_3_1

	if not self._conditional_color_scheme then
		return
	end

	local _get_value_from_color_scheme = self:_get_value_from_color_scheme(arg_3_1)

	self:set_lightfx_color(_get_value_from_color_scheme[1], _get_value_from_color_scheme[2], _get_value_from_color_scheme[3], _get_value_from_color_scheme[4], _get_value_from_color_scheme[5])
end

LightFXManager.set_lightfx_color = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _color_value = self._color_value

	if not (_color_value[1] ~= arg_4_1 or _color_value[2] ~= arg_4_2 or _color_value[3] ~= arg_4_3 or _color_value[4] ~= arg_4_4 or _color_value[5] ~= arg_4_5) then
		return
	end

	_color_value[1] = arg_4_1
	_color_value[2] = arg_4_2
	_color_value[3] = arg_4_3
	_color_value[4] = arg_4_4
	_color_value[5] = arg_4_5

	LightFX.set_color_in_cube(arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
end

LightFXManager._get_value_from_color_scheme = function (arg_5_0, arg_5_1)
	-- function 5
	local var_5_0 = LightFXSettings[arg_5_1]
	local value = var_5_0.value
	local update_func = var_5_0.update_func

	if not update_func then
		value = update_func(value)
	end

	return value
end

LightFXManager.update = function (self, arg_6_1)
	-- function 6
	if not GameSettingsDevelopment.use_alien_fx then
		return
	end

	if not rawget(_G, "LightFX") then
		return
	end

	local time = Managers.time:time("main")
	local flag = true
	local _color_scheme = self._color_scheme
	local var_6_3 = LightFXSettings[_color_scheme]
	local _conditional_color_scheme = self._conditional_color_scheme
	local _conditional_color_scheme_timer = self._conditional_color_scheme_timer
	local flag_2 = self._conditional_color_scheme ~= nil

	if not _conditional_color_scheme then
		_conditional_color_scheme_timer = not _conditional_color_scheme_timer and _conditional_color_scheme_timer - arg_6_1

		if not (not _conditional_color_scheme_timer and not (_conditional_color_scheme_timer > 0)) then
			flag = false
		elseif not _conditional_color_scheme.condition_func() then
			flag = false
		else
			_conditional_color_scheme = nil
		end
	end

	if not flag then
		for i, v in ipairs(LightFXConditionalSettings) do
			if not v.condition_func() then
				_conditional_color_scheme = v
				_conditional_color_scheme_timer = _conditional_color_scheme.time

				break
			end
		end
	end

	if not _conditional_color_scheme then
		local value = _conditional_color_scheme.value

		_conditional_color_scheme.update_func(arg_6_1, time, value)
	elseif not flag_2 then
		local _get_value_from_color_scheme = self:_get_value_from_color_scheme(self._color_scheme)

		self:set_lightfx_color(_get_value_from_color_scheme[1], _get_value_from_color_scheme[2], _get_value_from_color_scheme[3], _get_value_from_color_scheme[4], _get_value_from_color_scheme[5])
	elseif not var_6_3.update_func then
		local _get_value_from_color_scheme_2 = self:_get_value_from_color_scheme(_color_scheme)

		self:set_lightfx_color(_get_value_from_color_scheme_2[1], _get_value_from_color_scheme_2[2], _get_value_from_color_scheme_2[3], _get_value_from_color_scheme_2[4], _get_value_from_color_scheme_2[5])
	end

	self._conditional_color_scheme = _conditional_color_scheme
	self._conditional_color_scheme_timer = _conditional_color_scheme_timer

	if not script_data.debug_lightfx then
		self:udpate_debug(arg_6_1)
	end
end

LightFXManager.udpate_debug = function (arg_7_0, arg_7_1)
	-- function 7
	if not rawget(_G, "DebugScreen") then
		return
	end

	local gui = DebugScreen.gui

	if not gui then
		return
	end

	local color = LightFX.color

	if not color then
		return
	end

	local resolution, var_7_3 = Application.resolution()
	local num = 300
	local num_2 = 100
	local num_3 = resolution / 2 - num / 2
	local num_4 = var_7_3 - 10 - num_2
	local num_5 = 820
	local var_7_9 = Color(color[4], color[1], color[2], color[3])

	Gui.rect(gui, Vector3(num_3, num_4, num_5), Vector2(num, num_2), var_7_9)
end
