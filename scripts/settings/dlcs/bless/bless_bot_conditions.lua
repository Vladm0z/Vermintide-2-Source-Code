-- chunkname: @scripts/settings/dlcs/bless/bless_bot_conditions.lua

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

BTConditions.can_activate = BTConditions.can_activate or {}
BTConditions.can_activate_non_combat = BTConditions.can_activate_non_combat or {}

table.merge_recursive(BTConditions.ability_check_categories, {
	activate_ability = {
		wh_priest = true
	}
})

local var_0_1 = 15
local var_0_2 = 10
local var_0_3 = 5
local var_0_4 = 15

local function var_0_5(arg_1_0)
	local var_1_0 = ScriptUnit.has_extension(arg_1_0, "buff_system")

	return not var_1_0 or var_1_0:has_buff_perk(var_0_0.invulnerable)
end

function BTConditions.can_activate.wh_priest(arg_2_0)
	local var_2_0 = arg_2_0.unit
	local var_2_1 = arg_2_0.target_ally_unit
	local var_2_2 = false
	local var_2_3 = false

	if ALIVE[var_2_0] and ALIVE[var_2_1] and arg_2_0.ally_distance and arg_2_0.ally_distance < var_0_1 then
		local var_2_4 = ScriptUnit.has_extension(var_2_1, "status_system")

		if var_2_4 then
			if var_2_4:is_pounced_down() or var_2_4:is_grabbed_by_pack_master() or var_2_4:is_grabbed_by_corruptor() then
				var_2_2 = true
			end

			if not var_2_2 then
				local var_2_5 = ScriptUnit.has_extension(var_2_0, "talent_system")

				if var_2_5 and var_2_5:has_talent("victor_priest_6_3") and var_2_4:is_knocked_down() then
					var_2_2 = true
				end
			end
		end
	end

	if not var_2_2 then
		local var_2_6 = arg_2_0.ally_distance and arg_2_0.ally_distance > var_0_1
		local var_2_7 = arg_2_0.target_unit
		local var_2_8 = BLACKBOARDS[var_2_7]
		local var_2_9 = var_2_8 and var_2_8.breed

		if (var_2_9 and var_2_9.threat_value or 0) >= var_0_3 then
			local var_2_10 = arg_2_0.unit
			local var_2_11 = POSITION_LOOKUP[var_2_10]
			local var_2_12 = arg_2_0.proximite_enemies
			local var_2_13 = #var_2_12
			local var_2_14 = 0
			local var_2_15 = 0
			local var_2_16 = 0

			for iter_2_0 = 1, var_2_13 do
				local var_2_17 = var_2_12[iter_2_0]
				local var_2_18 = POSITION_LOOKUP[var_2_17]

				if ALIVE[var_2_17] then
					local var_2_19 = BLACKBOARDS[var_2_17].breed.threat_value

					if var_2_6 then
						var_2_15 = var_2_15 + var_2_19

						if var_2_15 > var_0_4 then
							break
						end
					elseif Vector3.distance_squared(var_2_11, var_2_18) <= var_0_2 then
						var_2_15 = var_2_15 + var_2_19
					else
						var_2_16 = var_2_16 + var_2_19

						if var_2_16 > var_0_4 then
							break
						end
					end
				end
			end

			if arg_2_0.ally_distance and arg_2_0.ally_distance <= 3.2 then
				var_2_16 = math.max(var_2_15, var_2_16)
			end

			if var_2_16 > var_0_4 then
				var_2_2 = true
			elseif var_2_15 > var_0_4 then
				var_2_3 = true
			end
		end
	end

	if var_2_2 or var_2_3 then
		local var_2_20

		if var_2_2 and not var_0_5(var_2_1) then
			var_2_20 = var_2_1
		elseif var_2_3 and not var_0_5(var_2_0) then
			var_2_20 = var_2_0
		end

		arg_2_0.activate_ability_data.target_unit = var_2_20

		return var_2_20 ~= nil
	end

	return false
end
