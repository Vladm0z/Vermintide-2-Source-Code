-- chunkname: @scripts/managers/light_fx/light_fx_manager.lua

if script_data.debug_lightfx then
	LightFX = LightFX or {}

	LightFX.set_color_in_cube = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
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

LightFXManager.init = function (arg_2_0)
	if not rawget(_G, "LightFX") then
		return
	end

	arg_2_0._color_value = {}

	arg_2_0:set_lightfx_color_scheme("loading")
end

LightFXManager.set_lightfx_color_scheme = function (arg_3_0, arg_3_1)
	fassert(type(arg_3_1) == "string", "wrong indata in set_lightfx_color_scheme")

	if not rawget(_G, "LightFX") then
		return
	end

	if arg_3_1 == arg_3_0._color_scheme then
		return
	end

	arg_3_0._color_scheme = arg_3_1

	if arg_3_0._conditional_color_scheme then
		return
	end

	local var_3_0 = arg_3_0:_get_value_from_color_scheme(arg_3_1)

	arg_3_0:set_lightfx_color(var_3_0[1], var_3_0[2], var_3_0[3], var_3_0[4], var_3_0[5])
end

LightFXManager.set_lightfx_color = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._color_value

	if var_4_0[1] == arg_4_1 and var_4_0[2] == arg_4_2 and var_4_0[3] == arg_4_3 and var_4_0[4] == arg_4_4 and var_4_0[5] == arg_4_5 then
		return
	end

	var_4_0[1] = arg_4_1
	var_4_0[2] = arg_4_2
	var_4_0[3] = arg_4_3
	var_4_0[4] = arg_4_4
	var_4_0[5] = arg_4_5

	LightFX.set_color_in_cube(arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
end

LightFXManager._get_value_from_color_scheme = function (arg_5_0, arg_5_1)
	local var_5_0 = LightFXSettings[arg_5_1]
	local var_5_1 = var_5_0.value
	local var_5_2 = var_5_0.update_func

	if var_5_2 then
		var_5_1 = var_5_2(var_5_1)
	end

	return var_5_1
end

LightFXManager.update = function (arg_6_0, arg_6_1)
	if not GameSettingsDevelopment.use_alien_fx then
		return
	end

	if not rawget(_G, "LightFX") then
		return
	end

	local var_6_0 = Managers.time:time("main")
	local var_6_1 = true
	local var_6_2 = arg_6_0._color_scheme
	local var_6_3 = LightFXSettings[var_6_2]
	local var_6_4 = arg_6_0._conditional_color_scheme
	local var_6_5 = arg_6_0._conditional_color_scheme_timer
	local var_6_6 = arg_6_0._conditional_color_scheme ~= nil

	if var_6_4 then
		var_6_5 = var_6_5 and var_6_5 - arg_6_1

		if var_6_5 and var_6_5 > 0 then
			var_6_1 = false
		elseif var_6_4.condition_func() then
			var_6_1 = false
		else
			var_6_4 = nil
		end
	end

	if var_6_1 then
		for iter_6_0, iter_6_1 in ipairs(LightFXConditionalSettings) do
			if iter_6_1.condition_func() then
				var_6_4 = iter_6_1
				var_6_5 = var_6_4.time

				break
			end
		end
	end

	if var_6_4 then
		local var_6_7 = var_6_4.value

		var_6_4.update_func(arg_6_1, var_6_0, var_6_7)
	elseif var_6_6 then
		local var_6_8 = arg_6_0:_get_value_from_color_scheme(arg_6_0._color_scheme)

		arg_6_0:set_lightfx_color(var_6_8[1], var_6_8[2], var_6_8[3], var_6_8[4], var_6_8[5])
	elseif var_6_3.update_func then
		local var_6_9 = arg_6_0:_get_value_from_color_scheme(var_6_2)

		arg_6_0:set_lightfx_color(var_6_9[1], var_6_9[2], var_6_9[3], var_6_9[4], var_6_9[5])
	end

	arg_6_0._conditional_color_scheme = var_6_4
	arg_6_0._conditional_color_scheme_timer = var_6_5

	if script_data.debug_lightfx then
		arg_6_0:udpate_debug(arg_6_1)
	end
end

LightFXManager.udpate_debug = function (arg_7_0, arg_7_1)
	if not rawget(_G, "DebugScreen") then
		return
	end

	local var_7_0 = DebugScreen.gui

	if not var_7_0 then
		return
	end

	local var_7_1 = LightFX.color

	if not var_7_1 then
		return
	end

	local var_7_2, var_7_3 = Application.resolution()
	local var_7_4 = 300
	local var_7_5 = 100
	local var_7_6 = var_7_2 / 2 - var_7_4 / 2
	local var_7_7 = var_7_3 - 10 - var_7_5
	local var_7_8 = 820
	local var_7_9 = Color(var_7_1[4], var_7_1[1], var_7_1[2], var_7_1[3])

	Gui.rect(var_7_0, Vector3(var_7_6, var_7_7, var_7_8), Vector2(var_7_4, var_7_5), var_7_9)
end
