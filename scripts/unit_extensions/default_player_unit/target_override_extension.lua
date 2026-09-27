-- chunkname: @scripts/unit_extensions/default_player_unit/target_override_extension.lua

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

TargetOverrideExtension = class(TargetOverrideExtension)

local num = 0.75
local num_2 = 5

TargetOverrideExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._result_table = {}
	self._stagger_impact = {
		scripts_utils_stagger_types.medium,
		scripts_utils_stagger_types.weak,
		scripts_utils_stagger_types.explosion,
		scripts_utils_stagger_types.none,
		scripts_utils_stagger_types.medium
	}
	self._side = arg_1_3.side
	self._broadphase_categories = self._side.enemy_broadphase_categories
end

TargetOverrideExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

TargetOverrideExtension.taunt = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local _unit = self._unit
	local time = Managers.time:time("game")
	local num = time + arg_3_2
	local var_3_3 = POSITION_LOOKUP[_unit]
	local _result_table = self._result_table
	local broadphase_query = AiUtils.broadphase_query(var_3_3, arg_3_1, _result_table, self._broadphase_categories)

	for i = 1, broadphase_query do
		local var_3_6 = _result_table[i]
		local extension = ScriptUnit.extension(var_3_6, "ai_system")
		local blackboard = extension:blackboard()
		local breed = extension:breed()

		if not ((not not breed.ignore_taunts or not breed.boss) and arg_3_4) then
			if blackboard.target_unit == _unit then
				blackboard.no_taunt_hesitate = true
			end

			blackboard.taunt_unit = _unit
			blackboard.taunt_end_time = num
			blackboard.target_unit = _unit
			blackboard.target_unit_found_time = time

			if not arg_3_3 then
				local num_2 = POSITION_LOOKUP[var_3_6] - var_3_3

				AiUtils.stagger_target(_unit, var_3_6, 1, self._stagger_impact, num_2, time)
			end
		end
	end
end

TargetOverrideExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local var_4_0 = POSITION_LOOKUP[arg_4_1]

	var_4_0 = var_4_0 or Unit.world_position(arg_4_1, 0)

	local var_4_1 = num
	local _result_table = self._result_table
	local num_3 = arg_4_5 + num_2
	local extension = ScriptUnit.extension(arg_4_1, "status_system")
	local is_disabled = extension:is_disabled()
	local is_invisible = extension:is_invisible()

	if not (is_disabled or is_invisible) then
		local system = Managers.state.entity:system("ai_system")
		local system_2 = Managers.state.entity:system("ai_slot_system")
		local broadphase_query = AiUtils.broadphase_query(var_4_0, var_4_1, _result_table, self._broadphase_categories)

		for i = 1, broadphase_query do
			local var_4_10 = _result_table[i]

			if not ScriptUnit.has_extension(var_4_10, "ai_slot_system") then
				local extension_2 = ScriptUnit.extension(var_4_10, "ai_system")
				local blackboard = extension_2:blackboard()
				local var_4_13 = blackboard.override_targets[arg_4_1]

				blackboard.override_targets[arg_4_1] = num_3

				if not (var_4_13 == nil or not (var_4_13 < arg_4_5)) then
					system:register_prioritized_perception_unit_update(var_4_10, extension_2)
					system_2:register_prioritized_ai_unit_update(var_4_10)
				end
			end
		end
	end
end

TargetOverrideExtension.add_to_override_targets = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local num = arg_5_4 + num_2
	local var_5_1 = arg_5_3.override_targets[arg_5_2]

	arg_5_3.override_targets[arg_5_2] = num

	if not (var_5_1 == nil or not (var_5_1 < arg_5_4)) then
		local system = Managers.state.entity:system("ai_system")
		local system_2 = Managers.state.entity:system("ai_slot_system")
		local extension = ScriptUnit.extension(arg_5_1, "ai_system")

		system:register_prioritized_perception_unit_update(arg_5_1, extension)
		system_2:register_prioritized_ai_unit_update(arg_5_1)
	end
end
