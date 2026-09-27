-- chunkname: @scripts/entity_system/systems/damage/health_trigger_system.lua

require("scripts/settings/dialogue_settings")

HealthTriggerSystem = class(HealthTriggerSystem, ExtensionSystemBase)

local tbl = {
	"HealthTriggerExtension"
}

HealthTriggerSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	HealthTriggerSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self.unit_extensions = {}
end

HealthTriggerSystem.destroy = function (self)
	-- function 2
	assert(not next(self.unit_extensions), "Found at least one unit that hasn't been unregistered for health trigger system.")

	self.unit_extensions = nil
end

HealthTriggerSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, ...)
	-- function 3
	local tbl = {}

	ScriptUnit.set_extension(arg_3_2, "health_trigger_system", tbl)

	arg_3_0.unit_extensions[arg_3_2] = tbl

	GarbageLeakDetector.register_object(tbl, "health_trigger_extension")

	return tbl
end

HealthTriggerSystem.on_remove_extension = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	assert(ScriptUnit.has_extension(arg_4_1, "health_trigger_system"), "Trying to remove non-existing extension %q from unit %s", arg_4_2, arg_4_1)
	ScriptUnit.remove_extension(arg_4_1, "health_trigger_system")

	arg_4_0.unit_extensions[arg_4_1] = nil
end

HealthTriggerSystem.extensions_ready = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	assert(self.is_server, "[HealthTriggerSystem] Clients should not hold health trigger extensions")

	local var_5_0 = self.unit_extensions[arg_5_2]

	var_5_0.health_extension = ScriptUnit.extension(arg_5_2, "health_system")

	assert(var_5_0.health_extension)

	var_5_0.last_health_percent = var_5_0.health_extension:current_health_percent()
	var_5_0.last_health_tick_percent = var_5_0.health_extension:current_health_percent()
	var_5_0.dialogue_input = ScriptUnit.extension_input(arg_5_2, "dialogue_system")
	var_5_0.tick_time = 0
end

local levels = HealthTriggerSettings.levels
local rapid_health_loss = HealthTriggerSettings.rapid_health_loss

HealthTriggerSystem.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	for k, v in pairs(self.unit_extensions) do
		local last_health_percent = v.last_health_percent
		local current_health_percent = v.health_extension:current_health_percent()

		if last_health_percent ~= current_health_percent then
			v.last_health_percent = current_health_percent

			for i, v_2 in ipairs(levels) do
				if not (not (v_2 < last_health_percent) or not (current_health_percent <= v_2)) then
					local alloc_table = FrameTable.alloc_table()

					alloc_table.trigger_type = "decreasing"
					alloc_table.current_amount = current_health_percent
					alloc_table.last_amount = last_health_percent

					v.dialogue_input:trigger_dialogue_event("health_trigger", alloc_table)

					local player_profile = ScriptUnit.extension(k, "dialogue_system").context.player_profile

					SurroundingAwareSystem.add_event(k, "enemy_health_trigger", DialogueSettings.default_view_distance, "trigger_type", "decreasing", "current_amount", alloc_table.current_amount, "last_amount", alloc_table.last_amount, "target_name", player_profile)
				elseif not (not (last_health_percent < v_2) or not (v_2 <= current_health_percent)) then
					local alloc_table_2 = FrameTable.alloc_table()

					alloc_table_2.trigger_type = "increasing"
					alloc_table_2.current_amount = current_health_percent
					alloc_table_2.last_amount = last_health_percent

					v.dialogue_input:trigger_dialogue_event("health_trigger", alloc_table_2)

					local player_profile_2 = ScriptUnit.extension(k, "dialogue_system").context.player_profile

					SurroundingAwareSystem.add_event(k, "enemy_health_trigger", DialogueSettings.default_view_distance, "trigger_type", "increasing", "current_amount", alloc_table_2.current_amount, "last_amount", alloc_table_2.last_amount, "target_name", player_profile_2)
				end
			end
		end

		if arg_6_2 > v.tick_time + rapid_health_loss.tick_time then
			v.tick_time = arg_6_2

			local last_health_tick_percent = v.last_health_tick_percent

			v.last_health_tick_percent = current_health_percent

			local num = last_health_tick_percent - current_health_percent
			local tick_loss_threshold = rapid_health_loss.tick_loss_threshold
			local extension = ScriptUnit.extension(k, "status_system")

			if not (not (tick_loss_threshold < num) or extension:is_wounded() or not (current_health_percent > 0)) then
				local player_profile_3 = ScriptUnit.extension(k, "dialogue_system").context.player_profile
				local alloc_table_3 = FrameTable.alloc_table()

				alloc_table_3.trigger_type = "losing_rapidly"
				alloc_table_3.target_name = player_profile_3

				v.dialogue_input:trigger_dialogue_event("health_trigger", alloc_table_3)

				local player_shield_check = Managers.state.entity:system("dialogue_system"):player_shield_check(k, "slot_melee")

				SurroundingAwareSystem.add_event(k, "health_trigger", DialogueSettings.default_view_distance, "trigger_type", "losing_rapidly", "has_shield", player_shield_check, "target_name", player_profile_3)
			end
		end
	end
end
