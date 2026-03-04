-- chunkname: @scripts/unit_extensions/generic/generic_health_extension.lua

local var_0_0 = {
	"DAMAGE_AMOUNT",
	"DAMAGE_TYPE",
	"ATTACKER",
	"HIT_ZONE",
	"POSITION",
	"DIRECTION",
	"DAMAGE_SOURCE_NAME",
	"HIT_RAGDOLL_ACTOR_NAME",
	"SOURCE_ATTACKER_UNIT",
	"HIT_REACT_TYPE",
	"CRITICAL_HIT",
	"FIRST_HIT",
	"TOTAL_HITS",
	"ATTACK_TYPE",
	"BACKSTAB_MULTIPLIER",
	"TARGET_INDEX"
}

DamageDataIndex = {}

local var_0_1 = DamageDataIndex

for iter_0_0, iter_0_1 in ipairs(var_0_0) do
	var_0_1[iter_0_1] = iter_0_0
end

var_0_1.STRIDE = #var_0_0

local var_0_2
local var_0_3 = 5

GenericHealthExtension = class(GenericHealthExtension)

function GenericHealthExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.system_data = arg_1_1.system_data
	arg_1_0.statistics_db = arg_1_1.statistics_db
	arg_1_0.damage_buffers = {
		pdArray.new(),
		pdArray.new()
	}
	arg_1_0.network_transmit = arg_1_1.network_transmit
	arg_1_0._breed = arg_1_3.breed

	local var_1_0 = arg_1_3.health or Unit.get_data(arg_1_2, "health")

	if var_1_0 == -1 then
		arg_1_0.is_invincible = true
		var_1_0 = math.huge
	else
		arg_1_0.is_invincible = false
	end

	arg_1_0.dead = false
	arg_1_0.predicted_dead = false
	arg_1_0.state = "alive"
	arg_1_0.damage = arg_1_3.damage or 0
	arg_1_0.predicted_damage = 0
	arg_1_0.last_damage_data = {}
	arg_1_0._health_system = arg_1_1.owning_system
	arg_1_0._recent_attackers = {}

	local var_1_1 = arg_1_0:set_max_health(var_1_0)

	arg_1_0.unmodified_max_health = var_1_1
	arg_1_0._min_health_percentage = nil
	arg_1_0._recent_damage_type = nil
	arg_1_0._recent_hit_react_type = nil
	arg_1_0._last_damage_t = nil
	arg_1_0._damage_cap = arg_1_3.damage_cap_per_hit or Unit.get_data(arg_1_2, "damage_cap_per_hit")
	arg_1_0._damage_cap_per_hit = arg_1_0._damage_cap or var_1_1
end

function GenericHealthExtension.destroy(arg_2_0)
	if arg_2_0._recent_attackers then
		for iter_2_0, iter_2_1 in pairs(arg_2_0._recent_attackers) do
			arg_2_0._health_system:return_recent_attacker(iter_2_1)

			arg_2_0._recent_attackers[iter_2_0] = nil
		end
	end
end

function GenericHealthExtension.freeze(arg_3_0)
	arg_3_0:set_dead()
end

function GenericHealthExtension.unfreeze(arg_4_0)
	arg_4_0:reset()
end

function GenericHealthExtension.reset(arg_5_0)
	arg_5_0.state = "alive"
	arg_5_0.dead = false
	arg_5_0.predicted_dead = false
	arg_5_0.damage = 0
	arg_5_0.predicted_damage = 0
	arg_5_0._recent_damage_type = nil
	arg_5_0._recent_hit_react_type = nil

	pdArray.set_empty(arg_5_0.damage_buffers[1])
	pdArray.set_empty(arg_5_0.damage_buffers[2])
	arg_5_0:set_max_health(arg_5_0.unmodified_max_health)
	table.clear(arg_5_0.last_damage_data)

	HEALTH_ALIVE[arg_5_0.unit] = true

	if arg_5_0._recent_attackers then
		for iter_5_0, iter_5_1 in pairs(arg_5_0._recent_attackers) do
			arg_5_0._health_system:return_recent_attacker(iter_5_1)

			arg_5_0._recent_attackers[iter_5_0] = nil
		end
	end
end

function GenericHealthExtension.hot_join_sync(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.unit
	local var_6_1, var_6_2 = Managers.state.network:game_object_or_level_id(var_6_0)

	if var_6_1 then
		local var_6_3 = NetworkLookup.health_statuses[arg_6_0.state]
		local var_6_4 = arg_6_0:get_damage_taken()
		local var_6_5 = NetworkUtils.get_network_safe_damage_hotjoin_sync(var_6_4)
		local var_6_6 = arg_6_0.network_transmit

		var_6_6:send_rpc("rpc_sync_damage_taken", arg_6_1, var_6_1, var_6_2, false, var_6_5, var_6_3)

		if arg_6_0.dead then
			local var_6_7 = 0
			local var_6_8 = NetworkLookup.hit_zones.full
			local var_6_9 = NetworkLookup.damage_types.sync_health
			local var_6_10 = Unit.world_position(var_6_0, 0)
			local var_6_11 = Vector3.up()
			local var_6_12 = NetworkConstants.invalid_game_object_id
			local var_6_13 = NetworkLookup.damage_sources["n/a"]
			local var_6_14 = NetworkLookup.hit_ragdoll_actors["n/a"]
			local var_6_15 = NetworkLookup.hit_react_types.light
			local var_6_16 = NetworkLookup.buff_attack_types["n/a"]
			local var_6_17 = true
			local var_6_18 = false
			local var_6_19 = false
			local var_6_20 = false
			local var_6_21 = 0
			local var_6_22 = 1
			local var_6_23 = 0 or 1

			var_6_6:send_rpc("rpc_add_damage", arg_6_1, var_6_1, var_6_2, var_6_1, var_6_2, var_6_12, var_6_7, var_6_8, var_6_9, var_6_10, var_6_11, var_6_13, var_6_14, var_6_15, var_6_17, var_6_18, var_6_19, var_6_20, var_6_21, var_6_16, var_6_22, var_6_23)
		end
	end
end

function GenericHealthExtension.set_server_damage_taken(arg_7_0, arg_7_1)
	fassert(arg_7_0.is_server, "[GenericHealthExtension] Only server is allowed to call this function")

	local var_7_0 = arg_7_0.unit
	local var_7_1, var_7_2 = Managers.state.network:game_object_or_level_id(var_7_0)

	if var_7_1 then
		local var_7_3 = NetworkLookup.health_statuses[arg_7_0.state]

		arg_7_0.network_transmit:send_rpc_clients("rpc_sync_damage_taken", var_7_1, var_7_2, false, arg_7_1, var_7_3)
	end

	arg_7_0.damage = arg_7_1
end

function GenericHealthExtension.is_alive(arg_8_0)
	return not arg_8_0.dead
end

function GenericHealthExtension.client_predicted_is_alive(arg_9_0)
	return not arg_9_0.dead and not arg_9_0.predicted_dead
end

function GenericHealthExtension.current_health_percent(arg_10_0)
	return 1 - arg_10_0.damage / arg_10_0.health
end

function GenericHealthExtension.current_health(arg_11_0)
	return arg_11_0.health - arg_11_0.damage
end

function GenericHealthExtension.get_damage_taken(arg_12_0)
	return arg_12_0.damage
end

function GenericHealthExtension.set_current_damage(arg_13_0, arg_13_1)
	arg_13_0.damage = arg_13_1
end

function GenericHealthExtension.set_min_health_percentage(arg_14_0, arg_14_1)
	arg_14_0._min_health_percentage = arg_14_1
end

function GenericHealthExtension.get_max_health(arg_15_0)
	return arg_15_0.health
end

function GenericHealthExtension.is_dead(arg_16_0)
	return arg_16_0.dead
end

function GenericHealthExtension.current_max_health_percent(arg_17_0)
	return 1
end

function GenericHealthExtension.set_max_health(arg_18_0, arg_18_1)
	local var_18_0 = NetworkConstants.health
	local var_18_1 = math.clamp(arg_18_1, var_18_0.min, var_18_0.max)
	local var_18_2 = var_18_1 % 1
	local var_18_3 = math.round(var_18_2 * 4) * 0.25
	local var_18_4 = math.floor(var_18_1) + var_18_3

	var_18_4 = var_18_4 <= 0 and 1 or var_18_4
	arg_18_0.health = var_18_4
	arg_18_0._damage_cap_per_hit = arg_18_0._damage_cap or arg_18_0.health

	local var_18_5, var_18_6 = Managers.state.network:game_object_or_level_id(arg_18_0.unit)

	if arg_18_0.is_server and var_18_5 then
		local var_18_7 = NetworkLookup.health_statuses[arg_18_0.state]

		arg_18_0.network_transmit:send_rpc_clients("rpc_sync_damage_taken", var_18_5, var_18_6, true, var_18_4, var_18_7)
	end

	return var_18_4
end

function GenericHealthExtension._add_to_damage_history_buffer(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13, arg_19_14, arg_19_15, arg_19_16, arg_19_17)
	local var_19_0 = arg_19_6 and {
		arg_19_6.x,
		arg_19_6.y,
		arg_19_6.z
	} or nil
	local var_19_1 = arg_19_7 and {
		arg_19_7.x,
		arg_19_7.y,
		arg_19_7.z
	} or nil
	local var_19_2 = arg_19_0.damage_buffers[arg_19_0.system_data.active_damage_buffer_index]
	local var_19_3 = FrameTable.alloc_table()

	var_19_3[var_0_1.DAMAGE_AMOUNT] = arg_19_3
	var_19_3[var_0_1.DAMAGE_TYPE] = arg_19_5
	var_19_3[var_0_1.ATTACKER] = arg_19_2
	var_19_3[var_0_1.HIT_ZONE] = arg_19_4
	var_19_3[var_0_1.POSITION] = var_19_0
	var_19_3[var_0_1.DIRECTION] = var_19_1
	var_19_3[var_0_1.DAMAGE_SOURCE_NAME] = arg_19_8 or "n/a"
	var_19_3[var_0_1.HIT_RAGDOLL_ACTOR_NAME] = arg_19_9 or "n/a"
	var_19_3[var_0_1.SOURCE_ATTACKER_UNIT] = arg_19_10 or arg_19_2
	var_19_3[var_0_1.HIT_REACT_TYPE] = arg_19_11 or "light"
	var_19_3[var_0_1.CRITICAL_HIT] = arg_19_12 or false
	var_19_3[var_0_1.FIRST_HIT] = arg_19_13 or false
	var_19_3[var_0_1.TOTAL_HITS] = arg_19_14 or 0
	var_19_3[var_0_1.ATTACK_TYPE] = arg_19_15 or "n/a"
	var_19_3[var_0_1.BACKSTAB_MULTIPLIER] = arg_19_16 or false
	var_19_3[var_0_1.TARGET_INDEX] = arg_19_17 or 1

	pdArray.push_back16(var_19_2, unpack(var_19_3))

	return var_19_3
end

function GenericHealthExtension._should_die(arg_20_0)
	return arg_20_0.damage >= arg_20_0.health
end

function GenericHealthExtension.apply_client_predicted_damage(arg_21_0, arg_21_1)
	fassert(not arg_21_0.is_server, "This should only be used for the clients!")

	if not arg_21_0:get_is_invincible() then
		local var_21_0 = math.min(arg_21_1, arg_21_0._damage_cap_per_hit)

		arg_21_0.predicted_damage = arg_21_0.predicted_damage + var_21_0
		arg_21_0.predicted_dead = arg_21_0.damage + arg_21_0.predicted_damage >= arg_21_0.health
	else
		arg_21_0.predicted_dead = false
	end
end

function GenericHealthExtension.add_damage(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10, arg_22_11, arg_22_12, arg_22_13, arg_22_14, arg_22_15, arg_22_16, arg_22_17)
	local var_22_0 = arg_22_0.unit
	local var_22_1, var_22_2 = Managers.state.network:game_object_or_level_id(var_22_0)

	if arg_22_0._min_health_percentage then
		local var_22_3 = arg_22_0:current_health()
		local var_22_4 = math.max(arg_22_0._min_health_percentage * arg_22_0.health, 0.25)
		local var_22_5 = var_22_3 - arg_22_2
		local var_22_6 = math.max(var_22_5, var_22_4)
		local var_22_7 = math.max(var_22_3 - var_22_6, 0)

		arg_22_2 = DamageUtils.networkify_damage(var_22_7)
	end

	local var_22_8 = AiUtils.get_actual_attacker_player(arg_22_1, var_22_0, arg_22_7)

	if not arg_22_9 then
		if var_22_8 and ALIVE[var_22_8.player_unit] then
			arg_22_9 = var_22_8.player_unit
		end

		if not arg_22_9 then
			local var_22_9 = arg_22_0.last_damage_data.attacker_unit_id

			arg_22_9 = var_22_9 and Managers.state.unit_storage:unit(var_22_9)
		end

		arg_22_9 = AiUtils.get_actual_attacker_unit(arg_22_9 or arg_22_1)
	end

	if var_22_8 then
		local var_22_10 = BLACKBOARDS[arg_22_9]
		local var_22_11 = ALIVE[arg_22_9] and Unit.get_data(arg_22_9, "breed") or var_22_10 and var_22_10.breed or ALIVE[arg_22_1] and Unit.get_data(arg_22_1, "breed")
		local var_22_12 = var_22_8:unique_id()
		local var_22_13 = Managers.player:owner(var_22_0)

		if var_22_12 ~= (var_22_13 and var_22_13:unique_id()) and var_22_11 and var_22_11.is_player then
			local var_22_14 = Managers.time:time("game")

			arg_22_0:_register_attacker(var_22_12, var_22_11, var_22_14)
		end
	end

	local var_22_15 = arg_22_0:_add_to_damage_history_buffer(var_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10, arg_22_11, arg_22_13, arg_22_14, arg_22_15, arg_22_16, arg_22_17)

	fassert(arg_22_4, "No damage_type!")

	arg_22_0._recent_damage_type = arg_22_4
	arg_22_0._recent_hit_react_type = arg_22_10
	arg_22_0._recent_damage_source_name = arg_22_7
	arg_22_0._last_damage_t = Managers.time:time("game")

	StatisticsUtil.register_damage(var_22_0, var_22_15, arg_22_0.statistics_db)
	arg_22_0:save_kill_feed_data(arg_22_1, var_22_15, arg_22_3, arg_22_4, arg_22_7, arg_22_9)
	DamageUtils.handle_hit_indication(arg_22_1, var_22_0, arg_22_2, arg_22_3, arg_22_12)

	local var_22_16 = 0
	local var_22_17 = ScriptUnit.has_extension(var_22_0, "buff_system")

	if var_22_17 then
		var_22_16 = var_22_17:has_buff_perk("ignore_death") and 1 or 0
	end

	if not arg_22_0:get_is_invincible() and not arg_22_0.dead then
		local var_22_18 = math.min(arg_22_2, arg_22_0._damage_cap_per_hit)

		if var_22_16 > 0 then
			local var_22_19 = arg_22_0:current_health()

			var_22_18 = var_22_19 <= var_22_18 and var_22_19 - var_22_16 or var_22_18
		end

		arg_22_0.damage = arg_22_0.damage + var_22_18
		arg_22_0.predicted_damage = math.max(arg_22_0.predicted_damage - var_22_18, 0)

		if arg_22_0:_should_die() and (arg_22_0.is_server or not var_22_1) then
			local var_22_20 = Unit.get_data(var_22_0, "breed")

			if var_22_20 and var_22_20.name == "skaven_poison_wind_globadier" then
				printf("[HON-43348] Globadier (%s) died. damage_table:\n\t%s", Unit.get_data(var_22_0, "globadier_43348"), table.tostring(var_22_15))
			end

			Managers.state.entity:system("death_system"):kill_unit(var_22_0, var_22_15)
		end
	end

	local var_22_21 = ScriptUnit.has_extension(arg_22_9, "buff_system")

	if var_22_21 and arg_22_7 == "dot_debuff" then
		var_22_21:trigger_procs("on_dot_damage_dealt", var_22_0, arg_22_9, arg_22_4, arg_22_7)
	end

	if var_22_17 and arg_22_2 > 0 and arg_22_7 ~= "temporary_health_degen" then
		var_22_17:trigger_procs("on_damage_taken", arg_22_1, arg_22_2, arg_22_4, arg_22_15)
	end

	arg_22_0:_sync_out_damage(arg_22_1, var_22_1, var_22_2, arg_22_9, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_10, arg_22_11, arg_22_12, arg_22_13, arg_22_14, arg_22_15, arg_22_16, arg_22_17)
end

function GenericHealthExtension._sync_out_damage(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9, arg_23_10, arg_23_11, arg_23_12, arg_23_13, arg_23_14, arg_23_15, arg_23_16, arg_23_17, arg_23_18, arg_23_19)
	if arg_23_0.is_server and arg_23_2 then
		local var_23_0 = Managers.state.network
		local var_23_1, var_23_2 = var_23_0:game_object_or_level_id(arg_23_1)
		local var_23_3 = var_23_0:unit_game_object_id(arg_23_4) or NetworkConstants.invalid_game_object_id
		local var_23_4 = NetworkLookup.hit_zones[arg_23_6]
		local var_23_5 = NetworkLookup.damage_types[arg_23_7]
		local var_23_6 = NetworkLookup.damage_sources[arg_23_10 or "n/a"]
		local var_23_7 = NetworkLookup.hit_ragdoll_actors[arg_23_11 or "n/a"]
		local var_23_8 = NetworkLookup.hit_react_types[arg_23_12 or "light"]
		local var_23_9 = NetworkLookup.buff_attack_types[arg_23_17 or "n/a"]
		local var_23_10 = arg_23_0.network_transmit
		local var_23_11 = arg_23_0.dead or false

		arg_23_13 = arg_23_13 or false
		arg_23_14 = arg_23_14 or false
		arg_23_15 = arg_23_15 or false
		arg_23_16 = arg_23_16 or 0
		arg_23_18 = arg_23_18 or 1
		arg_23_19 = arg_23_19 or 1

		var_23_10:send_rpc_clients("rpc_add_damage", arg_23_2, arg_23_3, var_23_1, var_23_2, var_23_3, arg_23_5, var_23_4, var_23_5, arg_23_8, arg_23_9, var_23_6, var_23_7, var_23_8, var_23_11, arg_23_13, arg_23_14, arg_23_15, arg_23_16, var_23_9, arg_23_18, arg_23_19)
	end
end

function GenericHealthExtension.add_heal(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = arg_24_0.unit
	local var_24_1 = ScriptUnit.has_extension(var_24_0, "buff_system")

	if var_24_1 and var_24_1:has_buff_perk("healing_immune") then
		return
	end

	arg_24_0:_add_to_damage_history_buffer(var_24_0, arg_24_1, -arg_24_2, nil, "heal", nil, nil, arg_24_3, nil, nil, nil, nil, nil, nil, nil, nil, nil)

	if not arg_24_0.dead then
		arg_24_0.damage = math.max(0, arg_24_0.damage - arg_24_2)

		local var_24_2, var_24_3 = Managers.state.network:game_object_or_level_id(var_24_0)

		if var_24_2 and arg_24_0.is_server then
			local var_24_4, var_24_5 = Managers.state.network:game_object_or_level_id(arg_24_1)
			local var_24_6 = NetworkLookup.heal_types[arg_24_4]

			arg_24_0.network_transmit:send_rpc_clients("rpc_heal", var_24_2, var_24_3, var_24_4, var_24_5, arg_24_2, var_24_6)
		end
	end
end

function GenericHealthExtension.die(arg_25_0, arg_25_1)
	if arg_25_0.is_server then
		local var_25_0 = arg_25_0.unit

		if ScriptUnit.has_extension(var_25_0, "ai_system") then
			arg_25_1 = arg_25_1 or "undefined"

			AiUtils.kill_unit(var_25_0, nil, nil, arg_25_1, nil)
		end
	end
end

function GenericHealthExtension.entered_kill_volume(arg_26_0, arg_26_1)
	arg_26_0:die("volume_insta_kill")
end

function GenericHealthExtension.set_dead(arg_27_0)
	arg_27_0.damage = arg_27_0.health
	arg_27_0.dead = true
	HEALTH_ALIVE[arg_27_0.unit] = nil
end

function GenericHealthExtension.has_assist_shield(arg_28_0)
	return false
end

function GenericHealthExtension.recent_damages(arg_29_0)
	local var_29_0 = 3 - arg_29_0.system_data.active_damage_buffer_index
	local var_29_1 = arg_29_0.damage_buffers[var_29_0]

	return pdArray.data(var_29_1)
end

function GenericHealthExtension.recent_damage_source(arg_30_0)
	return arg_30_0._recent_damage_source_name
end

function GenericHealthExtension.recently_damaged(arg_31_0)
	return arg_31_0._recent_damage_type, arg_31_0._recent_hit_react_type
end

function GenericHealthExtension.last_damage_t(arg_32_0)
	return arg_32_0._last_damage_t
end

function GenericHealthExtension.get_is_invincible(arg_33_0)
	local var_33_0 = arg_33_0.unit
	local var_33_1 = false
	local var_33_2 = ScriptUnit.has_extension(var_33_0, "buff_system")

	if var_33_2 then
		var_33_1 = var_33_2:has_buff_perk("invulnerable")
	end

	local var_33_3 = false
	local var_33_4 = ScriptUnit.has_extension(var_33_0, "ghost_mode_system")

	if var_33_4 then
		var_33_3 = var_33_4:is_in_ghost_mode()
	end

	return arg_33_0.is_invincible or var_33_1 or var_33_3
end

function GenericHealthExtension.save_kill_feed_data(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6)
	local var_34_0 = arg_34_0.unit
	local var_34_1 = arg_34_0.last_damage_data
	local var_34_2 = false
	local var_34_3 = arg_34_0:current_health()

	if arg_34_4 ~= "temporary_health_degen" and arg_34_4 ~= "knockdown_bleed" and var_34_3 > 0 then
		local var_34_4 = arg_34_6 or AiUtils.get_actual_attacker_unit(arg_34_1)

		if HEALTH_ALIVE[var_34_4] then
			local var_34_5 = Unit.get_data(var_34_4, "breed")

			if not (var_34_4 == var_34_0 and var_34_5 and not var_34_5.is_player) and (var_34_4 ~= var_34_0 or arg_34_4 ~= "cutting") and var_34_5 then
				var_34_1.breed = var_34_5
				var_34_1.damage_type = arg_34_4
				var_34_1.attacker_unit_id = Managers.state.network:unit_game_object_id(var_34_4)
				var_34_2 = true

				local var_34_6 = Managers.player:owner(var_34_4)

				if var_34_6 then
					var_34_1.attacker_unique_id = var_34_6:unique_id()
					var_34_1.attacker_side = Managers.state.side.side_by_unit[var_34_4]
				else
					var_34_1.attacker_unique_id = nil
					var_34_1.attacker_side = nil
				end
			end
		end
	end

	if not var_34_2 then
		local var_34_7 = Managers.state.entity:system("area_damage_system"):has_source_attacker_unit_data(arg_34_1)

		if var_34_7 then
			var_34_1.breed = var_34_7.breed
			var_34_1.attacker_unique_id = var_34_7.attacker_unique_id
			var_34_1.attacker_side = var_34_7.attacker_side
		end
	end
end

function GenericHealthExtension._register_attacker(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = arg_35_0._recent_attackers
	local var_35_1 = var_35_0[arg_35_1]
	local var_35_2 = arg_35_3 + var_0_3

	if var_35_1 then
		arg_35_0._health_system:refresh_recent_attacker(var_35_1, arg_35_2, var_35_2)
	else
		var_35_0[arg_35_1] = arg_35_0._health_system:rent_recent_attacker(arg_35_2, var_35_2)
	end
end

function GenericHealthExtension.was_attacked_by(arg_36_0, arg_36_1)
	local var_36_0 = Managers.time:time("game")
	local var_36_1 = arg_36_0._recent_attackers[arg_36_1]

	if var_36_1 and var_36_0 > var_36_1.t then
		arg_36_0._health_system:return_recent_attacker(var_36_1)

		arg_36_0._recent_attackers[arg_36_1] = nil

		return false
	end

	return var_36_1
end

function GenericHealthExtension.recent_attackers(arg_37_0)
	return arg_37_0._recent_attackers
end
