-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_command_stand.lua

local num = 11
local num_2 = -10

ActionCareerBwNecromancerCommandStand = class(ActionCareerBwNecromancerCommandStand, ActionBase)

ActionCareerBwNecromancerCommandStand.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerBwNecromancerCommandStand.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self._command_ability = self._career_extension:get_passive_ability_by_name("bw_necromancer_command")
end

ActionCareerBwNecromancerCommandStand.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_5 = arg_2_5 or {}

	ActionCareerBwNecromancerCommandStand.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	local var_2_0
	local var_2_1

	if not arg_2_3 then
		var_2_0 = arg_2_3.target_center:unbox()
		var_2_1 = arg_2_3.fp_rotation:unbox()
	end

	if not var_2_0 then
		self._command_ability:command_stand_ground(var_2_0, var_2_1)
	end
end

ActionCareerBwNecromancerCommandStand.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end
