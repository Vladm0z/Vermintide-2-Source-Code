-- chunkname: @scripts/settings/dlcs/bless/action_dynamic_sweep.lua

ActionDynamicSweep = class(ActionDynamicSweep, ActionSweep)

ActionDynamicSweep.init = function (self, world, item_name, is_server, owner_unit, damage_unit, first_person_unit, weapon_unit, weapon_system)
	-- function 1
	ActionDynamicSweep.super.init(self, world, item_name, is_server, owner_unit, damage_unit, first_person_unit, weapon_unit, weapon_system)

	self.weapon_extension = ScriptUnit.extension(weapon_unit, "weapon_system")
end

ActionDynamicSweep._get_damage_profile_name = function (self, action_hand, action)
	-- function 2
	local current_mode = self.weapon_extension:get_mode()
	local dynamic_profiles = action.dynamic_profiles
	local profile_to_use = dynamic_profiles[current_mode]
	local var_2_0

	if action_hand then
		var_2_0 = action["damage_profile_" .. action_hand]

		if not var_2_0 then
			-- Nothing
		end
	end

	var_2_0 = not not profile_to_use or not not "default"

	::label_2_0::

	return var_2_0
end

ActionDynamicSweep._calculate_attack_direction = function (self, action, weapon_rotation)
	-- function 3
	local current_mode = self.weapon_extension:get_mode()
	local dynamic_attack_directions = action.dynamic_attack_direction
	local invert_attack_direction = dynamic_attack_directions[current_mode]
	local attack_direction_2 = action.attack_direction

	if not attack_direction_2 then
		-- Nothing
	end

	attack_direction_2 = "forward"

	local quaternion_axis = attack_direction_2

	::label_3_0::

	local attack_direction = Quaternion[quaternion_axis](weapon_rotation)
	local num

	if invert_attack_direction then
		num = -attack_direction

		if not num then
			-- Nothing
		end
	end

	num = attack_direction

	::label_3_1::

	return num
end
