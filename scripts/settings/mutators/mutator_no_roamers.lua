-- chunkname: @scripts/settings/mutators/mutator_no_roamers.lua

return {
	hide_from_player_ui = true,
	tweak_pack_spawning_settings = function(arg_1_0, arg_1_1)
		arg_1_1.area_density_coefficient = 0

		for iter_1_0, iter_1_1 in pairs(arg_1_1.difficulty_overrides) do
			iter_1_1.area_density_coefficient = 0
		end
	end
}
