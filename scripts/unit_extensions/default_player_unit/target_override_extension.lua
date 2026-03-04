-- chunkname: @scripts/unit_extensions/default_player_unit/target_override_extension.lua

local var_0_0 = require("scripts/utils/stagger_types")

TargetOverrideExtension = class(TargetOverrideExtension)

local var_0_1 = 0.75
local var_0_2 = 5

function TargetOverrideExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._result_table = {}
	arg_1_0._stagger_impact = {
		var_0_0.medium,
		var_0_0.weak,
		var_0_0.explosion,
		var_0_0.none,
		var_0_0.medium
	}
	arg_1_0._side = arg_1_3.side
	arg_1_0._broadphase_categories = arg_1_0._side.enemy_broadphase_categories
end

function TargetOverrideExtension.destroy(arg_2_0)
	return
end

function TargetOverrideExtension.taunt(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0._unit
	local var_3_1 = Managers.time:time("game")
	local var_3_2 = var_3_1 + arg_3_2
	local var_3_3 = POSITION_LOOKUP[var_3_0]
	local var_3_4 = arg_3_0._result_table
	local var_3_5 = AiUtils.broadphase_query(var_3_3, arg_3_1, var_3_4, arg_3_0._broadphase_categories)

	for iter_3_0 = 1, var_3_5 do
		local var_3_6 = var_3_4[iter_3_0]
		local var_3_7 = ScriptUnit.extension(var_3_6, "ai_system")
		local var_3_8 = var_3_7:blackboard()
		local var_3_9 = var_3_7:breed()

		if not var_3_9.ignore_taunts and (not var_3_9.boss or arg_3_4) then
			if var_3_8.target_unit == var_3_0 then
				var_3_8.no_taunt_hesitate = true
			end

			var_3_8.taunt_unit = var_3_0
			var_3_8.taunt_end_time = var_3_2
			var_3_8.target_unit = var_3_0
			var_3_8.target_unit_found_time = var_3_1

			if arg_3_3 then
				local var_3_10 = POSITION_LOOKUP[var_3_6] - var_3_3

				AiUtils.stagger_target(var_3_0, var_3_6, 1, arg_3_0._stagger_impact, var_3_10, var_3_1)
			end
		end
	end
end

function TargetOverrideExtension.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = POSITION_LOOKUP[arg_4_1] or Unit.world_position(arg_4_1, 0)
	local var_4_1 = var_0_1
	local var_4_2 = arg_4_0._result_table
	local var_4_3 = arg_4_5 + var_0_2
	local var_4_4 = ScriptUnit.extension(arg_4_1, "status_system")
	local var_4_5 = var_4_4:is_disabled()
	local var_4_6 = var_4_4:is_invisible()

	if not var_4_5 and not var_4_6 then
		local var_4_7 = Managers.state.entity:system("ai_system")
		local var_4_8 = Managers.state.entity:system("ai_slot_system")
		local var_4_9 = AiUtils.broadphase_query(var_4_0, var_4_1, var_4_2, arg_4_0._broadphase_categories)

		for iter_4_0 = 1, var_4_9 do
			local var_4_10 = var_4_2[iter_4_0]

			if ScriptUnit.has_extension(var_4_10, "ai_slot_system") then
				local var_4_11 = ScriptUnit.extension(var_4_10, "ai_system")
				local var_4_12 = var_4_11:blackboard()
				local var_4_13 = var_4_12.override_targets[arg_4_1]

				var_4_12.override_targets[arg_4_1] = var_4_3

				if var_4_13 == nil or var_4_13 < arg_4_5 then
					var_4_7:register_prioritized_perception_unit_update(var_4_10, var_4_11)
					var_4_8:register_prioritized_ai_unit_update(var_4_10)
				end
			end
		end
	end
end

function TargetOverrideExtension.add_to_override_targets(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_4 + var_0_2
	local var_5_1 = arg_5_3.override_targets[arg_5_2]

	arg_5_3.override_targets[arg_5_2] = var_5_0

	if var_5_1 == nil or var_5_1 < arg_5_4 then
		local var_5_2 = Managers.state.entity:system("ai_system")
		local var_5_3 = Managers.state.entity:system("ai_slot_system")
		local var_5_4 = ScriptUnit.extension(arg_5_1, "ai_system")

		var_5_2:register_prioritized_perception_unit_update(arg_5_1, var_5_4)
		var_5_3:register_prioritized_ai_unit_update(arg_5_1)
	end
end
