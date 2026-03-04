-- chunkname: @scripts/unit_extensions/default_player_unit/ping/ping_target_extension.lua

PingTargetExtension = class(PingTargetExtension)

PingTargetExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._world = arg_1_1.world
	arg_1_0._unit = arg_1_2
	arg_1_0._pinged = 0
	arg_1_0._outline_ids = {}

	if arg_1_3.always_pingable == nil then
		arg_1_0.always_pingable = Unit.get_data(arg_1_2, "ping_data", "always_pingable")
	else
		arg_1_0.always_pingable = arg_1_3.always_pingable
	end
end

PingTargetExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._outline_extension = ScriptUnit.has_extension(arg_2_2, "outline_system")
	arg_2_0._buff_extension = ScriptUnit.has_extension(arg_2_2, "buff_system")
	arg_2_0._locomotion_extension = ScriptUnit.has_extension(arg_2_2, "locomotion_system")
end

PingTargetExtension.set_pinged = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0._unit

	arg_3_4 = arg_3_4 == nil and true or arg_3_4

	if arg_3_1 then
		arg_3_0._pinged = arg_3_0._pinged + 1
	else
		arg_3_0._pinged = arg_3_0._pinged - 1
	end

	if arg_3_0._outline_extension then
		if arg_3_4 then
			if arg_3_1 then
				local var_3_1 = table.shallow_copy(OutlineSettings.templates.ping_unit, true)

				var_3_1.method = arg_3_0._outline_extension.pinged_method

				local var_3_2 = arg_3_0._outline_extension:add_outline(var_3_1)

				arg_3_0._outline_ids[arg_3_3] = var_3_2
			else
				local var_3_3 = arg_3_0._outline_ids[arg_3_3]

				arg_3_0._outline_extension:remove_outline(var_3_3)

				arg_3_0._outline_ids[arg_3_3] = nil
			end
		end

		if arg_3_1 then
			arg_3_0:_add_witch_hunter_buff(arg_3_3)
		end
	end

	if Unit.alive(var_3_0) then
		if Unit.get_data(var_3_0, "breed") then
			local var_3_4 = ScriptUnit.has_extension(var_3_0, "proximity_system")

			if var_3_4 then
				var_3_4.has_been_seen = true
			end
		end

		local var_3_5 = ScriptUnit.has_extension(arg_3_3, "buff_system")

		if var_3_5 then
			var_3_5:trigger_procs("on_pinged", var_3_0, arg_3_3, arg_3_1)
		end

		Managers.state.event:trigger_referenced(var_3_0, "on_pinged", arg_3_3, arg_3_1)
	end
end

PingTargetExtension.pinged = function (arg_4_0)
	return arg_4_0._pinged > 0
end

PingTargetExtension.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	return
end

PingTargetExtension.destroy = function (arg_6_0)
	return
end

PingTargetExtension._add_witch_hunter_buff = function (arg_7_0, arg_7_1)
	if not Managers.state.network.is_server then
		return
	end

	local var_7_0 = arg_7_0._buff_extension

	if var_7_0 then
		local var_7_1 = "defence_debuff_enemies"
		local var_7_2 = Managers.state.side.side_by_unit[arg_7_1]

		if not var_7_2 then
			return
		end

		local var_7_3 = var_7_2.PLAYER_AND_BOT_UNITS
		local var_7_4 = #var_7_3

		for iter_7_0 = 1, var_7_4 do
			local var_7_5 = var_7_3[iter_7_0]
			local var_7_6 = ScriptUnit.has_extension(var_7_5, "career_system")
			local var_7_7 = ScriptUnit.has_extension(var_7_5, "talent_system")

			if (var_7_6 and var_7_6:career_name()) == "wh_captain" then
				var_7_0:add_buff(var_7_1)

				if var_7_7:has_talent("victor_witchhunter_improved_damage_taken_ping") then
					var_7_0:add_buff("victor_witchhunter_improved_damage_taken_ping")
				end
			end
		end
	end
end
