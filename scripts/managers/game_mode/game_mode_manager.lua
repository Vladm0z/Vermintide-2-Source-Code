-- chunkname: @scripts/managers/game_mode/game_mode_manager.lua

require("scripts/settings/game_mode_settings")
require("scripts/managers/game_mode/game_mode_helper")
require("scripts/managers/game_mode/game_modes/game_mode_adventure")
require("scripts/managers/game_mode/game_modes/game_mode_survival")
require("scripts/managers/game_mode/game_modes/game_mode_tutorial")
require("scripts/managers/game_mode/game_modes/game_mode_inn")
require("scripts/managers/game_mode/game_modes/game_mode_demo")
require("scripts/managers/game_mode/game_modes/game_mode_weave")
require("scripts/managers/game_mode/mutator_handler")
require("scripts/managers/game_mode/horde_surge_handler")
DLCUtils.require_list("game_mode_files")

local tbl = {
	"rpc_is_ready_for_transition",
	"rpc_apply_environment_variation",
	"rpc_change_game_mode_state",
	"rpc_trigger_level_event"
}
local testify = script_data.testify

testify = not testify and require("scripts/managers/game_mode/game_mode_manager_testify")

local tbl_2 = {}

for k, v in pairs(GameModeSettings) do
	local tbl_3 = {}

	for i, v_2 in ipairs(v.game_mode_states) do
		tbl_3[i] = v_2
		tbl_3[v_2] = i
	end

	tbl_2[k] = tbl_3
end

GameModeManager = class(GameModeManager)

GameModeManager.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	-- function 1
	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
	local is_host = arg_1_2.is_host

	self._lobby_host = not is_host and arg_1_2
	self._lobby_client = not is_host and arg_1_2
	self.is_server = is_host
	self._world = arg_1_1
	self._game_mode_key = arg_1_5
	self._level_key = get_current_level_keys
	self._end_conditions_met = false
	self._gm_event_end_conditions_met = false
	self._round_started = false
	self._end_reason = nil
	self._ready_for_transition = nil
	self.statistics_db = arg_1_4
	self._network_handler = arg_1_6
	self._network_transmit = arg_1_7
	self._profile_synchronizer = arg_1_8
	self._have_signalled_ready_to_transition = false

	self:_init_game_mode(arg_1_5, arg_1_9)

	local event = Managers.state.event

	event:register(self, "reload_application_settings", "event_reload_application_settings")
	event:register(self, "gm_event_round_started", "gm_event_round_started")
	event:register(self, "camera_teleported", "event_camera_teleported")

	self.network_event_delegate = arg_1_3

	arg_1_3:register(self, unpack(tbl))
	self._game_mode:register_rpcs(arg_1_3, arg_1_7)

	self._object_sets = nil
	self._object_set_names = nil

	local num = 8192

	self._flow_set_data = {
		units_per_frame = 150,
		write_index = 1,
		read_index = 1,
		size = 0,
		ring_buffer = Script.new_array(num),
		max_size = num
	}

	local mutators = self._game_mode:mutators()
	local mutators_2 = LevelSettings[self._level_key].mutators

	if not mutators_2 then
		mutators = mutators or {}

		for i = 1, #mutators_2 do
			mutators[#mutators + 1] = mutators_2[i]
		end
	end

	local flag = not DEDICATED_SERVER

	self._mutator_handler = MutatorHandler:new(mutators, self.is_server, arg_1_6, flag, arg_1_1, arg_1_3, arg_1_7)
	self._looping_event_timers = {}
	self._disable_spawning_reasons = {}

	if not self.is_server then
		self._initial_peers_ready = false
	end

	self._has_created_game_mode_data = false
	self._locked_profile_index = nil
end

GameModeManager.destroy = function (self)
	-- function 2
	self._mutator_handler:destroy()

	self._lobby_host = nil
	self._lobby_client = nil

	self._game_mode:unregister_rpcs()
	self._game_mode:destroy()
	Managers.party:cleanup_game_mode_data()
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

GameModeManager.cleanup_game_mode_units = function (self)
	-- function 3
	self._game_mode:cleanup_game_mode_units()
end

GameModeManager.deactivate_mutators = function (self, arg_4_1)
	-- function 4
	self._mutator_handler:deactivate_mutators(arg_4_1)
end

GameModeManager.conflict_director_updated_settings = function (self)
	-- function 5
	self._mutator_handler:conflict_director_updated_settings()
end

GameModeManager.settings = function (self)
	-- function 6
	return GameModeSettings[self._game_mode_key]
end

GameModeManager.setting = function (self, arg_7_1)
	-- function 7
	return GameModeSettings[self._game_mode_key][arg_7_1]
end

GameModeManager.gm_event_end_conditions_met = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	self._gm_event_end_conditions_met = true

	if arg_8_1 == "lost" then
		local current_level = LevelHelper:current_level(self._world)
		local str = self._game_mode_key .. "_round_lost"

		Level.trigger_event(current_level, str)
	end

	self._game_mode:gm_event_end_conditions_met(arg_8_1, arg_8_2, arg_8_3)
	self:_save_last_level_completed(arg_8_1)
end

GameModeManager.is_game_mode_ended = function (self)
	-- function 9
	return self._gm_event_end_conditions_met
end

GameModeManager.setup_done = function (self)
	-- function 10
	self._game_mode:setup_done()
	self._mutator_handler:activate_mutators()
end

GameModeManager.deactivate_mutator = function (self, arg_11_1)
	-- function 11
	self._mutator_handler:deactivate_mutator(arg_11_1)
end

GameModeManager.player_entered_game_session = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	self._game_mode:player_entered_game_session(arg_12_1, arg_12_2, arg_12_3)
end

GameModeManager.remove_bot = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	return self._game_mode:remove_bot(arg_13_1, arg_13_2, arg_13_3, arg_13_4)
end

GameModeManager.player_left_game_session = function (self, arg_14_1, arg_14_2)
	-- function 14
	self._game_mode:player_left_game_session(arg_14_1, arg_14_2)
end

GameModeManager.player_joined_party = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	self._game_mode:player_joined_party(arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
end

GameModeManager.player_left_party = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	self._game_mode:player_left_party(arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
end

GameModeManager.ai_killed = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	self._mutator_handler:ai_killed(arg_17_1, arg_17_2, arg_17_3, arg_17_4)

	local _game_mode = self._game_mode

	if not _game_mode.ai_killed then
		_game_mode:ai_killed(arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	end
end

GameModeManager.level_object_killed = function (self, arg_18_1, arg_18_2)
	-- function 18
	self._mutator_handler:level_object_killed(arg_18_1, arg_18_2)
end

GameModeManager.ai_hit_by_player = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	self._mutator_handler:ai_hit_by_player(arg_19_1, arg_19_2, arg_19_3)
end

GameModeManager.player_hit = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	self._mutator_handler:player_hit(arg_20_1, arg_20_2, arg_20_3)
end

GameModeManager.modify_player_base_damage = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	return self._mutator_handler:modify_player_base_damage(arg_21_1, arg_21_2, arg_21_3, arg_21_4)
end

GameModeManager.player_respawned = function (self, arg_22_1)
	-- function 22
	self._mutator_handler:player_respawned(arg_22_1)
end

GameModeManager.damage_taken = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	self._mutator_handler:damage_taken(arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
end

GameModeManager.pre_ai_spawned = function (self, arg_24_1, arg_24_2)
	-- function 24
	self._mutator_handler:pre_ai_spawned(arg_24_1, arg_24_2)
end

GameModeManager.ai_spawned = function (self, arg_25_1)
	-- function 25
	self._mutator_handler:ai_spawned(arg_25_1)
end

GameModeManager.post_ai_spawned = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	self._mutator_handler:post_ai_spawned(arg_26_2, arg_26_3)
end

GameModeManager.set_override_respawn_group = function (self, arg_27_1, arg_27_2)
	-- function 27
	if not self._game_mode.set_override_respawn_group then
		self._game_mode:set_override_respawn_group(arg_27_1, arg_27_2)
	end
end

GameModeManager.set_respawn_group_enabled = function (self, arg_28_1, arg_28_2)
	-- function 28
	if not self._game_mode.set_respawn_group_enabled then
		self._game_mode:set_respawn_group_enabled(arg_28_1, arg_28_2)
	end
end

GameModeManager.set_respawn_gate_enabled = function (self, arg_29_1, arg_29_2)
	-- function 29
	if not self._game_mode.set_respawn_gate_enabled then
		self._game_mode:set_respawn_gate_enabled(arg_29_1, arg_29_2)
	end
end

GameModeManager.players_left_safe_zone = function (self)
	-- function 30
	self._mutator_handler:players_left_safe_zone()

	if not self._game_mode.players_left_safe_zone then
		self._game_mode:players_left_safe_zone()
	end
end

GameModeManager.has_activated_mutator = function (self, arg_31_1)
	-- function 31
	return self._mutator_handler:has_activated_mutator(arg_31_1)
end

GameModeManager.activated_mutators = function (self)
	-- function 32
	return self._mutator_handler:activated_mutators()
end

GameModeManager.has_mutator = function (self, arg_33_1)
	-- function 33
	return self._mutator_handler:has_mutator(arg_33_1)
end

GameModeManager.mutators = function (self)
	-- function 34
	return self._mutator_handler:mutators()
end

GameModeManager.initialized_mutator_map = function (self)
	-- function 35
	return self._mutator_handler:initialized_mutator_map()
end

GameModeManager.evaluate_end_zone_activation_conditions = function (self)
	-- function 36
	return self._mutator_handler:evaluate_end_zone_activation_conditions()
end

GameModeManager.post_process_terror_event = function (self, arg_37_1)
	-- function 37
	self._mutator_handler:post_process_terror_event(arg_37_1)
end

GameModeManager.bots_disabled = function (self)
	-- function 38
	return self:settings().bots_disabled
end

GameModeManager.get_saved_game_mode_data = function (self)
	-- function 39
	if not self._game_mode.get_saved_game_mode_data then
		return self._game_mode:get_saved_game_mode_data()
	end
end

GameModeManager.set_object_set_enabled = function (self, arg_40_1, arg_40_2)
	-- function 40
	local var_40_0 = self._object_sets[arg_40_1]

	if not var_40_0 then
		return
	end

	self:_set_flow_object_set_enabled(var_40_0, arg_40_2, arg_40_1)
end

GameModeManager._set_flow_object_set_enabled = function (self, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	if arg_41_1.flow_set_enabled == arg_41_2 then
		return
	end

	local current_level = LevelHelper:current_level(self._world)

	arg_41_1.flow_set_enabled = arg_41_2

	local _flow_set_data = self._flow_set_data
	local ring_buffer = _flow_set_data.ring_buffer
	local write_index = _flow_set_data.write_index
	local read_index = _flow_set_data.read_index
	local size = _flow_set_data.size
	local max_size = _flow_set_data.max_size
	local units = arg_41_1.units
	local count = #units
	local num = size + count - max_size

	if num > 0 then
		local min = math.min(num, size)

		for i = 1, min do
			local var_41_11 = ring_buffer[read_index]

			self:_set_flow_object_set_unit_enabled(current_level, var_41_11)

			read_index = read_index % max_size + 1
			size = size - 1
		end

		_flow_set_data.read_index = read_index
	end

	local num_2 = count - max_size

	for i_2, v in ipairs(units) do
		local unit_by_index = Level.unit_by_index(current_level, v)

		if not unit_by_index then
			local get_data = Unit.get_data(unit_by_index, "flow_object_set_references")

			get_data = get_data or 1

			if not arg_41_2 then
				get_data = get_data + 1
			else
				get_data = math.max(get_data - 1, 0)
			end

			Unit.set_data(unit_by_index, "flow_object_set_references", get_data)

			if i_2 <= num_2 then
				self:_set_flow_object_set_unit_enabled(current_level, v)
			else
				ring_buffer[write_index] = v
				write_index = write_index % max_size + 1
				size = size + 1
			end
		end
	end

	_flow_set_data.write_index = write_index
	_flow_set_data.size = size
end

GameModeManager.event_camera_teleported = function (self)
	-- function 42
	self._flush_object_set_enable = 3
end

GameModeManager.post_update = function (self, arg_43_1, arg_43_2)
	-- function 43
	if not self._game_mode.post_update then
		self._game_mode:post_update(arg_43_1, arg_43_2)
	end
end

GameModeManager.update_flow_object_set_enable = function (self, arg_44_1)
	-- function 44
	local _flow_set_data = self._flow_set_data
	local size = _flow_set_data.size
	local _flush_object_set_enable = self._flush_object_set_enable

	if size > 0 then
		local huge

		if not _flush_object_set_enable then
			huge = math.huge

			if not huge then
				-- Nothing
			end
		end

		huge = _flow_set_data.units_per_frame

		::label_44_0::

		local min = math.min(huge, size)
		local read_index = _flow_set_data.read_index
		local max_size = _flow_set_data.max_size
		local ring_buffer = _flow_set_data.ring_buffer
		local current_level = LevelHelper:current_level(self._world)

		for i = 1, min do
			local var_44_9 = ring_buffer[read_index]

			self:_set_flow_object_set_unit_enabled(current_level, var_44_9)

			read_index = read_index % max_size + 1
			size = size - 1
		end

		_flow_set_data.size = size
		_flow_set_data.read_index = read_index
	end

	if not (not _flush_object_set_enable and _flush_object_set_enable ~= 1) then
		self._flush_object_set_enable = false
	elseif not _flush_object_set_enable then
		self._flush_object_set_enable = _flush_object_set_enable - 1
	end
end

local get_data = Unit.get_data
local flow_event = Unit.flow_event

GameModeManager._set_flow_object_set_unit_enabled = function (self, arg_45_1, arg_45_2)
	-- function 45
	local unit_by_index = Level.unit_by_index(arg_45_1, arg_45_2)
	local var_45_1 = get_data(unit_by_index, "flow_object_set_references")
	local var_45_2 = get_data(unit_by_index, "flow_object_set_enabled")

	if var_45_2 == nil then
		var_45_2 = true
	end

	local flag = not not var_45_2 or var_45_1 > 0
	local flag_2 = not var_45_2 and var_45_1 == 0
	local var_45_5

	if not flag then
		var_45_5 = true
	elseif not flag_2 then
		var_45_5 = false
	end

	if var_45_5 ~= nil then
		Unit.set_data(unit_by_index, "flow_object_set_enabled", var_45_5)

		if not Unit.has_data(unit_by_index, "LevelEditor", "is_gizmo_unit") then
			local get_data_2 = Unit.get_data(unit_by_index, "LevelEditor", "is_gizmo_unit")
			local is_a = Unit.is_a(unit_by_index, "core/stingray_renderer/helper_units/reflection_probe/reflection_probe")

			if not (not get_data_2 and is_a) then
				Unit.set_unit_visibility(unit_by_index, false)
			else
				Unit.set_unit_visibility(unit_by_index, var_45_5)
			end
		else
			Unit.set_unit_visibility(unit_by_index, var_45_5)
		end

		if self._game_mode_key ~= "versus" or not Unit.is_a(unit_by_index, "core/volumetrics/units/fog_volume") then
			if not var_45_5 then
				local get_data_3 = Unit.get_data(unit_by_index, "FogProperties", "albedo", 0)
				local get_data_4 = Unit.get_data(unit_by_index, "FogProperties", "albedo", 1)
				local get_data_5 = Unit.get_data(unit_by_index, "FogProperties", "albedo", 2)
				local get_data_6 = Unit.get_data(unit_by_index, "FogProperties", "falloff", 0)
				local get_data_7 = Unit.get_data(unit_by_index, "FogProperties", "falloff", 1)
				local get_data_8 = Unit.get_data(unit_by_index, "FogProperties", "falloff", 2)
				local get_data_9 = Unit.get_data(unit_by_index, "FogProperties", "extinction")
				local get_data_10 = Unit.get_data(unit_by_index, "FogProperties", "phase")

				Volumetrics.register_volume(unit_by_index, Vector3(get_data_3, get_data_4, get_data_4), get_data_9, get_data_10, Vector3(get_data_6, get_data_7, get_data_8))
			else
				Volumetrics.unregister_volume(unit_by_index)
			end
		end

		if not Unit.has_visibility_group(unit_by_index, "gizmo") then
			Unit.set_visibility(unit_by_index, "gizmo", false)
		end

		if not get_data(unit_by_index, "physics_ignores_object_set") then
			if not var_45_5 then
				flow_event(unit_by_index, "hide_helper_mesh")
				flow_event(unit_by_index, "unit_object_set_enabled")
			else
				flow_event(unit_by_index, "unit_object_set_disabled")
			end
		else
			local var_45_16

			if not var_45_5 then
				var_45_16 = get_data(unit_by_index, "flow_object_set_actor_list")
			else
				var_45_16 = {}
			end

			for i = 0, Unit.num_actors(unit_by_index) - 1 do
				if not var_45_5 and not var_45_16[i] then
					Unit.create_actor(unit_by_index, i)
				elseif var_45_5 or not Unit.actor(unit_by_index, i) then
					Unit.destroy_actor(unit_by_index, i)

					var_45_16[i] = true
				end
			end

			if not var_45_5 then
				Unit.set_data(unit_by_index, "flow_object_set_actor_list", nil)
				flow_event(unit_by_index, "hide_helper_mesh")
				flow_event(unit_by_index, "unit_object_set_enabled")
			else
				Unit.set_data(unit_by_index, "flow_object_set_actor_list", var_45_16)
				flow_event(unit_by_index, "unit_object_set_disabled")
			end
		end
	end
end

GameModeManager.get_end_screen_config = function (self, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	-- function 46
	local get_end_screen_config, var_46_1, var_46_2 = self._game_mode:get_end_screen_config(arg_46_1, arg_46_2, arg_46_3, arg_46_4)

	fassert(get_end_screen_config ~= nil, "No screen name returned")
	fassert(var_46_1 ~= nil, "No screen config returned")

	return get_end_screen_config, var_46_1, var_46_2
end

GameModeManager.get_end_of_round_screen_settings = function (self)
	-- function 47
	if not self._game_mode.get_end_of_round_screen_settings then
		return self._game_mode:get_end_of_round_screen_settings()
	end

	return "none", {}, {}
end

GameModeManager.get_player_wounds = function (self, arg_48_1)
	-- function 48
	return self._game_mode:get_player_wounds(arg_48_1)
end

GameModeManager.get_initial_inventory = function (self, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5)
	-- function 49
	return self._game_mode:get_initial_inventory(arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5)
end

GameModeManager.flow_cb_set_flow_object_set_enabled = function (self, arg_50_1, arg_50_2)
	-- function 50
	local var_50_0 = self._object_sets["flow_" .. arg_50_1]

	fassert(var_50_0, "[GameModeManager:flow_cb_set_flow_object_set_enabled()] Object set %s does not exist.", arg_50_1)
	self:_set_flow_object_set_enabled(var_50_0, arg_50_2, arg_50_1)
end

GameModeManager.register_object_sets = function (self, arg_51_1)
	-- function 51
	self._object_sets = {}
	self._object_set_names = {}

	for k, v in pairs(arg_51_1) do
		self._object_sets[k] = v
		self._object_set_names[v.key] = k

		if v.type == "flow" then
			self:_set_flow_object_set_enabled(v, false, k)
		end
	end
end

GameModeManager.event_reload_application_settings = function (self)
	-- function 52
	if not self._object_sets.shadow_lights then
		Managers.state.camera:set_shadow_lights(T(Application.user_setting("light_casts_shadows"), false), 1)
	end
end

GameModeManager._init_game_mode = function (self, arg_53_1, arg_53_2)
	-- function 53
	fassert(GameModeSettings[arg_53_1], "[GameModeManager] Tried to set unknown game mode %q", tostring(arg_53_1))

	local var_53_0 = GameModeSettings[arg_53_1]
	local var_53_1 = rawget(_G, var_53_0.class_name)

	if not DEDICATED_SERVER then
		cprintf("[GameModeManager] Changing game mode to: %s", arg_53_1)
	end

	self._game_mode = var_53_1:new(var_53_0, self._world, self._network_handler, self.is_server, self._profile_synchronizer, self._level_key, self.statistics_db, arg_53_2)
end

GameModeManager.host_player_spawned = function (arg_54_0)
	-- function 54
	Managers.state.entity:system("round_started_system"):player_spawned()
end

GameModeManager.round_started = function (self)
	-- function 55
	local num = 0

	self:trigger_event("round_started", num)
end

GameModeManager.gm_event_round_started = function (self, arg_56_1)
	-- function 56
	self._round_started = true
	self._round_start_time = Managers.time:time("game") - arg_56_1

	local current_level = LevelHelper:current_level(self._world)
	local str = self._game_mode_key .. "_round_started"

	Level.trigger_event(current_level, str)
	Managers.telemetry_events:round_started()

	if not TelemetrySettings.collect_memory then
		local memory_tree = Profiler.memory_tree()
		local memory_resources = Profiler.memory_resources("all")

		Managers.telemetry_events:memory_statistics(memory_tree, memory_resources, "round_started")
	end

	Level.trigger_event(current_level, "coop_round_started")

	if not self._game_mode.round_started then
		self._game_mode:round_started()
	end
end

GameModeManager.is_round_started = function (self)
	-- function 57
	local num

	if not self._round_start_time then
		num = Managers.time:time("game") - self._round_start_time

		if not num then
			-- Nothing
		end
	end

	num = nil

	::label_57_0::

	return self._round_started, num
end

GameModeManager.disable_lose_condition = function (self)
	-- function 58
	self._game_mode:disable_lose_condition()
end

GameModeManager.complete_level = function (self)
	-- function 59
	self._game_mode:complete_level(self._level_key)
	self._game_mode:trigger_end_level_area_events()
end

GameModeManager.wanted_transition = function (self)
	-- function 60
	return self._game_mode:wanted_transition()
end

GameModeManager.fail_level = function (self)
	-- function 61
	self._game_mode:fail_level()
end

GameModeManager.retry_level = function (arg_62_0)
	-- function 62
	local generate_level_seed = Managers.mechanism:generate_level_seed()

	Managers.level_transition_handler:reload_level(nil, generate_level_seed)
	Managers.level_transition_handler:promote_next_level_data()
end

GameModeManager.disable_player_spawning = function (self, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
	-- function 63
	local _disable_spawning_reasons = self._disable_spawning_reasons

	if not arg_63_1 then
		fassert(not _disable_spawning_reasons[arg_63_2], "Reason already disables player spawning")

		if not table.is_empty(_disable_spawning_reasons) then
			self._game_mode:disable_player_spawning()
		end

		_disable_spawning_reasons[arg_63_2] = true
	else
		fassert(_disable_spawning_reasons[arg_63_2], "Trying to enable spawning without disabling spawning first with reason")

		_disable_spawning_reasons[arg_63_2] = nil

		if not table.is_empty(_disable_spawning_reasons) then
			self._game_mode:enable_player_spawning(arg_63_3, arg_63_4)
		end
	end
end

GameModeManager.start_specific_level = function (self, arg_64_1, arg_64_2)
	-- function 64
	if not arg_64_2 then
		self.specific_level_to_start = arg_64_1
		self.specific_level_start_timer = arg_64_2
	else
		self.specific_level_to_start = nil
		self.specific_level_start_timer = nil

		local level_transition_handler = Managers.level_transition_handler
		local get_environment_variation_id = LevelHelper:get_environment_variation_id(arg_64_1)

		level_transition_handler:set_next_level(arg_64_1, get_environment_variation_id)
		level_transition_handler:promote_next_level_data()
	end
end

GameModeManager.update_timebased_level_start = function (self, arg_65_1)
	-- function 65
	local specific_level_start_timer = self.specific_level_start_timer

	if not specific_level_start_timer then
		local num = specific_level_start_timer - arg_65_1

		if num <= 0 then
			self:start_specific_level(self.specific_level_to_start)
		else
			self.specific_level_start_timer = num
		end
	end
end

GameModeManager.pre_update = function (self, arg_66_1, arg_66_2)
	-- function 66
	self._mutator_handler:pre_update(arg_66_2, arg_66_1)
	self._game_mode:pre_update(arg_66_1, arg_66_2)
end

GameModeManager.register_looping_event_timer = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	-- function 67
	local clock = os.clock()

	arg_67_0._looping_event_timers[arg_67_1] = {
		delay = arg_67_2,
		next_trigger_time = clock + arg_67_2,
		event_name = arg_67_3
	}
end

GameModeManager.unregister_looping_event_timer = function (arg_68_0, arg_68_1)
	-- function 68
	arg_68_0._looping_event_timers[arg_68_1] = nil
end

GameModeManager.local_player_ready_to_start = function (self, arg_69_1)
	-- function 69
	if not Managers.state.network:in_game_session() then
		return false
	end

	return self._game_mode:local_player_ready_to_start(arg_69_1)
end

GameModeManager.local_player_game_starts = function (self, arg_70_1, arg_70_2)
	-- function 70
	self._game_mode:local_player_game_starts(arg_70_1, arg_70_2)
end

GameModeManager.update = function (self, arg_71_1, arg_71_2)
	-- function 71
	self._mutator_handler:update(arg_71_1, arg_71_2)

	if not self._game_mode.update then
		self._game_mode:update(arg_71_2, arg_71_1)
	end

	local clock = os.clock()
	local current_level = LevelHelper:current_level(self._world)

	for k, v in pairs(self._looping_event_timers) do
		if clock > v.next_trigger_time then
			Level.trigger_event(current_level, v.event_name)

			v.next_trigger_time = v.next_trigger_time + v.delay
		end
	end

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

GameModeManager._update_initial_join = function (self, arg_72_1, arg_72_2)
	-- function 72
	if not self._network_handler:are_all_peers_ingame() then
		self._initial_peers_ready = true

		self._game_mode:all_peers_ready()
	end
end

GameModeManager.evaluate_end_condition_outcome = function (self, arg_73_1, arg_73_2)
	-- function 73
	if not self._game_mode.evaluate_end_condition_outcome then
		return self._game_mode:evaluate_end_condition_outcome(arg_73_1, arg_73_2)
	end

	local flag = not arg_73_1 and arg_73_1 == "won"
	local flag_2 = not arg_73_1 and arg_73_1 == "lost"

	return flag, flag_2
end

local tbl_4 = {
	party_one_won_early = true,
	reload = true,
	party_two_won_early = true
}

GameModeManager.server_update = function (self, arg_74_1, arg_74_2)
	-- function 74
	if not self._initial_peers_ready then
		self:_update_initial_join(arg_74_2, arg_74_1)
	end

	local _game_mode = self._game_mode

	_game_mode:server_update(arg_74_2, arg_74_1)

	if not self._have_signalled_game_mode_about_end_conditions then
		if not (self._end_conditions_met or LEVEL_EDITOR_TEST) then
			local _mutator_handler = self._mutator_handler
			local _round_started = self._round_started
			local evaluate_end_conditions, var_74_4, var_74_5 = self._game_mode:evaluate_end_conditions(_round_started, arg_74_1, arg_74_2, _mutator_handler)

			if not evaluate_end_conditions then
				_game_mode:ended(var_74_4)
				Managers.mechanism:game_round_ended(arg_74_2, arg_74_1, var_74_4, var_74_5)

				if not tbl_4[var_74_4] then
					Managers.mechanism:progress_state()
				end

				self._network_handler:enter_post_game()

				self._end_conditions_met = true
				self._end_reason = var_74_4

				local flag

				flag = var_74_4 ~= "lost" or Managers.state.spawn:checkpoint_data() or not true or false

				local percentages_completed = Managers.state.entity:system("mission_system"):percentages_completed()

				self:trigger_event("end_conditions_met", var_74_4, flag, percentages_completed)

				self._gm_event_end_conditions_met = true

				self:_save_last_level_completed(var_74_4)

				self._ready_for_transition = {}

				local human_players = Managers.player:human_players()

				for k, v in pairs(human_players) do
					local peer_id = v.peer_id

					self._ready_for_transition[peer_id] = false
				end
			end
		end

		if LEVEL_EDITOR_TEST or not self._end_conditions_met then
			local flag_2 = true
			local human_players_2 = Managers.player:human_players()

			for k_2, v_2 in pairs(human_players_2) do
				local peer_id_2 = v_2.peer_id

				if self._ready_for_transition[peer_id_2] == false then
					flag_2 = false

					break
				end
			end

			if not (not flag_2 and self._have_signalled_ready_to_transition) then
				_game_mode:ready_to_transition()

				self._have_signalled_ready_to_transition = true
			else
				self:update_timebased_level_start(arg_74_1)
			end
		end
	end
end

GameModeManager._save_last_level_completed = function (self, arg_75_1)
	-- function 75
	local level_key = self:level_key()

	SaveData.last_played_level = level_key
	SaveData.last_played_level_result = arg_75_1

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

GameModeManager.rpc_is_ready_for_transition = function (arg_76_0, arg_76_1)
	-- function 76
	local var_76_0 = CHANNEL_TO_PEER_ID[arg_76_1]

	arg_76_0._ready_for_transition[var_76_0] = true
end

GameModeManager.game_won = function (self, arg_77_1)
	-- function 77
	local evaluate_end_condition_outcome, var_77_1 = self:evaluate_end_condition_outcome(self._end_reason, arg_77_1)

	return evaluate_end_condition_outcome
end

GameModeManager.game_lost = function (self, arg_78_1)
	-- function 78
	local evaluate_end_condition_outcome, var_78_1 = self:evaluate_end_condition_outcome(self._end_reason, arg_78_1)

	return var_78_1
end

GameModeManager.set_end_reason = function (self, arg_79_1)
	-- function 79
	self._end_reason = arg_79_1
end

GameModeManager.get_end_reason = function (self)
	-- function 80
	return self._end_reason
end

GameModeManager.level_key = function (self)
	-- function 81
	return self._level_key
end

GameModeManager.trigger_event = function (self, arg_82_1, ...)
	-- function 82
	local str = "gm_event_" .. arg_82_1

	Managers.state.event:trigger(str, ...)

	if not self._lobby_host then
		Managers.state.network[str](Managers.state.network, ...)
	end
end

GameModeManager.game_mode = function (self)
	-- function 83
	return self._game_mode
end

GameModeManager.game_mode_key = function (self)
	-- function 84
	return self._game_mode_key
end

GameModeManager.hot_join_sync = function (self, arg_85_1)
	-- function 85
	self._mutator_handler:hot_join_sync(arg_85_1)

	local game_mode_state = self._game_mode:game_mode_state()

	if game_mode_state ~= "initial_state" then
		local var_85_1 = tbl_2[self._game_mode_key][game_mode_state]

		self._network_transmit:send_rpc("rpc_change_game_mode_state", arg_85_1, var_85_1)
	end

	if not self._round_started then
		local num = Managers.time:time("game") - self._round_start_time

		self._network_transmit:send_rpc("rpc_gm_event_round_started", arg_85_1, num)
	end

	self._game_mode:hot_join_sync(arg_85_1)

	if not self:get_environment_variation_name() then
		self._network_transmit:send_rpc("rpc_apply_environment_variation", arg_85_1)
	end
end

GameModeManager.activate_end_level_area = function (self, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
	-- function 86
	self._game_mode:activate_end_level_area(arg_86_1, arg_86_2, arg_86_3, arg_86_4)
end

GameModeManager.debug_end_level_area = function (self, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
	-- function 87
	self._game_mode:debug_end_level_area(arg_87_1, arg_87_2, arg_87_3, arg_87_4)
end

GameModeManager.disable_end_level_area = function (self, arg_88_1)
	-- function 88
	self._game_mode:disable_end_level_area(arg_88_1)
end

GameModeManager.teleport_despawned_players = function (self, arg_89_1)
	-- function 89
	self._game_mode:teleport_despawned_players(arg_89_1)
end

GameModeManager.flow_callback_add_spawn_point = function (self, arg_90_1)
	-- function 90
	self._game_mode:flow_callback_add_spawn_point(arg_90_1)
end

GameModeManager.flow_callback_add_game_mode_specific_spawn_point = function (self, arg_91_1)
	-- function 91
	local num = 0
	local tbl = {}

	while not Unit.has_data(arg_91_1, "sides", num) do
		local get_data = Unit.get_data(arg_91_1, "sides", num)

		if #get_data > 0 then
			tbl[#tbl + 1] = get_data
		end

		num = num + 1
	end

	local num_2 = 0

	while not Unit.has_data(arg_91_1, "game_modes", num_2) do
		if Unit.get_data(arg_91_1, "game_modes", num_2) == self._game_mode_key then
			if not self._game_mode.flow_callback_add_game_mode_specific_spawn_point then
				self._game_mode:flow_callback_add_game_mode_specific_spawn_point(arg_91_1, tbl)
			end

			break
		end

		num_2 = num_2 + 1
	end
end

GameModeManager.remove_respawn_units_due_to_crossroads = function (self, arg_92_1, arg_92_2)
	-- function 92
	if not self._game_mode.remove_respawn_units_due_to_crossroads then
		self._game_mode:remove_respawn_units_due_to_crossroads(arg_92_1, arg_92_2)
	end
end

GameModeManager.recalc_respawner_dist_due_to_crossroads = function (self)
	-- function 93
	if not self._game_mode.recalc_respawner_dist_due_to_crossroads then
		self._game_mode:recalc_respawner_dist_due_to_crossroads()
	end
end

GameModeManager.respawn_unit_spawned = function (self, arg_94_1)
	-- function 94
	self._game_mode:respawn_unit_spawned(arg_94_1)
end

GameModeManager.respawn_gate_unit_spawned = function (self, arg_95_1)
	-- function 95
	self._game_mode:respawn_gate_unit_spawned(arg_95_1)
end

GameModeManager.profile_changed = function (self, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5)
	-- function 96
	self._game_mode:profile_changed(arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5)
end

GameModeManager.force_respawn = function (self, arg_97_1, arg_97_2)
	-- function 97
	self._game_mode:force_respawn(arg_97_1, arg_97_2)
end

GameModeManager.force_respawn_dead_players = function (self)
	-- function 98
	self._game_mode:force_respawn_dead_players()
end

GameModeManager.set_respawning_enabled = function (self, arg_99_1)
	-- function 99
	if not self._game_mode.set_respawning_enabled then
		self._game_mode:set_respawning_enabled(arg_99_1)
	end
end

GameModeManager.on_game_mode_data_created = function (self, arg_100_1, arg_100_2)
	-- function 100
	fassert(self._has_created_game_mode_data == false, "There has already been a game mode data go created.")

	self._has_created_game_mode_data = true

	self._game_mode:on_game_mode_data_created(arg_100_1, arg_100_2)
end

GameModeManager.on_game_mode_data_destroyed = function (self)
	-- function 101
	self._has_created_game_mode_data = false

	self._game_mode:on_game_mode_data_destroyed()
end

GameModeManager._update_end_level_areas = function (self)
	-- function 102
	for k, v in pairs(self._debug_end_level_areas) do
		local node = Unit.node(k, v.object)
		local world_rotation = Unit.world_rotation(k, node)
		local right = Quaternion.right(world_rotation)
		local forward = Quaternion.forward(world_rotation)
		local up = Quaternion.up(world_rotation)
		local world_position = Unit.world_position(k, node)
		local unbox = v.offset:unbox()
		local num = world_position + right * unbox.x + forward * unbox.y + up * unbox.z
		local from_quaternion_position = Matrix4x4.from_quaternion_position(world_rotation, num)
		local unbox_2 = v.extents:unbox()

		QuickDrawer:quaternion(world_position, world_rotation)

		local var_102_10 = self._end_level_areas[k]
		local QuickDrawer = QuickDrawer
		local var_102_12 = QuickDrawer
		local box = QuickDrawer.box
		local var_102_14 = from_quaternion_position
		local var_102_15 = unbox_2
		local var_102_16

		if not var_102_10 then
			var_102_16 = Color(0, 255, 0)

			if not var_102_16 then
				-- Nothing
			end
		end

		var_102_16 = Color(255, 0, 0)

		::label_102_0::

		box(var_102_12, var_102_14, var_102_15, var_102_16)
	end

	if not table.is_empty(self._end_level_areas) then
		return false
	else
		local dot = Vector3.dot
		local abs = math.abs
		local num_2 = 0

		for k_2, v_2 in pairs(Managers.player:human_players()) do
			local player_unit = v_2.player_unit
			local alive = Unit.alive(player_unit)

			alive = not alive and not ScriptUnit.extension(player_unit, "status_system"):is_disabled()

			if not alive then
				num_2 = num_2 + 1

				local var_102_22 = POSITION_LOOKUP[player_unit]
				local flag = false

				for k_3, v_3 in pairs(self._end_level_areas) do
					local node_2 = Unit.node(k_3, v_3.object)
					local world_position_2 = Unit.world_position(k_3, node_2)
					local world_rotation_2 = Unit.world_rotation(k_3, node_2)
					local right_2 = Quaternion.right(world_rotation_2)
					local forward_2 = Quaternion.forward(world_rotation_2)
					local up_2 = Quaternion.up(world_rotation_2)
					local unbox_3 = v_3.offset:unbox()
					local num_3 = world_position_2 + right_2 * unbox_3.x + forward_2 * unbox_3.y + up_2 * unbox_3.z
					local unbox_4 = v_3.extents:unbox()
					local num_4 = var_102_22 - num_3

					if not (not (abs(dot(num_4, right_2)) < abs(unbox_4.x)) or not (abs(dot(num_4, forward_2)) < abs(unbox_4.y)) or not (abs(dot(num_4, up_2)) < abs(unbox_4.z))) then
						flag = true

						break
					end
				end

				if not flag then
					return false
				end
			end
		end

		return num_2 > 0
	end
end

GameModeManager.on_round_end = function (self)
	-- function 103
	local _game_mode = self._game_mode

	if not _game_mode and not _game_mode.on_round_end then
		_game_mode:on_round_end()
	end
end

GameModeManager.change_game_mode_state = function (self, arg_104_1)
	-- function 104
	fassert(self.is_server, "Should only be called on the server.")

	local setting = self:setting("game_mode_states")

	fassert(table.contains(setting, arg_104_1), "state_name (%s) does not exist in GameModeSettings", arg_104_1)

	local var_104_1 = tbl_2[self._game_mode_key][arg_104_1]

	self._network_transmit:send_rpc_clients("rpc_change_game_mode_state", var_104_1)
end

GameModeManager.get_boss_loot_pickup = function (self)
	-- function 105
	if not self._game_mode.get_boss_loot_pickup then
		return self._game_mode:get_boss_loot_pickup()
	end

	return "loot_die"
end

GameModeManager.get_environment_variation_name = function (self)
	-- function 106
	local get_current_environment_variation_name = Managers.level_transition_handler:get_current_environment_variation_name()

	if not get_current_environment_variation_name then
		local mutators = self:mutators()

		local function fn(arg_107_0, arg_107_1)
			-- function 107
			return arg_107_1.template.disable_environment_variations
		end

		if not (not mutators and table.find_func(mutators, fn)) then
			return get_current_environment_variation_name
		end
	end

	return nil
end

GameModeManager.lock_available_hero = function (self)
	-- function 108
	local human_and_bot_players = Managers.player:human_and_bot_players()
	local tbl = {}
	local heroes = PROFILES_BY_AFFILIATION.heroes

	for k, v in pairs(human_and_bot_players) do
		local profile_index = v:profile_index()

		if not profile_index then
			tbl[profile_index] = true
		end
	end

	for i, v_2 in ipairs(heroes) do
		local var_108_4 = FindProfileIndex(v_2)

		if not tbl[var_108_4] then
			self._locked_profile_index = var_108_4

			return self._locked_profile_index
		end
	end

	if not self._locked_profile_index then
		local party_id = Managers.party:parties_by_name().heroes.party_id
		local get_last_added_bot_for_party = Managers.party:get_last_added_bot_for_party(party_id)

		if not get_last_added_bot_for_party then
			self._locked_profile_index = get_last_added_bot_for_party.profile_index

			return self._locked_profile_index
		end
	end

	if not self._locked_profile_index then
		table.clear(tbl)

		local human_players = Managers.player:human_players()

		for k_2, v_3 in pairs(human_players) do
			tbl[v_3:profile_index()] = true
		end

		for i_2, v_4 in ipairs(heroes) do
			local var_108_8 = FindProfileIndex(v_4)

			if not tbl[var_108_8] then
				self._locked_profile_index = var_108_8

				return self._locked_profile_index
			end
		end
	end

	if not self._locked_profile_index then
		local var_108_9 = heroes[1]

		self._locked_profile_index = FindProfileIndex(var_108_9)

		return self._locked_profile_index
	end
end

GameModeManager.hero_is_locked = function (self, arg_109_1)
	-- function 109
	return self._locked_profile_index == arg_109_1
end

GameModeManager.apply_environment_variation = function (self)
	-- function 110
	local get_environment_variation_name = self:get_environment_variation_name()

	if not get_environment_variation_name then
		LevelHelper:flow_event(self._world, get_environment_variation_name)

		if not self.is_server then
			self._network_transmit:send_rpc_clients("rpc_apply_environment_variation")
		end
	end
end

GameModeManager.rpc_apply_environment_variation = function (self)
	-- function 111
	self:apply_environment_variation()
end

GameModeManager.rpc_change_game_mode_state = function (self, arg_112_1, arg_112_2)
	-- function 112
	fassert(not self.is_server, "Should only appear on the clients.")

	local var_112_0 = tbl_2[self._game_mode_key][arg_112_2]

	self._game_mode:change_game_mode_state(var_112_0)
end

GameModeManager.rpc_trigger_level_event = function (self, arg_113_1, arg_113_2)
	-- function 113
	local current_level = LevelHelper:current_level(self._world)

	if not current_level then
		Level.trigger_event(current_level, arg_113_2)
	end
end

GameModeManager.is_reservable = function (self)
	-- function 114
	return self._game_mode:is_reservable()
end

GameModeManager.is_joinable = function (self)
	-- function 115
	return self._game_mode:is_joinable()
end

GameModeManager.mutator_handler = function (self)
	-- function 116
	return self._mutator_handler
end

GameModeManager.level_start_objectives = function (self)
	-- function 117
	if not self._game_mode.level_start_objectives then
		return self._game_mode:level_start_objectives()
	end
end
