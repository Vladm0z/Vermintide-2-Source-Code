-- chunkname: @scripts/entity_system/systems/dialogues/dialogue_system.lua

require("scripts/utils/function_command_queue")
require("scripts/entity_system/systems/dialogues/tag_query")
require("scripts/entity_system/systems/dialogues/tag_query_database")
require("scripts/entity_system/systems/dialogues/tag_query_loader")
require("scripts/entity_system/systems/dialogues/dialogue_state_handler")
require("scripts/entity_system/systems/dialogues/dialogue_flow_events")
require("scripts/settings/dialogue_settings")

local var_0_0 = require("scripts/entity_system/systems/dialogues/dialogue_queries")
local var_0_1 = require("scripts/settings/live_events_packages")
local var_0_2 = require("scripts/entity_system/systems/dialogues/global_sound_event_filters")

script_data.dialogue_debug_all_contexts = script_data.dialogue_debug_all_contexts or Development.parameter("dialogue_debug_all_contexts")
script_data.dialogue_debug_last_query = script_data.dialogue_debug_last_query or Development.parameter("dialogue_debug_last_query")
script_data.dialogue_debug_last_played_query = script_data.dialogue_debug_last_played_query or Development.parameter("dialogue_debug_last_played_query")
script_data.dialogue_debug_queries = script_data.dialogue_debug_queries or Development.parameter("dialogue_debug_queries")
script_data.dialogue_debug_rules = script_data.dialogue_debug_rules or Development.parameter("dialogue_debug_rules")
script_data.dialogue_debug_missing_vo_trigger_error_sound = script_data.dialogue_debug_missing_vo_trigger_error_sound or Development.parameter("dialogue_debug_missing_vo_trigger_error_sound")

local var_0_3 = {
	"DialogueActorExtension"
}
local var_0_4 = DialogueSettings.dialogue_category_config
local var_0_5 = true
local var_0_6

DialogueSystem = class(DialogueSystem, ExtensionSystemBase)
DialogueSystem.stateless_global_context = table.make_strict({
	last_level_played = "none",
	last_level_won = false
})

local function var_0_7(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_1 ~= arg_1_2.wwise_source_id then
		arg_1_2.wwise_source_id = arg_1_1

		if arg_1_2.wwise_voice_switch_group and arg_1_2.wwise_voice_switch_value then
			WwiseWorld.set_switch(arg_1_0, arg_1_2.wwise_voice_switch_group, arg_1_2.wwise_voice_switch_value, arg_1_1)
		end

		if arg_1_2.wwise_career_switch_group and arg_1_2.wwise_career_switch_value then
			WwiseWorld.set_switch(arg_1_0, arg_1_2.wwise_career_switch_group, arg_1_2.wwise_career_switch_value, arg_1_1)
		end

		if arg_1_2.faction == "player" then
			WwiseWorld.set_switch(arg_1_0, "husk", tostring(not arg_1_2.local_player), arg_1_1)
		end

		if arg_1_2.vo_center_percent then
			WwiseWorld.set_source_parameter(arg_1_0, arg_1_1, "vo_center_percent", arg_1_2.vo_center_percent)
		end
	end
end

local function var_0_8()
	if not Managers then
		return nil
	end

	if not Managers.player then
		return nil
	end

	if not SPProfiles then
		return nil
	end

	local var_2_0 = Managers.player:local_player()

	if not var_2_0 then
		return nil
	end

	local var_2_1 = var_2_0:career_index()
	local var_2_2 = var_2_0:profile_index()

	return SPProfiles[var_2_2].careers[var_2_1].profile_name
end

function DialogueSystem.init(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_1.entity_manager

	var_3_0:register_system(arg_3_0, arg_3_2, var_0_3)

	arg_3_0._entity_manager = var_3_0
	arg_3_0._frozen_unit_extension_data = {}
	arg_3_0._unit_extension_data = {}
	arg_3_0._playing_dialogues = {}
	arg_3_0._playing_units = {}
	arg_3_0._query_results = {}
	arg_3_0._is_server = arg_3_1.is_server
	arg_3_0._debug_state = nil
	arg_3_0._mission_giver_events = {}
	arg_3_0._tagquery_database = TagQueryDatabase:new()
	arg_3_0._dialogues = {}
	arg_3_0._markers = {}
	arg_3_0._story_trigger_freezes = 0
	arg_3_0._tagquery_loader = TagQueryLoader:new(arg_3_0._tagquery_database, arg_3_0._dialogues)

	local var_3_1 = 2

	arg_3_0._function_command_queue = FunctionCommandQueue:new(var_3_1)

	local var_3_2 = arg_3_1.network_event_delegate

	arg_3_0._network_event_delegate = var_3_2

	var_3_2:register(arg_3_0, "rpc_trigger_dialogue_event", "rpc_play_dialogue_event", "rpc_interrupt_dialogue_event", "rpc_update_current_wind")

	local var_3_3 = arg_3_1.startup_data.level_key
	local var_3_4 = "dialogues/generated/" .. var_3_3
	local var_3_5 = DialogueSettings.blocked_auto_load_files[var_3_3]
	local var_3_6 = Managers.mechanism:current_mechanism_name()
	local var_3_7 = DialogueSettings.auto_load_files_mechanism[var_3_6] or {}

	arg_3_0._original_dialogue_settings = {}

	local var_3_8 = LevelSettings[var_3_3]
	local var_3_9 = var_3_8.override_dialogue_settings

	if var_3_9 then
		for iter_3_0, iter_3_1 in pairs(var_3_9) do
			arg_3_0._original_dialogue_settings[iter_3_0] = DialogueSettings[iter_3_0]
			DialogueSettings[iter_3_0] = iter_3_1
		end
	end

	arg_3_0._use_story_lines = Managers.state.game_mode:setting("use_story_lines")

	if Application.can_get("lua", var_3_4) then
		arg_3_0._tagquery_loader:load_file(var_3_4)
	end

	if not var_3_5 then
		arg_3_0._tagquery_loader:load_auto_load_files(arg_3_0._markers)

		for iter_3_2, iter_3_3 in ipairs(var_3_7) do
			if Application.can_get("lua", iter_3_3) then
				arg_3_0._tagquery_loader:load_file(iter_3_3)
			end

			if Application.can_get("lua", iter_3_3 .. "_markers") then
				local var_3_10 = dofile(iter_3_3 .. "_markers")

				for iter_3_4, iter_3_5 in pairs(var_3_10) do
					fassert(not arg_3_0._markers[iter_3_4], "[DialogueSystem] There is already a marker called %s registered", iter_3_4)

					arg_3_0._markers[iter_3_4] = iter_3_5
				end
			end
		end
	end

	local var_3_11 = DialogueSettings.level_specific_load_files[var_3_3]

	if var_3_11 then
		for iter_3_6, iter_3_7 in ipairs(var_3_11) do
			if Application.can_get("lua", iter_3_7) then
				arg_3_0._tagquery_loader:load_file(iter_3_7)
			end

			if Application.can_get("lua", iter_3_7 .. "_markers") then
				local var_3_12 = dofile(iter_3_7 .. "_markers")

				for iter_3_8, iter_3_9 in pairs(var_3_12) do
					fassert(not arg_3_0._markers[iter_3_8], "[DialogueSystem] There is already a marker called %s registered", iter_3_8)

					arg_3_0._markers[iter_3_8] = iter_3_9
				end
			end
		end
	end

	local var_3_13 = arg_3_1.startup_data.environment_variation_name

	arg_3_0._global_context = {
		game_about_to_end = 0,
		current_level = var_3_3,
		weather = var_3_13
	}

	if not var_3_8.tutorial_level then
		local var_3_14 = Managers.backend:get_interface("live_events")
		local var_3_15 = var_3_14 and var_3_14:get_special_events()

		if var_3_15 then
			local var_3_16 = Managers.mechanism:current_mechanism_name()

			arg_3_0._loaded_event_dialogues = {}

			for iter_3_10 = 1, #var_3_15 do
				local var_3_17 = var_3_15[iter_3_10]
				local var_3_18 = var_3_17.name

				arg_3_0._global_context[var_3_18] = true

				arg_3_0:_load_special_event_dialogues(var_3_18, var_3_16)

				local var_3_19 = var_3_17.mutators

				if var_3_19 then
					for iter_3_11 = 1, #var_3_19 do
						local var_3_20 = var_3_19[iter_3_11]

						arg_3_0:_load_special_event_dialogues(var_3_20, var_3_16)
					end
				end
			end
		end
	end

	table.merge(arg_3_0._global_context, DialogueSystem.stateless_global_context)

	local var_3_21 = Managers.state.game_mode:initialized_mutator_map()

	for iter_3_12 in pairs(var_3_21) do
		local var_3_22 = MutatorTemplates[iter_3_12].dialogue_settings

		if var_3_22 then
			for iter_3_13 = 1, #var_3_22 do
				local var_3_23 = var_3_22[iter_3_13]

				if Application.can_get("lua", var_3_23) then
					arg_3_0._tagquery_loader:load_file(var_3_23)
				end

				if Application.can_get("lua", var_3_23 .. "_markers") then
					local var_3_24 = dofile(var_3_23 .. "_markers")

					for iter_3_14, iter_3_15 in pairs(var_3_24) do
						fassert(not arg_3_0._markers[iter_3_14], "[DialogueSystem] There is already a marker called %s registered", iter_3_14)

						arg_3_0._markers[iter_3_14] = iter_3_15
					end
				end
			end
		end
	end

	arg_3_0._tagquery_database:finalize_rules()

	local var_3_25 = arg_3_1.world

	arg_3_0.world = var_3_25

	if not DEDICATED_SERVER then
		arg_3_0.wwise_world = Managers.world:wwise_world(var_3_25)
		arg_3_0._flow_calls_implementation = DialogueSystemFlow:new(arg_3_0.wwise_world, Managers.state.entity:system("hud_system"))
	end

	arg_3_0.gui = World.create_screen_gui(var_3_25, "material", "materials/fonts/gw_fonts", "immediate")

	if arg_3_0._is_server then
		arg_3_0._dialogue_state_handler = DialogueStateHandler:new(arg_3_0.world)
	end

	arg_3_0._input_event_queue = {}
	arg_3_0._input_event_queue_n = 0
	arg_3_0._faction_memories = {
		player = {},
		enemy = {}
	}

	local var_3_26 = {}

	for iter_3_16, iter_3_17 in pairs(Breeds) do
		if iter_3_17.wwise_voice_switch_group then
			var_3_26[iter_3_16] = 1
		end
	end

	arg_3_0._wwise_voice_switch_value_indices = var_3_26
	arg_3_0.statistics_db = arg_3_1.statistics_db

	for iter_3_18, iter_3_19 in ipairs(SPProfiles) do
		arg_3_0._global_context[iter_3_19.display_name] = false

		for iter_3_20, iter_3_21 in ipairs(iter_3_19.careers) do
			arg_3_0._global_context[iter_3_21.display_name] = false
		end
	end

	local var_3_27 = Managers.weave:get_active_weave_template()

	if var_3_27 and arg_3_0._is_server then
		local var_3_28 = var_3_27.wind

		arg_3_0._global_context.current_wind = var_3_28
	end

	local var_3_29 = Managers.mechanism:get_level_dialogue_context()

	table.merge(arg_3_0._global_context, var_3_29)

	arg_3_0._global_context.level_time = 0

	local var_3_30 = Managers.mechanism:game_mechanism()

	if var_3_30.get_current_set then
		local var_3_31 = var_3_30:get_current_set()

		arg_3_0._global_context.current_set = var_3_31
	end

	arg_3_0._tagquery_database:set_global_context(arg_3_0._global_context)

	arg_3_0._next_story_line_update_t = DialogueSettings.story_start_delay
end

function DialogueSystem._load_special_event_dialogues(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = var_0_1[arg_4_1]
	local var_4_1 = var_4_0 and var_4_0.dialogues
	local var_4_2 = var_4_1 and var_4_1[arg_4_2]

	if var_4_2 then
		for iter_4_0 = 1, #var_4_2 do
			local var_4_3 = var_4_2[iter_4_0]

			if not arg_4_0._loaded_event_dialogues[var_4_3] then
				if Application.can_get("lua", var_4_3) then
					arg_4_0._tagquery_loader:load_file(var_4_3)
				end

				if Application.can_get("lua", var_4_3 .. "_markers") then
					local var_4_4 = dofile(var_4_3 .. "_markers")

					for iter_4_1, iter_4_2 in pairs(var_4_4) do
						fassert(not arg_4_0._markers[iter_4_1], "[DialogueSystem] There is already a marker called %s registered", iter_4_1)

						arg_4_0._markers[iter_4_1] = iter_4_2
					end
				end

				arg_4_0._loaded_event_dialogues[var_4_3] = true
			end
		end
	end
end

function DialogueSystem.dialogue_units(arg_5_0)
	return arg_5_0._unit_extension_data
end

function DialogueSystem.is_dialogue_playing(arg_6_0)
	return not table.is_empty(arg_6_0._playing_dialogues)
end

function DialogueSystem.destroy(arg_7_0)
	arg_7_0._tagquery_loader:unload_files()
	arg_7_0._tagquery_database:destroy()
	World.destroy_gui(arg_7_0.world, arg_7_0.gui)
	arg_7_0._network_event_delegate:unregister(arg_7_0)

	if next(arg_7_0._original_dialogue_settings) then
		for iter_7_0, iter_7_1 in pairs(arg_7_0._original_dialogue_settings) do
			DialogueSettings[iter_7_0] = iter_7_1
		end
	end

	table.clear(arg_7_0)
end

local var_0_9 = {}

function DialogueSystem.on_add_extension(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = {
		user_memory = {},
		context = {
			health = 1
		},
		local_player = arg_8_4.local_player,
		dialogue_profile = arg_8_4.dialogue_profile
	}
	local var_8_1 = arg_8_0

	var_8_0.input = MakeTableStrict({
		trigger_dialogue_event = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			if not var_8_1._is_server then
				return
			end

			local var_9_0 = var_8_1._input_event_queue
			local var_9_1 = var_8_1._input_event_queue_n

			var_9_0[var_9_1 + 1] = arg_8_2
			var_9_0[var_9_1 + 2] = arg_9_1
			var_9_0[var_9_1 + 3] = arg_9_2 or var_0_9
			var_9_0[var_9_1 + 4] = arg_9_3 or ""
			var_8_1._input_event_queue_n = var_9_1 + 4
		end,
		trigger_networked_dialogue_event = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			if LEVEL_EDITOR_TEST then
				return
			end

			if var_8_1._is_server then
				local var_10_0 = var_8_1._input_event_queue
				local var_10_1 = var_8_1._input_event_queue_n

				var_10_0[var_10_1 + 1] = arg_8_2
				var_10_0[var_10_1 + 2] = arg_10_1
				var_10_0[var_10_1 + 3] = arg_10_2 or var_0_9
				var_10_0[var_10_1 + 4] = arg_10_3 or ""
				var_8_1._input_event_queue_n = var_10_1 + 4

				return
			end

			local var_10_2 = FrameTable.alloc_table()
			local var_10_3 = FrameTable.alloc_table()

			if arg_10_2 then
				local var_10_4 = table.table_to_array(arg_10_2, var_10_3)

				for iter_10_0 = 1, var_10_4 do
					local var_10_5 = var_10_3[iter_10_0]

					if type(var_10_5) == "number" then
						fassert(var_10_5 % 1 == 0, "Tried to pass non-integer value to dialogue event")
						fassert(var_10_5 >= 0, "Tried to send a dialogue data number smaller than zero")

						var_10_3[iter_10_0] = var_10_5 + 1
						var_10_2[iter_10_0] = true
					else
						var_10_3[iter_10_0] = NetworkLookup.dialogue_event_data_names[var_10_5]
						var_10_2[iter_10_0] = false
					end
				end
			end

			local var_10_6 = NetworkUnit.game_object_id(arg_8_2)
			local var_10_7 = NetworkLookup.dialogue_events[arg_10_1]

			fassert(var_10_6, "No game object id for unit %s.", arg_8_2)
			Managers.state.network.network_transmit:send_rpc_server("rpc_trigger_dialogue_event", var_10_6, var_10_7, var_10_3, var_10_2)
		end,
		play_voice = function(arg_11_0, arg_11_1, arg_11_2)
			if DEDICATED_SERVER then
				return
			end

			local var_11_0, var_11_1 = WwiseUtils.make_unit_auto_source(var_8_1.world, var_8_0.play_unit, var_8_0.voice_node)

			var_0_7(var_11_1, var_11_0, var_8_0)

			local var_11_2, var_11_3 = var_8_1:_check_play_debug_sound(arg_11_1, var_8_0.currently_playing_dialogue and var_8_0.currently_playing_dialogue.currently_playing_subtitle or "")

			if not var_11_2 then
				return WwiseWorld.trigger_event(var_11_1, arg_11_1, arg_11_2, var_11_0)
			else
				return
			end
		end,
		play_voice_debug = function(arg_12_0, arg_12_1)
			if DEDICATED_SERVER then
				return
			end

			local var_12_0, var_12_1 = WwiseUtils.make_unit_auto_source(var_8_1.world, var_8_0.play_unit, var_8_0.voice_node)

			var_0_7(var_12_1, var_12_0, var_8_0)

			local var_12_2, var_12_3 = var_8_1:_check_play_debug_sound(arg_12_1, var_8_0.currently_playing_dialogue and var_8_0.currently_playing_dialogue.currently_playing_subtitle or "")

			if not var_12_2 then
				return WwiseWorld.trigger_event(var_12_1, arg_12_1, var_12_0)
			else
				return
			end
		end,
		trigger_query = function(arg_13_0, arg_13_1)
			local var_13_0, var_13_1, var_13_2, var_13_3, var_13_4 = unpack(arg_13_1)

			var_8_1._tagquery_database:debug_test_query(var_13_0, var_13_1, var_13_2, var_13_3, var_13_4)
		end
	})

	arg_8_0._tagquery_database:add_object_context(arg_8_2, "user_memory", var_8_0.user_memory)
	arg_8_0._tagquery_database:add_object_context(arg_8_2, "user_context", var_8_0.context)

	local var_8_2 = arg_8_4.faction or Unit.get_data(arg_8_2, "faction")

	if var_8_2 then
		var_8_0.faction = var_8_2

		fassert(arg_8_0._faction_memories[var_8_2], "No such faction %q", tostring(var_8_2))
		arg_8_0._tagquery_database:add_object_context(arg_8_2, "faction_memory", arg_8_0._faction_memories[var_8_2])

		var_8_0.faction_memory = arg_8_0._faction_memories[var_8_2]
	end

	ScriptUnit.set_extension(arg_8_2, "dialogue_system", var_8_0)

	arg_8_0._unit_extension_data[arg_8_2] = var_8_0

	local var_8_3 = arg_8_4.breed_name

	if var_8_3 then
		local var_8_4 = Breeds[var_8_3]

		if var_8_4.wwise_voice_switch_group then
			local var_8_5 = var_8_4.wwise_voices
			local var_8_6 = #var_8_5
			local var_8_7 = arg_8_0._wwise_voice_switch_value_indices[var_8_3]
			local var_8_8 = var_8_5[var_8_7]

			var_8_0.wwise_voice_switch_value = var_8_8

			local var_8_9 = var_8_4.wwise_voice_switch_group

			var_8_0.wwise_voice_switch_group = var_8_9
			arg_8_0._wwise_voice_switch_value_indices[var_8_3] = var_8_7 % var_8_6 + 1

			if script_data.sound_debug then
				printf("[DialogueSystem] Spawned breed %s - using switch group '%s' with '%s'", var_8_3, var_8_9, var_8_8)
			end
		end

		if DialogueSettings.breed_types_trigger_on_spawn[var_8_3] and arg_8_0._is_server then
			arg_8_0._entity_manager:system("surrounding_aware_system"):add_system_event(arg_8_2, "enemy_spawn", math.huge, "breed_type", var_8_3)
		end
	elseif arg_8_4.wwise_voice_switch_group ~= nil then
		var_8_0.wwise_voice_switch_group = arg_8_4.wwise_voice_switch_group
		var_8_0.wwise_voice_switch_value = arg_8_4.wwise_voice_switch_value
		var_8_0.wwise_career_switch_group = arg_8_4.wwise_career_switch_group
		var_8_0.wwise_career_switch_value = arg_8_4.wwise_career_switch_value
	end

	return var_8_0
end

function DialogueSystem.extensions_ready(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._unit_extension_data[arg_14_2]
	local var_14_1 = arg_14_0._unit_extension_data[arg_14_2].context
	local var_14_2 = var_14_1.player_profile
	local var_14_3 = ScriptUnit.has_extension(arg_14_2, "status_system")

	if var_14_3 then
		var_14_0.status_extension = var_14_3
		arg_14_0._global_context[var_14_2] = true

		local var_14_4 = ScriptUnit.extension(arg_14_2, "career_system"):career_name()

		arg_14_0._global_context[var_14_4] = true
		var_14_1.player_career = var_14_4
	elseif var_14_2 == nil then
		var_14_1.player_profile = var_14_0.dialogue_profile or Unit.get_data(arg_14_2, "dialogue_profile")
	end

	local var_14_5 = arg_14_2
	local var_14_6 = 0
	local var_14_7 = 0

	if var_14_0.local_player then
		var_14_5 = ScriptUnit.extension(arg_14_2, "first_person_system"):get_first_person_unit()
		var_14_6 = 100
		var_14_7 = Unit.node(var_14_5, "camera_node")
	elseif Unit.has_node(var_14_5, "a_voice") then
		var_14_7 = Unit.node(var_14_5, "a_voice")
	elseif Unit.has_node(var_14_5, "j_head") then
		var_14_7 = Unit.node(var_14_5, "j_head")
	end

	var_14_0.play_unit = var_14_5
	var_14_0.voice_node = var_14_7
	var_14_0.vo_center_percent = var_14_6
end

function DialogueSystem.on_remove_extension(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0._frozen_unit_extension_data[arg_15_1] = nil

	arg_15_0:_cleanup_extension(arg_15_1, arg_15_2)
	ScriptUnit.remove_extension(arg_15_1, arg_15_0.NAME)
end

function DialogueSystem.on_freeze_extension(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._unit_extension_data[arg_16_1]

	fassert(var_16_0, "Unit was already frozen.")

	arg_16_0._frozen_unit_extension_data[arg_16_1] = var_16_0

	arg_16_0:_cleanup_extension(arg_16_1, arg_16_2)
end

function DialogueSystem.freeze(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0._frozen_unit_extension_data

	if var_17_0[arg_17_1] then
		return
	end

	local var_17_1 = arg_17_0._unit_extension_data[arg_17_1]

	fassert(var_17_1, "Unit to freeze didn't have unfrozen extension")
	arg_17_0:_cleanup_extension(arg_17_1, arg_17_2)

	arg_17_0._unit_extension_data[arg_17_1] = nil
	var_17_0[arg_17_1] = var_17_1
end

function DialogueSystem.unfreeze(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._frozen_unit_extension_data[arg_18_1]

	fassert(var_18_0, "Unit to unfreeze didn't have frozen extension")

	arg_18_0._frozen_unit_extension_data[arg_18_1] = nil
	arg_18_0._unit_extension_data[arg_18_1] = var_18_0

	arg_18_0._tagquery_database:add_object_context(arg_18_1, "user_memory", var_18_0.user_memory)
	arg_18_0._tagquery_database:add_object_context(arg_18_1, "user_context", var_18_0.context)
	arg_18_0._tagquery_database:add_object_context(arg_18_1, "faction_memory", arg_18_0._faction_memories[var_18_0.faction])
end

function DialogueSystem.set_faction_memory(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_0._faction_memories[arg_19_1][arg_19_2] = arg_19_3
end

function DialogueSystem.set_user_memory(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_0._unit_extension_data[arg_20_1]

	if var_20_0 then
		var_20_0.user_memory[arg_20_2] = arg_20_3
	end
end

function DialogueSystem.set_user_context(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_0._unit_extension_data[arg_21_1]

	if var_21_0 then
		var_21_0.user_context[arg_21_2] = arg_21_3
	end
end

function DialogueSystem.set_global_context(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0._global_context[arg_22_1] = arg_22_2
end

function DialogueSystem.get_global_context(arg_23_0, arg_23_1)
	return arg_23_0._global_context[arg_23_1]
end

function DialogueSystem.force_faction_op(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	arg_24_0._faction_memories[arg_24_2][arg_24_3] = DialogueSystem.function_by_op[TagQuery.OP[arg_24_4]](arg_24_0._faction_memories[arg_24_2][arg_24_3], arg_24_5)
end

function DialogueSystem._cleanup_extension(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._unit_extension_data[arg_25_1]

	if var_25_0 == nil then
		return
	end

	local var_25_1 = var_25_0.context
	local var_25_2 = var_25_1.player_profile

	if var_25_2 then
		local var_25_3 = arg_25_0._global_context

		var_25_3[var_25_2] = false

		local var_25_4 = var_25_1.player_career

		if var_25_4 then
			var_25_3[var_25_4] = false
		end
	end

	table.clear(var_25_0.user_memory)
	table.clear(var_25_1)

	var_25_1.health = 1

	local var_25_5 = var_25_0.currently_playing_dialogue

	if arg_25_0._playing_dialogues[var_25_5] then
		if var_25_5.currently_playing_id and WwiseWorld.is_playing(arg_25_0.wwise_world, var_25_5.currently_playing_id) then
			WwiseWorld.stop_event(arg_25_0.wwise_world, var_25_5.currently_playing_id)
		end

		arg_25_0._playing_dialogues[var_25_5] = nil
		var_25_5.currently_playing_id = nil
		var_25_5.currently_playing_unit = nil
	end

	var_25_0.used_query = nil
	var_25_0.currently_playing_dialogue = nil
	arg_25_0._playing_units[arg_25_1] = nil
	arg_25_0._unit_extension_data[arg_25_1] = nil

	arg_25_0._tagquery_database:remove_object(arg_25_1)
	arg_25_0._function_command_queue:cleanup_destroyed_unit(arg_25_1)
end

local var_0_10 = 0

DialogueSystem.function_by_op = DialogueSystem.function_by_op or {
	[TagQuery.OP.ADD] = function(arg_26_0, arg_26_1)
		return (arg_26_0 or 0) + arg_26_1
	end,
	[TagQuery.OP.SUB] = function(arg_27_0, arg_27_1)
		return (arg_27_0 or 0) - arg_27_1
	end,
	[TagQuery.OP.NUMSET] = function(arg_28_0, arg_28_1)
		return arg_28_1 or 0
	end,
	[TagQuery.OP.TIMESET] = function()
		return Managers.time:time("game") + 900
	end
}

function DialogueSystem._update_currently_playing_dialogues(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0._function_command_queue
	local var_30_1 = Managers.player
	local var_30_2 = arg_30_0._unit_extension_data
	local var_30_3 = arg_30_0._playing_units
	local var_30_4 = Unit.alive

	for iter_30_0, iter_30_1 in pairs(var_30_3) do
		repeat
			local var_30_5 = iter_30_1.currently_playing_dialogue

			if not var_30_4(iter_30_0) then
				var_30_3[iter_30_0] = nil

				if var_30_5 then
					var_30_5.currently_playing_id = nil
					var_30_5.currently_playing_unit = nil
					arg_30_0._playing_dialogues[var_30_5] = nil
				end

				break
			end

			fassert(var_30_5, "Dialogue for playing unit was nil!")

			if not (var_30_5.dialogue_timer - arg_30_1 > 0) then
				if Unit.has_animation_state_machine(iter_30_0) then
					if var_30_1:owner(iter_30_0) ~= nil or Unit.has_data(iter_30_0, "dialogue_face_anim") then
						var_30_0:queue_function_command(Unit.animation_event, iter_30_0, "face_neutral")
						var_30_0:queue_function_command(Unit.animation_event, iter_30_0, "dialogue_end")
					elseif Unit.has_data(iter_30_0, "enemy_dialogue_face_anim") then
						var_30_0:queue_function_command(Unit.animation_event, iter_30_0, "talk_end")
					end

					if Unit.has_data(iter_30_0, "enemy_dialogue_body_anim") then
						var_30_0:queue_function_command(Unit.animation_event, iter_30_0, "talk_body_end")
					end
				end

				local var_30_6 = var_30_5.sound_distance

				iter_30_1.currently_playing_dialogue = nil
				var_30_5.currently_playing_id = nil
				var_30_5.currently_playing_unit = nil
				arg_30_0._playing_dialogues[var_30_5] = nil
				var_30_3[iter_30_0] = nil

				if not arg_30_0._is_server then
					break
				end

				local var_30_7 = iter_30_1.used_query

				iter_30_1.used_query = nil

				local var_30_8 = var_30_7.result

				if var_30_8 then
					local var_30_9 = var_30_7.query_context.source
					local var_30_10 = var_30_7.validated_rule
					local var_30_11 = var_30_10.on_done

					if var_30_11 then
						for iter_30_2 = 1, #var_30_11 do
							local var_30_12 = var_30_11[iter_30_2]
							local var_30_13 = var_30_12[1]
							local var_30_14 = var_30_12[2]
							local var_30_15 = var_30_12[3]
							local var_30_16 = var_30_12[4]
							local var_30_17 = var_30_2[var_30_9]

							if type(var_30_15) == "table" then
								fassert(DialogueSystem.function_by_op[var_30_15], "Unknown operator: %q", tostring(var_30_15))

								var_30_17[var_30_13][var_30_14] = DialogueSystem.function_by_op[var_30_15](var_30_17[var_30_13][var_30_14], var_30_16)
							else
								fassert(var_30_15, "No such operator in on_done-command for rule %q", var_30_10.name)

								var_30_17[var_30_13][var_30_14] = var_30_15
							end
						end
					end

					local var_30_18 = "UNKNOWN"
					local var_30_19 = Unit.get_data(var_30_9, "breed")

					if var_30_19 and not var_30_19.is_player then
						var_30_18 = var_30_19.name
					else
						local var_30_20 = arg_30_0._unit_extension_data[var_30_9]

						if var_30_20 then
							var_30_18 = var_30_20.context.player_profile
						end
					end

					if var_30_5.override_awareness then
						local var_30_21 = FrameTable.alloc_table()

						var_30_21.dialogue_name_nopre = string.sub(var_30_8, 5)
						var_30_21.dialogue_name = var_30_8
						var_30_21.speaker = var_30_9
						var_30_21.distance = 1
						var_30_21.speaker_name = var_30_18
						var_30_21.sound_event = iter_30_1.last_query_sound_event

						for iter_30_3, iter_30_4 in pairs(arg_30_0._unit_extension_data) do
							iter_30_4.input:trigger_dialogue_event(var_30_5.override_awareness, var_30_21)
						end
					else
						arg_30_0._entity_manager:system("surrounding_aware_system"):add_system_event(var_30_9, "heard_speak", var_30_6, "speaker", var_30_9, "speaker_name", var_30_18, "sound_event", iter_30_1.last_query_sound_event or "unknown", "dialogue_name", var_30_8, "dialogue_name_nopre", string.sub(var_30_8, 5))
					end

					iter_30_1.last_query_sound_event = nil
				end

				break
			end

			if var_30_5.dialogue_timer then
				local var_30_22 = false
				local var_30_23 = ScriptUnit.has_extension(iter_30_0, "ghost_mode_system")

				if var_30_23 and var_30_23:is_in_ghost_mode() and not var_30_5.only_local and not var_30_5.only_allies then
					var_30_22 = true
				end

				if var_30_22 or ScriptUnit.has_extension(iter_30_0, "health_system") and not HEALTH_ALIVE[iter_30_0] then
					if arg_30_0._is_server then
						local var_30_24, var_30_25 = Managers.state.network:game_object_or_level_id(iter_30_0)

						arg_30_0:rpc_interrupt_dialogue_event(0, var_30_24, var_30_25)
						Managers.state.network.network_transmit:send_rpc_clients("rpc_interrupt_dialogue_event", var_30_24, var_30_25)
					end

					break
				end

				var_30_5.dialogue_timer = var_30_5.dialogue_timer - arg_30_1
			end
		until true
	end
end

function DialogueSystem.update(arg_31_0, arg_31_1, arg_31_2)
	return
end

function DialogueSystem._handle_wwise_markers(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = WwiseWorld.pull_marker_events(arg_32_0.wwise_world)

	if var_32_0 then
		for iter_32_0 = 1, #var_32_0 do
			local var_32_1 = var_32_0[iter_32_0]
			local var_32_2 = arg_32_0._markers[var_32_1.label]

			if var_32_2 then
				arg_32_0:_trigger_marker(var_32_2)
			end
		end
	end
end

function DialogueSystem._trigger_marker(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_1.sound_event
	local var_33_1 = arg_33_1.source_name
	local var_33_2
	local var_33_3 = Managers.player:players()

	for iter_33_0, iter_33_1 in pairs(var_33_3) do
		local var_33_4 = iter_33_1.player_unit
		local var_33_5 = arg_33_0._unit_extension_data[var_33_4]

		if var_33_5 and (var_33_5.context and var_33_5.context.player_profile) == var_33_1 then
			var_33_2 = iter_33_1.player_unit

			break
		end
	end

	if not var_33_2 then
		Application.error("[DialogueSystem] No source_name called %s could be found", var_33_1)
	elseif arg_33_0._playing_units[var_33_2] then
		Application.error("[DialogueSystem] Marker couldn't play since %s was already talking", var_33_1)
	else
		local var_33_6 = arg_33_0._unit_extension_data[var_33_2]

		if not var_33_6 then
			Application.error("[DialogueSystem] Could not find any extension_data for profile %s", var_33_1)
		else
			local var_33_7, var_33_8 = WwiseUtils.make_unit_auto_source(arg_33_0.world, var_33_6.play_unit, var_33_6.voice_node)

			var_0_7(var_33_8, var_33_7, var_33_6)

			local var_33_9, var_33_10 = arg_33_0:_check_play_debug_sound(var_33_0, var_33_6.currently_playing_dialogue and var_33_6.currently_playing_dialogue.currently_playing_subtitle or "")

			var_33_9 = var_33_9 or WwiseWorld.trigger_event(var_33_8, var_33_0, var_33_7)

			if var_33_9 ~= 0 then
				local var_33_11 = NetworkLookup.markers[var_33_0]
				local var_33_12 = Managers.state.network
				local var_33_13, var_33_14 = var_33_12:game_object_or_level_id(var_33_2)

				var_33_12.network_transmit:send_rpc_clients("rpc_play_marker_event", var_33_13, var_33_11)

				if script_data.dialogue_debug_all_contexts or arg_33_0._debug_state == 2 then
					printf("[DialogueSystem] Playing marker %s", var_33_0)
				end
			end
		end
	end
end

local var_0_11 = {}

function DialogueSystem.physics_async_update(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_1.dt

	arg_34_0:_update_currently_playing_dialogues(var_34_0)
	arg_34_0:_update_cutscene_subtitles(arg_34_2)
	arg_34_0:_update_sound_event_subtitles()

	if not arg_34_0._is_server then
		return
	end

	arg_34_0._dialogue_state_handler:update(arg_34_2)
	arg_34_0:_handle_wwise_markers(var_34_0, arg_34_2)

	arg_34_0._global_context.level_time = arg_34_2
	var_0_10 = arg_34_2 + 900

	arg_34_0:_update_incapacitation(arg_34_2)

	local var_34_1 = arg_34_0._tagquery_database
	local var_34_2 = arg_34_0._query_results
	local var_34_3 = var_34_1:iterate_queries(var_34_2, var_0_10)

	if var_0_5 and (arg_34_0._global_context.level_time > DialogueSettings.dialogue_level_start_delay or arg_34_0:has_local_player_moved_from_start_position()) then
		for iter_34_0 = 1, var_34_3 do
			local var_34_4 = var_34_2[iter_34_0]
			local var_34_5 = var_34_4.query_context.source
			local var_34_6 = arg_34_0._unit_extension_data[var_34_5]

			var_34_6.last_query = var_34_4

			local var_34_7 = var_34_4.result
			local var_34_8 = arg_34_0._dialogues[var_34_7]
			local var_34_9 = var_34_8.category
			local var_34_10 = var_0_4[var_34_9]
			local var_34_11 = var_34_10.playable_during_category

			fassert(var_34_10, "No category setting for category %q used in dialogue %q", var_34_9, var_34_7)

			local var_34_12 = Managers.player
			local var_34_13 = var_34_12:owner(var_34_5)
			local var_34_14 = Managers.state.side
			local var_34_15 = arg_34_0._playing_dialogues
			local var_34_16 = true
			local var_34_17 = FrameTable.alloc_table()

			for iter_34_1, iter_34_2 in pairs(var_34_15) do
				local var_34_18 = iter_34_2.mutually_exclusive
				local var_34_19 = iter_34_2.interrupted_by
				local var_34_20 = iter_34_1.only_allies and not var_34_14:is_ally(var_34_5, iter_34_1.currently_playing_unit)
				local var_34_21 = iter_34_1.only_local and (not var_34_13 or var_34_13 ~= var_34_12:owner(iter_34_1.currently_playing_unit))

				if var_34_20 or var_34_21 then
					-- block empty
				elseif var_34_18 and var_34_9 == iter_34_1.category then
					var_34_16 = false

					break
				elseif var_34_19[var_34_9] then
					var_34_17[iter_34_1] = true
				elseif iter_34_1.currently_playing_unit == var_34_5 then
					var_34_16 = false

					break
				elseif var_34_11[iter_34_1.category] then
					-- block empty
				else
					var_34_16 = false

					break
				end
			end

			if var_34_8.currently_playing_id then
				var_34_16 = false
			end

			if var_34_16 then
				var_34_6.used_query = var_34_4

				local var_34_22 = Managers.state.network

				for iter_34_3, iter_34_4 in pairs(var_34_17) do
					var_34_15[iter_34_3] = nil
					var_34_17[iter_34_3] = nil

					local var_34_23 = iter_34_3.currently_playing_unit
					local var_34_24, var_34_25 = var_34_22:game_object_or_level_id(var_34_23)

					arg_34_0:rpc_interrupt_dialogue_event(0, var_34_24, var_34_25)
					var_34_22.network_transmit:send_rpc_clients("rpc_interrupt_dialogue_event", var_34_24, var_34_25)
				end

				local var_34_26, var_34_27 = var_34_22:game_object_or_level_id(var_34_5)
				local var_34_28 = FrameTable.alloc_table()

				var_34_28.query_context = var_34_4.query_context
				var_34_28.global_context = arg_34_0._global_context

				local var_34_29 = arg_34_0._tagquery_database:get_object_context(var_34_5) or var_0_11

				var_34_28.user_context = var_34_29.user_context or var_0_11
				var_34_28.user_memory = var_34_29.user_memory or var_0_11
				var_34_28.faction_memory = var_34_29.faction_memory or var_0_11

				local var_34_30 = var_0_0.get_filtered_dialogue_event_index(var_34_8, var_34_28, var_0_2)
				local var_34_31 = var_34_8.additional_trigger or var_34_8.additional_trigger_heard

				if var_34_31 then
					local var_34_32 = FrameTable.alloc_table()
					local var_34_33 = var_34_5
					local var_34_34 = "UNKNOWN"
					local var_34_35 = Unit.get_data(var_34_33, "breed")

					if var_34_35 and not var_34_35.is_player then
						var_34_34 = var_34_35.name
					elseif var_34_33 and arg_34_0._unit_extension_data[var_34_33] then
						var_34_34 = arg_34_0._unit_extension_data[var_34_33].context.player_profile
					end

					var_34_32.dialogue_name_nopre = string.sub(var_34_7, 5)
					var_34_32.dialogue_name = var_34_7
					var_34_32.speaker = var_34_33
					var_34_32.speaker_name = var_34_34
					var_34_32.sound_event = var_34_6.last_query_sound_event

					if not var_34_8.additional_trigger_heard then
						var_34_32.distance = 1

						for iter_34_5, iter_34_6 in pairs(arg_34_0._unit_extension_data) do
							iter_34_6.input:trigger_dialogue_event(var_34_31, var_34_32)
						end
					else
						local var_34_36 = POSITION_LOOKUP[var_34_33] or Unit.local_position(var_34_33, 0)
						local var_34_37 = DialogueSettings.default_hear_distance

						for iter_34_7, iter_34_8 in pairs(arg_34_0._unit_extension_data) do
							local var_34_38 = POSITION_LOOKUP[iter_34_7] or Unit.local_position(iter_34_7, 0)
							local var_34_39 = Vector3.distance(var_34_36, var_34_38)

							if var_34_39 <= var_34_37 then
								var_34_32.distance = var_34_39

								iter_34_8.input:trigger_dialogue_event(var_34_31, var_34_32)

								var_34_32 = table.shallow_copy(var_34_32, false, FrameTable.alloc_table())
							end
						end
					end
				end

				local var_34_40 = var_0_0.get_sound_event_duration(var_34_8, var_34_30)
				local var_34_41 = var_34_4.query_context

				if var_34_41.identifier and var_34_41.identifier ~= "" then
					arg_34_0._dialogue_state_handler:add_playing_dialogue(var_34_41.identifier, var_34_8.sound_events[var_34_30], arg_34_2, var_34_40)
				end

				local var_34_42 = NetworkLookup.dialogues[var_34_7]

				if var_34_8.only_local then
					local var_34_43 = Managers.player:owner(var_34_5)
					local var_34_44 = var_34_43 and not var_34_43.bot_player and var_34_43:network_id()

					if var_34_44 then
						arg_34_0:rpc_play_dialogue_event(0, var_34_26, var_34_27, var_34_42, var_34_30)

						if var_34_44 ~= Network.peer_id() then
							var_34_22.network_transmit:send_rpc("rpc_play_dialogue_event", var_34_44, var_34_26, var_34_27, var_34_42, var_34_30)
						end
					end
				elseif var_34_8.only_allies then
					local var_34_45 = Managers.state.side.side_by_unit[var_34_5]

					if var_34_45 then
						local var_34_46 = true
						local var_34_47 = false

						arg_34_0:rpc_play_dialogue_event(0, var_34_26, var_34_27, var_34_42, var_34_30)
						var_34_22.network_transmit:send_rpc_side_clients("rpc_play_dialogue_event", var_34_45, var_34_46, var_34_47, var_34_26, var_34_27, var_34_42, var_34_30)
					end
				else
					arg_34_0:rpc_play_dialogue_event(0, var_34_26, var_34_27, var_34_42, var_34_30)
					var_34_22.network_transmit:send_rpc_clients("rpc_play_dialogue_event", var_34_26, var_34_27, var_34_42, var_34_30)
				end
			end
		end

		if arg_34_0._use_story_lines then
			arg_34_0:_update_story_lines(arg_34_2)
		end

		arg_34_0:_update_player_jumping(arg_34_2)
	end

	arg_34_0:_update_mission_giver_events(var_34_0)
	arg_34_0:_update_new_events(arg_34_2)
end

function DialogueSystem.post_update(arg_35_0, arg_35_1, arg_35_2)
	arg_35_0._function_command_queue:run_commands()
end

function DialogueSystem._update_incapacitation(arg_36_0, arg_36_1)
	for iter_36_0, iter_36_1 in pairs(arg_36_0._unit_extension_data) do
		local var_36_0 = iter_36_1.status_extension

		if var_36_0 then
			local var_36_1 = var_36_0:is_disabled()

			if not iter_36_1.is_incapacitated and var_36_1 then
				iter_36_1.incapacitate_time = arg_36_1
			end

			iter_36_1.is_incapacitated = var_36_1
		end
	end
end

local var_0_12 = {}

function DialogueSystem._update_new_events(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0._unit_extension_data
	local var_37_1 = arg_37_0._tagquery_database
	local var_37_2 = Unit.alive
	local var_37_3 = arg_37_0._input_event_queue
	local var_37_4 = arg_37_0._input_event_queue_n

	for iter_37_0 = 1, var_37_4, 4 do
		repeat
			local var_37_5 = var_37_3[iter_37_0]

			if not var_37_2(var_37_5) then
				break
			end

			local var_37_6 = var_37_3[iter_37_0 + 2]
			local var_37_7

			if arg_37_0._dialogues[var_37_6.dialogue_name] then
				var_37_7 = arg_37_0._dialogues[var_37_6.dialogue_name].category
			end

			local var_37_8 = var_37_0[var_37_5]

			if not var_37_8 or var_37_8.is_incapacitated and arg_37_1 > var_37_8.incapacitate_time + 0.1 and var_37_7 ~= "knocked_down_override" and var_37_6.is_ping ~= true then
				break
			end

			local var_37_9 = var_0_12

			table.clear(var_37_9)

			local var_37_10 = var_37_3[iter_37_0 + 1]
			local var_37_11 = var_37_3[iter_37_0 + 3]
			local var_37_12 = var_37_1:create_query()
			local var_37_13 = 0

			for iter_37_1, iter_37_2 in pairs(var_37_6) do
				var_37_9[var_37_13 + 1] = iter_37_1
				var_37_9[var_37_13 + 2] = iter_37_2
				var_37_13 = var_37_13 + 2
			end

			local var_37_14 = Unit.get_data(var_37_5, "breed")
			local var_37_15

			if var_37_14 and not var_37_14.is_player then
				var_37_15 = var_37_14.dialogue_source_name or var_37_14.name
			else
				var_37_15 = arg_37_0._unit_extension_data[var_37_5].context.player_profile
			end

			var_37_12:add("concept", var_37_10, "source", var_37_5, "source_name", var_37_15, "identifier", var_37_11, unpack(var_37_9))
			var_37_12:finalize()

			var_37_3[iter_37_0] = nil
			var_37_3[iter_37_0 + 1] = nil
			var_37_3[iter_37_0 + 2] = nil
		until true
	end

	arg_37_0._input_event_queue_n = 0
end

function DialogueSystem.hot_join_sync(arg_38_0, arg_38_1)
	if arg_38_0._global_context.current_wind then
		local var_38_0 = arg_38_0._global_context.current_wind
		local var_38_1 = NetworkLookup.weave_winds[var_38_0]

		Managers.state.network.network_transmit:send_rpc("rpc_update_current_wind", arg_38_1, var_38_1)
	end
end

function DialogueSystem.has_local_player_moved_from_start_position(arg_39_0)
	if var_0_6 then
		return false
	end

	local var_39_0 = Managers.state.entity:system("round_started_system")

	return var_39_0:round_has_started() or var_39_0:player_has_moved()
end

function DialogueSystem.player_shield_check(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = 0

	if Unit.alive(arg_40_1) and Managers.player:owner(arg_40_1) ~= nil then
		local var_40_1 = ScriptUnit.extension(arg_40_1, "inventory_system")
		local var_40_2

		if arg_40_2 then
			var_40_2 = var_40_1:get_slot_data(arg_40_2)
		else
			local var_40_3 = var_40_1:get_wielded_slot_name()

			var_40_2 = var_40_1:get_slot_data(var_40_3)
		end

		if var_40_2 then
			local var_40_4 = var_40_2.item_data
			local var_40_5 = var_40_4 and var_40_4.item_type

			if var_40_5 and string.find(var_40_5, "shield") then
				var_40_0 = 1
			end
		end
	end

	return var_40_0
end

function DialogueSystem.trigger_general_unit_event(arg_41_0, arg_41_1, arg_41_2)
	Managers.state.entity:system("audio_system"):_play_event(arg_41_2, arg_41_1, 0)

	local var_41_0 = NetworkLookup.sound_events[arg_41_2]
	local var_41_1 = Managers.state.network
	local var_41_2, var_41_3 = var_41_1:game_object_or_level_id(arg_41_1)

	var_41_1.network_transmit:send_rpc_clients("rpc_server_audio_unit_event", var_41_0, var_41_2, var_41_3, 0)
end

function DialogueSystem.trigger_targeted_by_ratling(arg_42_0, arg_42_1)
	local var_42_0 = Managers.player:unit_owner(arg_42_1)

	if arg_42_1 and var_42_0 ~= nil then
		ScriptUnit.extension_input(arg_42_1, "dialogue_system"):trigger_dialogue_event("ratling_target")
	end
end

function DialogueSystem.trigger_attack(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	local var_43_0 = Managers.player:unit_owner(arg_43_2)

	if ALIVE[arg_43_2] and var_43_0 and ALIVE[arg_43_3] then
		local var_43_1 = arg_43_0._unit_extension_data[arg_43_3]
		local var_43_2
		local var_43_3

		if not DEDICATED_SERVER then
			var_43_2, var_43_3 = WwiseUtils.make_unit_auto_source(arg_43_1.world, arg_43_3, var_43_1.voice_node)

			var_0_7(var_43_3, var_43_2, var_43_1)
		end

		if not var_43_0.bot_player then
			local var_43_4 = arg_43_1.breed
			local var_43_5 = Managers.state.network
			local var_43_6

			if arg_43_4 then
				var_43_6 = var_43_4.backstab_player_sound_event
			elseif arg_43_5 and var_43_4.attack_player_sound_event_long then
				var_43_6 = var_43_4.attack_player_sound_event_long
			else
				var_43_6 = var_43_4.attack_player_sound_event
			end

			local var_43_7 = NetworkLookup.sound_events[var_43_6]
			local var_43_8 = Managers.player:owner(arg_43_2)
			local var_43_9 = NetworkUnit.game_object_id(arg_43_3)
			local var_43_10

			if arg_43_5 and var_43_4.attack_general_sound_event_long then
				var_43_10 = var_43_4.attack_general_sound_event_long
			else
				var_43_10 = var_43_4.attack_general_sound_event
			end

			if var_43_6 then
				if var_43_8.local_player then
					WwiseWorld.trigger_event(var_43_3, var_43_6, var_43_2)
				else
					local var_43_11 = PEER_ID_TO_CHANNEL[var_43_0.peer_id]

					RPC.rpc_server_audio_unit_event(var_43_11, var_43_7, var_43_9, false, 0)
				end
			end

			local var_43_12 = NetworkLookup.sound_events[var_43_10]

			var_43_5.network_transmit:send_rpc_all_except("rpc_server_audio_unit_dialogue_event", var_43_0.peer_id, var_43_12, var_43_9, 0)
		end
	end
end

function DialogueSystem.trigger_backstab(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = Managers.player:unit_owner(arg_44_1)

	if ALIVE[arg_44_1] and var_44_0 and ALIVE[arg_44_2] and not var_44_0.bot_player then
		local var_44_1 = arg_44_0._unit_extension_data[arg_44_2]
		local var_44_2
		local var_44_3

		if not DEDICATED_SERVER then
			var_44_2, var_44_3 = WwiseUtils.make_unit_auto_source(arg_44_3.world, arg_44_2, var_44_1.voice_node)

			var_0_7(var_44_3, var_44_2, var_44_1)
		end

		local var_44_4 = arg_44_3.breed.backstab_player_sound_event
		local var_44_5 = Managers.player:owner(arg_44_1)
		local var_44_6 = NetworkUnit.game_object_id(arg_44_2)

		if var_44_4 then
			if var_44_5.local_player then
				WwiseWorld.trigger_event(var_44_3, var_44_4, var_44_2)
			else
				local var_44_7 = NetworkLookup.sound_events[var_44_4]
				local var_44_8 = PEER_ID_TO_CHANNEL[var_44_0.peer_id]

				RPC.rpc_server_audio_unit_event(var_44_8, var_44_7, var_44_6, false, 0)
			end
		end
	end
end

function DialogueSystem.trigger_flanking(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = Managers.player:unit_owner(arg_45_1)

	if ALIVE[arg_45_1] and var_45_0 and ALIVE[arg_45_2] then
		local var_45_1 = ScriptUnit.extension(arg_45_2, "ai_system"):breed()

		if var_45_1.flanking_sound_event then
			local var_45_2 = var_45_1.flanking_sound_event
			local var_45_3 = NetworkUnit.game_object_id(arg_45_2)

			if Managers.player:local_player().player_unit == arg_45_1 then
				WwiseUtils.trigger_unit_event(arg_45_0.world, var_45_2, arg_45_2, 0)
			else
				local var_45_4 = NetworkLookup.sound_events[var_45_2]
				local var_45_5 = PEER_ID_TO_CHANNEL[var_45_0.peer_id]

				RPC.rpc_server_audio_unit_event(var_45_5, var_45_4, var_45_3, false, 0)
			end
		end
	end
end

function DialogueSystem.trigger_backstab_hit(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = Managers.player:unit_owner(arg_46_1)
	local var_46_1 = Managers.state.network:game()

	if ALIVE[arg_46_1] and var_46_0 and ALIVE[arg_46_2] and var_46_1 and not var_46_0.bot_player then
		local var_46_2 = Vector3.normalize(POSITION_LOOKUP[arg_46_2] - POSITION_LOOKUP[arg_46_1])
		local var_46_3 = Managers.state.network.unit_storage:go_id(arg_46_1)
		local var_46_4 = GameSession.game_object_field(var_46_1, var_46_3, "aim_direction")
		local var_46_5 = Quaternion.forward(Quaternion.look(var_46_4))

		if Vector3.dot(var_46_2, var_46_5) < 0.4 then
			local var_46_6 = "Play_hud_enemy_attack_back_hit"
			local var_46_7 = Managers.player:owner(arg_46_1)

			if var_46_7.local_player then
				ScriptUnit.extension(arg_46_1, "first_person_system"):play_hud_sound_event(var_46_6, nil, false)
			else
				local var_46_8 = NetworkUnit.game_object_id(arg_46_1)
				local var_46_9 = NetworkLookup.sound_events[var_46_6]
				local var_46_10 = PEER_ID_TO_CHANNEL[var_46_7.peer_id]

				RPC.rpc_play_first_person_sound(var_46_10, var_46_8, var_46_9, POSITION_LOOKUP[arg_46_1])
			end
		end
	end
end

function DialogueSystem.get_random_player(arg_47_0)
	return PlayerUtils.get_random_alive_hero()
end

function DialogueSystem._update_story_lines(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_0._next_story_line_update_t

	if not arg_48_0:_is_story_trigger_frozen() and var_48_0 < arg_48_1 then
		arg_48_0._next_story_line_update_t = arg_48_1 + DialogueSettings.story_tick_time

		local var_48_1 = arg_48_0:get_random_player()

		if var_48_1 ~= nil then
			ScriptUnit.extension_input(var_48_1, "dialogue_system"):trigger_dialogue_event("story_trigger")
		end
	end
end

function DialogueSystem.freeze_story_trigger(arg_49_0)
	arg_49_0._story_trigger_freezes = arg_49_0._story_trigger_freezes + 1
end

function DialogueSystem.unfreeze_story_trigger(arg_50_0)
	arg_50_0._story_trigger_freezes = math.max(0, arg_50_0._story_trigger_freezes - 1)
end

function DialogueSystem._is_story_trigger_frozen(arg_51_0)
	return arg_51_0._story_trigger_freezes and arg_51_0._story_trigger_freezes > 0
end

local var_0_13 = {}
local var_0_14
local var_0_15 = 0
local var_0_16 = 5

function DialogueSystem.trigger_cutscene_subtitles(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	var_0_5 = false
	var_0_14 = arg_52_2
	var_0_16 = arg_52_3

	for iter_52_0, iter_52_1 in pairs(SpecialSubtitleEvents[arg_52_1]) do
		var_0_13[iter_52_0] = iter_52_1 + Managers.time:time("game")
	end
end

function DialogueSystem._update_cutscene_subtitles(arg_53_0, arg_53_1)
	local var_53_0 = Managers.state.entity:system("hud_system")

	for iter_53_0, iter_53_1 in pairs(var_0_13) do
		if iter_53_1 < arg_53_1 then
			var_53_0:add_subtitle(var_0_14, iter_53_0)

			var_0_13[iter_53_0] = nil
		end

		var_0_15 = arg_53_1 + var_0_16
	end

	if arg_53_1 > var_0_15 and var_0_14 ~= nil then
		var_53_0:remove_subtitle(var_0_14)

		var_0_5 = true
	end
end

function DialogueSystem.trigger_sound_event_with_subtitles(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
	if DEDICATED_SERVER then
		return
	end

	arg_54_0._flow_calls_implementation:trigger_sound_event_with_subtitles(arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
end

function DialogueSystem._update_sound_event_subtitles(arg_55_0)
	if DEDICATED_SERVER then
		return
	end

	arg_55_0._flow_calls_implementation:update_sound_event_subtitles()
end

function DialogueSystem.disable(arg_56_0)
	var_0_5 = false
end

function DialogueSystem.enable(arg_57_0)
	var_0_5 = true
end

function DialogueSystem.tagquery_loader(arg_58_0)
	return arg_58_0._tagquery_loader
end

function DialogueSystem.tagquery_database(arg_59_0)
	return arg_59_0._tagquery_database
end

function DialogueSystem.reset_memory_time(arg_60_0, arg_60_1, arg_60_2, arg_60_3)
	local var_60_0 = var_0_10 - 2000
	local var_60_1 = arg_60_0._unit_extension_data[arg_60_3]

	if var_60_1 then
		var_60_1[arg_60_1][arg_60_2] = var_60_0
	end

	if arg_60_2 == "time_since_conversation" then
		arg_60_0._next_story_line_update_t = 0
	end
end

function DialogueSystem.trigger_story_dialogue(arg_61_0, arg_61_1)
	if Unit.alive(arg_61_1) and not arg_61_0:_is_story_trigger_frozen() then
		local var_61_0 = ScriptUnit.extension_input(arg_61_1, "dialogue_system")
		local var_61_1 = FrameTable.alloc_table()

		var_61_1.is_forced = true

		var_61_0:trigger_dialogue_event("story_trigger", var_61_1)
	end
end

local var_0_17 = 0
local var_0_18 = 0

function DialogueSystem._update_player_jumping(arg_62_0, arg_62_1)
	if DEDICATED_SERVER then
		return
	end

	local var_62_0 = Managers.input.input_services.Player
	local var_62_1 = Managers.player:local_player().player_unit

	if Unit.alive(var_62_1) then
		local var_62_2 = ScriptUnit.extension(var_62_1, "locomotion_system")

		if (var_62_0:get("jump") or var_62_0:get("jump_only")) and var_62_2:jump_allowed() then
			var_0_17 = var_0_17 + 1

			if var_0_17 == 1 then
				var_0_18 = arg_62_1
			end
		end

		if arg_62_1 > var_0_18 + DialogueSettings.bunny_jumping.tick_time then
			var_0_18 = arg_62_1

			if var_0_17 > DialogueSettings.bunny_jumping.jump_threshold then
				SurroundingAwareSystem.add_event(var_62_1, "bunny_trigger", DialogueSettings.friends_close_distance)
			end

			var_0_17 = 0
		end
	end
end

function DialogueSystem.queue_mission_giver_event(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	arg_63_0._mission_giver_events[#arg_63_0._mission_giver_events + 1] = {
		delay = DialogueSettings.mission_giver_events_delay,
		event_name = arg_63_1,
		event_data = arg_63_2,
		side_name = arg_63_3
	}
end

function DialogueSystem.trigger_mission_giver_event(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	local var_64_0 = Managers.state.entity:system("surrounding_aware_system"):get_global_observers()
	local var_64_1 = Managers.state.side:get_side_from_name(arg_64_3)
	local var_64_2 = var_64_1 and var_64_1.side_id

	for iter_64_0, iter_64_1 in pairs(var_64_0) do
		if not var_64_2 or var_64_2 == iter_64_1.side_id then
			ScriptUnit.extension_input(iter_64_0, "dialogue_system"):trigger_networked_dialogue_event(arg_64_1, arg_64_2)
		end
	end
end

function DialogueSystem._update_mission_giver_events(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_0._mission_giver_events
	local var_65_1 = #var_65_0
	local var_65_2 = 1

	while var_65_2 <= var_65_1 do
		local var_65_3 = var_65_0[var_65_2]

		var_65_3.delay = var_65_3.delay - arg_65_1

		if var_65_3.delay < 0 then
			arg_65_0:trigger_mission_giver_event(var_65_3.event_name, var_65_3.event_data, var_65_3.side_name)
			table.swap_delete(var_65_0, var_65_2)

			var_65_1 = var_65_1 - 1
		else
			var_65_2 = var_65_2 + 1
		end
	end
end

function DialogueSystem.rpc_trigger_dialogue_event(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6)
	local var_66_0 = Managers.state.unit_storage:unit(arg_66_2)

	if not var_66_0 then
		return
	end

	if FROZEN[var_66_0] then
		return
	end

	local var_66_1

	if not table.is_empty(arg_66_4) then
		local var_66_2 = #arg_66_4

		for iter_66_0 = 1, var_66_2 do
			local var_66_3 = arg_66_4[iter_66_0]

			if arg_66_5[iter_66_0] then
				arg_66_4[iter_66_0] = var_66_3 - 1
			else
				arg_66_4[iter_66_0] = NetworkLookup.dialogue_event_data_names[var_66_3]
			end
		end

		var_66_1 = FrameTable.alloc_table()

		table.array_to_table(arg_66_4, var_66_2, var_66_1)
	end

	local var_66_4 = NetworkLookup.dialogue_events[arg_66_3]
	local var_66_5 = arg_66_0._input_event_queue
	local var_66_6 = arg_66_0._input_event_queue_n

	var_66_5[var_66_6 + 1] = var_66_0
	var_66_5[var_66_6 + 2] = var_66_4
	var_66_5[var_66_6 + 3] = var_66_1 or var_0_9
	var_66_5[var_66_6 + 4] = arg_66_6 or ""
	arg_66_0._input_event_queue_n = var_66_6 + 4
end

function DialogueSystem.rpc_play_marker_event(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	local var_67_0 = Managers.state.network:game_object_or_level_unit(arg_67_2, false)

	if not var_67_0 then
		return
	end

	if FROZEN[var_67_0] then
		return
	end

	if arg_67_0._playing_units[var_67_0] then
		Application.error("[DialogueSystem] Marker couldn't play since %q was already talking", var_67_0)
	end

	local var_67_1 = NetworkLookup.markers[arg_67_3]
	local var_67_2 = arg_67_0._unit_extension_data[var_67_0]
	local var_67_3, var_67_4 = WwiseUtils.make_unit_auto_source(arg_67_0.world, var_67_2.play_unit, var_67_2.voice_node)

	var_0_7(var_67_4, var_67_3, var_67_2)

	local var_67_5, var_67_6 = arg_67_0:_check_play_debug_sound(var_67_1, var_67_2.currently_playing_dialogue and var_67_2.currently_playing_dialogue.currently_playing_subtitle or "")

	if not var_67_5 then
		WwiseWorld.trigger_event(var_67_4, var_67_1, var_67_3)
	end
end

function DialogueSystem._check_play_debug_sound(arg_68_0, arg_68_1, arg_68_2)
	return
end

function DialogueSystem.is_unit_playing_dialogue(arg_69_0, arg_69_1)
	return arg_69_0._playing_units[arg_69_1]
end

function DialogueSystem.rpc_play_dialogue_event(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5)
	local var_70_0 = Managers.state.network:game_object_or_level_unit(arg_70_2, arg_70_3)

	if not var_70_0 then
		return
	end

	if FROZEN[var_70_0] then
		return
	end

	local var_70_1 = NetworkLookup.dialogues[arg_70_4]
	local var_70_2 = arg_70_0._dialogues[var_70_1]

	if not var_70_2 then
		Crashify.print_exception("DialogueSystem", "Mismatch in loaded dialogue packages. Received rpc to play dialogue '%s'", var_70_1)

		return
	end

	local var_70_3 = table.shallow_copy(var_70_2)
	local var_70_4 = arg_70_0._unit_extension_data[var_70_0]
	local var_70_5, var_70_6, var_70_7, var_70_8 = var_0_0.get_dialogue_event(var_70_3, arg_70_5)
	local var_70_9
	local var_70_10 = var_70_4.context.player_career
	local var_70_11 = CareerSettings[var_70_10]
	local var_70_12 = var_70_11 and var_70_11.unique_subtitles

	if var_70_12 then
		local var_70_13 = var_70_12[1]
		local var_70_14 = var_70_12[2]

		var_70_9 = string.insert(var_70_6, var_70_13, var_70_14)
	end

	if var_70_9 and Managers.localizer:exists(var_70_9) then
		var_70_3.currently_playing_subtitle = var_70_9
	else
		var_70_3.currently_playing_subtitle = var_70_6 or ""
	end

	local var_70_15 = Managers.player:local_player()
	local var_70_16 = true
	local var_70_17 = Managers.state.side
	local var_70_18 = var_70_17.side_by_unit[var_70_0]

	if var_70_18 then
		local var_70_19 = Managers.party:get_party_from_unique_id(var_70_15 and var_70_15:unique_id())
		local var_70_20 = var_70_17.side_by_party[var_70_19]

		var_70_16 = var_70_17:is_ally_by_side(var_70_18, var_70_20)
	end

	if var_70_3.intended_player_profile ~= nil and var_70_3.intended_player_profile ~= var_0_8() or var_70_3.only_allies and not var_70_16 or var_70_3.only_local and (not var_70_15 or var_70_15 ~= Managers.player:owner(var_70_0)) then
		var_70_3.currently_playing_subtitle = ""
	else
		if Managers.player:owner(var_70_0) and not var_70_16 then
			var_70_3.currently_playing_subtitle = ""
		end

		if not DEDICATED_SERVER then
			local var_70_21, var_70_22 = WwiseUtils.make_unit_auto_source(arg_70_0.world, var_70_4.play_unit, var_70_4.voice_node)

			var_0_7(var_70_22, var_70_21, var_70_4)

			local var_70_23, var_70_24 = arg_70_0:_check_play_debug_sound(var_70_5, var_70_6)

			if not var_70_23 then
				Managers.state.vce:interrupt_vce(var_70_0)

				local var_70_25

				var_70_3.currently_playing_id, var_70_25 = WwiseWorld.trigger_event(var_70_22, var_70_5, var_70_21)
			end
		end
	end

	var_70_3.currently_playing_unit = var_70_0

	local var_70_26
	local var_70_27 = Unit.get_data(var_70_0, "breed")

	if var_70_27 and not var_70_27.is_player then
		var_70_26 = var_70_27.name
	else
		var_70_26 = var_70_4.context.player_profile
	end

	var_70_4.last_query_sound_event = var_70_5
	var_70_3.speaker_name = var_70_26
	var_70_3.dialogue_timer = var_0_0.get_sound_event_duration(var_70_3, arg_70_5)
	var_70_4.currently_playing_dialogue = var_70_3
	arg_70_0._playing_units[var_70_0] = var_70_4

	local var_70_28 = var_70_3.category
	local var_70_29 = var_0_4[var_70_28]

	arg_70_0._playing_dialogues[var_70_3] = var_70_29

	local var_70_30 = arg_70_0._function_command_queue

	if Managers.player:owner(var_70_0) ~= nil or Unit.has_data(var_70_0, "dialogue_face_anim") then
		var_70_30:queue_function_command(Unit.animation_event, var_70_0, var_70_7)
		var_70_30:queue_function_command(Unit.animation_event, var_70_0, var_70_8)
	end

	if Unit.has_data(var_70_0, "enemy_dialogue_face_anim") and Unit.has_animation_state_machine(var_70_0) then
		Unit.animation_event(var_70_0, "talk_loop")
	end

	if Unit.has_data(var_70_0, "enemy_dialogue_body_anim") and Unit.has_animation_state_machine(var_70_0) then
		Unit.flow_event(var_70_0, "action_talk_body")
	end

	if var_70_10 and arg_70_0._is_server then
		Managers.telemetry_events:vo_event_played(var_70_28, var_70_1, var_70_5, var_70_10)
	end
end

function DialogueSystem.rpc_interrupt_dialogue_event(arg_71_0, arg_71_1, arg_71_2, arg_71_3)
	local var_71_0 = Managers.state.network:game_object_or_level_unit(arg_71_2, arg_71_3)

	if not var_71_0 then
		return
	end

	if arg_71_0._frozen_unit_extension_data[var_71_0] then
		return
	end

	local var_71_1 = arg_71_0._unit_extension_data[var_71_0]
	local var_71_2 = var_71_1.currently_playing_dialogue

	if var_71_2 then
		if not DEDICATED_SERVER then
			local var_71_3 = arg_71_0.wwise_world

			if WwiseWorld.is_playing(var_71_3, var_71_2.currently_playing_id) then
				WwiseWorld.stop_event(var_71_3, var_71_2.currently_playing_id)
			end
		end

		var_71_2.currently_playing_id = nil
		var_71_2.dialogue_timer = nil
		var_71_1.currently_playing_dialogue = nil
		arg_71_0._playing_dialogues[var_71_2] = nil
		arg_71_0._playing_units[var_71_0] = nil

		if Managers.player:owner(var_71_0) ~= nil or Unit.has_data(var_71_0, "dialogue_face_anim") then
			Unit.animation_event(var_71_0, "face_neutral")
			Unit.animation_event(var_71_0, "dialogue_end")
		elseif Unit.has_data(var_71_0, "enemy_dialogue_face_anim") and Unit.has_animation_state_machine(var_71_0) then
			Unit.animation_event(var_71_0, "talk_end")
		end

		if Unit.has_data(var_71_0, "enemy_dialogue_body_anim") and Unit.has_animation_state_machine(var_71_0) then
			Unit.animation_event(var_71_0, "talk_body_end")
		end
	end
end

function DialogueSystem.rpc_update_current_wind(arg_72_0, arg_72_1, arg_72_2)
	local var_72_0 = NetworkLookup.weave_winds[arg_72_2]

	arg_72_0._global_context.current_wind = var_72_0
end
