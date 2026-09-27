-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_command_attack.lua

ActionCareerBWNecromancerCommandAttack = class(ActionCareerBWNecromancerCommandAttack, ActionBase)

local tbl = {
	critter_rat = true
}
local tbl_2 = {}
local tbl_3 = {}
local tbl_4 = {}
local tbl_5 = {}

ActionCareerBWNecromancerCommandAttack.pre_calculate_target = function (arg_1_0)
	-- function 1
	local extension = ScriptUnit.extension(arg_1_0, "ai_commander_system")
	local extension_2 = ScriptUnit.extension(arg_1_0, "first_person_system")
	local get_controlled_units = extension:get_controlled_units()

	if not table.is_empty(get_controlled_units) then
		return nil
	end

	local current_position = extension_2:current_position()
	local forward = Quaternion.forward(extension_2:current_rotation())
	local enemy_broadphase_categories = Managers.state.side.side_by_unit[arg_1_0].enemy_broadphase_categories

	table.clear(tbl_5)

	local num = 50
	local broadphase_query = AiUtils.broadphase_query(current_position, num, tbl_3, enemy_broadphase_categories)

	for i = 1, broadphase_query do
		tbl_5[i] = tbl_3[i]
	end

	local broadphase_query_2 = PlayerUtils.broadphase_query(current_position, num, tbl_4, enemy_broadphase_categories)

	for j = 1, broadphase_query_2 do
		local has_extension = ScriptUnit.has_extension(tbl_4[j], "status_system")

		if not (not has_extension and has_extension:is_invisible()) then
			tbl_5[#tbl_5 + 1] = tbl_4[j]
		end
	end

	local num_2 = 1
	local num_3 = 1
	local num_4 = 1
	local num_5 = 1.5
	local sort = TrueFlightUtility.sort(tbl_5, current_position, forward, num_2, num_3, num_4, num, 0.7, 1.8, num_5)

	for k = 1, broadphase_query + broadphase_query_2 do
		repeat
			local var_1_15 = tbl_5[k]
			local var_1_16 = BLACKBOARDS[var_1_15]
			local flag = not var_1_16 and var_1_16.breed.name

			if sort[var_1_15] == 0 then
				return false
			end

			if not (tbl[flag] or HEALTH_ALIVE[var_1_15]) then
				break
			end

			if not AiUtils.line_of_sight_from_random_point(current_position, var_1_15, math.huge) then
				break
			end

			tbl_2[arg_1_0] = var_1_15

			return true
		until true
	end
end

ActionCareerBWNecromancerCommandAttack.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	-- function 2
	ActionCareerBWNecromancerCommandAttack.super.init(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)

	self._buff_extension = ScriptUnit.extension(arg_2_4, "buff_system")
	self._commander_extension = ScriptUnit.extension(arg_2_4, "ai_commander_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_2_4, "first_person_system")
	self._career_extension = ScriptUnit.has_extension(arg_2_4, "career_system")
	self._command_ability = self._career_extension:get_passive_ability_by_name("bw_necromancer_command")
	self._owner_unit = arg_2_4
end

ActionCareerBWNecromancerCommandAttack.client_owner_start_action = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	ActionCareerBWNecromancerCommandAttack.super.client_owner_start_action(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	local var_3_0 = tbl_2[self._owner_unit]

	tbl_2[self._owner_unit] = nil

	if not ALIVE[var_3_0] then
		local _is_charge_off_cooldown = self:_is_charge_off_cooldown()

		_is_charge_off_cooldown = not _is_charge_off_cooldown and self:_has_armored_pet()

		self._command_ability:command_attack_enemy(var_3_0, _is_charge_off_cooldown, arg_3_2)
	end
end

ActionCareerBWNecromancerCommandAttack.client_owner_post_update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	return
end

ActionCareerBWNecromancerCommandAttack.destroy = function (arg_5_0)
	-- function 5
	return
end

ActionCareerBWNecromancerCommandAttack._select_target = function (arg_6_0)
	-- function 6
	return
end

ActionCareerBWNecromancerCommandAttack._is_charge_off_cooldown = function (self)
	-- function 7
	return self._buff_extension:get_buff_type("sienna_necromancer_6_3_available_charge")
end

ActionCareerBWNecromancerCommandAttack._has_armored_pet = function (self)
	-- function 8
	for k, v in pairs(self._commander_extension:get_controlled_units()) do
		if Unit.get_data(k, "breed").name == "pet_skeleton_armored" then
			return true
		end
	end
end
