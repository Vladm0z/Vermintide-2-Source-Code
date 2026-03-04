-- chunkname: @scripts/unit_extensions/deus/deus_belakor_totem_extension.lua

require("scripts/settings/dlcs/belakor/belakor_balancing")

local var_0_0 = {
	INITIAL = 0,
	COOLDOWN_FROM_SPAWN = 2,
	WAITING_TO_SPAWN_ENEMIES = 1,
	SPAWNING_ENEMIES = 4,
	DESPAWNED = 5,
	DECAL_SPAWNED = 3
}
local var_0_1 = "units/decals/deus_decal_aoe_cursedchest_01"
local var_0_2 = 2
local var_0_3 = 5
local var_0_4 = 8

local function var_0_5(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_2 * arg_1_2

	for iter_1_0 = 1, #arg_1_1 do
		local var_1_1 = arg_1_1[iter_1_0]

		if var_1_1 and var_1_0 > Vector3.distance_squared(arg_1_0, var_1_1) then
			return true
		end
	end

	return false
end

local function var_0_6(arg_2_0, arg_2_1)
	return var_0_5(arg_2_0, arg_2_1, BelakorBalancing.totem_spawns_distance)
end

local function var_0_7(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_3 + Vector3(0, 0, 1.5)
	local var_3_1 = Vector3.normalize(var_3_0 - arg_3_2)

	return Vector3.dot(arg_3_1, var_3_1) > 0 and (not World.umbra_available(arg_3_0) or World.umbra_has_line_of_sight(arg_3_0, var_3_0, arg_3_2))
end

local function var_0_8(arg_4_0)
	local var_4_0, var_4_1 = var_0_2, Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_4_0)

	Matrix4x4.set_scale(var_4_1, Vector3(var_4_0, var_4_0, var_4_0))

	local var_4_2, var_4_3 = Managers.state.unit_spawner:spawn_network_unit(var_0_1, "network_synched_dummy_unit", nil, var_4_1)

	return var_4_2, var_4_3
end

local function var_0_9(arg_5_0, arg_5_1, arg_5_2)
	if not World.umbra_available(arg_5_0) then
		return true
	end

	local var_5_0 = Vector3(0, 0, 1.5)

	for iter_5_0 = 1, #arg_5_2 do
		local var_5_1 = arg_5_2[iter_5_0]

		if World.umbra_has_line_of_sight(arg_5_0, var_5_1 + var_5_0, arg_5_1 + var_5_0) then
			return true
		end
	end

	return false
end

local function var_0_10(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0
	local var_6_1 = Managers.state.conflict:start_terror_event(arg_6_2, arg_6_1, arg_6_0)

	arg_6_1 = Math.next_random(arg_6_1)

	return arg_6_1, var_6_1
end

function push_players_away(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = math.pi / 6
	local var_7_1 = arg_7_3 * math.cos(var_7_0)
	local var_7_2 = arg_7_3 * math.sin(var_7_0)
	local var_7_3 = arg_7_2 * arg_7_2

	for iter_7_0 = 1, #arg_7_0 do
		local var_7_4 = arg_7_0[iter_7_0]
		local var_7_5 = POSITION_LOOKUP[var_7_4] - arg_7_1

		if var_7_3 >= Vector3.length_squared(var_7_5) then
			local var_7_6 = Vector3.normalize(Vector3.flat(var_7_5)) * var_7_1

			var_7_6.z = var_7_2

			StatusUtils.set_catapulted_network(var_7_4, true, var_7_6)
		end
	end

	local var_7_7 = NetworkLookup.effects["fx/chr_kruber_shockwave"]

	Managers.state.network:rpc_play_particle_effect_no_rotation(nil, var_7_7, NetworkConstants.invalid_game_object_id, 0, arg_7_1, false)
end

DeusBelakorTotemExtension = class(DeusBelakorTotemExtension)

DeusBelakorTotemExtension.init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0._unit = arg_8_2
	arg_8_0.spawn_count = 0
	arg_8_0._is_server = Managers.player.is_server
	arg_8_0._world = arg_8_1.world
	arg_8_0._hero_side = Managers.state.side:get_side_from_name("heroes")
	arg_8_0._network_transmit = arg_8_1.network_transmit

	if arg_8_0._is_server then
		arg_8_0._current_state = var_0_0.INITIAL
		arg_8_0._last_in_range_t = 0
	end

	arg_8_0._dead = false
end

DeusBelakorTotemExtension.game_object_initialized = function (arg_9_0, arg_9_1, arg_9_2)
	arg_9_0._current_state = var_0_0.COOLDOWN_FROM_SPAWN

	local var_9_0 = Managers.mechanism:get_level_seed()

	arg_9_0._seed = HashUtils.fnv32_hash(arg_9_2 .. "_" .. var_9_0)
end

DeusBelakorTotemExtension.extensions_ready = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0._health_ext = ScriptUnit.extension(arg_10_2, "health_system")
end

DeusBelakorTotemExtension.destroy = function (arg_11_0)
	if ALIVE[arg_11_0._decal_unit] then
		Unit.flow_event(arg_11_0._decal_unit, "despawned")
		arg_11_0._network_transmit:send_rpc_clients("rpc_flow_event", arg_11_0._decal_unit_go_id, NetworkLookup.flow_events.despawned)

		arg_11_0._decal_unit = nil
		arg_11_0._decal_unit_go_id = nil
	end
end

DeusBelakorTotemExtension.is_despawned = function (arg_12_0)
	return arg_12_0._current_state == var_0_0.DESPAWNED
end

DeusBelakorTotemExtension.update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	if not HEALTH_ALIVE[arg_13_1] then
		if not arg_13_0._dead then
			Managers.state.achievement:trigger_event("register_totem_state_change", arg_13_0._unit, false)

			if arg_13_0._is_server and arg_13_0._decal_unit then
				Unit.flow_event(arg_13_0._decal_unit, "despawned")
				arg_13_0._network_transmit:send_rpc_clients("rpc_flow_event", arg_13_0._decal_unit_go_id, NetworkLookup.flow_events.despawned)

				arg_13_0._decal_unit = nil
				arg_13_0._decal_unit_go_id = nil
			end

			Managers.state.event:trigger("tutorial_event_show_health_bar", arg_13_0._unit, false)
			Unit.flow_event(arg_13_1, "lua_on_death")

			arg_13_0._dead = true
		end

		return
	end

	if not arg_13_0._totem_position then
		arg_13_0._totem_position = Vector3Box(Unit.world_position(arg_13_0._unit, 0))
	end

	local var_13_0 = arg_13_0._totem_position:unbox()
	local var_13_1 = false
	local var_13_2 = Managers.player:local_player().player_unit

	if var_13_2 and ScriptUnit.has_extension(var_13_2, "first_person_system") then
		local var_13_3 = ScriptUnit.extension(var_13_2, "first_person_system")
		local var_13_4 = var_13_3:current_position()
		local var_13_5 = var_13_3:current_rotation()
		local var_13_6 = Quaternion.forward(var_13_5)

		var_13_1 = var_0_7(arg_13_0._world, var_13_6, var_13_4, var_13_0)
	end

	if arg_13_0._player_seeing_totem == nil or var_13_1 ~= arg_13_0._player_seeing_totem then
		local var_13_7 = Managers.state.event

		if var_13_1 then
			var_13_7:trigger("tutorial_event_show_health_bar", arg_13_0._unit, true)
		else
			var_13_7:trigger("tutorial_event_show_health_bar", arg_13_0._unit, false)
		end
	end

	arg_13_0._player_seeing_totem = var_13_1

	if arg_13_0._is_server then
		local var_13_8 = arg_13_0._hero_side.PLAYER_AND_BOT_POSITIONS

		if not arg_13_0._totem_activated then
			if var_0_9(arg_13_0._world, var_13_0, var_13_8) then
				arg_13_0._totem_activated = true

				Managers.state.achievement:trigger_event("register_totem_state_change", arg_13_0._unit, true)
			end
		else
			if not arg_13_0._panic_spawn_triggered and arg_13_0._health_ext:current_health_percent() <= 0.5 then
				arg_13_0._panic_spawn_triggered = true
				arg_13_0._seed = var_0_10(arg_13_0._unit, arg_13_0._seed, "belakor_totem_panic_spawns")
			end

			local var_13_9 = arg_13_0._current_state

			if var_13_9 == var_0_0.COOLDOWN_FROM_SPAWN then
				if not TerrorEventMixer.is_event_id_active_or_pending(arg_13_0._totem_terror_event_id) then
					arg_13_0._current_state = var_0_0.DECAL_SPAWNED
				end
			elseif var_13_9 == var_0_0.DECAL_SPAWNED then
				if not arg_13_0._spawn_decal_end_t then
					arg_13_0._spawn_decal_end_t = arg_13_5 + BelakorBalancing.totem_decal_duration
				end

				if not arg_13_0._decal_unit then
					arg_13_0._decal_unit, arg_13_0._decal_unit_go_id = var_0_8(var_13_0)
				end

				if arg_13_5 > arg_13_0._spawn_decal_end_t then
					Unit.flow_event(arg_13_0._decal_unit, "despawned")
					arg_13_0._network_transmit:send_rpc_clients("rpc_flow_event", arg_13_0._decal_unit_go_id, NetworkLookup.flow_events.despawned)

					arg_13_0._decal_unit = nil
					arg_13_0._decal_unit_go_id = nil
					arg_13_0._spawn_decal_end_t = nil

					if var_0_6(var_13_0, var_13_8) then
						arg_13_0._current_state = var_0_0.SPAWNING_ENEMIES
					else
						arg_13_0._current_state = var_0_0.WAITING_TO_SPAWN_ENEMIES
					end
				end
			elseif var_13_9 == var_0_0.WAITING_TO_SPAWN_ENEMIES then
				if var_0_6(var_13_0, var_13_8) then
					arg_13_0._current_state = var_0_0.DECAL_SPAWNED
				end
			elseif var_13_9 == var_0_0.SPAWNING_ENEMIES then
				if arg_13_0.spawn_count >= BelakorBalancing.harder_spawn_interval then
					arg_13_0.spawn_count = 0
					arg_13_0._seed, arg_13_0._totem_terror_event_id = var_0_10(arg_13_0._unit, arg_13_0._seed, "belakor_hard_totem_spawns")
				else
					arg_13_0.spawn_count = arg_13_0.spawn_count + 1
					arg_13_0._seed, arg_13_0._totem_terror_event_id = var_0_10(arg_13_0._unit, arg_13_0._seed, "belakor_easy_totem_spawns")
				end

				arg_13_0._current_state = var_0_0.COOLDOWN_FROM_SPAWN
			end
		end

		if var_0_5(var_13_0, var_13_8, BelakorBalancing.totem_despawn_distance) then
			arg_13_0._last_in_range_t = arg_13_5
		elseif arg_13_5 >= arg_13_0._last_in_range_t + BelakorBalancing.totem_distance_despawn_time then
			Managers.state.achievement:trigger_event("register_totem_state_change", arg_13_0._unit, false)

			arg_13_0._current_state = var_0_0.DESPAWNED
		end
	elseif not arg_13_0._totem_activated then
		local var_13_10 = arg_13_0._hero_side.PLAYER_AND_BOT_POSITIONS

		if var_0_9(arg_13_0._world, var_13_0, var_13_10) then
			arg_13_0._totem_activated = true

			Managers.state.achievement:trigger_event("register_totem_state_change", arg_13_0._unit, true)
		end
	end
end
