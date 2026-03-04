-- chunkname: @scripts/unit_extensions/default_player_unit/boons/boon_extension.lua

BoonExtension = class(BoonExtension)

function BoonExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._profile_index = arg_1_3.profile_index
end

function BoonExtension.game_object_initialized(arg_2_0, arg_2_1, arg_2_2)
	if DamageUtils.is_in_inn then
		return
	end

	local var_2_0 = Managers.backend:get_interface("boons"):get_active_boons()
	local var_2_1 = Managers.state.entity:system("buff_system")

	for iter_2_0, iter_2_1 in ipairs(var_2_0) do
		local var_2_2 = BoonTemplates[iter_2_1.boon_name].buff_per_hero[arg_2_0._profile_index]

		fassert(var_2_2, "boon %s doesn't have buff for profile %d", iter_2_1.boon_name, arg_2_0._profile_index)
		var_2_1:add_buff(arg_2_1, var_2_2, arg_2_1, false)
	end
end

function BoonExtension.destroy(arg_3_0)
	return
end
