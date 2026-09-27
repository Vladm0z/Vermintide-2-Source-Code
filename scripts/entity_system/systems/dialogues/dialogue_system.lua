-- chunkname: @scripts/entity_system/systems/dialogues/dialogue_system.lua

require("scripts/utils/function_command_queue")
require("scripts/entity_system/systems/dialogues/tag_query")
require("scripts/entity_system/systems/dialogues/tag_query_database")
require("scripts/entity_system/systems/dialogues/tag_query_loader")
require("scripts/entity_system/systems/dialogues/dialogue_state_handler")
require("scripts/entity_system/systems/dialogues/dialogue_flow_events")
require("scripts/settings/dialogue_settings")

local scripts_entity_system_systems_dialogues_dialogue_queries = require("scripts/entity_system/systems/dialogues/dialogue_queries")
local scripts_settings_live_events_packages = require("scripts/settings/live_events_packages")
local scripts_entity_system_systems_dialogues_global_sound_event_filters = require("scripts/entity_system/systems/dialogues/global_sound_event_filters")
local script_data = script_data
local dialogue_debug_all_contexts = script_data.dialogue_debug_all_contexts

dialogue_debug_all_contexts = dialogue_debug_all_contexts or Development.parameter("dialogue_debug_all_contexts")
script_data.dialogue_debug_all_contexts = dialogue_debug_all_contexts

local script_data_2 = script_data
local dialogue_debug_last_query = script_data.dialogue_debug_last_query

dialogue_debug_last_query = dialogue_debug_last_query or Development.parameter("dialogue_debug_last_query")
script_data_2.dialogue_debug_last_query = dialogue_debug_last_query

local script_data_3 = script_data
local dialogue_debug_last_played_query = script_data.dialogue_debug_last_played_query

dialogue_debug_last_played_query = dialogue_debug_last_played_query or Development.parameter("dialogue_debug_last_played_query")
script_data_3.dialogue_debug_last_played_query = dialogue_debug_last_played_query

local script_data_4 = script_data
local dialogue_debug_queries = script_data.dialogue_debug_queries

dialogue_debug_queries = dialogue_debug_queries or Development.parameter("dialogue_debug_queries")
script_data_4.dialogue_debug_queries = dialogue_debug_queries

local script_data_5 = script_data
local dialogue_debug_rules = script_data.dialogue_debug_rules

dialogue_debug_rules = dialogue_debug_rules or Development.parameter("dialogue_debug_rules")
script_data_5.dialogue_debug_rules = dialogue_debug_rules

local script_data_6 = script_data
local dialogue_debug_missing_vo_trigger_error_sound = script_data.dialogue_debug_missing_vo_trigger_error_sound

dialogue_debug_missing_vo_trigger_error_sound = dialogue_debug_missing_vo_trigger_error_sound or Development.parameter("dialogue_debug_missing_vo_trigger_error_sound")
script_data_6.dialogue_debug_missing_vo_trigger_error_sound = dialogue_debug_missing_vo_trigger_error_sound

local tbl = {
	"DialogueActorExtension"
}
local dialogue_category_config = DialogueSettings.dialogue_category_config
local flag = true
local var_0_18

DialogueSystem = class(DialogueSystem, ExtensionSystemBase)
DialogueSystem.stateless_global_context = table.make_strict({
	last_level_played = "none",
	last_level_won = false
})

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	if arg_1_1 ~= arg_1_2.wwise_source_id then
		arg_1_2.wwise_source_id = arg_1_1

		if not arg_1_2.wwise_voice_switch_group and not arg_1_2.wwise_voice_switch_value then
			WwiseWorld.set_switch(arg_1_0, arg_1_2.wwise_voice_switch_group, arg_1_2.wwise_voice_switch_value, arg_1_1)
		end

		if not arg_1_2.wwise_career_switch_group and not arg_1_2.wwise_career_switch_value then
			WwiseWorld.set_switch(arg_1_0, arg_1_2.wwise_career_switch_group, arg_1_2.wwise_career_switch_value, arg_1_1)
		end

		if arg_1_2.faction == "player" then
			WwiseWorld.set_switch(arg_1_0, "husk", tostring(not arg_1_2.local_player), arg_1_1)
		end

		if not arg_1_2.vo_center_percent then
			WwiseWorld.set_source_parameter(arg_1_0, arg_1_1, "vo_center_percent", arg_1_2.vo_center_percent)
		end
	end
end

local function fn_2()
	-- function 2
	if not Managers then
		return nil
	end

	if not Managers.player then
		return nil
	end

	if not SPProfiles then
		return nil
	end

	local local_player = Managers.player:local_player()

	if not local_player then
		return nil
	end

	local career_index = local_player:career_index()
	local profile_index = local_player:profile_index()

	return SPProfiles[profile_index].careers[career_index].profile_name
end

DialogueSystem.init = function (self, arg_3_1, arg_3_2)
	-- function 3
	local entity_manager = arg_3_1.entity_manager

	entity_manager:register_system(self, arg_3_2, tbl)

	self._entity_manager = entity_manager
	self._frozen_unit_extension_data = {}
	self._unit_extension_data = {}
	self._playing_dialogues = {}
	self._playing_units = {}
	self._query_results = {}
	self._is_server = arg_3_1.is_server
	self._debug_state = nil
	self._mission_giver_events = {}
	self._tagquery_database = TagQueryDatabase:new()
	self._dialogues = {}
	self._markers = {}
	self._story_trigger_freezes = 0
	self._tagquery_loader = TagQueryLoader:new(self._tagquery_database, self._dialogues)

	local num = 2

	self._function_command_queue = FunctionCommandQueue:new(num)

	local network_event_delegate = arg_3_1.network_event_delegate

	self._network_event_delegate = network_event_delegate

	network_event_delegate:register(self, "rpc_trigger_dialogue_event", "rpc_play_dialogue_event", "rpc_interrupt_dialogue_event", "rpc_update_current_wind")

	local level_key = arg_3_1.startup_data.level_key
	local str = "dialogues/generated/" .. level_key
	local var_3_5 = DialogueSettings.blocked_auto_load_files[level_key]
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local var_3_7 = DialogueSettings.auto_load_files_mechanism[current_mechanism_name]

	var_3_7 = var_3_7 or {}
	self._original_dialogue_settings = {}

	local var_3_8 = LevelSettings[level_key]
	local override_dialogue_settings = var_3_8.override_dialogue_settings

	if not override_dialogue_settings then
		for k, v in pairs(override_dialogue_settings) do
			self._original_dialogue_settings[k] = DialogueSettings[k]
			DialogueSettings[k] = v
		end
	end

	self._use_story_lines = Managers.state.game_mode:setting("use_story_lines")

	if not Application.can_get("lua", str) then
		self._tagquery_loader:load_file(str)
	end

	if not var_3_5 then
		self._tagquery_loader:load_auto_load_files(self._markers)

		for i, v_2 in ipairs(var_3_7) do
			if not Application.can_get("lua", v_2) then
				self._tagquery_loader:load_file(v_2)
			end

			if not Application.can_get("lua", v_2 .. "_markers") then
				local var_3_10 = dofile(v_2 .. "_markers")

				for k_2, v_3 in pairs(var_3_10) do
					fassert(not self._markers[k_2], "[DialogueSystem] There is already a marker called %s registered", k_2)

					self._markers[k_2] = v_3
				end
			end
		end
	end

	local var_3_11 = DialogueSettings.level_specific_load_files[level_key]

	if not var_3_11 then
		for i_2, v_4 in ipairs(var_3_11) do
			if not Application.can_get("lua", v_4) then
				self._tagquery_loader:load_file(v_4)
			end

			if not Application.can_get("lua", v_4 .. "_markers") then
				local var_3_12 = dofile(v_4 .. "_markers")

				for k_3, v_5 in pairs(var_3_12) do
					fassert(not self._markers[k_3], "[DialogueSystem] There is already a marker called %s registered", k_3)

					self._markers[k_3] = v_5
				end
			end
		end
	end

	local environment_variation_name = arg_3_1.startup_data.environment_variation_name

	self._global_context = {
		game_about_to_end = 0,
		current_level = level_key,
		weather = environment_variation_name
	}

	if not var_3_8.tutorial_level then
		local get_interface = Managers.backend:get_interface("live_events")
		local flag = not get_interface and get_interface:get_special_events()

		if not flag then
			local current_mechanism_name_2 = Managers.mechanism:current_mechanism_name()

			self._loaded_event_dialogues = {}

			for i10 = 1, #flag do
				local var_3_17 = flag[i10]
				local name = var_3_17.name

				self._global_context[name] = true

				self:_load_special_event_dialogues(name, current_mechanism_name_2)

				local mutators = var_3_17.mutators

				if not mutators then
					for i11 = 1, #mutators do
						local var_3_20 = mutators[i11]

						self:_load_special_event_dialogues(var_3_20, current_mechanism_name_2)
					end
				end
			end
		end
	end

	table.merge(self._global_context, DialogueSystem.stateless_global_context)

	local initialized_mutator_map = Managers.state.game_mode:initialized_mutator_map()

	for k_4 in pairs(initialized_mutator_map) do
		local dialogue_settings = MutatorTemplates[k_4].dialogue_settings

		if not dialogue_settings then
			for i13 = 1, #dialogue_settings do
				local var_3_23 = dialogue_settings[i13]

				if not Application.can_get("lua", var_3_23) then
					self._tagquery_loader:load_file(var_3_23)
				end

				if not Application.can_get("lua", var_3_23 .. "_markers") then
					local var_3_24 = dofile(var_3_23 .. "_markers")

					for k_5, v_6 in pairs(var_3_24) do
						fassert(not self._markers[k_5], "[DialogueSystem] There is already a marker called %s registered", k_5)

						self._markers[k_5] = v_6
					end
				end
			end
		end
	end

	self._tagquery_database:finalize_rules()

	local world = arg_3_1.world

	self.world = world

	if not DEDICATED_SERVER then
		self.wwise_world = Managers.world:wwise_world(world)
		self._flow_calls_implementation = DialogueSystemFlow:new(self.wwise_world, Managers.state.entity:system("hud_system"))
	end

	self.gui = World.create_screen_gui(world, "material", "materials/fonts/gw_fonts", "immediate")

	if not self._is_server then
		self._dialogue_state_handler = DialogueStateHandler:new(self.world)
	end

	self._input_event_queue = {}
	self._input_event_queue_n = 0
	self._faction_memories = {
		player = {},
		enemy = {}
	}

	local tbl_2 = {}

	for k_6, v_7 in pairs(Breeds) do
		if not v_7.wwise_voice_switch_group then
			tbl_2[k_6] = 1
		end
	end

	self._wwise_voice_switch_value_indices = tbl_2
	self.statistics_db = arg_3_1.statistics_db

	for i_3, v_8 in ipairs(SPProfiles) do
		self._global_context[v_8.display_name] = false

		for i_4, v_9 in ipairs(v_8.careers) do
			self._global_context[v_9.display_name] = false
		end
	end

	local get_active_weave_template = Managers.weave:get_active_weave_template()

	if not get_active_weave_template and not self._is_server then
		local wind = get_active_weave_template.wind

		self._global_context.current_wind = wind
	end

	local get_level_dialogue_context = Managers.mechanism:get_level_dialogue_context()

	table.merge(self._global_context, get_level_dialogue_context)

	self._global_context.level_time = 0

	local game_mechanism = Managers.mechanism:game_mechanism()

	if not game_mechanism.get_current_set then
		local get_current_set = game_mechanism:get_current_set()

		self._global_context.current_set = get_current_set
	end

	self._tagquery_database:set_global_context(self._global_context)

	self._next_story_line_update_t = DialogueSettings.story_start_delay
end

DialogueSystem._load_special_event_dialogues = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = scripts_settings_live_events_packages[arg_4_1]
	local flag = not var_4_0 and var_4_0.dialogues
	local flag_2 = not flag and flag[arg_4_2]

	if not flag_2 then
		for i = 1, #flag_2 do
			local var_4_3 = flag_2[i]

			if not self._loaded_event_dialogues[var_4_3] then
				if not Application.can_get("lua", var_4_3) then
					self._tagquery_loader:load_file(var_4_3)
				end

				if not Application.can_get("lua", var_4_3 .. "_markers") then
					local var_4_4 = dofile(var_4_3 .. "_markers")

					for k, v in pairs(var_4_4) do
						fassert(not self._markers[k], "[DialogueSystem] There is already a marker called %s registered", k)

						self._markers[k] = v
					end
				end

				self._loaded_event_dialogues[var_4_3] = true
			end
		end
	end
end

DialogueSystem.dialogue_units = function (self)
	-- function 5
	return self._unit_extension_data
end

DialogueSystem.is_dialogue_playing = function (self)
	-- function 6
	return not table.is_empty(self._playing_dialogues)
end

DialogueSystem.destroy = function (self)
	-- function 7
	self._tagquery_loader:unload_files()
	self._tagquery_database:destroy()
	World.destroy_gui(self.world, self.gui)
	self._network_event_delegate:unregister(self)

	if not next(self._original_dialogue_settings) then
		for k, v in pairs(self._original_dialogue_settings) do
			DialogueSettings[k] = v
		end
	end

	table.clear(self)
end

local tbl_2 = {}

DialogueSystem.on_add_extension = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local tbl = {
		user_memory = {},
		context = {
			health = 1
		},
		local_player = arg_8_4.local_player,
		dialogue_profile = arg_8_4.dialogue_profile
	}
	local var_8_1 = self

	tbl.input = MakeTableStrict({
		trigger_dialogue_event = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			-- function 9
			if not var_8_1._is_server then
				return
			end

			local _input_event_queue = var_8_1._input_event_queue
			local _input_event_queue_n = var_8_1._input_event_queue_n

			_input_event_queue[_input_event_queue_n + 1] = arg_8_2
			_input_event_queue[_input_event_queue_n + 2] = arg_9_1
			_input_event_queue[_input_event_queue_n + 3] = arg_9_2 or tbl_2
			_input_event_queue[_input_event_queue_n + 4] = arg_9_3 or ""
			var_8_1._input_event_queue_n = _input_event_queue_n + 4
		end,
		trigger_networked_dialogue_event = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			-- function 10
			if not LEVEL_EDITOR_TEST then
				return
			end

			if not var_8_1._is_server then
				local _input_event_queue = var_8_1._input_event_queue
				local _input_event_queue_n = var_8_1._input_event_queue_n

				_input_event_queue[_input_event_queue_n + 1] = arg_8_2
				_input_event_queue[_input_event_queue_n + 2] = arg_10_1
				_input_event_queue[_input_event_queue_n + 3] = arg_10_2 or tbl_2
				_input_event_queue[_input_event_queue_n + 4] = arg_10_3 or ""
				var_8_1._input_event_queue_n = _input_event_queue_n + 4

				return
			end

			local alloc_table = FrameTable.alloc_table()
			local alloc_table_2 = FrameTable.alloc_table()

			if not arg_10_2 then
				local table_to_array = table.table_to_array(arg_10_2, alloc_table_2)

				for i = 1, table_to_array do
					local var_10_5 = alloc_table_2[i]

					if type(var_10_5) == "number" then
						fassert(var_10_5 % 1 == 0, "Tried to pass non-integer value to dialogue event")
						fassert(var_10_5 >= 0, "Tried to send a dialogue data number smaller than zero")

						alloc_table_2[i] = var_10_5 + 1
						alloc_table[i] = true
					else
						alloc_table_2[i] = NetworkLookup.dialogue_event_data_names[var_10_5]
						alloc_table[i] = false
					end
				end
			end

			local game_object_id = NetworkUnit.game_object_id(arg_8_2)
			local var_10_7 = NetworkLookup.dialogue_events[arg_10_1]

			fassert(game_object_id, "No game object id for unit %s.", arg_8_2)
			Managers.state.network.network_transmit:send_rpc_server("rpc_trigger_dialogue_event", game_object_id, var_10_7, alloc_table_2, alloc_table)
		end,
		play_voice = function (arg_11_0, arg_11_1, arg_11_2)
			-- function 11
			if not DEDICATED_SERVER then
				return
			end

			local make_unit_auto_source, var_11_1 = WwiseUtils.make_unit_auto_source(var_8_1.world, tbl.play_unit, tbl.voice_node)

			fn(var_11_1, make_unit_auto_source, tbl)

			local var_11_2 = var_8_1
			local var_11_3 = var_11_2
			local _check_play_debug_sound = var_11_2._check_play_debug_sound
			local var_11_5 = arg_11_1
			local currently_playing_subtitle

			if not tbl.currently_playing_dialogue then
				currently_playing_subtitle = tbl.currently_playing_dialogue.currently_playing_subtitle

				if not currently_playing_subtitle then
					-- Nothing
				end
			end

			currently_playing_subtitle = ""

			::label_11_0::

			local var_11_7, var_11_8 = _check_play_debug_sound(var_11_3, var_11_5, currently_playing_subtitle)

			if not var_11_7 then
				return WwiseWorld.trigger_event(var_11_1, arg_11_1, arg_11_2, make_unit_auto_source)
			else
				return
			end
		end,
		play_voice_debug = function (arg_12_0, arg_12_1)
			-- function 12
			if not DEDICATED_SERVER then
				return
			end

			local make_unit_auto_source, var_12_1 = WwiseUtils.make_unit_auto_source(var_8_1.world, tbl.play_unit, tbl.voice_node)

			fn(var_12_1, make_unit_auto_source, tbl)

			local var_12_2 = var_8_1
			local var_12_3 = var_12_2
			local _check_play_debug_sound = var_12_2._check_play_debug_sound
			local var_12_5 = arg_12_1
			local currently_playing_subtitle

			if not tbl.currently_playing_dialogue then
				currently_playing_subtitle = tbl.currently_playing_dialogue.currently_playing_subtitle

				if not currently_playing_subtitle then
					-- Nothing
				end
			end

			currently_playing_subtitle = ""

			::label_12_0::

			local var_12_7, var_12_8 = _check_play_debug_sound(var_12_3, var_12_5, currently_playing_subtitle)

			if not var_12_7 then
				return WwiseWorld.trigger_event(var_12_1, arg_12_1, make_unit_auto_source)
			else
				return
			end
		end,
		trigger_query = function (arg_13_0, arg_13_1)
			-- function 13
			local var_13_0, var_13_1, var_13_2, var_13_3, var_13_4 = unpack(arg_13_1)

			var_8_1._tagquery_database:debug_test_query(var_13_0, var_13_1, var_13_2, var_13_3, var_13_4)
		end
	})

	self._tagquery_database:add_object_context(arg_8_2, "user_memory", tbl.user_memory)
	self._tagquery_database:add_object_context(arg_8_2, "user_context", tbl.context)

	local faction = arg_8_4.faction

	faction = faction or Unit.get_data(arg_8_2, "faction")

	if not faction then
		tbl.faction = faction

		fassert(self._faction_memories[faction], "No such faction %q", tostring(faction))
		self._tagquery_database:add_object_context(arg_8_2, "faction_memory", self._faction_memories[faction])

		tbl.faction_memory = self._faction_memories[faction]
	end

	ScriptUnit.set_extension(arg_8_2, "dialogue_system", tbl)

	self._unit_extension_data[arg_8_2] = tbl

	local breed_name = arg_8_4.breed_name

	if not breed_name then
		local var_8_4 = Breeds[breed_name]

		if not var_8_4.wwise_voice_switch_group then
			local wwise_voices = var_8_4.wwise_voices
			local count = #wwise_voices
			local var_8_7 = self._wwise_voice_switch_value_indices[breed_name]
			local var_8_8 = wwise_voices[var_8_7]

			tbl.wwise_voice_switch_value = var_8_8

			local wwise_voice_switch_group = var_8_4.wwise_voice_switch_group

			tbl.wwise_voice_switch_group = wwise_voice_switch_group
			self._wwise_voice_switch_value_indices[breed_name] = var_8_7 % count + 1

			if not script_data.sound_debug then
				printf("[DialogueSystem] Spawned breed %s - using switch group '%s' with '%s'", breed_name, wwise_voice_switch_group, var_8_8)
			end
		end

		if not DialogueSettings.breed_types_trigger_on_spawn[breed_name] and not self._is_server then
			self._entity_manager:system("surrounding_aware_system"):add_system_event(arg_8_2, "enemy_spawn", math.huge, "breed_type", breed_name)
		end
	elseif arg_8_4.wwise_voice_switch_group ~= nil then
		tbl.wwise_voice_switch_group = arg_8_4.wwise_voice_switch_group
		tbl.wwise_voice_switch_value = arg_8_4.wwise_voice_switch_value
		tbl.wwise_career_switch_group = arg_8_4.wwise_career_switch_group
		tbl.wwise_career_switch_value = arg_8_4.wwise_career_switch_value
	end

	return tbl
end

DialogueSystem.extensions_ready = function (self, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0 = self._unit_extension_data[arg_14_2]
	local context = self._unit_extension_data[arg_14_2].context
	local player_profile = context.player_profile
	local has_extension = ScriptUnit.has_extension(arg_14_2, "status_system")

	if not has_extension then
		var_14_0.status_extension = has_extension
		self._global_context[player_profile] = true

		local career_name = ScriptUnit.extension(arg_14_2, "career_system"):career_name()

		self._global_context[career_name] = true
		context.player_career = career_name
	elseif player_profile == nil then
		local dialogue_profile = var_14_0.dialogue_profile

		dialogue_profile = dialogue_profile or Unit.get_data(arg_14_2, "dialogue_profile")
		context.player_profile = dialogue_profile
	end

	local var_14_6 = arg_14_2
	local num = 0
	local num_2 = 0

	if not var_14_0.local_player then
		var_14_6 = ScriptUnit.extension(arg_14_2, "first_person_system"):get_first_person_unit()
		num = 100
		num_2 = Unit.node(var_14_6, "camera_node")
	elseif not Unit.has_node(var_14_6, "a_voice") then
		num_2 = Unit.node(var_14_6, "a_voice")
	elseif not Unit.has_node(var_14_6, "j_head") then
		num_2 = Unit.node(var_14_6, "j_head")
	end

	var_14_0.play_unit = var_14_6
	var_14_0.voice_node = num_2
	var_14_0.vo_center_percent = num
end

DialogueSystem.on_remove_extension = function (self, arg_15_1, arg_15_2)
	-- function 15
	self._frozen_unit_extension_data[arg_15_1] = nil

	self:_cleanup_extension(arg_15_1, arg_15_2)
	ScriptUnit.remove_extension(arg_15_1, self.NAME)
end

DialogueSystem.on_freeze_extension = function (self, arg_16_1, arg_16_2)
	-- function 16
	local var_16_0 = self._unit_extension_data[arg_16_1]

	fassert(var_16_0, "Unit was already frozen.")

	self._frozen_unit_extension_data[arg_16_1] = var_16_0

	self:_cleanup_extension(arg_16_1, arg_16_2)
end

DialogueSystem.freeze = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local _frozen_unit_extension_data = self._frozen_unit_extension_data

	if not _frozen_unit_extension_data[arg_17_1] then
		return
	end

	local var_17_1 = self._unit_extension_data[arg_17_1]

	fassert(var_17_1, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(arg_17_1, arg_17_2)

	self._unit_extension_data[arg_17_1] = nil
	_frozen_unit_extension_data[arg_17_1] = var_17_1
end

DialogueSystem.unfreeze = function (self, arg_18_1)
	-- function 18
	local var_18_0 = self._frozen_unit_extension_data[arg_18_1]

	fassert(var_18_0, "Unit to unfreeze didn't have frozen extension")

	self._frozen_unit_extension_data[arg_18_1] = nil
	self._unit_extension_data[arg_18_1] = var_18_0

	self._tagquery_database:add_object_context(arg_18_1, "user_memory", var_18_0.user_memory)
	self._tagquery_database:add_object_context(arg_18_1, "user_context", var_18_0.context)
	self._tagquery_database:add_object_context(arg_18_1, "faction_memory", self._faction_memories[var_18_0.faction])
end

DialogueSystem.set_faction_memory = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	arg_19_0._faction_memories[arg_19_1][arg_19_2] = arg_19_3
end

DialogueSystem.set_user_memory = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local var_20_0 = self._unit_extension_data[arg_20_1]

	if not var_20_0 then
		var_20_0.user_memory[arg_20_2] = arg_20_3
	end
end

DialogueSystem.set_user_context = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local var_21_0 = self._unit_extension_data[arg_21_1]

	if not var_21_0 then
		var_21_0.user_context[arg_21_2] = arg_21_3
	end
end

DialogueSystem.set_global_context = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	arg_22_0._global_context[arg_22_1] = arg_22_2
end

DialogueSystem.get_global_context = function (self, arg_23_1)
	-- function 23
	return self._global_context[arg_23_1]
end

DialogueSystem.force_faction_op = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	-- function 24
	self._faction_memories[arg_24_2][arg_24_3] = DialogueSystem.function_by_op[TagQuery.OP[arg_24_4]](self._faction_memories[arg_24_2][arg_24_3], arg_24_5)
end

DialogueSystem._cleanup_extension = function (self, arg_25_1, arg_25_2)
	-- function 25
	local var_25_0 = self._unit_extension_data[arg_25_1]

	if var_25_0 == nil then
		return
	end

	local context = var_25_0.context
	local player_profile = context.player_profile

	if not player_profile then
		local _global_context = self._global_context

		_global_context[player_profile] = false

		local player_career = context.player_career

		if not player_career then
			_global_context[player_career] = false
		end
	end

	table.clear(var_25_0.user_memory)
	table.clear(context)

	context.health = 1

	local currently_playing_dialogue = var_25_0.currently_playing_dialogue

	if not self._playing_dialogues[currently_playing_dialogue] then
		if not currently_playing_dialogue.currently_playing_id and not WwiseWorld.is_playing(self.wwise_world, currently_playing_dialogue.currently_playing_id) then
			WwiseWorld.stop_event(self.wwise_world, currently_playing_dialogue.currently_playing_id)
		end

		self._playing_dialogues[currently_playing_dialogue] = nil
		currently_playing_dialogue.currently_playing_id = nil
		currently_playing_dialogue.currently_playing_unit = nil
	end

	var_25_0.used_query = nil
	var_25_0.currently_playing_dialogue = nil
	self._playing_units[arg_25_1] = nil
	self._unit_extension_data[arg_25_1] = nil

	self._tagquery_database:remove_object(arg_25_1)
	self._function_command_queue:cleanup_destroyed_unit(arg_25_1)
end

local num = 0
local DialogueSystem = DialogueSystem
local function_by_op = DialogueSystem.function_by_op

function_by_op = function_by_op or {
	[TagQuery.OP.ADD] = function (arg_26_0, arg_26_1)
		-- function 26
		return (arg_26_0 or 0) + arg_26_1
	end,
	[TagQuery.OP.SUB] = function (arg_27_0, arg_27_1)
		-- function 27
		return (arg_27_0 or 0) - arg_27_1
	end,
	[TagQuery.OP.NUMSET] = function (arg_28_0, arg_28_1)
		-- function 28
		return arg_28_1 or 0
	end,
	[TagQuery.OP.TIMESET] = function ()
		-- function 29
		return Managers.time:time("game") + 900
	end
}
DialogueSystem.function_by_op = function_by_op

DialogueSystem._update_currently_playing_dialogues = function (self, arg_30_1)
	-- function 30
	local _function_command_queue = self._function_command_queue
	local player = Managers.player
	local _unit_extension_data = self._unit_extension_data
	local _playing_units = self._playing_units
	local alive = Unit.alive

	for k, v in pairs(_playing_units) do
		repeat
			local currently_playing_dialogue = v.currently_playing_dialogue

			if not alive(k) then
				_playing_units[k] = nil

				if not currently_playing_dialogue then
					currently_playing_dialogue.currently_playing_id = nil
					currently_playing_dialogue.currently_playing_unit = nil
					self._playing_dialogues[currently_playing_dialogue] = nil
				end

				break
			end

			fassert(currently_playing_dialogue, "Dialogue for playing unit was nil!")

			if not (currently_playing_dialogue.dialogue_timer - arg_30_1 > 0) then
				if not Unit.has_animation_state_machine(k) then
					if player:owner(k) ~= nil or not Unit.has_data(k, "dialogue_face_anim") then
						_function_command_queue:queue_function_command(Unit.animation_event, k, "face_neutral")
						_function_command_queue:queue_function_command(Unit.animation_event, k, "dialogue_end")
					elseif not Unit.has_data(k, "enemy_dialogue_face_anim") then
						_function_command_queue:queue_function_command(Unit.animation_event, k, "talk_end")
					end

					if not Unit.has_data(k, "enemy_dialogue_body_anim") then
						_function_command_queue:queue_function_command(Unit.animation_event, k, "talk_body_end")
					end
				end

				local sound_distance = currently_playing_dialogue.sound_distance

				v.currently_playing_dialogue = nil
				currently_playing_dialogue.currently_playing_id = nil
				currently_playing_dialogue.currently_playing_unit = nil
				self._playing_dialogues[currently_playing_dialogue] = nil
				_playing_units[k] = nil

				if not self._is_server then
					break
				end

				local used_query = v.used_query

				v.used_query = nil

				local result = used_query.result

				if not result then
					local source = used_query.query_context.source
					local validated_rule = used_query.validated_rule
					local on_done = validated_rule.on_done

					if not on_done then
						for k_2 = 1, #on_done do
							local var_30_12 = on_done[k_2]
							local var_30_13 = var_30_12[1]
							local var_30_14 = var_30_12[2]
							local var_30_15 = var_30_12[3]
							local var_30_16 = var_30_12[4]
							local var_30_17 = _unit_extension_data[source]

							if type(var_30_15) == "table" then
								fassert(DialogueSystem.function_by_op[var_30_15], "Unknown operator: %q", tostring(var_30_15))

								var_30_17[var_30_13][var_30_14] = DialogueSystem.function_by_op[var_30_15](var_30_17[var_30_13][var_30_14], var_30_16)
							else
								fassert(var_30_15, "No such operator in on_done-command for rule %q", validated_rule.name)

								var_30_17[var_30_13][var_30_14] = var_30_15
							end
						end
					end

					local str = "UNKNOWN"
					local get_data = Unit.get_data(source, "breed")

					if not (not get_data and get_data.is_player) then
						str = get_data.name
					else
						local var_30_20 = self._unit_extension_data[source]

						if not var_30_20 then
							str = var_30_20.context.player_profile
						end
					end

					if not currently_playing_dialogue.override_awareness then
						local alloc_table = FrameTable.alloc_table()

						alloc_table.dialogue_name_nopre = string.sub(result, 5)
						alloc_table.dialogue_name = result
						alloc_table.speaker = source
						alloc_table.distance = 1
						alloc_table.speaker_name = str
						alloc_table.sound_event = v.last_query_sound_event

						for k_3, v_2 in pairs(self._unit_extension_data) do
							v_2.input:trigger_dialogue_event(currently_playing_dialogue.override_awareness, alloc_table)
						end
					else
						local system = self._entity_manager:system("surrounding_aware_system")
						local var_30_23 = system
						local add_system_event = system.add_system_event
						local var_30_25 = source
						local str_2 = "heard_speak"
						local var_30_27 = sound_distance
						local str_3 = "speaker"
						local var_30_29 = source
						local str_4 = "speaker_name"
						local var_30_31 = str
						local str_5 = "sound_event"
						local last_query_sound_event = v.last_query_sound_event

						last_query_sound_event = last_query_sound_event or "unknown"

						add_system_event(var_30_23, var_30_25, str_2, var_30_27, str_3, var_30_29, str_4, var_30_31, str_5, last_query_sound_event, "dialogue_name", result, "dialogue_name_nopre", string.sub(result, 5))
					end

					v.last_query_sound_event = nil
				end

				break
			end

			if not currently_playing_dialogue.dialogue_timer then
				local flag = false
				local has_extension = ScriptUnit.has_extension(k, "ghost_mode_system")

				if not (not has_extension and not has_extension:is_in_ghost_mode() and currently_playing_dialogue.only_local or currently_playing_dialogue.only_allies) then
					flag = true
				end

				if not ((flag or not ScriptUnit.has_extension(k, "health_system")) and HEALTH_ALIVE[k]) then
					if not self._is_server then
						local game_object_or_level_id, var_30_37 = Managers.state.network:game_object_or_level_id(k)

						self:rpc_interrupt_dialogue_event(0, game_object_or_level_id, var_30_37)
						Managers.state.network.network_transmit:send_rpc_clients("rpc_interrupt_dialogue_event", game_object_or_level_id, var_30_37)
					end

					break
				end

				currently_playing_dialogue.dialogue_timer = currently_playing_dialogue.dialogue_timer - arg_30_1
			end
		until true
	end
end

DialogueSystem.update = function (arg_31_0, arg_31_1, arg_31_2)
	-- function 31
	return
end

DialogueSystem._handle_wwise_markers = function (self, arg_32_1, arg_32_2)
	-- function 32
	local pull_marker_events = WwiseWorld.pull_marker_events(self.wwise_world)

	if not pull_marker_events then
		for i = 1, #pull_marker_events do
			local var_32_1 = pull_marker_events[i]
			local var_32_2 = self._markers[var_32_1.label]

			if not var_32_2 then
				self:_trigger_marker(var_32_2)
			end
		end
	end
end

DialogueSystem._trigger_marker = function (self, arg_33_1)
	-- function 33
	local sound_event = arg_33_1.sound_event
	local source_name = arg_33_1.source_name
	local var_33_2
	local players = Managers.player:players()

	for k, v in pairs(players) do
		local player_unit = v.player_unit
		local var_33_5 = self._unit_extension_data[player_unit]

		if not var_33_5 then
			local context = var_33_5.context

			context = not context and var_33_5.context.player_profile

			if context == source_name then
				var_33_2 = v.player_unit

				break
			end
		end
	end

	if not var_33_2 then
		Application.error("[DialogueSystem] No source_name called %s could be found", source_name)
	elseif not self._playing_units[var_33_2] then
		Application.error("[DialogueSystem] Marker couldn't play since %s was already talking", source_name)
	else
		local var_33_7 = self._unit_extension_data[var_33_2]

		if not var_33_7 then
			Application.error("[DialogueSystem] Could not find any extension_data for profile %s", source_name)
		else
			local make_unit_auto_source, var_33_9 = WwiseUtils.make_unit_auto_source(self.world, var_33_7.play_unit, var_33_7.voice_node)

			fn(var_33_9, make_unit_auto_source, var_33_7)

			local var_33_10 = self
			local _check_play_debug_sound = self._check_play_debug_sound
			local var_33_12 = sound_event
			local currently_playing_subtitle

			if not var_33_7.currently_playing_dialogue then
				currently_playing_subtitle = var_33_7.currently_playing_dialogue.currently_playing_subtitle

				if not currently_playing_subtitle then
					-- Nothing
				end
			end

			currently_playing_subtitle = ""

			::label_33_0::

			local var_33_14, var_33_15 = _check_play_debug_sound(var_33_10, var_33_12, currently_playing_subtitle)

			var_33_14 = var_33_14 or WwiseWorld.trigger_event(var_33_9, sound_event, make_unit_auto_source)

			if var_33_14 ~= 0 then
				local var_33_16 = NetworkLookup.markers[sound_event]
				local network = Managers.state.network
				local game_object_or_level_id, var_33_19 = network:game_object_or_level_id(var_33_2)

				network.network_transmit:send_rpc_clients("rpc_play_marker_event", game_object_or_level_id, var_33_16)

				if not (script_data.dialogue_debug_all_contexts or self._debug_state ~= 2) then
					printf("[DialogueSystem] Playing marker %s", sound_event)
				end
			end
		end
	end
end

local tbl_3 = {}

DialogueSystem.physics_async_update = function (self, arg_34_1, arg_34_2)
	-- function 34
	local dt = arg_34_1.dt

	self:_update_currently_playing_dialogues(dt)
	self:_update_cutscene_subtitles(arg_34_2)
	self:_update_sound_event_subtitles()

	if not self._is_server then
		return
	end

	self._dialogue_state_handler:update(arg_34_2)
	self:_handle_wwise_markers(dt, arg_34_2)

	self._global_context.level_time = arg_34_2
	num = arg_34_2 + 900

	self:_update_incapacitation(arg_34_2)

	local _tagquery_database = self._tagquery_database
	local _query_results = self._query_results
	local iterate_queries = _tagquery_database:iterate_queries(_query_results, num)

	if not flag and self._global_context.level_time > DialogueSettings.dialogue_level_start_delay and not self:has_local_player_moved_from_start_position() then
		for i = 1, iterate_queries do
			local var_34_4 = _query_results[i]
			local source = var_34_4.query_context.source
			local var_34_6 = self._unit_extension_data[source]

			var_34_6.last_query = var_34_4

			local result = var_34_4.result
			local var_34_8 = self._dialogues[result]
			local category = var_34_8.category
			local var_34_10 = dialogue_category_config[category]
			local playable_during_category = var_34_10.playable_during_category

			fassert(var_34_10, "No category setting for category %q used in dialogue %q", category, result)

			local player = Managers.player
			local owner = player:owner(source)
			local side = Managers.state.side
			local _playing_dialogues = self._playing_dialogues
			local flag_2 = true
			local alloc_table = FrameTable.alloc_table()

			for k, v in pairs(_playing_dialogues) do
				local mutually_exclusive = v.mutually_exclusive
				local interrupted_by = v.interrupted_by
				local flag_3 = not k.only_allies and not side:is_ally(source, k.currently_playing_unit)
				local only_local = k.only_local

				only_local = not only_local and not owner and owner ~= player:owner(k.currently_playing_unit)

				if flag_3 or not only_local then
					-- Nothing
				elseif not (not mutually_exclusive and category ~= k.category) then
					flag_2 = false

					break
				elseif not interrupted_by[category] then
					alloc_table[k] = true
				elseif k.currently_playing_unit == source then
					flag_2 = false

					break
				elseif not playable_during_category[k.category] then
					-- Nothing
				else
					flag_2 = false

					break
				end
			end

			if not var_34_8.currently_playing_id then
				flag_2 = false
			end

			if not flag_2 then
				var_34_6.used_query = var_34_4

				local network = Managers.state.network

				for k_2, v_2 in pairs(alloc_table) do
					_playing_dialogues[k_2] = nil
					alloc_table[k_2] = nil

					local currently_playing_unit = k_2.currently_playing_unit
					local game_object_or_level_id, var_34_25 = network:game_object_or_level_id(currently_playing_unit)

					self:rpc_interrupt_dialogue_event(0, game_object_or_level_id, var_34_25)
					network.network_transmit:send_rpc_clients("rpc_interrupt_dialogue_event", game_object_or_level_id, var_34_25)
				end

				local game_object_or_level_id_2, var_34_27 = network:game_object_or_level_id(source)
				local alloc_table_2 = FrameTable.alloc_table()

				alloc_table_2.query_context = var_34_4.query_context
				alloc_table_2.global_context = self._global_context

				local get_object_context = self._tagquery_database:get_object_context(source)

				get_object_context = get_object_context or tbl_3

				local user_context = get_object_context.user_context

				user_context = user_context or tbl_3
				alloc_table_2.user_context = user_context

				local user_memory = get_object_context.user_memory

				user_memory = user_memory or tbl_3
				alloc_table_2.user_memory = user_memory

				local faction_memory = get_object_context.faction_memory

				faction_memory = faction_memory or tbl_3
				alloc_table_2.faction_memory = faction_memory

				local get_filtered_dialogue_event_index = scripts_entity_system_systems_dialogues_dialogue_queries.get_filtered_dialogue_event_index(var_34_8, alloc_table_2, scripts_entity_system_systems_dialogues_global_sound_event_filters)
				local additional_trigger = var_34_8.additional_trigger

				additional_trigger = additional_trigger or var_34_8.additional_trigger_heard

				if not additional_trigger then
					local alloc_table_3 = FrameTable.alloc_table()
					local var_34_36 = source
					local str = "UNKNOWN"
					local get_data = Unit.get_data(var_34_36, "breed")

					if not (not get_data and get_data.is_player) then
						str = get_data.name
					elseif not var_34_36 and not self._unit_extension_data[var_34_36] then
						str = self._unit_extension_data[var_34_36].context.player_profile
					end

					alloc_table_3.dialogue_name_nopre = string.sub(result, 5)
					alloc_table_3.dialogue_name = result
					alloc_table_3.speaker = var_34_36
					alloc_table_3.speaker_name = str
					alloc_table_3.sound_event = var_34_6.last_query_sound_event

					if not var_34_8.additional_trigger_heard then
						alloc_table_3.distance = 1

						for k_3, v_3 in pairs(self._unit_extension_data) do
							v_3.input:trigger_dialogue_event(additional_trigger, alloc_table_3)
						end
					else
						local local_position = Unit.local_position(var_34_36, 0)
						local default_hear_distance = DialogueSettings.default_hear_distance

						for k_4, v_4 in pairs(self._unit_extension_data) do
							local local_position_2 = Unit.local_position(k_4, 0)
							local distance = Vector3.distance(local_position, local_position_2)

							if distance <= default_hear_distance then
								alloc_table_3.distance = distance

								v_4.input:trigger_dialogue_event(additional_trigger, alloc_table_3)

								alloc_table_3 = table.shallow_copy(alloc_table_3, false, FrameTable.alloc_table())
							end
						end
					end
				end

				local get_sound_event_duration = scripts_entity_system_systems_dialogues_dialogue_queries.get_sound_event_duration(var_34_8, get_filtered_dialogue_event_index)
				local query_context = var_34_4.query_context

				if not (not query_context.identifier and query_context.identifier == "") then
					self._dialogue_state_handler:add_playing_dialogue(query_context.identifier, var_34_8.sound_events[get_filtered_dialogue_event_index], arg_34_2, get_sound_event_duration)
				end

				local var_34_45 = NetworkLookup.dialogues[result]

				if not var_34_8.only_local then
					local owner_2 = Managers.player:owner(source)
					local flag_4 = not owner_2 and not not owner_2.bot_player or owner_2:network_id()

					if not flag_4 then
						self:rpc_play_dialogue_event(0, game_object_or_level_id_2, var_34_27, var_34_45, get_filtered_dialogue_event_index)

						if flag_4 ~= Network.peer_id() then
							network.network_transmit:send_rpc("rpc_play_dialogue_event", flag_4, game_object_or_level_id_2, var_34_27, var_34_45, get_filtered_dialogue_event_index)
						end
					end
				elseif not var_34_8.only_allies then
					local var_34_48 = Managers.state.side.side_by_unit[source]

					if not var_34_48 then
						local flag_5 = true
						local flag_6 = false

						self:rpc_play_dialogue_event(0, game_object_or_level_id_2, var_34_27, var_34_45, get_filtered_dialogue_event_index)
						network.network_transmit:send_rpc_side_clients("rpc_play_dialogue_event", var_34_48, flag_5, flag_6, game_object_or_level_id_2, var_34_27, var_34_45, get_filtered_dialogue_event_index)
					end
				else
					self:rpc_play_dialogue_event(0, game_object_or_level_id_2, var_34_27, var_34_45, get_filtered_dialogue_event_index)
					network.network_transmit:send_rpc_clients("rpc_play_dialogue_event", game_object_or_level_id_2, var_34_27, var_34_45, get_filtered_dialogue_event_index)
				end
			end
		end

		if not self._use_story_lines then
			self:_update_story_lines(arg_34_2)
		end

		self:_update_player_jumping(arg_34_2)
	end

	self:_update_mission_giver_events(dt)
	self:_update_new_events(arg_34_2)
end

DialogueSystem.post_update = function (self, arg_35_1, arg_35_2)
	-- function 35
	self._function_command_queue:run_commands()
end

DialogueSystem._update_incapacitation = function (self, arg_36_1)
	-- function 36
	for k, v in pairs(self._unit_extension_data) do
		local status_extension = v.status_extension

		if not status_extension then
			local is_disabled = status_extension:is_disabled()

			if v.is_incapacitated or not is_disabled then
				v.incapacitate_time = arg_36_1
			end

			v.is_incapacitated = is_disabled
		end
	end
end

local tbl_4 = {}

DialogueSystem._update_new_events = function (self, arg_37_1)
	-- function 37
	local _unit_extension_data = self._unit_extension_data
	local _tagquery_database = self._tagquery_database
	local alive = Unit.alive
	local _input_event_queue = self._input_event_queue
	local _input_event_queue_n = self._input_event_queue_n

	for i = 1, _input_event_queue_n, 4 do
		repeat
			local var_37_5 = _input_event_queue[i]

			if not alive(var_37_5) then
				break
			end

			local var_37_6 = _input_event_queue[i + 2]
			local var_37_7

			if not self._dialogues[var_37_6.dialogue_name] then
				var_37_7 = self._dialogues[var_37_6.dialogue_name].category
			end

			local var_37_8 = _unit_extension_data[var_37_5]

			if not (not var_37_8 and not var_37_8.is_incapacitated and not (arg_37_1 > var_37_8.incapacitate_time + 0.1) or var_37_7 == "knocked_down_override" or var_37_6.is_ping == true) then
				break
			end

			local var_37_9 = tbl_4

			table.clear(var_37_9)

			local var_37_10 = _input_event_queue[i + 1]
			local var_37_11 = _input_event_queue[i + 3]
			local create_query = _tagquery_database:create_query()
			local num = 0

			for k, v in pairs(var_37_6) do
				var_37_9[num + 1] = k
				var_37_9[num + 2] = v
				num = num + 2
			end

			local get_data = Unit.get_data(var_37_5, "breed")
			local var_37_15

			if not (not get_data and get_data.is_player) then
				var_37_15 = get_data.dialogue_source_name or get_data.name
			else
				var_37_15 = self._unit_extension_data[var_37_5].context.player_profile
			end

			create_query:add("concept", var_37_10, "source", var_37_5, "source_name", var_37_15, "identifier", var_37_11, unpack(var_37_9))
			create_query:finalize()

			_input_event_queue[i] = nil
			_input_event_queue[i + 1] = nil
			_input_event_queue[i + 2] = nil
		until true
	end

	self._input_event_queue_n = 0
end

DialogueSystem.hot_join_sync = function (self, arg_38_1)
	-- function 38
	if not self._global_context.current_wind then
		local current_wind = self._global_context.current_wind
		local var_38_1 = NetworkLookup.weave_winds[current_wind]

		Managers.state.network.network_transmit:send_rpc("rpc_update_current_wind", arg_38_1, var_38_1)
	end
end

DialogueSystem.has_local_player_moved_from_start_position = function (arg_39_0)
	-- function 39
	if not var_0_18 then
		return false
	end

	local system = Managers.state.entity:system("round_started_system")
	local round_has_started = system:round_has_started()

	round_has_started = round_has_started or system:player_has_moved()

	return round_has_started
end

DialogueSystem.player_shield_check = function (arg_40_0, arg_40_1, arg_40_2)
	-- function 40
	local num = 0

	if not (not Unit.alive(arg_40_1) and Managers.player:owner(arg_40_1) == nil) then
		local extension = ScriptUnit.extension(arg_40_1, "inventory_system")
		local var_40_2

		if not arg_40_2 then
			var_40_2 = extension:get_slot_data(arg_40_2)
		else
			local get_wielded_slot_name = extension:get_wielded_slot_name()

			var_40_2 = extension:get_slot_data(get_wielded_slot_name)
		end

		if not var_40_2 then
			local item_data = var_40_2.item_data
			local flag = not item_data and item_data.item_type

			if not flag and not string.find(flag, "shield") then
				num = 1
			end
		end
	end

	return num
end

DialogueSystem.trigger_general_unit_event = function (arg_41_0, arg_41_1, arg_41_2)
	-- function 41
	Managers.state.entity:system("audio_system"):_play_event(arg_41_2, arg_41_1, 0)

	local var_41_0 = NetworkLookup.sound_events[arg_41_2]
	local network = Managers.state.network
	local game_object_or_level_id, var_41_3 = network:game_object_or_level_id(arg_41_1)

	network.network_transmit:send_rpc_clients("rpc_server_audio_unit_event", var_41_0, game_object_or_level_id, var_41_3, 0)
end

DialogueSystem.trigger_targeted_by_ratling = function (arg_42_0, arg_42_1)
	-- function 42
	local unit_owner = Managers.player:unit_owner(arg_42_1)

	if not (not arg_42_1 and unit_owner == nil) then
		ScriptUnit.extension_input(arg_42_1, "dialogue_system"):trigger_dialogue_event("ratling_target")
	end
end

DialogueSystem.trigger_attack = function (self, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	-- function 43
	local unit_owner = Managers.player:unit_owner(arg_43_2)

	if not ALIVE[arg_43_2] and not unit_owner and not ALIVE[arg_43_3] then
		local var_43_1 = self._unit_extension_data[arg_43_3]
		local var_43_2
		local var_43_3

		if not DEDICATED_SERVER then
			var_43_2, var_43_3 = WwiseUtils.make_unit_auto_source(arg_43_1.world, arg_43_3, var_43_1.voice_node)

			fn(var_43_3, var_43_2, var_43_1)
		end

		if not unit_owner.bot_player then
			local breed = arg_43_1.breed
			local network = Managers.state.network
			local var_43_6

			if not arg_43_4 then
				var_43_6 = breed.backstab_player_sound_event
			elseif not arg_43_5 and not breed.attack_player_sound_event_long then
				var_43_6 = breed.attack_player_sound_event_long
			else
				var_43_6 = breed.attack_player_sound_event
			end

			local var_43_7 = NetworkLookup.sound_events[var_43_6]
			local owner = Managers.player:owner(arg_43_2)
			local game_object_id = NetworkUnit.game_object_id(arg_43_3)
			local var_43_10

			if not arg_43_5 and not breed.attack_general_sound_event_long then
				var_43_10 = breed.attack_general_sound_event_long
			else
				var_43_10 = breed.attack_general_sound_event
			end

			if not var_43_6 then
				if not owner.local_player then
					WwiseWorld.trigger_event(var_43_3, var_43_6, var_43_2)
				else
					local var_43_11 = PEER_ID_TO_CHANNEL[unit_owner.peer_id]

					RPC.rpc_server_audio_unit_event(var_43_11, var_43_7, game_object_id, false, 0)
				end
			end

			local var_43_12 = NetworkLookup.sound_events[var_43_10]

			network.network_transmit:send_rpc_all_except("rpc_server_audio_unit_dialogue_event", unit_owner.peer_id, var_43_12, game_object_id, 0)
		end
	end
end

DialogueSystem.trigger_backstab = function (self, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	local unit_owner = Managers.player:unit_owner(arg_44_1)

	if not (not ALIVE[arg_44_1] and not unit_owner and not ALIVE[arg_44_2] and unit_owner.bot_player) then
		local var_44_1 = self._unit_extension_data[arg_44_2]
		local var_44_2
		local var_44_3

		if not DEDICATED_SERVER then
			var_44_2, var_44_3 = WwiseUtils.make_unit_auto_source(arg_44_3.world, arg_44_2, var_44_1.voice_node)

			fn(var_44_3, var_44_2, var_44_1)
		end

		local backstab_player_sound_event = arg_44_3.breed.backstab_player_sound_event
		local owner = Managers.player:owner(arg_44_1)
		local game_object_id = NetworkUnit.game_object_id(arg_44_2)

		if not backstab_player_sound_event then
			if not owner.local_player then
				WwiseWorld.trigger_event(var_44_3, backstab_player_sound_event, var_44_2)
			else
				local var_44_7 = NetworkLookup.sound_events[backstab_player_sound_event]
				local var_44_8 = PEER_ID_TO_CHANNEL[unit_owner.peer_id]

				RPC.rpc_server_audio_unit_event(var_44_8, var_44_7, game_object_id, false, 0)
			end
		end
	end
end

DialogueSystem.trigger_flanking = function (self, arg_45_1, arg_45_2)
	-- function 45
	local unit_owner = Managers.player:unit_owner(arg_45_1)

	if not ALIVE[arg_45_1] and not unit_owner and not ALIVE[arg_45_2] then
		local breed = ScriptUnit.extension(arg_45_2, "ai_system"):breed()

		if not breed.flanking_sound_event then
			local flanking_sound_event = breed.flanking_sound_event
			local game_object_id = NetworkUnit.game_object_id(arg_45_2)

			if Managers.player:local_player().player_unit == arg_45_1 then
				WwiseUtils.trigger_unit_event(self.world, flanking_sound_event, arg_45_2, 0)
			else
				local var_45_4 = NetworkLookup.sound_events[flanking_sound_event]
				local var_45_5 = PEER_ID_TO_CHANNEL[unit_owner.peer_id]

				RPC.rpc_server_audio_unit_event(var_45_5, var_45_4, game_object_id, false, 0)
			end
		end
	end
end

DialogueSystem.trigger_backstab_hit = function (arg_46_0, arg_46_1, arg_46_2)
	-- function 46
	local unit_owner = Managers.player:unit_owner(arg_46_1)
	local game = Managers.state.network:game()

	if not (not ALIVE[arg_46_1] and not unit_owner and not ALIVE[arg_46_2] and not game and unit_owner.bot_player) then
		local normalize = Vector3.normalize(POSITION_LOOKUP[arg_46_2] - POSITION_LOOKUP[arg_46_1])
		local go_id = Managers.state.network.unit_storage:go_id(arg_46_1)
		local game_object_field = GameSession.game_object_field(game, go_id, "aim_direction")
		local forward = Quaternion.forward(Quaternion.look(game_object_field))

		if Vector3.dot(normalize, forward) < 0.4 then
			local str = "Play_hud_enemy_attack_back_hit"
			local owner = Managers.player:owner(arg_46_1)

			if not owner.local_player then
				ScriptUnit.extension(arg_46_1, "first_person_system"):play_hud_sound_event(str, nil, false)
			else
				local game_object_id = NetworkUnit.game_object_id(arg_46_1)
				local var_46_9 = NetworkLookup.sound_events[str]
				local var_46_10 = PEER_ID_TO_CHANNEL[owner.peer_id]

				RPC.rpc_play_first_person_sound(var_46_10, game_object_id, var_46_9, POSITION_LOOKUP[arg_46_1])
			end
		end
	end
end

DialogueSystem.get_random_player = function (arg_47_0)
	-- function 47
	return PlayerUtils.get_random_alive_hero()
end

DialogueSystem._update_story_lines = function (self, arg_48_1)
	-- function 48
	local _next_story_line_update_t = self._next_story_line_update_t

	if not (self:_is_story_trigger_frozen() or not (_next_story_line_update_t < arg_48_1)) then
		self._next_story_line_update_t = arg_48_1 + DialogueSettings.story_tick_time

		local get_random_player = self:get_random_player()

		if get_random_player ~= nil then
			ScriptUnit.extension_input(get_random_player, "dialogue_system"):trigger_dialogue_event("story_trigger")
		end
	end
end

DialogueSystem.freeze_story_trigger = function (self)
	-- function 49
	self._story_trigger_freezes = self._story_trigger_freezes + 1
end

DialogueSystem.unfreeze_story_trigger = function (self)
	-- function 50
	self._story_trigger_freezes = math.max(0, self._story_trigger_freezes - 1)
end

DialogueSystem._is_story_trigger_frozen = function (self)
	-- function 51
	local _story_trigger_freezes = self._story_trigger_freezes

	_story_trigger_freezes = not _story_trigger_freezes and self._story_trigger_freezes > 0

	return _story_trigger_freezes
end

local tbl_5 = {}
local var_0_28
local num_2 = 0
local num_3 = 5

DialogueSystem.trigger_cutscene_subtitles = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	-- function 52
	flag = false
	var_0_28 = arg_52_2
	num_3 = arg_52_3

	for k, v in pairs(SpecialSubtitleEvents[arg_52_1]) do
		tbl_5[k] = v + Managers.time:time("game")
	end
end

DialogueSystem._update_cutscene_subtitles = function (arg_53_0, arg_53_1)
	-- function 53
	local system = Managers.state.entity:system("hud_system")

	for k, v in pairs(tbl_5) do
		if v < arg_53_1 then
			system:add_subtitle(var_0_28, k)

			tbl_5[k] = nil
		end

		num_2 = arg_53_1 + num_3
	end

	if not (not (arg_53_1 > num_2) or var_0_28 == nil) then
		system:remove_subtitle(var_0_28)

		flag = true
	end
end

DialogueSystem.trigger_sound_event_with_subtitles = function (self, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
	-- function 54
	if not DEDICATED_SERVER then
		return
	end

	self._flow_calls_implementation:trigger_sound_event_with_subtitles(arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
end

DialogueSystem._update_sound_event_subtitles = function (self)
	-- function 55
	if not DEDICATED_SERVER then
		return
	end

	self._flow_calls_implementation:update_sound_event_subtitles()
end

DialogueSystem.disable = function (arg_56_0)
	-- function 56
	flag = false
end

DialogueSystem.enable = function (arg_57_0)
	-- function 57
	flag = true
end

DialogueSystem.tagquery_loader = function (self)
	-- function 58
	return self._tagquery_loader
end

DialogueSystem.tagquery_database = function (self)
	-- function 59
	return self._tagquery_database
end

DialogueSystem.reset_memory_time = function (self, arg_60_1, arg_60_2, arg_60_3)
	-- function 60
	local num_2 = num - 2000
	local var_60_1 = self._unit_extension_data[arg_60_3]

	if not var_60_1 then
		var_60_1[arg_60_1][arg_60_2] = num_2
	end

	if arg_60_2 == "time_since_conversation" then
		self._next_story_line_update_t = 0
	end
end

DialogueSystem.trigger_story_dialogue = function (self, arg_61_1)
	-- function 61
	if not (not Unit.alive(arg_61_1) and self:_is_story_trigger_frozen()) then
		local extension_input = ScriptUnit.extension_input(arg_61_1, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		alloc_table.is_forced = true

		extension_input:trigger_dialogue_event("story_trigger", alloc_table)
	end
end

local num_4 = 0
local num_5 = 0

DialogueSystem._update_player_jumping = function (arg_62_0, arg_62_1)
	-- function 62
	if not DEDICATED_SERVER then
		return
	end

	local Player = Managers.input.input_services.Player
	local player_unit = Managers.player:local_player().player_unit

	if not Unit.alive(player_unit) then
		local extension = ScriptUnit.extension(player_unit, "locomotion_system")

		if Player:get("jump") or not Player:get("jump_only") or not extension:jump_allowed() then
			num_4 = num_4 + 1

			if num_4 == 1 then
				num_5 = arg_62_1
			end
		end

		if arg_62_1 > num_5 + DialogueSettings.bunny_jumping.tick_time then
			num_5 = arg_62_1

			if num_4 > DialogueSettings.bunny_jumping.jump_threshold then
				SurroundingAwareSystem.add_event(player_unit, "bunny_trigger", DialogueSettings.friends_close_distance)
			end

			num_4 = 0
		end
	end
end

DialogueSystem.queue_mission_giver_event = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	-- function 63
	arg_63_0._mission_giver_events[#arg_63_0._mission_giver_events + 1] = {
		delay = DialogueSettings.mission_giver_events_delay,
		event_name = arg_63_1,
		event_data = arg_63_2,
		side_name = arg_63_3
	}
end

DialogueSystem.trigger_mission_giver_event = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	-- function 64
	local get_global_observers = Managers.state.entity:system("surrounding_aware_system"):get_global_observers()
	local get_side_from_name = Managers.state.side:get_side_from_name(arg_64_3)
	local flag = not get_side_from_name and get_side_from_name.side_id

	for k, v in pairs(get_global_observers) do
		if not (not flag and flag ~= v.side_id) then
			ScriptUnit.extension_input(k, "dialogue_system"):trigger_networked_dialogue_event(arg_64_1, arg_64_2)
		end
	end
end

DialogueSystem._update_mission_giver_events = function (self, arg_65_1)
	-- function 65
	local _mission_giver_events = self._mission_giver_events
	local count = #_mission_giver_events
	local num = 1

	while num <= count do
		local var_65_3 = _mission_giver_events[num]

		var_65_3.delay = var_65_3.delay - arg_65_1

		if var_65_3.delay < 0 then
			self:trigger_mission_giver_event(var_65_3.event_name, var_65_3.event_data, var_65_3.side_name)
			table.swap_delete(_mission_giver_events, num)

			count = count - 1
		else
			num = num + 1
		end
	end
end

DialogueSystem.rpc_trigger_dialogue_event = function (self, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6)
	-- function 66
	local unit = Managers.state.unit_storage:unit(arg_66_2)

	if not unit then
		return
	end

	if not FROZEN[unit] then
		return
	end

	local var_66_1

	if not table.is_empty(arg_66_4) then
		local count = #arg_66_4

		for i = 1, count do
			local var_66_3 = arg_66_4[i]

			if not arg_66_5[i] then
				arg_66_4[i] = var_66_3 - 1
			else
				arg_66_4[i] = NetworkLookup.dialogue_event_data_names[var_66_3]
			end
		end

		var_66_1 = FrameTable.alloc_table()

		table.array_to_table(arg_66_4, count, var_66_1)
	end

	local var_66_4 = NetworkLookup.dialogue_events[arg_66_3]
	local _input_event_queue = self._input_event_queue
	local _input_event_queue_n = self._input_event_queue_n

	_input_event_queue[_input_event_queue_n + 1] = unit
	_input_event_queue[_input_event_queue_n + 2] = var_66_4
	_input_event_queue[_input_event_queue_n + 3] = var_66_1 or tbl_2
	_input_event_queue[_input_event_queue_n + 4] = arg_66_6 or ""
	self._input_event_queue_n = _input_event_queue_n + 4
end

DialogueSystem.rpc_play_marker_event = function (self, arg_67_1, arg_67_2, arg_67_3)
	-- function 67
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_67_2, false)

	if not game_object_or_level_unit then
		return
	end

	if not FROZEN[game_object_or_level_unit] then
		return
	end

	if not self._playing_units[game_object_or_level_unit] then
		Application.error("[DialogueSystem] Marker couldn't play since %q was already talking", game_object_or_level_unit)
	end

	local var_67_1 = NetworkLookup.markers[arg_67_3]
	local var_67_2 = self._unit_extension_data[game_object_or_level_unit]
	local make_unit_auto_source, var_67_4 = WwiseUtils.make_unit_auto_source(self.world, var_67_2.play_unit, var_67_2.voice_node)

	fn(var_67_4, make_unit_auto_source, var_67_2)

	local var_67_5 = self
	local _check_play_debug_sound = self._check_play_debug_sound
	local var_67_7 = var_67_1
	local currently_playing_subtitle

	if not var_67_2.currently_playing_dialogue then
		currently_playing_subtitle = var_67_2.currently_playing_dialogue.currently_playing_subtitle

		if not currently_playing_subtitle then
			-- Nothing
		end
	end

	currently_playing_subtitle = ""

	::label_67_0::

	local var_67_9, var_67_10 = _check_play_debug_sound(var_67_5, var_67_7, currently_playing_subtitle)

	if not var_67_9 then
		WwiseWorld.trigger_event(var_67_4, var_67_1, make_unit_auto_source)
	end
end

DialogueSystem._check_play_debug_sound = function (arg_68_0, arg_68_1, arg_68_2)
	-- function 68
	return
end

DialogueSystem.is_unit_playing_dialogue = function (self, arg_69_1)
	-- function 69
	return self._playing_units[arg_69_1]
end

DialogueSystem.rpc_play_dialogue_event = function (self, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5)
	-- function 70
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_70_2, arg_70_3)

	if not game_object_or_level_unit then
		return
	end

	if not FROZEN[game_object_or_level_unit] then
		return
	end

	local var_70_1 = NetworkLookup.dialogues[arg_70_4]
	local var_70_2 = self._dialogues[var_70_1]

	if not var_70_2 then
		Crashify.print_exception("DialogueSystem", "Mismatch in loaded dialogue packages. Received rpc to play dialogue '%s'", var_70_1)

		return
	end

	local shallow_copy = table.shallow_copy(var_70_2)
	local var_70_4 = self._unit_extension_data[game_object_or_level_unit]
	local get_dialogue_event, var_70_6, var_70_7, var_70_8 = scripts_entity_system_systems_dialogues_dialogue_queries.get_dialogue_event(shallow_copy, arg_70_5)
	local var_70_9
	local player_career = var_70_4.context.player_career
	local var_70_11 = CareerSettings[player_career]
	local flag = not var_70_11 and var_70_11.unique_subtitles

	if not flag then
		local var_70_13 = flag[1]
		local var_70_14 = flag[2]

		var_70_9 = string.insert(var_70_6, var_70_13, var_70_14)
	end

	if not var_70_9 and not Managers.localizer:exists(var_70_9) then
		shallow_copy.currently_playing_subtitle = var_70_9
	else
		shallow_copy.currently_playing_subtitle = var_70_6 or ""
	end

	local local_player = Managers.player:local_player()
	local flag_2 = true
	local side = Managers.state.side
	local var_70_18 = side.side_by_unit[game_object_or_level_unit]

	if not var_70_18 then
		local get_party_from_unique_id = Managers.party:get_party_from_unique_id(not local_player and local_player:unique_id())
		local var_70_20 = side.side_by_party[get_party_from_unique_id]

		flag_2 = side:is_ally_by_side(var_70_18, var_70_20)
	end

	if not (shallow_copy.intended_player_profile == nil or shallow_copy.intended_player_profile ~= fn_2()) then
		-- Nothing
	end

	do
		local only_local
	end

	::label_70_0::

	if not shallow_copy.only_allies and not flag_2 then
		only_local = shallow_copy.only_local

		if not only_local then
			-- Nothing
		end

		if not (not local_player and local_player ~= Managers.player:owner(game_object_or_level_unit)) then
			only_local = false

			goto label_70_1
		end
	end

	only_local = true

	::label_70_1::

	if not only_local then
		shallow_copy.currently_playing_subtitle = ""
	else
		if not (not Managers.player:owner(game_object_or_level_unit) and not flag_2) then
			shallow_copy.currently_playing_subtitle = ""
		end

		if not DEDICATED_SERVER then
			local make_unit_auto_source, var_70_23 = WwiseUtils.make_unit_auto_source(self.world, var_70_4.play_unit, var_70_4.voice_node)

			fn(var_70_23, make_unit_auto_source, var_70_4)

			local _check_play_debug_sound, var_70_25 = self:_check_play_debug_sound(get_dialogue_event, var_70_6)

			if not _check_play_debug_sound then
				Managers.state.vce:interrupt_vce(game_object_or_level_unit)

				local var_70_26

				shallow_copy.currently_playing_id, var_70_26 = WwiseWorld.trigger_event(var_70_23, get_dialogue_event, make_unit_auto_source)
			end
		end
	end

	shallow_copy.currently_playing_unit = game_object_or_level_unit

	local var_70_27
	local get_data = Unit.get_data(game_object_or_level_unit, "breed")

	if not (not get_data and get_data.is_player) then
		var_70_27 = get_data.name
	else
		var_70_27 = var_70_4.context.player_profile
	end

	var_70_4.last_query_sound_event = get_dialogue_event
	shallow_copy.speaker_name = var_70_27
	shallow_copy.dialogue_timer = scripts_entity_system_systems_dialogues_dialogue_queries.get_sound_event_duration(shallow_copy, arg_70_5)
	var_70_4.currently_playing_dialogue = shallow_copy
	self._playing_units[game_object_or_level_unit] = var_70_4

	local category = shallow_copy.category
	local var_70_30 = dialogue_category_config[category]

	self._playing_dialogues[shallow_copy] = var_70_30

	local _function_command_queue = self._function_command_queue

	if Managers.player:owner(game_object_or_level_unit) ~= nil or not Unit.has_data(game_object_or_level_unit, "dialogue_face_anim") then
		_function_command_queue:queue_function_command(Unit.animation_event, game_object_or_level_unit, var_70_7)
		_function_command_queue:queue_function_command(Unit.animation_event, game_object_or_level_unit, var_70_8)
	end

	if not Unit.has_data(game_object_or_level_unit, "enemy_dialogue_face_anim") and not Unit.has_animation_state_machine(game_object_or_level_unit) then
		Unit.animation_event(game_object_or_level_unit, "talk_loop")
	end

	if not Unit.has_data(game_object_or_level_unit, "enemy_dialogue_body_anim") and not Unit.has_animation_state_machine(game_object_or_level_unit) then
		Unit.flow_event(game_object_or_level_unit, "action_talk_body")
	end

	if not player_career and not self._is_server then
		Managers.telemetry_events:vo_event_played(category, var_70_1, get_dialogue_event, player_career)
	end
end

DialogueSystem.rpc_interrupt_dialogue_event = function (self, arg_71_1, arg_71_2, arg_71_3)
	-- function 71
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_71_2, arg_71_3)

	if not game_object_or_level_unit then
		return
	end

	if not self._frozen_unit_extension_data[game_object_or_level_unit] then
		return
	end

	local var_71_1 = self._unit_extension_data[game_object_or_level_unit]
	local currently_playing_dialogue = var_71_1.currently_playing_dialogue

	if not currently_playing_dialogue then
		if not DEDICATED_SERVER then
			local wwise_world = self.wwise_world

			if not WwiseWorld.is_playing(wwise_world, currently_playing_dialogue.currently_playing_id) then
				WwiseWorld.stop_event(wwise_world, currently_playing_dialogue.currently_playing_id)
			end
		end

		currently_playing_dialogue.currently_playing_id = nil
		currently_playing_dialogue.dialogue_timer = nil
		var_71_1.currently_playing_dialogue = nil
		self._playing_dialogues[currently_playing_dialogue] = nil
		self._playing_units[game_object_or_level_unit] = nil

		if Managers.player:owner(game_object_or_level_unit) ~= nil or not Unit.has_data(game_object_or_level_unit, "dialogue_face_anim") then
			Unit.animation_event(game_object_or_level_unit, "face_neutral")
			Unit.animation_event(game_object_or_level_unit, "dialogue_end")
		elseif not Unit.has_data(game_object_or_level_unit, "enemy_dialogue_face_anim") and not Unit.has_animation_state_machine(game_object_or_level_unit) then
			Unit.animation_event(game_object_or_level_unit, "talk_end")
		end

		if not Unit.has_data(game_object_or_level_unit, "enemy_dialogue_body_anim") and not Unit.has_animation_state_machine(game_object_or_level_unit) then
			Unit.animation_event(game_object_or_level_unit, "talk_body_end")
		end
	end
end

DialogueSystem.rpc_update_current_wind = function (arg_72_0, arg_72_1, arg_72_2)
	-- function 72
	local var_72_0 = NetworkLookup.weave_winds[arg_72_2]

	arg_72_0._global_context.current_wind = var_72_0
end
