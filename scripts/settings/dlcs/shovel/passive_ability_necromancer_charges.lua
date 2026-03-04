-- chunkname: @scripts/settings/dlcs/shovel/passive_ability_necromancer_charges.lua

local var_0_0 = {
	"rpc_necromancer_passive_spawn_pet",
	"rpc_necromancer_respawn_all_pets",
	"rpc_necromancer_passive_kill_pets"
}
local var_0_1
local var_0_2

NecromancerPositionModes, var_0_2 = table.enum_lookup("Absolute", "Relative")
PassiveAbilityNecromancerCharges = class(PassiveAbilityNecromancerCharges)

PassiveAbilityNecromancerCharges.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._player = arg_1_3.player
	arg_1_0._is_local = arg_1_3.player.local_player
	arg_1_0._owner_unit = arg_1_2
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0._army_definition = {}
	arg_1_0._spawn_queue = {}
	arg_1_0._queued_pets = {}
	arg_1_0._spawned_pets = {}
	arg_1_0._num_queued_pets = 0
	arg_1_0._pet_respawn_buffs = {}
	arg_1_0._last_spawn_index = 0
	arg_1_0._resummon_spawn_data = {}
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._network_event_delegate = arg_1_0._network_transmit.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_0))

	arg_1_0._unit_storage = arg_1_1.unit_storage
	arg_1_0._ping_explosion_params = {
		source_attacker_unit = arg_1_2
	}
	arg_1_0._dual_wield_params = {
		source_attacker_unit = arg_1_2
	}
	arg_1_0._achv_staff_gandalf_data = {}
end

PassiveAbilityNecromancerCharges.warm_up_skeletons = function (arg_2_0, arg_2_1)
	print("Necromancer - Warm up skeletons:")

	local var_2_0 = Managers.level_transition_handler.enemy_package_loader
	local var_2_1 = true

	for iter_2_0, iter_2_1 in ipairs(arg_2_1) do
		if not var_2_0:is_breed_processed(iter_2_1) then
			printf("\t -> %s", iter_2_1)
			var_2_0:request_breed(iter_2_1, var_2_1)
		end
	end
end

PassiveAbilityNecromancerCharges.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._buff_system = Managers.state.entity:system("buff_system")
	arg_3_0._buff_extension = ScriptUnit.extension(arg_3_2, "buff_system")
	arg_3_0._status_extension = ScriptUnit.extension(arg_3_2, "status_system")
	arg_3_0._talent_extension = ScriptUnit.extension(arg_3_2, "talent_system")
	arg_3_0._cutscene_system = Managers.state.entity:system("cutscene_system")

	local var_3_0 = ScriptUnit.has_extension(arg_3_2, "career_system")

	if var_3_0 then
		local var_3_1 = var_3_0:ability_id("bw_necromancer")

		arg_3_0._career_ability = var_3_0:ability_by_id(var_3_1)
	end

	if arg_3_0._is_local or arg_3_0._is_server then
		arg_3_0._commander_extension = ScriptUnit.extension(arg_3_2, "ai_commander_system")
	end

	arg_3_0:_register_events()
	arg_3_0:_on_talents_changed(arg_3_2, ScriptUnit.extension(arg_3_2, "talent_system"))

	arg_3_0._start_update_t = Managers.time:time("game") + 3
end

PassiveAbilityNecromancerCharges._on_talents_changed = function (arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1 ~= arg_4_0._owner_unit then
		return
	end

	arg_4_0._has_army = arg_4_2:has_talent("sienna_necromancer_6_1")
	arg_4_0._has_dual_wield = arg_4_2:has_talent("sienna_necromancer_6_2")

	if arg_4_2:has_talent("sienna_necromancer_6_3") then
		arg_4_0._army_definition = {
			"pet_skeleton_with_shield",
			"pet_skeleton_with_shield",
			"pet_skeleton_with_shield",
			"pet_skeleton_armored",
			"pet_skeleton_armored",
			"pet_skeleton_armored"
		}
	elseif arg_4_0._has_dual_wield then
		arg_4_0._army_definition = table.fill({}, 6, "pet_skeleton_dual_wield")
	else
		arg_4_0._army_definition = table.fill({}, 6, "pet_skeleton")
	end

	arg_4_0._extra_army_skeletons = arg_4_0._has_army and table.fill({}, 6, "pet_skeleton")

	local var_4_0 = Managers.level_transition_handler:in_hub_level()

	arg_4_0._pets_forbidden_in_level = script_data.pets_forbidden_in_hub and var_4_0

	if arg_4_0._is_server then
		arg_4_0:warm_up_skeletons(arg_4_0._army_definition)
	end

	arg_4_0._force_respawn_pets = true
end

PassiveAbilityNecromancerCharges._register_events = function (arg_5_0)
	Managers.state.event:register(arg_5_0, "on_talents_changed", "_on_talents_changed")
end

PassiveAbilityNecromancerCharges._unregister_events = function (arg_6_0)
	if Managers.state.event then
		Managers.state.event:unregister("on_talents_changed", arg_6_0)
	end
end

PassiveAbilityNecromancerCharges.destroy = function (arg_7_0)
	arg_7_0._network_event_delegate:unregister(arg_7_0)
	arg_7_0:_unregister_events()

	if not Managers.state.network:in_game_session() then
		return
	end

	if not Managers.state.network.profile_synchronizer:get_own_actually_ingame() then
		return
	end

	if arg_7_0._is_server then
		arg_7_0:_kill_all_pets_server(true)
	end
end

PassiveAbilityNecromancerCharges.update = function (arg_8_0, arg_8_1, arg_8_2)
	if arg_8_2 < arg_8_0._start_update_t then
		return
	end

	if arg_8_0._is_server then
		arg_8_0:_update_pets_server()
		arg_8_0:_update_spawning(arg_8_2)
	end

	arg_8_0:_update_achievements(arg_8_2)
end

local var_0_3 = {}
local var_0_4 = 4
local var_0_5 = 10
local var_0_6 = math.pi * 0.05

for iter_0_0 = 1, var_0_5 do
	local var_0_7 = (iter_0_0 - (var_0_5 * 0.5 - 0.5)) * var_0_6
	local var_0_8 = Vector3Box(Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), var_0_7), Vector3.forward()) * var_0_4)

	var_0_3[#var_0_3 + 1] = var_0_8
end

PassiveAbilityNecromancerCharges.spawn_army_pet = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0._army_definition
	local var_9_1 = "necromancer_pet_charges"
	local var_9_2 = var_9_0[arg_9_1]
	local var_9_3 = #var_9_0
	local var_9_4 = var_9_3 <= arg_9_1
	local var_9_5 = arg_9_0._extra_army_skeletons

	if var_9_4 and var_9_5 then
		var_9_4 = false

		if not var_9_2 then
			arg_9_1 = arg_9_1 - var_9_3
			var_9_2 = var_9_5[arg_9_1]
			var_9_1 = "necromancer_pet_army"
			var_9_4 = arg_9_1 >= #var_9_5
		end
	end

	if var_9_2 then
		arg_9_0:spawn_pet(var_9_1, var_9_2, arg_9_2, arg_9_3)
	end

	return var_9_4
end

PassiveAbilityNecromancerCharges.spawn_pet = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	if arg_10_0._pets_forbidden_in_level then
		return
	end

	if not arg_10_3 then
		arg_10_0._last_spawn_index = arg_10_0._last_spawn_index + 1
		arg_10_3 = var_0_3[arg_10_0._last_spawn_index % #var_0_3 + 1]:unbox()
		arg_10_4 = NecromancerPositionModes.Relative
	end

	if arg_10_0._is_server then
		arg_10_0:_queue_pet(arg_10_2, arg_10_3, arg_10_4, arg_10_1)
	else
		local var_10_0 = arg_10_0._network_transmit
		local var_10_1 = NetworkLookup.breeds[arg_10_2]
		local var_10_2 = NetworkLookup.controlled_unit_templates[arg_10_1]
		local var_10_3 = var_0_2[arg_10_4]

		var_10_0:send_rpc_server("rpc_necromancer_passive_spawn_pet", var_10_2, var_10_1, arg_10_3, var_10_3)
	end
end

PassiveAbilityNecromancerCharges.spawn_pets = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	for iter_11_0 = 1, arg_11_1 do
		arg_11_0:spawn_pet(arg_11_2, arg_11_3)
	end
end

PassiveAbilityNecromancerCharges._queue_pet = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	if arg_12_0:is_invalid_spawn_position(arg_12_2) then
		arg_12_2 = Vector3.zero()
		arg_12_3 = NecromancerPositionModes.Relative
	end

	arg_12_0._spawn_queue[#arg_12_0._spawn_queue + 1] = {
		breed_name = arg_12_1,
		position = Vector3Box(arg_12_2),
		position_mode = arg_12_3,
		template_name = arg_12_4
	}
end

PassiveAbilityNecromancerCharges.store_buff_unit = function (arg_13_0, arg_13_1)
	arg_13_0._buff_unit = arg_13_1
end

PassiveAbilityNecromancerCharges.is_ready = function (arg_14_0)
	if not ALIVE[arg_14_0._buff_unit] then
		return true
	end

	return not ScriptUnit.extension(arg_14_0._buff_unit, "buff_system"):has_buff_type("raise_dead_ability")
end

PassiveAbilityNecromancerCharges.rpc_necromancer_passive_spawn_pet = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	assert(arg_15_0._is_server, "[PassiveAbilityNecromancerCharges] 'rpc_necromancer_passive_spawn_pet' is a server only function.")

	if CHANNEL_TO_PEER_ID[arg_15_1] ~= arg_15_0._player.peer_id then
		return
	end

	local var_15_0 = NetworkLookup.breeds[arg_15_3]
	local var_15_1 = NetworkLookup.controlled_unit_templates[arg_15_2]
	local var_15_2 = var_0_2[arg_15_5]

	arg_15_0:_queue_pet(var_15_0, arg_15_4, var_15_2, var_15_1)
end

PassiveAbilityNecromancerCharges.kill_pets = function (arg_16_0, arg_16_1)
	if not arg_16_0._is_server then
		arg_16_0._network_transmit:send_rpc_server("rpc_necromancer_passive_kill_pets")

		return
	end

	if arg_16_0._has_army then
		for iter_16_0, iter_16_1 in pairs(arg_16_0._spawned_pets) do
			if HEALTH_ALIVE[iter_16_0] and iter_16_1 ~= "necromancer_pet_army" then
				arg_16_0:_remove_unit(iter_16_0)
				AiUtils.kill_unit(iter_16_0)
			end
		end
	else
		arg_16_0:_kill_all_pets_server(false)
	end
end

PassiveAbilityNecromancerCharges.rpc_necromancer_passive_kill_pets = function (arg_17_0, arg_17_1)
	assert(arg_17_0._is_server, "[PassiveAbilityNecromancerCharges] 'rpc_necromancer_passive_kill_pets' is a server only function.")

	local var_17_0 = CHANNEL_TO_PEER_ID[arg_17_1]

	if var_17_0 ~= arg_17_0._player.peer_id then
		return
	end

	arg_17_0:kill_pets(var_17_0)
end

PassiveAbilityNecromancerCharges.rpc_necromancer_respawn_all_pets = function (arg_18_0, arg_18_1)
	assert(arg_18_0._is_server, "[PassiveAbilityNecromancerCharges] 'rpc_necromancer_respawn_pets' is a server only function.")

	if CHANNEL_TO_PEER_ID[arg_18_1] ~= arg_18_0._player.peer_id then
		return
	end

	for iter_18_0 in pairs(arg_18_0._pet_respawn_buffs) do
		arg_18_0:consume_pet_charge(iter_18_0)
	end
end

PassiveAbilityNecromancerCharges._update_pets_server = function (arg_19_0)
	if arg_19_0._pets_forbidden_in_level then
		return
	end

	local var_19_0 = arg_19_0._status_extension

	if (var_19_0:is_dead() or var_19_0:is_ready_for_assisted_respawn()) and not arg_19_0._was_dead then
		arg_19_0._was_dead = true

		arg_19_0:_kill_all_pets_server()
	end
end

PassiveAbilityNecromancerCharges.invalid_spawn_position = function (arg_20_0)
	return Vector3(0, 0, -500)
end

PassiveAbilityNecromancerCharges.is_invalid_spawn_position = function (arg_21_0, arg_21_1)
	return not arg_21_1 or arg_21_1[3] < -400
end

PassiveAbilityNecromancerCharges._spawn_pet_server = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = arg_22_0._commander_extension
	local var_22_1 = arg_22_0._buff_extension
	local var_22_2 = arg_22_0._owner_unit
	local var_22_3 = Managers.state.side.side_by_unit[var_22_2].side_id
	local var_22_4 = "resurrected"
	local var_22_5 = arg_22_0._queued_pets
	local var_22_6 = Breeds[arg_22_1]
	local var_22_7 = {
		ignore_event_counter = true,
		ignore_breed_limits = true,
		side_id = var_22_3,
		spawned_func = function (arg_23_0, arg_23_1, arg_23_2)
			if ALIVE[var_22_2] then
				arg_22_0._spawned_pets[arg_23_0] = arg_22_4
				var_22_5[arg_23_2] = nil
				arg_22_0._num_queued_pets = arg_22_0._num_queued_pets - 1

				var_22_1:trigger_procs("on_pet_spawned", arg_23_0)

				local var_23_0 = FrameTable.alloc_table()

				var_23_0.source_attacker_unit = var_22_2

				arg_22_0._buff_system:add_buff_synced(arg_23_0, "sienna_necromancer_pet_attack_sfx", BuffSyncType.Local, var_23_0, arg_22_0._player.peer_id)
				arg_22_0._buff_system:add_buff_synced(arg_23_0, "update_anim_movespeed", BuffSyncType.All)

				if arg_22_0._has_dual_wield then
					arg_22_0._buff_system:add_buff_synced(arg_23_0, "sienna_necromancer_passive_balefire", BuffSyncType.Local)
				end

				if arg_22_4 == "necromancer_pet_charges" then
					if arg_22_0._has_dual_wield then
						arg_22_0._buff_system:add_buff_synced(arg_23_0, "sienna_necromancer_6_2_pet_buff", BuffSyncType.Local, arg_22_0._dual_wield_params)
					end
				elseif arg_22_4 == "necromancer_pet_ability" then
					local var_23_1 = BLACKBOARDS[arg_23_0]

					var_23_1.ability_spawned = true
					var_23_1.dont_follow_commander = true

					if not arg_22_0._talent_extension:has_talent("sienna_necromancer_6_3_2") then
						var_23_1.navigation_extension:add_movement_modifier(0.35 + math.random() * 0.2)
					end
				end

				local var_23_2 = Managers.time:time("game")

				var_22_0:add_controlled_unit(arg_23_0, arg_22_4, var_23_2)
				arg_22_0:_extract_resummon_data(arg_23_0, arg_22_4)
			end
		end
	}
	local var_22_8

	if arg_22_0._first_person_extension then
		var_22_8 = arg_22_0._first_person_extension:current_rotation()
		var_22_8 = Quaternion.look(Vector3.flat(Quaternion.forward(var_22_8)), Vector3.up())
	else
		local var_22_9 = arg_22_0._unit_storage:go_id(var_22_2)
		local var_22_10 = Managers.state.network:game()
		local var_22_11 = GameSession.game_object_field(var_22_10, var_22_9, "aim_direction")

		var_22_8 = Quaternion.look(Vector3.flat(var_22_11), Vector3.up())
	end

	if arg_22_3 == NecromancerPositionModes.Relative then
		arg_22_2 = POSITION_LOOKUP[var_22_2] + Quaternion.rotate(var_22_8, arg_22_2)
	end

	local var_22_12 = arg_22_0._nav_world
	local var_22_13, var_22_14 = GwNavQueries.triangle_from_position(var_22_12, arg_22_2, 2, 2)

	if var_22_13 then
		arg_22_2.z = var_22_14
	else
		arg_22_2 = GwNavQueries.inside_position_from_outside_position(var_22_12, arg_22_2, 2, 2, 5, 1)
	end

	if not arg_22_2 then
		return false
	end

	var_22_5[var_22_7] = Managers.state.conflict:spawn_queued_unit(var_22_6, Vector3Box(arg_22_2), QuaternionBox(var_22_8), var_22_4, nil, nil, var_22_7)
	arg_22_0._num_queued_pets = arg_22_0._num_queued_pets + 1

	return true
end

PassiveAbilityNecromancerCharges._kill_all_pets_server = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._queued_pets

	for iter_24_0, iter_24_1 in pairs(var_24_0) do
		var_24_0[iter_24_0] = nil
		arg_24_0._num_queued_pets = arg_24_0._num_queued_pets - 1

		Managers.state.conflict:remove_queued_unit(iter_24_1)
	end

	arg_24_0._disable_pet_charges = true

	local var_24_1 = arg_24_0._spawned_pets

	for iter_24_2 in pairs(var_24_1) do
		arg_24_0:_remove_unit(iter_24_2)

		if HEALTH_ALIVE[iter_24_2] then
			AiUtils.kill_unit(iter_24_2)
		end
	end

	arg_24_0._disable_pet_charges = false

	if arg_24_1 then
		return
	end

	arg_24_0:_remove_pet_charges()
end

PassiveAbilityNecromancerCharges.resummon_pet = function (arg_25_0, arg_25_1)
	local var_25_0 = (ScriptUnit.extension(arg_25_0._owner_unit, "ai_commander_system"):get_controlled_units() or EMPTY_TABLE)[arg_25_1].template
	local var_25_1 = var_25_0 and var_25_0.name or arg_25_0._spawned_pets[arg_25_1]

	arg_25_0:_gather_resummon_data(arg_25_1, var_25_1)

	arg_25_0._disable_pet_charges = true

	arg_25_0:_remove_unit(arg_25_1)
	AiUtils.kill_unit(arg_25_1)

	local var_25_2 = BLACKBOARDS[arg_25_1].breed.name

	arg_25_0:spawn_pets(1, var_25_1, var_25_2)

	arg_25_0._disable_pet_charges = false
end

local var_0_9 = {}

PassiveAbilityNecromancerCharges._gather_resummon_data = function (arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_0._is_server then
		return
	end

	local var_26_0 = (ScriptUnit.extension(arg_26_0._owner_unit, "ai_commander_system"):get_controlled_units() or var_0_9)[arg_26_1].start_t
	local var_26_1 = ScriptUnit.extension(arg_26_1, "health_system"):get_damage_taken()

	arg_26_0._resummon_spawn_data[arg_26_2] = arg_26_0._resummon_spawn_data[arg_26_2] or {}
	arg_26_0._resummon_spawn_data[arg_26_2][#arg_26_0._resummon_spawn_data[arg_26_2] + 1] = {
		damage_taken = var_26_1,
		start_t = var_26_0
	}
end

PassiveAbilityNecromancerCharges._extract_resummon_data = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_0._resummon_spawn_data[arg_27_2]

	if not var_27_0 then
		return
	end

	local var_27_1 = var_27_0[#var_27_0]
	local var_27_2 = var_27_1.damage_taken
	local var_27_3 = var_27_1.start_t

	ScriptUnit.extension(arg_27_0._owner_unit, "ai_commander_system"):get_controlled_units()[arg_27_1].start_t = var_27_3

	ScriptUnit.extension(arg_27_1, "health_system"):set_server_damage_taken(var_27_1.damage_taken)

	var_27_0[#var_27_0] = nil

	if #var_27_0 == 0 then
		arg_27_0._resummon_spawn_data[arg_27_2] = nil
	end
end

PassiveAbilityNecromancerCharges._remove_unit = function (arg_28_0, arg_28_1)
	arg_28_0._spawned_pets[arg_28_1] = nil

	arg_28_0._commander_extension:remove_controlled_unit(arg_28_1)
end

PassiveAbilityNecromancerCharges.add_pet_charge = function (arg_29_0, arg_29_1, arg_29_2)
	assert(arg_29_0._is_server, "[PassiveAbilityNecromancerCharges] Local only function")
	Managers.state.event:unregister_referenced("on_ai_unit_destroyed", arg_29_1, arg_29_0)

	if arg_29_0._disable_pet_charges then
		return
	end

	local var_29_0

	if arg_29_2 then
		var_29_0 = FrameTable.alloc_table()
		var_29_0.external_optional_duration = arg_29_2
	end

	local var_29_1 = arg_29_0._buff_system:add_buff_synced(arg_29_0._owner_unit, "sienna_pet_spawn_charge", BuffSyncType.ClientAndServer, var_29_0, arg_29_0._player.peer_id)

	arg_29_0._pet_respawn_buffs[var_29_1] = true
end

PassiveAbilityNecromancerCharges.consume_pet_charge = function (arg_30_0, arg_30_1)
	assert(arg_30_0._is_server, "[PassiveAbilityNecromancerCharges] Local only function")

	arg_30_0._pet_respawn_buffs[arg_30_1] = nil

	arg_30_0._buff_system:remove_buff_synced(arg_30_0._owner_unit, arg_30_1)
	arg_30_0:spawn_pets(1, "necromancer_pet_charges")
end

PassiveAbilityNecromancerCharges._remove_pet_charges = function (arg_31_0)
	assert(arg_31_0._is_server, "[PassiveAbilityNecromancerCharges] Local only function")

	local var_31_0 = arg_31_0._owner_unit
	local var_31_1 = arg_31_0._buff_system

	for iter_31_0 in pairs(arg_31_0._pet_respawn_buffs) do
		var_31_1:remove_buff_synced(var_31_0, iter_31_0)

		arg_31_0._pet_respawn_buffs[iter_31_0] = nil
	end
end

PassiveAbilityNecromancerCharges._update_spawning = function (arg_32_0, arg_32_1)
	if arg_32_0._cutscene_system:is_active() then
		return
	end

	local var_32_0 = 0
	local var_32_1 = arg_32_0._spawn_queue

	for iter_32_0 = 1, #var_32_1 do
		local var_32_2 = var_32_1[iter_32_0]
		local var_32_3 = var_32_2.breed_name
		local var_32_4 = var_32_2.position
		local var_32_5 = var_32_2.template_name
		local var_32_6 = var_32_2.position_mode
		local var_32_7 = arg_32_0:_spawn_pet_server(var_32_3, var_32_4:unbox(), var_32_6, var_32_5)

		var_32_1[iter_32_0] = nil

		if not var_32_7 then
			var_32_0 = var_32_0 + 1
			var_32_1[var_32_0] = var_32_2
		end
	end
end

PassiveAbilityNecromancerCharges._update_achievements = function (arg_33_0, arg_33_1)
	if arg_33_0._is_local then
		arg_33_0:_achievement_staff_gandalf_update(arg_33_1)
	end
end

PassiveAbilityNecromancerCharges.achievement_staff_gandalf_trigger = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	arg_34_0._achv_staff_gandalf_data[arg_34_1] = arg_34_2 + arg_34_3
end

PassiveAbilityNecromancerCharges._achievement_staff_gandalf_update = function (arg_35_0, arg_35_1)
	for iter_35_0, iter_35_1 in pairs(arg_35_0._achv_staff_gandalf_data) do
		if iter_35_1 < arg_35_1 then
			arg_35_0._achv_staff_gandalf_data[iter_35_0] = nil

			Managers.state.achievement:trigger_event("necromancer_staff_gandalf_delayed_check", iter_35_0)
		end
	end
end
