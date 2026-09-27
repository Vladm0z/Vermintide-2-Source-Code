-- chunkname: @scripts/unit_extensions/deus/deus_belakor_totem_extension.lua

require("scripts/settings/dlcs/belakor/belakor_balancing")

local tbl = {
	INITIAL = 0,
	COOLDOWN_FROM_SPAWN = 2,
	WAITING_TO_SPAWN_ENEMIES = 1,
	SPAWNING_ENEMIES = 4,
	DESPAWNED = 5,
	DECAL_SPAWNED = 3
}
local str = "units/decals/deus_decal_aoe_cursedchest_01"
local num = 2
local num_2 = 5
local num_3 = 8

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local num = arg_1_2 * arg_1_2

	for i = 1, #arg_1_1 do
		local var_1_1 = arg_1_1[i]

		if not (not var_1_1 and not (num > Vector3.distance_squared(arg_1_0, var_1_1))) then
			return true
		end
	end

	return false
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	return fn(arg_2_0, arg_2_1, BelakorBalancing.totem_spawns_distance)
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local num = arg_3_3 + Vector3(0, 0, 1.5)
	local normalize = Vector3.normalize(num - arg_3_2)

	return (not (Vector3.dot(arg_3_1, normalize) > 0) or not World.umbra_available(arg_3_0)) and World.umbra_has_line_of_sight(arg_3_0, num, arg_3_2)
end

local function fn_4(arg_4_0)
	-- function 4
	local var_4_0, from_quaternion_position = num, Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_4_0)

	Matrix4x4.set_scale(from_quaternion_position, Vector3(var_4_0, var_4_0, var_4_0))

	local spawn_network_unit, var_4_3 = Managers.state.unit_spawner:spawn_network_unit(str, "network_synched_dummy_unit", nil, from_quaternion_position)

	return spawn_network_unit, var_4_3
end

local function fn_5(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	if not World.umbra_available(arg_5_0) then
		return true
	end

	local var_5_0 = Vector3(0, 0, 1.5)

	for i = 1, #arg_5_2 do
		local var_5_1 = arg_5_2[i]

		if not World.umbra_has_line_of_sight(arg_5_0, var_5_1 + var_5_0, arg_5_1 + var_5_0) then
			return true
		end
	end

	return false
end

local function fn_6(arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0
	local start_terror_event = Managers.state.conflict:start_terror_event(arg_6_2, arg_6_1, arg_6_0)

	arg_6_1 = Math.next_random(arg_6_1)

	return arg_6_1, start_terror_event
end

function push_players_away(self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local num = math.pi / 6
	local num_2 = arg_7_3 * math.cos(num)
	local num_3 = arg_7_3 * math.sin(num)
	local num_4 = arg_7_2 * arg_7_2

	for i = 1, #self do
		local var_7_4 = self[i]
		local num_5 = POSITION_LOOKUP[var_7_4] - arg_7_1

		if num_4 >= Vector3.length_squared(num_5) then
			local num_6 = Vector3.normalize(Vector3.flat(num_5)) * num_2

			num_6.z = num_3

			StatusUtils.set_catapulted_network(var_7_4, true, num_6)
		end
	end

	local var_7_7 = NetworkLookup.effects["fx/chr_kruber_shockwave"]

	Managers.state.network:rpc_play_particle_effect_no_rotation(nil, var_7_7, NetworkConstants.invalid_game_object_id, 0, arg_7_1, false)
end

DeusBelakorTotemExtension = class(DeusBelakorTotemExtension)

DeusBelakorTotemExtension.init = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	self._unit = arg_8_2
	self.spawn_count = 0
	self._is_server = Managers.player.is_server
	self._world = arg_8_1.world
	self._hero_side = Managers.state.side:get_side_from_name("heroes")
	self._network_transmit = arg_8_1.network_transmit

	if not self._is_server then
		self._current_state = tbl.INITIAL
		self._last_in_range_t = 0
	end

	self._dead = false
end

DeusBelakorTotemExtension.game_object_initialized = function (self, arg_9_1, arg_9_2)
	-- function 9
	self._current_state = tbl.COOLDOWN_FROM_SPAWN

	local get_level_seed = Managers.mechanism:get_level_seed()

	self._seed = HashUtils.fnv32_hash(arg_9_2 .. "_" .. get_level_seed)
end

DeusBelakorTotemExtension.extensions_ready = function (self, arg_10_1, arg_10_2)
	-- function 10
	self._health_ext = ScriptUnit.extension(arg_10_2, "health_system")
end

DeusBelakorTotemExtension.destroy = function (self)
	-- function 11
	if not ALIVE[self._decal_unit] then
		Unit.flow_event(self._decal_unit, "despawned")
		self._network_transmit:send_rpc_clients("rpc_flow_event", self._decal_unit_go_id, NetworkLookup.flow_events.despawned)

		self._decal_unit = nil
		self._decal_unit_go_id = nil
	end
end

DeusBelakorTotemExtension.is_despawned = function (self)
	-- function 12
	return self._current_state == tbl.DESPAWNED
end

DeusBelakorTotemExtension.update = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	if not HEALTH_ALIVE[arg_13_1] then
		if not self._dead then
			Managers.state.achievement:trigger_event("register_totem_state_change", self._unit, false)

			if not self._is_server and not self._decal_unit then
				Unit.flow_event(self._decal_unit, "despawned")
				self._network_transmit:send_rpc_clients("rpc_flow_event", self._decal_unit_go_id, NetworkLookup.flow_events.despawned)

				self._decal_unit = nil
				self._decal_unit_go_id = nil
			end

			Managers.state.event:trigger("tutorial_event_show_health_bar", self._unit, false)
			Unit.flow_event(arg_13_1, "lua_on_death")

			self._dead = true
		end

		return
	end

	if not self._totem_position then
		self._totem_position = Vector3Box(Unit.world_position(self._unit, 0))
	end

	local unbox = self._totem_position:unbox()
	local flag = false
	local player_unit = Managers.player:local_player().player_unit

	if not player_unit and not ScriptUnit.has_extension(player_unit, "first_person_system") then
		local extension = ScriptUnit.extension(player_unit, "first_person_system")
		local current_position = extension:current_position()
		local current_rotation = extension:current_rotation()
		local forward = Quaternion.forward(current_rotation)

		flag = fn_3(self._world, forward, current_position, unbox)
	end

	if not (self._player_seeing_totem == nil or flag == self._player_seeing_totem) then
		local event = Managers.state.event

		if not flag then
			event:trigger("tutorial_event_show_health_bar", self._unit, true)
		else
			event:trigger("tutorial_event_show_health_bar", self._unit, false)
		end
	end

	self._player_seeing_totem = flag

	if not self._is_server then
		local PLAYER_AND_BOT_POSITIONS = self._hero_side.PLAYER_AND_BOT_POSITIONS

		if not self._totem_activated then
			if not fn_5(self._world, unbox, PLAYER_AND_BOT_POSITIONS) then
				self._totem_activated = true

				Managers.state.achievement:trigger_event("register_totem_state_change", self._unit, true)
			end
		else
			if not (self._panic_spawn_triggered or not (self._health_ext:current_health_percent() <= 0.5)) then
				self._panic_spawn_triggered = true
				self._seed = fn_6(self._unit, self._seed, "belakor_totem_panic_spawns")
			end

			local _current_state = self._current_state

			if _current_state == tbl.COOLDOWN_FROM_SPAWN then
				if not TerrorEventMixer.is_event_id_active_or_pending(self._totem_terror_event_id) then
					self._current_state = tbl.DECAL_SPAWNED
				end
			elseif _current_state == tbl.DECAL_SPAWNED then
				if not self._spawn_decal_end_t then
					self._spawn_decal_end_t = arg_13_5 + BelakorBalancing.totem_decal_duration
				end

				if not self._decal_unit then
					self._decal_unit, self._decal_unit_go_id = fn_4(unbox)
				end

				if arg_13_5 > self._spawn_decal_end_t then
					Unit.flow_event(self._decal_unit, "despawned")
					self._network_transmit:send_rpc_clients("rpc_flow_event", self._decal_unit_go_id, NetworkLookup.flow_events.despawned)

					self._decal_unit = nil
					self._decal_unit_go_id = nil
					self._spawn_decal_end_t = nil

					if not fn_2(unbox, PLAYER_AND_BOT_POSITIONS) then
						self._current_state = tbl.SPAWNING_ENEMIES
					else
						self._current_state = tbl.WAITING_TO_SPAWN_ENEMIES
					end
				end
			elseif _current_state == tbl.WAITING_TO_SPAWN_ENEMIES then
				if not fn_2(unbox, PLAYER_AND_BOT_POSITIONS) then
					self._current_state = tbl.DECAL_SPAWNED
				end
			elseif _current_state == tbl.SPAWNING_ENEMIES then
				if self.spawn_count >= BelakorBalancing.harder_spawn_interval then
					self.spawn_count = 0
					self._seed, self._totem_terror_event_id = fn_6(self._unit, self._seed, "belakor_hard_totem_spawns")
				else
					self.spawn_count = self.spawn_count + 1
					self._seed, self._totem_terror_event_id = fn_6(self._unit, self._seed, "belakor_easy_totem_spawns")
				end

				self._current_state = tbl.COOLDOWN_FROM_SPAWN
			end
		end

		if not fn(unbox, PLAYER_AND_BOT_POSITIONS, BelakorBalancing.totem_despawn_distance) then
			self._last_in_range_t = arg_13_5
		elseif arg_13_5 >= self._last_in_range_t + BelakorBalancing.totem_distance_despawn_time then
			Managers.state.achievement:trigger_event("register_totem_state_change", self._unit, false)

			self._current_state = tbl.DESPAWNED
		end
	elseif not self._totem_activated then
		local PLAYER_AND_BOT_POSITIONS_2 = self._hero_side.PLAYER_AND_BOT_POSITIONS

		if not fn_5(self._world, unbox, PLAYER_AND_BOT_POSITIONS_2) then
			self._totem_activated = true

			Managers.state.achievement:trigger_event("register_totem_state_change", self._unit, true)
		end
	end
end
