-- chunkname: @scripts/entity_system/systems/damage/health_system.lua

require("scripts/unit_extensions/generic/generic_health_extension")
require("scripts/unit_extensions/generic/overpowered_blob_health_extension")
require("scripts/unit_extensions/generic/explosive_barrel_health_extension")
require("scripts/unit_extensions/generic/invincible_health_extension")
require("scripts/unit_extensions/generic/rat_ogre_health_extension")
require("scripts/unit_extensions/generic/chaos_troll_health_extension")
require("scripts/unit_extensions/generic/chaos_troll_husk_health_extension")
require("scripts/unit_extensions/generic/training_dummy_health_extension")
require("scripts/unit_extensions/default_player_unit/player_unit_health_extension")
require("scripts/unit_extensions/health/loot_rat_health_extension")
require("scripts/unit_extensions/health/lure_health_extension")
require("scripts/unit_extensions/health/target_health_extension")

HealthSystem = class(HealthSystem, ExtensionSystemBase)

local var_0_0 = script_data
local var_0_1 = {
	"rpc_add_damage",
	"rpc_add_damage_network",
	"rpc_damage_taken_overcharge",
	"rpc_heal",
	"rpc_remove_assist_shield",
	"rpc_request_heal",
	"rpc_suicide",
	"rpc_sync_damage_taken",
	"rpc_take_falling_damage",
	"rpc_request_knock_down",
	"rpc_request_heal_wounds",
	"rpc_request_revive",
	"rpc_request_insta_kill",
	"rpc_request_convert_temp"
}
local var_0_2 = {
	"ChaosTrollHealthExtension",
	"ChaosTrollHuskHealthExtension",
	"ExplosiveBarrelHealthExtension",
	"GenericHealthExtension",
	"InvincibleHealthExtension",
	"LootRatHealthExtension",
	"PlayerUnitHealthExtension",
	"RatOgreHealthExtension",
	"LureHealthExtension",
	"OverpoweredBlobHealthExtension",
	"TrainingDummyHealthExtension",
	"TargetHealthExtension"
}

DLCUtils.require_list("health_extension_files")
DLCUtils.append("health_extensions", var_0_2)

HealthSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	HealthSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_2)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_1))

	arg_1_0.unit_extensions = {}
	arg_1_0.frozen_unit_extensions = {}
	arg_1_0.player_unit_extensions = {}
	arg_1_0.updateable_unit_extensions = {}
	arg_1_0.active_damage_buffer_index = 1
	arg_1_0.extension_init_context.system_data = arg_1_0
	arg_1_0._recent_attackers_free_list = {
		[0] = 0
	}
end

HealthSystem.destroy = function (arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
	fassert(next(HEALTH_ALIVE) == nil, "global HEALTH_ALIVE table has units that were not cleaned up. Should be empty")
	table.clear(HEALTH_ALIVE)
end

HealthSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = ScriptUnit.add_extension(arg_3_0.extension_init_context, arg_3_2, arg_3_3, arg_3_0.NAME, arg_3_4)

	HEALTH_ALIVE[arg_3_2] = true
	arg_3_0.unit_extensions[arg_3_2] = var_3_0

	if arg_3_3 == "PlayerUnitHealthExtension" then
		arg_3_0.player_unit_extensions[arg_3_2] = var_3_0
	end

	if var_3_0.update then
		arg_3_0.updateable_unit_extensions[arg_3_2] = var_3_0
	end

	return var_3_0
end

HealthSystem.on_remove_extension = function (arg_4_0, arg_4_1, arg_4_2)
	fassert(ScriptUnit.has_extension(arg_4_1, arg_4_0.NAME), "Trying to remove non-existing extension %q from unit %s", arg_4_2, arg_4_1)
	ScriptUnit.remove_extension(arg_4_1, arg_4_0.NAME)

	arg_4_0.unit_extensions[arg_4_1] = nil
	arg_4_0.frozen_unit_extensions[arg_4_1] = nil
	arg_4_0.player_unit_extensions[arg_4_1] = nil
	arg_4_0.updateable_unit_extensions[arg_4_1] = nil
	HEALTH_ALIVE[arg_4_1] = nil
end

HealthSystem.freeze = function (arg_5_0, arg_5_1, arg_5_2)
	fassert(arg_5_0.frozen_unit_extensions[arg_5_1] == nil, "Tried to freeze an already frozen unit.")

	local var_5_0 = arg_5_0.unit_extensions[arg_5_1]

	fassert(var_5_0, "Unit to freeze didn't have unfrozen extension")

	if var_5_0.freeze then
		var_5_0:freeze()
	end

	arg_5_0.unit_extensions[arg_5_1] = nil
	arg_5_0.frozen_unit_extensions[arg_5_1] = var_5_0

	fassert(var_5_0.unit, "Should this extension have a unit member?")
end

HealthSystem.unfreeze = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.frozen_unit_extensions[arg_6_1]

	fassert(var_6_0, "Unit to unfreeze didn't have frozen extension")

	arg_6_0.frozen_unit_extensions[arg_6_1] = nil
	arg_6_0.unit_extensions[arg_6_1] = var_6_0

	if var_6_0.unfreeze then
		var_6_0:unfreeze()
	end
end

HealthSystem.hot_join_sync = function (arg_7_0, arg_7_1)
	for iter_7_0, iter_7_1 in pairs(arg_7_0.unit_extensions) do
		if iter_7_1.hot_join_sync then
			iter_7_1:hot_join_sync(arg_7_1)
		end
	end
end

HealthSystem.update = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.active_damage_buffer_index = 3 - arg_8_0.active_damage_buffer_index

	local var_8_0 = arg_8_0.active_damage_buffer_index
	local var_8_1 = pdArray.set_empty
	local var_8_2 = arg_8_0.player_unit_extensions

	for iter_8_0, iter_8_1 in pairs(arg_8_0.unit_extensions) do
		local var_8_3 = iter_8_1.damage_buffers[var_8_0]

		var_8_1(var_8_3)

		iter_8_1._recent_damage_type = nil
		iter_8_1._recent_hit_react_type = nil
	end

	local var_8_4 = arg_8_1.dt

	for iter_8_2, iter_8_3 in pairs(arg_8_0.updateable_unit_extensions) do
		iter_8_3:update(var_8_4, arg_8_1, arg_8_2)
	end
end

HealthSystem._assist_shield = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.unit_extensions[arg_9_1]
	local var_9_1 = ScriptUnit.extension(arg_9_1, "status_system")

	var_9_0:shield(arg_9_2)
	var_9_1:set_shielded(true)
end

HealthSystem.suicide = function (arg_10_0, arg_10_1)
	if not Unit.alive(arg_10_1) then
		if not arg_10_1 then
			print("Got suicide from deleted player unit")
		else
			print("Trying suicide but already dead")
		end

		return
	end

	ScriptUnit.extension(arg_10_1, "health_system"):die("forced")
end

HealthSystem.rent_recent_attacker = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._recent_attackers_free_list
	local var_11_1
	local var_11_2 = var_11_0[0]

	if var_11_2 > 0 then
		var_11_1 = var_11_0[var_11_2]
		var_11_0[0] = var_11_2 - 1
	else
		var_11_1 = {}
	end

	arg_11_0:refresh_recent_attacker(var_11_1, arg_11_1, arg_11_2)

	return var_11_1
end

HealthSystem.refresh_recent_attacker = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	arg_12_1.attacker_breed = arg_12_2
	arg_12_1.t = arg_12_3
end

HealthSystem.return_recent_attacker = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._recent_attackers_free_list
	local var_13_1 = var_13_0[0] + 1

	var_13_0[var_13_1] = arg_13_1
	var_13_0[0] = var_13_1
end

local var_0_3 = {}

HealthSystem.update_debug = function (arg_14_0)
	if var_0_0.damage_debug then
		for iter_14_0, iter_14_1 in pairs(arg_14_0.unit_extensions) do
			if Managers.player:owner(iter_14_0) then
				local var_14_0 = iter_14_1:get_damage_taken()
				local var_14_1 = iter_14_1:get_max_health()
				local var_14_2 = ScriptUnit.has_extension(iter_14_0, "dialogue_system")

				if var_14_2 then
					Debug.text("Player: %s @ %.2f/%.2f", var_14_2.context.player_profile, var_14_0, var_14_1)
				else
					Debug.text("Player: @ %.2f/%.2f", var_14_0, var_14_1)
				end
			else
				local var_14_3 = iter_14_1:current_health()
				local var_14_4 = iter_14_1:get_damage_taken()
				local var_14_5 = var_14_3 == math.huge and "inf" or string.format("%.2f", var_14_3)
				local var_14_6 = Unit.get_data(iter_14_0, "breed")

				if var_14_6 ~= nil then
					Debug.text("Breed %s @ %.2f/%s", var_14_6.name, var_14_4, var_14_5)
				else
					Debug.text("%s @ %.2f/%s", Unit.debug_name(iter_14_0), var_14_4, var_14_5)
				end
			end
		end
	end

	local var_14_7 = var_0_0.show_ai_health
	local var_14_8 = var_0_0.show_ai_spawn_info

	if var_14_7 or var_14_8 then
		local var_14_9 = Managers.player:local_player()

		if var_14_9 == nil then
			return
		end

		local var_14_10 = var_14_9.player_unit
		local var_14_11 = Managers.free_flight
		local var_14_12 = var_14_11:active("global") and var_14_11:camera_position_rotation()
		local var_14_13 = Managers.state.entity:system("ai_system").broadphase
		local var_14_14 = var_14_12 or POSITION_LOOKUP[var_14_10]

		if var_14_13 and var_14_14 then
			local var_14_15 = Broadphase.query(var_14_13, var_14_14, 20, var_0_3)
			local var_14_16 = Vector3(0, 0, 0.5)
			local var_14_17 = Vector3(0, 0, 0.65)
			local var_14_18 = Vector3(0, 0, 0.75)
			local var_14_19 = Vector3(255, 200, 0)
			local var_14_20 = Vector3(255, 0, 200)
			local var_14_21 = Vector3(255, 70, 0)
			local var_14_22 = Vector3(55, 70, 255)
			local var_14_23 = Vector3(0, 175, 75)
			local var_14_24 = Vector3(175, 175, 0)
			local var_14_25 = Vector3(175, 0, 0)
			local var_14_26 = Vector3(100, 0, 0)
			local var_14_27 = "player_1"
			local var_14_28 = Managers.state.debug_text

			for iter_14_2 = 1, var_14_15 do
				local var_14_29 = var_0_3[iter_14_2]
				local var_14_30 = Unit.has_node(var_14_29, "c_head") and Unit.node(var_14_29, "c_head")

				if var_14_30 then
					local var_14_31 = arg_14_0.unit_extensions[var_14_29]

					if var_14_7 then
						var_14_28:clear_unit_text(var_14_29, "health")

						local var_14_32 = var_14_31.health - var_14_31.damage
						local var_14_33 = var_14_32 / var_14_31.health
						local var_14_34 = var_14_33 > 0.99 and var_14_23 or var_14_33 > 0.25 and var_14_24 or var_14_25
						local var_14_35 = BLACKBOARDS[var_14_29]
						local var_14_36 = var_14_35 and (var_14_35.lean_dogpile or 0) or "-"

						if var_14_33 <= 0 then
							local var_14_37 = string.format("dead, dogpile %s", var_14_36)

							var_14_28:output_unit_text(var_14_37, 0.16, var_14_29, var_14_30, var_14_16, nil, "health", var_14_26, var_14_27)
						else
							local var_14_38 = string.format("%.2f / %.2f dogpile %s", var_14_32, var_14_31.health, var_14_36)

							var_14_28:output_unit_text(var_14_38, 0.3, var_14_29, var_14_30, var_14_16, nil, "health", var_14_34, var_14_27)
						end

						local var_14_39 = ScriptUnit.has_extension(var_14_29, "ai_group_system")
						local var_14_40 = var_14_39 and var_14_39.template or ""

						if var_14_40 then
							var_14_28:output_unit_text(var_14_40, 0.15, var_14_29, var_14_30, var_14_17, nil, "health", var_14_21, var_14_27)
						end
					end

					if var_14_8 then
						var_14_28:clear_unit_text(var_14_29, "spawn_info")

						local var_14_41 = var_14_31.zone_data

						if var_14_41 then
							local var_14_42 = var_14_41.hi_data
							local var_14_43
							local var_14_44

							if var_14_31.replaced_breed then
								var_14_44 = var_14_22
								var_14_43 = string.format("%s R>%s", var_14_31.debug_info or "Roaming", var_14_31.replaced_breed)
							else
								var_14_44 = var_14_21
								var_14_43 = string.format("%s SEG=%d", var_14_31.debug_info or "Roaming", var_14_42.id)
							end

							var_14_28:output_unit_text(var_14_43, 0.15, var_14_29, var_14_30, var_14_18, nil, "spawn_info", var_14_44, var_14_27)

							local var_14_45 = BLACKBOARDS[var_14_29].breed.name
							local var_14_46 = var_14_42 and var_14_42.breed_count and var_14_42.breed_count[var_14_45]
							local var_14_47 = var_14_46 and var_14_46.count or " "
							local var_14_48 = string.format("%s %s %q(%s)", var_14_41.island and "island_id:" or "zone_id:", var_14_41.unique_zone_id, var_14_41.pack_type or "?", var_14_47)

							if var_14_41.hi then
								var_14_44 = var_14_20
							else
								var_14_44 = var_14_19
							end

							var_14_28:output_unit_text(var_14_48, 0.15, var_14_29, var_14_30, var_14_17, nil, "spawn_info", var_14_44, var_14_27)
						else
							local var_14_49 = ScriptUnit.has_extension(var_14_29, "ai_group_system")
							local var_14_50 = var_14_49 and var_14_49.template or ""

							if var_14_50 then
								var_14_28:output_unit_text(var_14_50, 0.15, var_14_29, var_14_30, var_14_17, nil, "spawn_info", var_14_21, var_14_27)
							end
						end
					end
				end
			end
		end
	end
end

HealthSystem.rpc_add_damage = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11, arg_15_12, arg_15_13, arg_15_14, arg_15_15, arg_15_16, arg_15_17, arg_15_18, arg_15_19, arg_15_20, arg_15_21, arg_15_22)
	fassert(not arg_15_0.is_server, "Tried sending rpc_add_damage to something other than client")

	local var_15_0
	local var_15_1 = arg_15_0.unit_storage

	if arg_15_3 then
		var_15_0 = LevelHelper:unit_by_index(arg_15_0.world, arg_15_2)
	else
		var_15_0 = var_15_1:unit(arg_15_2)
	end

	if not Unit.alive(var_15_0) then
		return
	end

	local var_15_2

	if arg_15_5 then
		var_15_2 = LevelHelper:unit_by_index(arg_15_0.world, arg_15_4)
	else
		var_15_2 = var_15_1:unit(arg_15_4)
	end

	local var_15_3 = var_15_1:unit(arg_15_6)
	local var_15_4 = NetworkLookup.hit_zones[arg_15_8]
	local var_15_5 = NetworkLookup.damage_types[arg_15_9]
	local var_15_6 = NetworkLookup.damage_sources[arg_15_12]
	local var_15_7 = NetworkLookup.hit_ragdoll_actors[arg_15_13]
	local var_15_8 = NetworkLookup.hit_react_types[arg_15_14]
	local var_15_9 = NetworkLookup.buff_attack_types[arg_15_20]
	local var_15_10 = Unit.alive(var_15_2)
	local var_15_11 = arg_15_0.unit_extensions[var_15_0]
	local var_15_12 = ScriptUnit.has_extension(var_15_3, "buff_system")

	if var_15_12 and var_15_6 == "dot_debuff" then
		var_15_12:trigger_procs("on_dot_damage_dealt", var_15_0, var_15_3, var_15_5, var_15_6)
	end

	if var_15_5 ~= "sync_health" then
		var_15_11:add_damage(var_15_10 and var_15_2 or var_15_0, arg_15_7, var_15_4, var_15_5, arg_15_10, arg_15_11, var_15_6, var_15_7, var_15_3, var_15_8, arg_15_16, arg_15_17, arg_15_18, arg_15_19, var_15_9, arg_15_21, arg_15_22)
	end

	if var_15_11:is_alive() and arg_15_15 then
		local var_15_13 = FrameTable.alloc_table()
		local var_15_14 = arg_15_10 and Vector3Aux.box(nil, arg_15_10)
		local var_15_15 = Vector3Aux.box(nil, arg_15_11)

		var_15_13[DamageDataIndex.DAMAGE_AMOUNT] = arg_15_7
		var_15_13[DamageDataIndex.DAMAGE_TYPE] = var_15_5
		var_15_13[DamageDataIndex.ATTACKER] = var_15_10 and var_15_2 or var_15_0
		var_15_13[DamageDataIndex.HIT_ZONE] = var_15_4
		var_15_13[DamageDataIndex.POSITION] = var_15_14
		var_15_13[DamageDataIndex.DIRECTION] = var_15_15
		var_15_13[DamageDataIndex.DAMAGE_SOURCE_NAME] = var_15_6
		var_15_13[DamageDataIndex.HIT_RAGDOLL_ACTOR_NAME] = var_15_7
		var_15_13[DamageDataIndex.SOURCE_ATTACKER_UNIT] = var_15_3 or var_15_13[DamageDataIndex.ATTACKER]
		var_15_13[DamageDataIndex.HIT_REACT_TYPE] = var_15_8
		var_15_13[DamageDataIndex.CRITICAL_HIT] = arg_15_16
		var_15_13[DamageDataIndex.FIRST_HIT] = arg_15_18
		var_15_13[DamageDataIndex.TOTAL_HITS] = arg_15_19
		var_15_13[DamageDataIndex.ATTACK_TYPE] = var_15_9
		var_15_13[DamageDataIndex.BACKSTAB_MULTIPLIER] = arg_15_21
		var_15_13[DamageDataIndex.TARGET_INDEX] = arg_15_22 or 1

		Managers.state.entity:system("death_system"):kill_unit(var_15_0, var_15_13)
	end
end

HealthSystem.rpc_add_damage_network = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9, arg_16_10, arg_16_11, arg_16_12, arg_16_13, arg_16_14, arg_16_15, arg_16_16, arg_16_17, arg_16_18, arg_16_19)
	fassert(arg_16_0.is_server, "Tried sending rpc_add_damage_network to something other than the server")

	local var_16_0
	local var_16_1 = arg_16_0.unit_storage

	if arg_16_3 then
		var_16_0 = LevelHelper:unit_by_index(arg_16_0.world, arg_16_2)
	else
		var_16_0 = var_16_1:unit(arg_16_2)
	end

	if not Unit.alive(var_16_0) then
		return
	end

	local var_16_2

	if arg_16_5 then
		var_16_2 = LevelHelper:unit_by_index(arg_16_0.world, arg_16_4)
	else
		var_16_2 = var_16_1:unit(arg_16_4)
	end

	local var_16_3

	if arg_16_6 ~= NetworkConstants.invalid_game_object_id then
		local var_16_4 = var_16_1:unit(arg_16_6)
	end

	local var_16_5 = NetworkLookup.hit_zones[arg_16_8]
	local var_16_6 = NetworkLookup.damage_types[arg_16_9]
	local var_16_7 = NetworkLookup.damage_sources[arg_16_12]
	local var_16_8 = NetworkLookup.hit_react_types[arg_16_13]
	local var_16_9
	local var_16_10
	local var_16_11

	arg_16_16 = arg_16_16 or false
	arg_16_17 = arg_16_17 or 0

	DamageUtils.add_damage_network(var_16_0, var_16_2, arg_16_7, var_16_5, var_16_6, arg_16_10, arg_16_11, var_16_7, var_16_9, var_16_10, var_16_11, var_16_8, arg_16_14, arg_16_15, arg_16_16, arg_16_17, arg_16_18, nil, arg_16_19)
end

HealthSystem.rpc_damage_taken_overcharge = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0.unit_storage:unit(arg_17_2)

	if var_17_0 then
		DamageUtils.apply_damage_to_overcharge(var_17_0, arg_17_3)
	end
end

HealthSystem.rpc_heal = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
	local var_18_0
	local var_18_1 = arg_18_0.unit_storage

	if arg_18_3 then
		var_18_0 = LevelHelper:unit_by_index(arg_18_0.world, arg_18_2)
	else
		var_18_0 = var_18_1:unit(arg_18_2)
	end

	if not Unit.alive(var_18_0) then
		return
	end

	local var_18_2

	if arg_18_5 then
		var_18_2 = LevelHelper:unit_by_index(arg_18_0.world, arg_18_4)
	else
		var_18_2 = var_18_1:unit(arg_18_4)
	end

	local var_18_3 = NetworkLookup.heal_types[arg_18_7]

	if var_18_3 == "shield_by_assist" then
		arg_18_0:_assist_shield(var_18_0, arg_18_6)
	else
		arg_18_0.unit_extensions[var_18_0]:add_heal(var_18_2, arg_18_6, nil, var_18_3)

		local var_18_4 = ScriptUnit.has_extension(var_18_0, "status_system")

		if var_18_4 then
			var_18_4:healed(var_18_3)
		end

		local var_18_5 = ScriptUnit.has_extension(var_18_0, "buff_system")

		if var_18_5 then
			var_18_5:trigger_procs("on_healed", var_18_2, arg_18_6, var_18_3)
		end

		local var_18_6 = ScriptUnit.has_extension(var_18_2, "buff_system")

		if var_18_0 ~= var_18_2 and var_18_6 then
			var_18_6:trigger_procs("on_healed_ally", var_18_0, arg_18_6, var_18_3)
		end
	end
end

HealthSystem.rpc_remove_assist_shield = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.unit_storage:unit(arg_19_2)

	arg_19_0.unit_extensions[var_19_0]:remove_assist_shield("blocked_damage")
end

HealthSystem.rpc_request_heal = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	fassert(arg_20_0.is_server or LEVEL_EDITOR_TEST, "Trying to request a heal from a client")

	local var_20_0 = arg_20_0.unit_storage:unit(arg_20_2)

	if not Unit.alive(var_20_0) then
		return
	end

	local var_20_1 = ScriptUnit.has_extension(var_20_0, "status_system")

	if var_20_1 and var_20_1:is_disabled() then
		local var_20_2 = NetworkLookup.heal_types[arg_20_4]

		if var_20_2 == "healing_draught" or var_20_2 == "healing_draught_temp_health" then
			local var_20_3 = CHANNEL_TO_PEER_ID[arg_20_1]
			local var_20_4 = NetworkLookup.equipment_slots.slot_healthkit
			local var_20_5 = NetworkLookup.item_names.potion_healing_draught_01
			local var_20_6 = NetworkLookup.weapon_skins["n/a"]

			Managers.state.network.network_transmit:send_rpc("rpc_add_inventory_slot_item", var_20_3, arg_20_2, var_20_4, var_20_5, var_20_6)

			return
		end
	end

	local var_20_7 = NetworkLookup.heal_types[arg_20_4]

	if var_20_7 == "shield_by_assist" then
		DamageUtils.assist_shield_network(var_20_0, var_20_0, arg_20_3)
	else
		DamageUtils.heal_network(var_20_0, var_20_0, arg_20_3, var_20_7)
	end
end

HealthSystem.rpc_request_convert_temp = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	fassert(arg_21_0.is_server or LEVEL_EDITOR_TEST, "Trying to request a health convert from a client")

	local var_21_0 = arg_21_0.unit_storage:unit(arg_21_2)

	if not ALIVE[var_21_0] then
		return
	end

	arg_21_0.unit_extensions[var_21_0]:convert_to_temp(arg_21_3)
end

HealthSystem.rpc_suicide = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0.unit_storage:unit(arg_22_2)

	arg_22_0:suicide(var_22_0)
end

HealthSystem.rpc_sync_damage_taken = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
	fassert(not arg_23_0.is_server, "rpc_sync_damage_taken was sent to server, only clients should receive this!")

	local var_23_0
	local var_23_1 = arg_23_0.unit_storage

	if arg_23_3 then
		var_23_0 = LevelHelper:unit_by_index(arg_23_0.world, arg_23_2)
	else
		var_23_0 = var_23_1:unit(arg_23_2)
	end

	if not Unit.alive(var_23_0) then
		return
	end

	local var_23_2 = arg_23_0.unit_extensions[var_23_0]
	local var_23_3 = NetworkLookup.health_statuses[arg_23_6]

	if var_23_2.sync_damage_taken then
		var_23_2:sync_damage_taken(arg_23_5, arg_23_4, var_23_3)
	elseif arg_23_4 then
		var_23_2:set_max_health(arg_23_5)

		var_23_2.state = var_23_3
	else
		var_23_2.damage = arg_23_5
		var_23_2.state = var_23_3
	end
end

HealthSystem.rpc_take_falling_damage = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = arg_24_0.unit_storage:unit(arg_24_2)

	if not var_24_0 or not Unit.alive(var_24_0) then
		return
	end

	local var_24_1 = arg_24_0.player_unit_extensions[var_24_0]

	if not var_24_1 then
		return
	end

	arg_24_3 = arg_24_3 * 0.25

	local var_24_2 = PlayerUnitMovementSettings.get_movement_settings_table(var_24_0)
	local var_24_3 = var_24_2.fall.heights.FALL_DAMAGE_MULTIPLIER
	local var_24_4 = var_24_2.fall.heights.MIN_FALL_DAMAGE_HEIGHT
	local var_24_5 = var_24_2.fall.heights.MIN_FALL_DAMAGE_PERCENTAGE
	local var_24_6 = var_24_2.fall.heights.MAX_FALL_DAMAGE_PERCENTAGE
	local var_24_7 = var_24_1:get_max_health()
	local var_24_8 = var_24_7 * var_24_5
	local var_24_9 = var_24_7 * var_24_6

	if var_24_4 < arg_24_3 then
		local var_24_10 = arg_24_3 - var_24_4
		local var_24_11 = math.clamp(var_24_10 * var_24_3, var_24_8, var_24_9)
		local var_24_12 = Vector3.up()
		local var_24_13 = "full"
		local var_24_14 = "kinetic"

		DamageUtils.add_damage_network(var_24_0, var_24_0, var_24_11, var_24_13, var_24_14, nil, var_24_12, "ground_impact", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
	end
end

HealthSystem.rpc_request_knock_down = function (arg_25_0, arg_25_1, arg_25_2)
	fassert(arg_25_0.is_server or LEVEL_EDITOR_TEST, "Trying to request a knock down from a client")

	local var_25_0 = arg_25_0.unit_storage:unit(arg_25_2)

	ScriptUnit.extension(var_25_0, "health_system"):knock_down(var_25_0)
end

HealthSystem.rpc_request_heal_wounds = function (arg_26_0, arg_26_1, arg_26_2)
	fassert(arg_26_0.is_server or LEVEL_EDITOR_TEST, "Trying to request a wound heal from a client")

	local var_26_0 = arg_26_0.unit_storage:unit(arg_26_2)

	StatusUtils.set_wounded_network(var_26_0, false, "healed")
end

HealthSystem.rpc_request_revive = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	fassert(arg_27_0.is_server or LEVEL_EDITOR_TEST, "Trying to request a revive from a client")

	local var_27_0 = arg_27_0.unit_storage:unit(arg_27_2)
	local var_27_1 = arg_27_0.unit_storage:unit(arg_27_3)

	StatusUtils.set_revived_network(var_27_0, true, var_27_1)

	local var_27_2 = Managers.player
	local var_27_3 = var_27_2:unit_owner(var_27_1)
	local var_27_4 = var_27_2:unit_owner(var_27_0)

	if not var_27_3 or not var_27_4 then
		return
	end

	local var_27_5 = POSITION_LOOKUP[var_27_0]

	Managers.telemetry_events:player_revived(var_27_3, var_27_4, var_27_5)
end

HealthSystem.rpc_request_insta_kill = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	fassert(arg_28_0.is_server or LEVEL_EDITOR_TEST, "Trying to request a insta kill from a client")

	local var_28_0 = arg_28_0.unit_storage:unit(arg_28_2)

	if not var_28_0 or not Unit.alive(var_28_0) then
		return
	end

	local var_28_1 = arg_28_0.unit_extensions[var_28_0]

	if not var_28_1 then
		return
	end

	local var_28_2 = NetworkLookup.damage_types[arg_28_3]

	var_28_1:die(var_28_2)
end
