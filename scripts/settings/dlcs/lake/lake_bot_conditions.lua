-- chunkname: @scripts/settings/dlcs/lake/lake_bot_conditions.lua

local BTConditions = BTConditions
local can_activate = BTConditions.can_activate

can_activate = can_activate or {}
BTConditions.can_activate = can_activate

table.merge_recursive(BTConditions.ability_check_categories, {
	activate_ability = {
		es_questingknight = true
	}
})

local num = 5
local num_2 = num * num
local num_3 = 5
local num_4 = 10

BTConditions.can_activate.es_questingknight = function (self)
	-- function 1
	local target_unit = self.target_unit

	if not ALIVE[target_unit] then
		return false
	end

	local var_1_1 = BLACKBOARDS[target_unit]

	if not var_1_1 then
		return false
	end

	if not ((target_unit ~= self.priority_target_enemy or not (self.priority_target_distance <= num) or target_unit ~= self.urgent_target_enemy) and (not (self.urgent_target_distance <= num) or target_unit ~= self.opportunity_target_enemy or not (self.opportunity_target_distance <= num))) then
		return true
	end

	local breed = var_1_1.breed
	local threat_value

	if not breed then
		threat_value = breed.threat_value

		if not threat_value then
			-- Nothing
		end
	end

	threat_value = 0

	::label_1_0::

	if threat_value >= num_3 then
		local unit = self.unit
		local var_1_5 = POSITION_LOOKUP[unit]
		local proximite_enemies = self.proximite_enemies
		local count = #proximite_enemies
		local num_5 = 0

		for i = 1, count do
			local var_1_9 = proximite_enemies[i]
			local var_1_10 = POSITION_LOOKUP[var_1_9]

			if not (not ALIVE[var_1_9] and not (Vector3.distance_squared(var_1_5, var_1_10) <= num_2)) then
				num_5 = num_5 + BLACKBOARDS[var_1_9].breed.threat_value

				if num_5 >= num_4 then
					return true
				end
			end
		end
	end

	return false
end
