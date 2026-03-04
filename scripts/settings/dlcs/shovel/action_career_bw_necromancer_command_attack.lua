-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_command_attack.lua

ActionCareerBWNecromancerCommandAttack = class(ActionCareerBWNecromancerCommandAttack, ActionBase)

local var_0_0 = {
	critter_rat = true
}
local var_0_1 = {}
local var_0_2 = {}
local var_0_3 = {}
local var_0_4 = {}

ActionCareerBWNecromancerCommandAttack.pre_calculate_target = function (arg_1_0)
	local var_1_0 = ScriptUnit.extension(arg_1_0, "ai_commander_system")
	local var_1_1 = ScriptUnit.extension(arg_1_0, "first_person_system")
	local var_1_2 = var_1_0:get_controlled_units()

	if table.is_empty(var_1_2) then
		return nil
	end

	local var_1_3 = var_1_1:current_position()
	local var_1_4 = Quaternion.forward(var_1_1:current_rotation())
	local var_1_5 = Managers.state.side.side_by_unit[arg_1_0].enemy_broadphase_categories

	table.clear(var_0_4)

	local var_1_6 = 50
	local var_1_7 = AiUtils.broadphase_query(var_1_3, var_1_6, var_0_2, var_1_5)

	for iter_1_0 = 1, var_1_7 do
		var_0_4[iter_1_0] = var_0_2[iter_1_0]
	end

	local var_1_8 = PlayerUtils.broadphase_query(var_1_3, var_1_6, var_0_3, var_1_5)

	for iter_1_1 = 1, var_1_8 do
		local var_1_9 = ScriptUnit.has_extension(var_0_3[iter_1_1], "status_system")

		if not (var_1_9 and var_1_9:is_invisible()) then
			var_0_4[#var_0_4 + 1] = var_0_3[iter_1_1]
		end
	end

	local var_1_10 = 1
	local var_1_11 = 1
	local var_1_12 = 1
	local var_1_13 = 1.5
	local var_1_14 = TrueFlightUtility.sort(var_0_4, var_1_3, var_1_4, var_1_10, var_1_11, var_1_12, var_1_6, 0.7, 1.8, var_1_13)

	for iter_1_2 = 1, var_1_7 + var_1_8 do
		repeat
			local var_1_15 = var_0_4[iter_1_2]
			local var_1_16 = BLACKBOARDS[var_1_15]
			local var_1_17 = var_1_16 and var_1_16.breed.name

			if var_1_14[var_1_15] == 0 then
				return false
			end

			if var_0_0[var_1_17] or not HEALTH_ALIVE[var_1_15] then
				break
			end

			if not AiUtils.line_of_sight_from_random_point(var_1_3, var_1_15, math.huge) then
				break
			end

			var_0_1[arg_1_0] = var_1_15

			return true
		until true
	end
end

ActionCareerBWNecromancerCommandAttack.init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	ActionCareerBWNecromancerCommandAttack.super.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)

	arg_2_0._buff_extension = ScriptUnit.extension(arg_2_4, "buff_system")
	arg_2_0._commander_extension = ScriptUnit.extension(arg_2_4, "ai_commander_system")
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_4, "first_person_system")
	arg_2_0._career_extension = ScriptUnit.has_extension(arg_2_4, "career_system")
	arg_2_0._command_ability = arg_2_0._career_extension:get_passive_ability_by_name("bw_necromancer_command")
	arg_2_0._owner_unit = arg_2_4
end

ActionCareerBWNecromancerCommandAttack.client_owner_start_action = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	ActionCareerBWNecromancerCommandAttack.super.client_owner_start_action(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	local var_3_0 = var_0_1[arg_3_0._owner_unit]

	var_0_1[arg_3_0._owner_unit] = nil

	if ALIVE[var_3_0] then
		local var_3_1 = arg_3_0:_is_charge_off_cooldown() and arg_3_0:_has_armored_pet()

		arg_3_0._command_ability:command_attack_enemy(var_3_0, var_3_1, arg_3_2)
	end
end

ActionCareerBWNecromancerCommandAttack.client_owner_post_update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	return
end

ActionCareerBWNecromancerCommandAttack.destroy = function (arg_5_0)
	return
end

ActionCareerBWNecromancerCommandAttack._select_target = function (arg_6_0)
	return
end

ActionCareerBWNecromancerCommandAttack._is_charge_off_cooldown = function (arg_7_0)
	return arg_7_0._buff_extension:get_buff_type("sienna_necromancer_6_3_available_charge")
end

ActionCareerBWNecromancerCommandAttack._has_armored_pet = function (arg_8_0)
	for iter_8_0, iter_8_1 in pairs(arg_8_0._commander_extension:get_controlled_units()) do
		if Unit.get_data(iter_8_0, "breed").name == "pet_skeleton_armored" then
			return true
		end
	end
end
