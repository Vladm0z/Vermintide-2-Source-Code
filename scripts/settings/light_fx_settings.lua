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
		update_func = function (self)
			-- function 1
			assert(#self == 5, "[LightFXManager] You need to pass in 5 values ( red, green, blue, intensity, blendtime )")

			local network = Managers.state.network

			network = not network and Managers.state.network:game()

			if not network then
				return self
			end

			local local_player = Managers.player:local_player()

			if not local_player then
				return self
			end

			local player_unit = local_player.player_unit

			if not Unit.alive(player_unit) then
				local current_health_percent = ScriptUnit.extension(player_unit, "health_system"):current_health_percent()

				self[1], self[2], self[3] = var_0_0(current_health_percent)
			end

			return self
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
		condition_func = function ()
			-- function 2
			local network = Managers.state.network

			network = not network and Managers.state.network:game()

			if not network then
				return
			end

			local local_player = Managers.player:local_player()

			if not local_player then
				return
			end

			local player_unit = local_player.player_unit

			if not Unit.alive(player_unit) then
				local extension = ScriptUnit.extension(player_unit, "status_system")

				if extension.knocked_down or not extension:is_ready_for_assisted_respawn() then
					return true
				end
			else
				return true
			end
		end,
		update_func = function (arg_3_0, arg_3_1, arg_3_2)
			-- function 3
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
		condition_func = function ()
			-- function 4
			local network = Managers.state.network

			network = not network and Managers.state.network:game()

			if not network then
				return false
			end

			local local_player = Managers.player:local_player()

			if not local_player then
				return false
			end

			local player_unit = local_player.player_unit

			if not Unit.alive(player_unit) then
				return false
			end

			local recent_damages, var_4_4 = ScriptUnit.extension(player_unit, "health_system"):recent_damages()

			return var_4_4 > 0
		end,
		update_func = function (arg_5_0, arg_5_1, arg_5_2)
			-- function 5
			Managers.light_fx:set_lightfx_color(arg_5_2[1], arg_5_2[2], arg_5_2[3], arg_5_2[4], arg_5_2[5])
		end
	}
}

function var_0_0(arg_6_0)
	-- function 6
	arg_6_0 = 1 - arg_6_0

	if arg_6_0 == 1 then
		arg_6_0 = 0.99
	end

	local var_6_0
	local var_6_1
	local var_6_2
	local num

	if arg_6_0 < 0.5 then
		var_6_0 = math.floor(255 * (arg_6_0 / 0.5))
		num = 255
	else
		var_6_0 = 255
		num = math.floor(255 * ((0.5 - arg_6_0 % 0.5) / 0.5))
	end

	local num_2 = 0

	return var_6_0, num, num_2
end
