-- chunkname: @scripts/entity_system/systems/damage/health_trigger_system.lua

require("scripts/settings/dialogue_settings")

HealthTriggerSystem = class(HealthTriggerSystem, ExtensionSystemBase)

local var_0_0 = {
	"HealthTriggerExtension"
}

HealthTriggerSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	HealthTriggerSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0.unit_extensions = {}
end

HealthTriggerSystem.destroy = function (arg_2_0)
	assert(not next(arg_2_0.unit_extensions), "Found at least one unit that hasn't been unregistered for health trigger system.")

	arg_2_0.unit_extensions = nil
end

HealthTriggerSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, ...)
	local var_3_0 = {}

	ScriptUnit.set_extension(arg_3_2, "health_trigger_system", var_3_0)

	arg_3_0.unit_extensions[arg_3_2] = var_3_0

	GarbageLeakDetector.register_object(var_3_0, "health_trigger_extension")

	return var_3_0
end

HealthTriggerSystem.on_remove_extension = function (arg_4_0, arg_4_1, arg_4_2)
	assert(ScriptUnit.has_extension(arg_4_1, "health_trigger_system"), "Trying to remove non-existing extension %q from unit %s", arg_4_2, arg_4_1)
	ScriptUnit.remove_extension(arg_4_1, "health_trigger_system")

	arg_4_0.unit_extensions[arg_4_1] = nil
end

HealthTriggerSystem.extensions_ready = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	assert(arg_5_0.is_server, "[HealthTriggerSystem] Clients should not hold health trigger extensions")

	local var_5_0 = arg_5_0.unit_extensions[arg_5_2]

	var_5_0.health_extension = ScriptUnit.extension(arg_5_2, "health_system")

	assert(var_5_0.health_extension)

	var_5_0.last_health_percent = var_5_0.health_extension:current_health_percent()
	var_5_0.last_health_tick_percent = var_5_0.health_extension:current_health_percent()
	var_5_0.dialogue_input = ScriptUnit.extension_input(arg_5_2, "dialogue_system")
	var_5_0.tick_time = 0
end

local var_0_1 = HealthTriggerSettings.levels
local var_0_2 = HealthTriggerSettings.rapid_health_loss

HealthTriggerSystem.update = function (arg_6_0, arg_6_1, arg_6_2)
	for iter_6_0, iter_6_1 in pairs(arg_6_0.unit_extensions) do
		local var_6_0 = iter_6_1.last_health_percent
		local var_6_1 = iter_6_1.health_extension:current_health_percent()

		if var_6_0 ~= var_6_1 then
			iter_6_1.last_health_percent = var_6_1

			for iter_6_2, iter_6_3 in ipairs(var_0_1) do
				if iter_6_3 < var_6_0 and var_6_1 <= iter_6_3 then
					local var_6_2 = FrameTable.alloc_table()

					var_6_2.trigger_type = "decreasing"
					var_6_2.current_amount = var_6_1
					var_6_2.last_amount = var_6_0

					iter_6_1.dialogue_input:trigger_dialogue_event("health_trigger", var_6_2)

					local var_6_3 = ScriptUnit.extension(iter_6_0, "dialogue_system").context.player_profile

					SurroundingAwareSystem.add_event(iter_6_0, "enemy_health_trigger", DialogueSettings.default_view_distance, "trigger_type", "decreasing", "current_amount", var_6_2.current_amount, "last_amount", var_6_2.last_amount, "target_name", var_6_3)
				elseif var_6_0 < iter_6_3 and iter_6_3 <= var_6_1 then
					local var_6_4 = FrameTable.alloc_table()

					var_6_4.trigger_type = "increasing"
					var_6_4.current_amount = var_6_1
					var_6_4.last_amount = var_6_0

					iter_6_1.dialogue_input:trigger_dialogue_event("health_trigger", var_6_4)

					local var_6_5 = ScriptUnit.extension(iter_6_0, "dialogue_system").context.player_profile

					SurroundingAwareSystem.add_event(iter_6_0, "enemy_health_trigger", DialogueSettings.default_view_distance, "trigger_type", "increasing", "current_amount", var_6_4.current_amount, "last_amount", var_6_4.last_amount, "target_name", var_6_5)
				end
			end
		end

		if arg_6_2 > iter_6_1.tick_time + var_0_2.tick_time then
			iter_6_1.tick_time = arg_6_2

			local var_6_6 = iter_6_1.last_health_tick_percent

			iter_6_1.last_health_tick_percent = var_6_1

			local var_6_7 = var_6_6 - var_6_1
			local var_6_8 = var_0_2.tick_loss_threshold
			local var_6_9 = ScriptUnit.extension(iter_6_0, "status_system")

			if var_6_8 < var_6_7 and not var_6_9:is_wounded() and var_6_1 > 0 then
				local var_6_10 = ScriptUnit.extension(iter_6_0, "dialogue_system").context.player_profile
				local var_6_11 = FrameTable.alloc_table()

				var_6_11.trigger_type = "losing_rapidly"
				var_6_11.target_name = var_6_10

				iter_6_1.dialogue_input:trigger_dialogue_event("health_trigger", var_6_11)

				local var_6_12 = Managers.state.entity:system("dialogue_system"):player_shield_check(iter_6_0, "slot_melee")

				SurroundingAwareSystem.add_event(iter_6_0, "health_trigger", DialogueSettings.default_view_distance, "trigger_type", "losing_rapidly", "has_shield", var_6_12, "target_name", var_6_10)
			end
		end
	end
end
