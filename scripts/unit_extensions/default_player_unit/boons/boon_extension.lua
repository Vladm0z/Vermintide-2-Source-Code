-- chunkname: @scripts/unit_extensions/default_player_unit/boons/boon_extension.lua

BoonExtension = class(BoonExtension)

BoonExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._profile_index = arg_1_3.profile_index
end

BoonExtension.game_object_initialized = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not DamageUtils.is_in_inn then
		return
	end

	local get_active_boons = Managers.backend:get_interface("boons"):get_active_boons()
	local system = Managers.state.entity:system("buff_system")

	for i, v in ipairs(get_active_boons) do
		local var_2_2 = BoonTemplates[v.boon_name].buff_per_hero[self._profile_index]

		fassert(var_2_2, "boon %s doesn't have buff for profile %d", v.boon_name, self._profile_index)
		system:add_buff(arg_2_1, var_2_2, arg_2_1, false)
	end
end

BoonExtension.destroy = function (arg_3_0)
	-- function 3
	return
end
