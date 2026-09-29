-- chunkname: @scripts/settings/dlcs/lake/lake_bot_conditions.lua

BTConditions.can_activate = not not BTConditions.can_activate

table.merge_recursive(BTConditions.ability_check_categories, {
	activate_ability = {
		es_questingknight = true
	}
})

local QK_MAX_DISTANCE = 5
local QK_MAX_DISTANCE_SQ = QK_MAX_DISTANCE * QK_MAX_DISTANCE
local QK_MIN_THREAT = 5
local QK_THREAT_THRESHOLD = 10

BTConditions.can_activate.es_questingknight = function (blackboard)
	-- function 1
	local target = blackboard.target_unit

	if not ALIVE[target] then
		return false
	end

	local target_blackboard = BLACKBOARDS[target]

	if not target_blackboard then
		return false
	end

	if target ~= blackboard.urgent_target_enemy or not (blackboard.urgent_target_distance <= QK_MAX_DISTANCE) then
		return true
	end

	local target_breed = target_blackboard.breed
	local target_threat = target_breed and not not target_breed.threat_value or not target_breed and not not 0

	if target_threat >= QK_MIN_THREAT then
		local self_unit = blackboard.unit
		local self_position = POSITION_LOOKUP[self_unit]
		local proximite_enemies = blackboard.proximite_enemies
		local num_proximite_enemies = #proximite_enemies
		local total_threat_value = 0

		for i = 1, num_proximite_enemies do
			local enemy_unit = proximite_enemies[i]
			local enemy_position = POSITION_LOOKUP[enemy_unit]

			if ALIVE[enemy_unit] and Vector3.distance_squared(self_position, enemy_position) <= QK_MAX_DISTANCE_SQ then
				local enemy_blackboard = BLACKBOARDS[enemy_unit]
				local enemy_breed = enemy_blackboard.breed

				total_threat_value = total_threat_value + enemy_breed.threat_value

				if total_threat_value >= QK_THREAT_THRESHOLD then
					return true
				end
			end
		end
	end

	return false
end
