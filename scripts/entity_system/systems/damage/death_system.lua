-- chunkname: @scripts/entity_system/systems/damage/death_system.lua

DeathSystem = class(DeathSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_forced_kill"
}
local var_0_1 = {
	"GenericDeathExtension"
}
local var_0_2 = BLACKBOARDS

function DeathSystem.init(arg_1_0, arg_1_1, arg_1_2)
	DeathSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0.unit_extensions = {}
	arg_1_0.frozen_unit_extensions = {}
	arg_1_0.death_reactions_to_start = {}
	arg_1_0.active_reactions = {
		unit = {},
		husk = {}
	}
	arg_1_0._current_death_reaction_killing_blow = nil
end

function DeathSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

function DeathSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = ScriptUnit.add_extension(arg_3_0.extension_init_context, arg_3_2, arg_3_3, arg_3_0.NAME, arg_3_4)

	arg_3_0.unit_extensions[arg_3_2] = var_3_0

	local var_3_1 = arg_3_4.death_reaction_template or Unit.get_data(arg_3_2, "death_reaction")

	arg_3_0:set_death_reaction_template(arg_3_2, var_3_1)
	fassert(var_3_0.death_reaction_template, "Missing death reaction template in unit data or extension init data.")

	return var_3_0
end

function DeathSystem.extensions_ready(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0.unit_extensions[arg_4_2].health_extension = ScriptUnit.extension(arg_4_2, "health_system")
end

function DeathSystem.on_remove_extension(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.frozen_unit_extensions[arg_5_1] = nil

	arg_5_0:_cleanup_extension(arg_5_1, arg_5_2)
	ScriptUnit.remove_extension(arg_5_1, arg_5_0.NAME)
end

function DeathSystem.on_freeze_extension(arg_6_0, arg_6_1, arg_6_2)
	ferror("Shouldn't get called, should run during death until unspawned/frozen.")
end

function DeathSystem._cleanup_extension(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.unit_extensions[arg_7_1]

	if var_7_0 == nil then
		return
	end

	var_7_0.death_has_started = false
	arg_7_0.unit_extensions[arg_7_1] = nil
	arg_7_0.death_reactions_to_start[arg_7_1] = nil
	arg_7_0.active_reactions[var_7_0.network_type][var_7_0.death_reaction_template][arg_7_1] = nil
end

function DeathSystem.freeze(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	fassert(arg_8_0.frozen_unit_extensions[arg_8_1] == nil, "Extension shouldn't be frozen on death")

	local var_8_0 = arg_8_0.unit_extensions[arg_8_1]

	fassert(var_8_0, "Unit to freeze didn't have unfrozen extension")
	var_8_0:freeze()
	arg_8_0:_cleanup_extension(arg_8_1, arg_8_2)

	arg_8_0.unit_extensions[arg_8_1] = nil
	arg_8_0.frozen_unit_extensions[arg_8_1] = var_8_0
end

function DeathSystem.unfreeze(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.frozen_unit_extensions[arg_9_1]

	fassert(var_9_0, "Unit to unfreeze didn't have frozen extension")

	arg_9_0.frozen_unit_extensions[arg_9_1] = nil
	arg_9_0.unit_extensions[arg_9_1] = var_9_0
end

function DeathSystem.hot_join_sync(arg_10_0, arg_10_1)
	return
end

function DeathSystem.set_death_reaction_template(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.unit_extensions[arg_11_1]

	var_11_0.death_reaction_template = arg_11_2

	local var_11_1 = var_11_0.network_type
	local var_11_2 = arg_11_0.active_reactions[var_11_1]

	var_11_2[arg_11_2] = var_11_2[arg_11_2] or {}

	if not var_11_0.is_alive and not var_11_0.death_is_done then
		arg_11_0.active_reactions[var_11_1][arg_11_2][arg_11_1] = var_11_0
	end
end

local function var_0_3(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	local var_12_0 = arg_12_1.network_type
	local var_12_1 = arg_12_1.death_reaction_template
	local var_12_2 = DeathReactions.templates[var_12_1][var_12_0]
	local var_12_3 = Unit.get_data(arg_12_0, "breed")

	if var_12_3 and var_12_3.name == "skaven_poison_wind_globadier" then
		printf("[HON-43348] Globadier (%s) starting death reaction. temlate_name: '%s', network_type: '%s', killing_blow:\n%s", Unit.get_data(arg_12_0, "globadier_43348"), var_12_1, var_12_0, table.tostring(arg_12_2))
	end

	local var_12_4, var_12_5 = var_12_2.start(arg_12_0, arg_12_5, arg_12_4, arg_12_2, arg_12_6, arg_12_1)

	if var_12_5 == DeathReactions.IS_DONE then
		Unit.flow_event(arg_12_0, "lua_dead")
	else
		arg_12_3[var_12_0][var_12_1][arg_12_0] = arg_12_1
	end

	arg_12_1.death_reaction = var_12_2
	arg_12_1.death_reaction_data = var_12_4
	arg_12_1.death_is_done = var_12_5 == DeathReactions.IS_DONE

	local var_12_6 = var_0_2[arg_12_0]

	if arg_12_6 and var_12_6 then
		local var_12_7 = var_12_6.breed

		if var_12_7.run_on_death then
			var_12_7.run_on_death(arg_12_0, var_12_6)
		end
	end
end

function DeathSystem.update(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_1.dt
	local var_13_1 = DeathReactions
	local var_13_2 = var_13_1.IS_DONE
	local var_13_3 = arg_13_0.active_reactions
	local var_13_4 = arg_13_0.death_reactions_to_start

	for iter_13_0, iter_13_1 in pairs(var_13_4) do
		arg_13_0._current_death_reaction_killing_blow = iter_13_1

		local var_13_5 = arg_13_0.unit_extensions[iter_13_0]

		var_0_3(iter_13_0, var_13_5, iter_13_1, var_13_3, arg_13_2, arg_13_1, arg_13_0.is_server)

		var_13_4[iter_13_0] = nil
	end

	for iter_13_2, iter_13_3 in pairs(var_13_3) do
		for iter_13_4, iter_13_5 in pairs(iter_13_3) do
			local var_13_6 = var_13_1.templates[iter_13_4][iter_13_2]

			for iter_13_6, iter_13_7 in pairs(iter_13_5) do
				if var_13_6.update(iter_13_6, var_13_0, arg_13_1, arg_13_2, iter_13_7.death_reaction_data) == var_13_2 then
					Unit.flow_event(iter_13_6, "lua_dead")

					iter_13_7.death_is_done = true
					var_13_3[iter_13_2][iter_13_4][iter_13_6] = nil
				end
			end
		end
	end
end

local function var_0_4(arg_14_0)
	return arg_14_0[DamageDataIndex.DAMAGE_TYPE] == "sync_health"
end

function DeathSystem.kill_unit(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0._current_death_reaction_killing_blow = arg_15_2

	local var_15_0 = arg_15_0.unit_extensions[arg_15_1]
	local var_15_1 = Unit.get_data(arg_15_1, "breed")

	if var_15_1 and var_15_1.name == "skaven_poison_wind_globadier" then
		printf("[HON-43348] Globadier (%s) killing unit. extension: '%s', killing_blow:\n%s", Unit.get_data(arg_15_1, "globadier_43348"), var_15_0, table.tostring(arg_15_2))
	end

	if not var_15_0 then
		return
	end

	if arg_15_0.is_server then
		Managers.state.entity:system("ping_system"):remove_ping_from_unit(arg_15_1)
	end

	var_15_0.health_extension:set_dead()

	local var_15_2 = ScriptUnit.has_extension(arg_15_1, "buff_system")

	if var_15_2 then
		var_15_2:trigger_procs("on_death", arg_15_1)
	end

	if var_0_4(arg_15_2) then
		var_15_0.death_has_started = true
	end

	if var_15_1 and var_15_1.is_player and var_15_1.keep_weapon_on_death == false then
		local var_15_3 = ScriptUnit.has_extension(arg_15_1, "inventory_system")

		if var_15_3 then
			var_15_3:drop_equipped_weapons("death")
		end
	end

	local var_15_4 = Managers.time:time("game")
	local var_15_5 = arg_15_0.extension_init_context
	local var_15_6 = var_15_0.network_type
	local var_15_7 = var_15_0.death_reaction_template

	DeathReactions.templates[var_15_7][var_15_6].pre_start(arg_15_1, var_15_5, var_15_4, arg_15_2)

	if var_15_1 and var_15_1.name == "skaven_poison_wind_globadier" then
		printf("[HON-43348] Globadier (%s) pre-starting death reaction. template: '%s', network_type: '%s'", Unit.get_data(arg_15_1, "globadier_43348"), var_15_7, var_15_6)
	end

	arg_15_0.death_reactions_to_start[arg_15_1] = arg_15_2
end

function DeathSystem._create_dummy_killing_blow(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = FrameTable.alloc_table()
	local var_16_1 = Unit.world_position(arg_16_1, 0)
	local var_16_2 = var_16_1 and Vector3Aux.box(nil, var_16_1)
	local var_16_3 = "full"
	local var_16_4 = Vector3.up()
	local var_16_5 = Vector3Aux.box(nil, var_16_4)

	var_16_0[DamageDataIndex.DAMAGE_AMOUNT] = NetworkConstants.damage.max
	var_16_0[DamageDataIndex.DAMAGE_TYPE] = arg_16_2
	var_16_0[DamageDataIndex.ATTACKER] = arg_16_1
	var_16_0[DamageDataIndex.HIT_ZONE] = var_16_3
	var_16_0[DamageDataIndex.POSITION] = var_16_2
	var_16_0[DamageDataIndex.DIRECTION] = var_16_5
	var_16_0[DamageDataIndex.DAMAGE_SOURCE_NAME] = "n/a"
	var_16_0[DamageDataIndex.HIT_RAGDOLL_ACTOR_NAME] = "n/a"
	var_16_0[DamageDataIndex.SOURCE_ATTACKER_UNIT] = arg_16_1
	var_16_0[DamageDataIndex.HIT_REACT_TYPE] = "n/a"
	var_16_0[DamageDataIndex.CRITICAL_HIT] = false
	var_16_0[DamageDataIndex.FIRST_HIT] = true
	var_16_0[DamageDataIndex.TOTAL_HITS] = 1
	var_16_0[DamageDataIndex.ATTACK_TYPE] = "n/a"
	var_16_0[DamageDataIndex.BACKSTAB_MULTIPLIER] = 1
	var_16_0[DamageDataIndex.TARGET_INDEX] = 1

	return var_16_0
end

function DeathSystem.forced_kill(arg_17_0, arg_17_1, arg_17_2)
	fassert(Managers.player:is_player_unit(arg_17_1), "Tried to perform forced_kill on non-player unit, ONLY USE THIS FOR PLAYERS!")
	fassert(arg_17_0.is_server, "Do not call forced_kill on clients. Death should always occur on the server first, so call it on the server and it will sync out to clients.")

	local var_17_0 = arg_17_0:_create_dummy_killing_blow(arg_17_1, arg_17_2)

	arg_17_0:kill_unit(arg_17_1, var_17_0)

	local var_17_1 = arg_17_0.unit_storage:go_id(arg_17_1)
	local var_17_2 = NetworkLookup.damage_types[arg_17_2]

	arg_17_0.network_transmit:send_rpc_clients("rpc_forced_kill", var_17_1, var_17_2)
end

function DeathSystem.rpc_forced_kill(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_0.unit_storage:unit(arg_18_2)
	local var_18_1 = NetworkLookup.damage_types[arg_18_3]

	if Unit.alive(var_18_0) then
		if arg_18_0.is_server then
			arg_18_0:forced_kill(var_18_0, var_18_1)
		else
			local var_18_2 = arg_18_0:_create_dummy_killing_blow(var_18_0, var_18_1)

			arg_18_0:kill_unit(var_18_0, var_18_2)
		end
	end
end

function DeathSystem.get_dead(arg_19_0, arg_19_1)
	local var_19_0 = 0
	local var_19_1 = arg_19_0.active_reactions

	for iter_19_0, iter_19_1 in pairs(var_19_1) do
		for iter_19_2, iter_19_3 in pairs(iter_19_1) do
			for iter_19_4, iter_19_5 in pairs(iter_19_3) do
				var_19_0 = var_19_0 + 1
				arg_19_1[iter_19_4] = true
			end
		end
	end

	return var_19_0
end

function DeathSystem.flow_get_killing_blow_attacker_unit(arg_20_0)
	local var_20_0 = arg_20_0._current_death_reaction_killing_blow

	return var_20_0 and var_20_0[DamageDataIndex.ATTACKER]
end
