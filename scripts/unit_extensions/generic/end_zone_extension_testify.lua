-- chunkname: @scripts/unit_extensions/generic/end_zone_extension_testify.lua

local function var_0_0(arg_1_0)
	return arg_1_0._activation_name
end

local function var_0_1(arg_2_0, arg_2_1)
	local var_2_0 = var_0_0(arg_2_1)

	return arg_2_0 and arg_2_0 == var_2_0
end

return {
	is_end_zone_activated = function (arg_3_0, arg_3_1)
		if not var_0_1(arg_3_1, arg_3_0) then
			return Testify.RETRY
		end

		return arg_3_0._activated == true
	end,
	teleport_player_to_end_zone_position = function (arg_4_0, arg_4_1)
		if not var_0_1(arg_4_1, arg_4_0) then
			return Testify.RETRY
		end

		local var_4_0 = Unit.local_position(arg_4_0._unit, 0)
		local var_4_1 = Managers.player:local_player().player_unit
		local var_4_2 = Unit.mover(var_4_1)

		var_4_0.z = var_4_0.z + 1

		Mover.set_position(var_4_2, var_4_0)
	end
}
