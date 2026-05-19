-- chunkname: @scripts/entity_system/systems/statistics/statistics_system.lua

require("scripts/entity_system/systems/statistics/statistics_templates")

StatisticsSystem = class(StatisticsSystem, ExtensionSystemBase)

local var_0_0 = {
	"StatisticsExtension"
}
local var_0_1 = {
	"rpc_register_kill"
}

function StatisticsSystem.init(arg_1_0, arg_1_1, arg_1_2)
	StatisticsSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0.unit_extension_data = {}

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	if not arg_1_0.is_server then
		var_1_0:register(arg_1_0, unpack(var_0_1))
	end
end

function StatisticsSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

local var_0_2 = {}

function StatisticsSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_4.template
	local var_3_1 = arg_3_4.statistics_id

	assert(var_3_0, "No statistic template set for statistics extension on unit %s", tostring(arg_3_2))
	assert(var_3_1, "No statistic id set for statistics extension on unit %s", tostring(arg_3_2))

	local var_3_2 = {
		template_category_name = var_3_0,
		statistics_id = var_3_1
	}
	local var_3_3 = StatisticsTemplateCategories[var_3_0]

	for iter_3_0 = 1, #var_3_3 do
		local var_3_4 = var_3_3[iter_3_0]

		var_3_2[var_3_4] = StatisticsTemplates[var_3_4].init()
	end

	ScriptUnit.set_extension(arg_3_2, arg_3_0.name, var_3_2, var_0_2)

	arg_3_0.unit_extension_data[arg_3_2] = var_3_2

	return var_3_2
end

function StatisticsSystem.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.unit_extension_data[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, arg_4_0.NAME)
end

function StatisticsSystem.update(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_1.statistics_db
	local var_5_1 = StatisticsTemplateCategories
	local var_5_2 = StatisticsTemplates

	for iter_5_0, iter_5_1 in pairs(arg_5_0.unit_extension_data) do
		if var_5_0:is_registered(iter_5_1.statistics_id) then
			local var_5_3 = var_5_1[iter_5_1.template_category_name]

			for iter_5_2 = 1, #var_5_3 do
				var_5_2[var_5_3[iter_5_2]].update(iter_5_0, iter_5_1, arg_5_1, arg_5_2)
			end
		end
	end
end

function StatisticsSystem.hot_join_sync(arg_6_0, arg_6_1)
	return
end

local var_0_3 = {}

function StatisticsSystem.rpc_register_kill(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.unit_storage:unit(arg_7_2)

	table.clear(var_0_3)

	var_0_3[DamageDataIndex.DAMAGE_AMOUNT] = NetworkConstants.damage.max
	var_0_3[DamageDataIndex.DAMAGE_TYPE] = "forced"
	var_0_3[DamageDataIndex.ATTACKER] = var_7_0
	var_0_3[DamageDataIndex.HIT_ZONE] = "full"
	var_0_3[DamageDataIndex.POSITION] = Unit.world_position(var_7_0, 0)
	var_0_3[DamageDataIndex.DIRECTION] = Vector3.down()
	var_0_3[DamageDataIndex.DAMAGE_SOURCE_NAME] = "suicide"
	var_0_3[DamageDataIndex.HIT_RAGDOLL_ACTOR_NAME] = "n/a"
	var_0_3[DamageDataIndex.SOURCE_ATTACKER_UNIT] = nil
	var_0_3[DamageDataIndex.HIT_REACT_TYPE] = "light"
	var_0_3[DamageDataIndex.CRITICAL_HIT] = false
	var_0_3[DamageDataIndex.FIRST_HIT] = true
	var_0_3[DamageDataIndex.TOTAL_HITS] = 0
	var_0_3[DamageDataIndex.TARGET_INDEX] = 1

	local var_7_1 = arg_7_0.statistics_db

	StatisticsUtil.register_kill(var_7_0, var_0_3, var_7_1, false)
end
