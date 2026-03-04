-- chunkname: @scripts/entity_system/systems/locomotion/locomotion_templates_ai_c.lua

LocomotionTemplates.AILocomotionExtensionC = {}

LocomotionTemplates.AILocomotionExtensionC.init = function (arg_1_0, arg_1_1)
	return
end

LocomotionTemplates.AILocomotionExtensionC.update = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = EngineOptimizedExtensions.ai_locomotion_update(arg_2_1, arg_2_2)

	if var_2_0 then
		local var_2_1 = ScriptUnit.extension
		local var_2_2 = ScriptUnit.has_extension
		local var_2_3 = Managers.state.conflict
		local var_2_4 = Managers.player:statistics_db()
		local var_2_5 = Managers.state.network
		local var_2_6 = var_2_5.network_transmit
		local var_2_7 = FrameTable.alloc_table()

		var_2_7[DamageDataIndex.DAMAGE_AMOUNT] = NetworkConstants.damage.max
		var_2_7[DamageDataIndex.DAMAGE_TYPE] = "forced"
		var_2_7[DamageDataIndex.HIT_ZONE] = "full"
		var_2_7[DamageDataIndex.DIRECTION] = Vector3.down()
		var_2_7[DamageDataIndex.DAMAGE_SOURCE_NAME] = "suicide"
		var_2_7[DamageDataIndex.HIT_RAGDOLL_ACTOR_NAME] = "n/a"
		var_2_7[DamageDataIndex.HIT_REACT_TYPE] = "light"
		var_2_7[DamageDataIndex.CRITICAL_HIT] = false
		var_2_7[DamageDataIndex.FIRST_HIT] = true
		var_2_7[DamageDataIndex.TOTAL_HITS] = 1
		var_2_7[DamageDataIndex.BACKSTAB_MULTIPLIER] = 1
		var_2_7[DamageDataIndex.TARGET_INDEX] = 1

		for iter_2_0 = 1, #var_2_0 do
			print("Destroying unit since outside mesh or world")

			local var_2_8 = var_2_0[iter_2_0]
			local var_2_9 = var_2_1(var_2_8, "ai_system")._blackboard

			var_2_7[DamageDataIndex.ATTACKER] = var_2_8
			var_2_7[DamageDataIndex.POSITION] = Unit.world_position(var_2_8, 0)
			var_2_7[DamageDataIndex.SOURCE_ATTACKER_UNIT] = var_2_8

			local var_2_10 = var_2_2(var_2_8, "buff_system")

			if var_2_10 then
				var_2_10:trigger_procs("on_death", var_2_8)
			end

			StatisticsUtil.register_kill(var_2_8, var_2_7, var_2_4, true)

			local var_2_11 = var_2_5:unit_game_object_id(var_2_8)

			var_2_6:send_rpc_clients("rpc_register_kill", var_2_11)
			var_2_3:destroy_unit(var_2_8, var_2_9, "out_of_range")
		end
	end
end
