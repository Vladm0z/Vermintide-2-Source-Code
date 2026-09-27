-- chunkname: @scripts/entity_system/systems/statistics/statistics_system.lua

require("scripts/entity_system/systems/statistics/statistics_templates")

StatisticsSystem = class(StatisticsSystem, ExtensionSystemBase)

local tbl = {
	"StatisticsExtension"
}
local tbl_2 = {
	"rpc_register_kill"
}

StatisticsSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	StatisticsSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self.unit_extension_data = {}

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	if not self.is_server then
		network_event_delegate:register(self, unpack(tbl_2))
	end
end

StatisticsSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

local tbl_3 = {}

StatisticsSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local template = arg_3_4.template
	local statistics_id = arg_3_4.statistics_id

	assert(template, "No statistic template set for statistics extension on unit %s", tostring(arg_3_2))
	assert(statistics_id, "No statistic id set for statistics extension on unit %s", tostring(arg_3_2))

	local tbl = {
		template_category_name = template,
		statistics_id = statistics_id
	}
	local var_3_3 = StatisticsTemplateCategories[template]

	for i = 1, #var_3_3 do
		local var_3_4 = var_3_3[i]

		tbl[var_3_4] = StatisticsTemplates[var_3_4].init()
	end

	ScriptUnit.set_extension(arg_3_2, self.name, tbl, tbl_3)

	self.unit_extension_data[arg_3_2] = tbl

	return tbl
end

StatisticsSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.unit_extension_data[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, self.NAME)
end

StatisticsSystem.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local statistics_db = arg_5_1.statistics_db
	local StatisticsTemplateCategories = StatisticsTemplateCategories
	local StatisticsTemplates = StatisticsTemplates

	for k, v in pairs(self.unit_extension_data) do
		if not statistics_db:is_registered(v.statistics_id) then
			local var_5_3 = StatisticsTemplateCategories[v.template_category_name]

			for k_2 = 1, #var_5_3 do
				StatisticsTemplates[var_5_3[k_2]].update(k, v, arg_5_1, arg_5_2)
			end
		end
	end
end

StatisticsSystem.hot_join_sync = function (arg_6_0, arg_6_1)
	-- function 6
	return
end

local tbl_4 = {}

StatisticsSystem.rpc_register_kill = function (self, arg_7_1, arg_7_2)
	-- function 7
	local unit = self.unit_storage:unit(arg_7_2)

	table.clear(tbl_4)

	tbl_4[DamageDataIndex.DAMAGE_AMOUNT] = NetworkConstants.damage.max
	tbl_4[DamageDataIndex.DAMAGE_TYPE] = "forced"
	tbl_4[DamageDataIndex.ATTACKER] = unit
	tbl_4[DamageDataIndex.HIT_ZONE] = "full"
	tbl_4[DamageDataIndex.POSITION] = Unit.world_position(unit, 0)
	tbl_4[DamageDataIndex.DIRECTION] = Vector3.down()
	tbl_4[DamageDataIndex.DAMAGE_SOURCE_NAME] = "suicide"
	tbl_4[DamageDataIndex.HIT_RAGDOLL_ACTOR_NAME] = "n/a"
	tbl_4[DamageDataIndex.SOURCE_ATTACKER_UNIT] = nil
	tbl_4[DamageDataIndex.HIT_REACT_TYPE] = "light"
	tbl_4[DamageDataIndex.CRITICAL_HIT] = false
	tbl_4[DamageDataIndex.FIRST_HIT] = true
	tbl_4[DamageDataIndex.TOTAL_HITS] = 0
	tbl_4[DamageDataIndex.TARGET_INDEX] = 1

	local statistics_db = self.statistics_db

	StatisticsUtil.register_kill(unit, tbl_4, statistics_db, false)
end
