-- chunkname: @scripts/settings/dlcs/bless/action_dynamic_sweep.lua

ActionDynamicSweep = class(ActionDynamicSweep, ActionSweep)

ActionDynamicSweep.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionDynamicSweep.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
end

ActionDynamicSweep._get_damage_profile_name = function (self, arg_2_1, arg_2_2)
	-- function 2
	local get_mode = self.weapon_extension:get_mode()
	local var_2_1 = arg_2_2.dynamic_profiles[get_mode]
	local var_2_2

	if not arg_2_1 then
		var_2_2 = arg_2_2["damage_profile_" .. arg_2_1]

		if not var_2_2 then
			-- Nothing
		end
	end

	var_2_2 = var_2_1 or "default"

	::label_2_0::

	return var_2_2
end

ActionDynamicSweep._calculate_attack_direction = function (self, arg_3_1, arg_3_2)
	-- function 3
	local get_mode = self.weapon_extension:get_mode()
	local var_3_1 = arg_3_1.dynamic_attack_direction[get_mode]
	local attack_direction = arg_3_1.attack_direction

	attack_direction = attack_direction or "forward"

	local var_3_3 = Quaternion[attack_direction](arg_3_2)
	local num

	if not var_3_1 then
		num = -var_3_3

		if not num then
			-- Nothing
		end
	end

	num = var_3_3

	::label_3_0::

	return num
end
