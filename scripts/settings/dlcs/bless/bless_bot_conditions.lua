-- chunkname: @scripts/settings/dlcs/bless/bless_bot_conditions.lua

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local BTConditions = BTConditions
local can_activate = BTConditions.can_activate

can_activate = can_activate or {}
BTConditions.can_activate = can_activate

local BTConditions_2 = BTConditions
local can_activate_non_combat = BTConditions.can_activate_non_combat

can_activate_non_combat = can_activate_non_combat or {}
BTConditions_2.can_activate_non_combat = can_activate_non_combat

table.merge_recursive(BTConditions.ability_check_categories, {
	activate_ability = {
		wh_priest = true
	}
})

local num = 15
local num_2 = 10
local num_3 = 5
local num_4 = 15

local function fn(arg_1_0)
	-- function 1
	local has_extension = ScriptUnit.has_extension(arg_1_0, "buff_system")

	return not has_extension and has_extension:has_buff_perk(scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.invulnerable)
end

BTConditions.can_activate.wh_priest = function (self)
	-- function 2
	local unit = self.unit
	local target_ally_unit = self.target_ally_unit
	local flag = false
	local flag_2 = false

	if not (not ALIVE[unit] and not ALIVE[target_ally_unit] and not self.ally_distance and not (self.ally_distance < num)) then
		local has_extension = ScriptUnit.has_extension(target_ally_unit, "status_system")

		if not has_extension then
			if has_extension:is_pounced_down() or has_extension:is_grabbed_by_pack_master() or not has_extension:is_grabbed_by_corruptor() then
				flag = true
			end

			if not flag then
				local has_extension_2 = ScriptUnit.has_extension(unit, "talent_system")

				if not (not has_extension_2 and has_extension_2:has_talent("victor_priest_6_3")) and not has_extension:is_knocked_down() then
					flag = true
				end
			end
		end
	end

	if not flag then
		local ally_distance = self.ally_distance

		ally_distance = not ally_distance and self.ally_distance > num

		local target_unit = self.target_unit
		local var_2_8 = BLACKBOARDS[target_unit]
		local flag_3 = not var_2_8 and var_2_8.breed
		local threat_value

		if not flag_3 then
			threat_value = flag_3.threat_value

			if not threat_value then
				-- Nothing
			end
		end

		threat_value = 0

		::label_2_0::

		if threat_value >= num_3 then
			local unit_2 = self.unit
			local var_2_12 = POSITION_LOOKUP[unit_2]
			local proximite_enemies = self.proximite_enemies
			local count = #proximite_enemies
			local num_5 = 0
			local num_6 = 0
			local num_7 = 0

			for i = 1, count do
				local var_2_18 = proximite_enemies[i]
				local var_2_19 = POSITION_LOOKUP[var_2_18]

				if not ALIVE[var_2_18] then
					local threat_value_2 = BLACKBOARDS[var_2_18].breed.threat_value

					if not ally_distance then
						num_6 = num_6 + threat_value_2

						if num_6 > num_4 then
							break
						end
					elseif Vector3.distance_squared(var_2_12, var_2_19) <= num_2 then
						num_6 = num_6 + threat_value_2
					else
						num_7 = num_7 + threat_value_2

						if num_7 > num_4 then
							break
						end
					end
				end
			end

			if not (not self.ally_distance and not (self.ally_distance <= 3.2)) then
				num_7 = math.max(num_6, num_7)
			end

			if num_7 > num_4 then
				flag = true
			elseif num_6 > num_4 then
				flag_2 = true
			end
		end
	end

	if flag or not flag_2 then
		local var_2_21

		if not (not flag and fn(target_ally_unit)) then
			var_2_21 = target_ally_unit
		elseif not (not flag_2 and fn(unit)) then
			var_2_21 = unit
		end

		self.activate_ability_data.target_unit = var_2_21

		return var_2_21 ~= nil
	end

	return false
end
