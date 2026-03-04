-- chunkname: @scripts/settings/light_fx_settings.lua

local var_0_0

LightFXSettings = {
	inn_level = {
		value = {
			255,
			255,
			0,
			255,
			1
		}
	},
	loading = {
		value = {
			128,
			128,
			128,
			128,
			1
		}
	},
	ingame = {
		value = {
			0,
			255,
			0,
			255,
			1
		},
		update_func = function(arg_1_0)
			assert(#arg_1_0 == 5, "[LightFXManager] You need to pass in 5 values ( red, green, blue, intensity, blendtime )")

			if not (Managers.state.network and Managers.state.network:game()) then
				return arg_1_0
			end

			local var_1_0 = Managers.player:local_player()

			if not var_1_0 then
				return arg_1_0
			end

			local var_1_1 = var_1_0.player_unit

			if Unit.alive(var_1_1) then
				local var_1_2 = ScriptUnit.extension(var_1_1, "health_system"):current_health_percent()

				arg_1_0[1], arg_1_0[2], arg_1_0[3] = var_0_0(var_1_2)
			end

			return arg_1_0
		end
	}
}
LightFXConditionalSettings = {
	{
		name = "Knocked down",
		value = {
			255,
			0,
			0,
			60,
			2
		},
		condition_func = function()
			if not (Managers.state.network and Managers.state.network:game()) then
				return
			end

			local var_2_0 = Managers.player:local_player()

			if not var_2_0 then
				return
			end

			local var_2_1 = var_2_0.player_unit

			if Unit.alive(var_2_1) then
				local var_2_2 = ScriptUnit.extension(var_2_1, "status_system")

				if var_2_2.knocked_down or var_2_2:is_ready_for_assisted_respawn() then
					return true
				end
			else
				return true
			end
		end,
		update_func = function(arg_3_0, arg_3_1, arg_3_2)
			Managers.light_fx:set_lightfx_color(arg_3_2[1], arg_3_2[2], arg_3_2[3], arg_3_2[4], arg_3_2[5])
		end
	},
	{
		name = "Hit",
		time = 0.5,
		value = {
			255,
			0,
			0,
			255,
			0.1
		},
		condition_func = function()
			if not (Managers.state.network and Managers.state.network:game()) then
				return false
			end

			local var_4_0 = Managers.player:local_player()

			if not var_4_0 then
				return false
			end

			local var_4_1 = var_4_0.player_unit

			if not Unit.alive(var_4_1) then
				return false
			end

			local var_4_2, var_4_3 = ScriptUnit.extension(var_4_1, "health_system"):recent_damages()

			return var_4_3 > 0
		end,
		update_func = function(arg_5_0, arg_5_1, arg_5_2)
			Managers.light_fx:set_lightfx_color(arg_5_2[1], arg_5_2[2], arg_5_2[3], arg_5_2[4], arg_5_2[5])
		end
	}
}

function var_0_0(arg_6_0)
	arg_6_0 = 1 - arg_6_0

	if arg_6_0 == 1 then
		arg_6_0 = 0.99
	end

	local var_6_0
	local var_6_1
	local var_6_2
	local var_6_3

	if arg_6_0 < 0.5 then
		var_6_0 = math.floor(255 * (arg_6_0 / 0.5))
		var_6_3 = 255
	else
		var_6_0 = 255
		var_6_3 = math.floor(255 * ((0.5 - arg_6_0 % 0.5) / 0.5))
	end

	local var_6_4 = 0

	return var_6_0, var_6_3, var_6_4
end
