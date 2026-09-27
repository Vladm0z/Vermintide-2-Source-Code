-- chunkname: @scripts/entity_system/systems/locomotion/locomotion_templates_ai_c.lua

LocomotionTemplates.AILocomotionExtensionC = {}

LocomotionTemplates.AILocomotionExtensionC.init = function (arg_1_0, arg_1_1)
	-- function 1
	return
end

LocomotionTemplates.AILocomotionExtensionC.update = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local ai_locomotion_update = EngineOptimizedExtensions.ai_locomotion_update(arg_2_1, arg_2_2)

	if not ai_locomotion_update then
		local extension = ScriptUnit.extension
		local has_extension = ScriptUnit.has_extension
		local conflict = Managers.state.conflict
		local statistics_db = Managers.player:statistics_db()
		local network = Managers.state.network
		local network_transmit = network.network_transmit
		local alloc_table = FrameTable.alloc_table()

		alloc_table[DamageDataIndex.DAMAGE_AMOUNT] = NetworkConstants.damage.max
		alloc_table[DamageDataIndex.DAMAGE_TYPE] = "forced"
		alloc_table[DamageDataIndex.HIT_ZONE] = "full"
		alloc_table[DamageDataIndex.DIRECTION] = Vector3.down()
		alloc_table[DamageDataIndex.DAMAGE_SOURCE_NAME] = "suicide"
		alloc_table[DamageDataIndex.HIT_RAGDOLL_ACTOR_NAME] = "n/a"
		alloc_table[DamageDataIndex.HIT_REACT_TYPE] = "light"
		alloc_table[DamageDataIndex.CRITICAL_HIT] = false
		alloc_table[DamageDataIndex.FIRST_HIT] = true
		alloc_table[DamageDataIndex.TOTAL_HITS] = 1
		alloc_table[DamageDataIndex.BACKSTAB_MULTIPLIER] = 1
		alloc_table[DamageDataIndex.TARGET_INDEX] = 1

		for i = 1, #ai_locomotion_update do
			print("Destroying unit since outside mesh or world")

			local var_2_8 = ai_locomotion_update[i]
			local _blackboard = extension(var_2_8, "ai_system")._blackboard

			alloc_table[DamageDataIndex.ATTACKER] = var_2_8
			alloc_table[DamageDataIndex.POSITION] = Unit.world_position(var_2_8, 0)
			alloc_table[DamageDataIndex.SOURCE_ATTACKER_UNIT] = var_2_8

			local var_2_10 = has_extension(var_2_8, "buff_system")

			if not var_2_10 then
				var_2_10:trigger_procs("on_death", var_2_8)
			end

			StatisticsUtil.register_kill(var_2_8, alloc_table, statistics_db, true)

			local unit_game_object_id = network:unit_game_object_id(var_2_8)

			network_transmit:send_rpc_clients("rpc_register_kill", unit_game_object_id)
			conflict:destroy_unit(var_2_8, _blackboard, "out_of_range")
		end
	end
end
