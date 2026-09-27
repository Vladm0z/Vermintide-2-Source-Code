-- chunkname: @scripts/unit_extensions/generic/end_zone_extension_testify.lua

local function fn(self)
	-- function 1
	return self._activation_name
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local var_2_0 = fn(arg_2_1)

	return not arg_2_0 and arg_2_0 == var_2_0
end

return {
	is_end_zone_activated = function (self, arg_3_1)
		-- function 3
		if not fn_2(arg_3_1, self) then
			return Testify.RETRY
		end

		return self._activated == true
	end,
	teleport_player_to_end_zone_position = function (self, arg_4_1)
		-- function 4
		if not fn_2(arg_4_1, self) then
			return Testify.RETRY
		end

		local local_position = Unit.local_position(self._unit, 0)
		local player_unit = Managers.player:local_player().player_unit
		local mover = Unit.mover(player_unit)

		local_position.z = local_position.z + 1

		Mover.set_position(mover, local_position)
	end
}
