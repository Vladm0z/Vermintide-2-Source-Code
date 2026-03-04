-- chunkname: @scripts/utils/debug_screen_config.lua

require("scripts/utils/debug_hero_templates")

local function var_0_0()
	local var_1_0 = Managers.backend

	var_1_0:get_interface("statistics"):save()
	var_1_0:commit(true)
end

local function var_0_1(arg_2_0, arg_2_1)
	local var_2_0 = Managers.backend._backend_mirror
	local var_2_1 = {
		FunctionName = "devGrantItems",
		FunctionParameter = {
			items = arg_2_0
		}
	}

	local function var_2_2(arg_3_0)
		local var_3_0 = arg_3_0.FunctionResult.items
		local var_3_1 = Managers.backend:get_interface("items")

		for iter_3_0 = 1, #var_3_0 do
			if arg_2_1 and iter_3_0 == #var_3_0 then
				arg_2_1 = nil
			end

			local var_3_2 = var_3_0[iter_3_0]

			var_2_0:add_item(var_3_2.ItemInstanceId, var_3_2, arg_2_1)
		end

		local var_3_3 = arg_3_0.FunctionResult.chest_inventory

		if var_3_3 then
			var_2_0:set_read_only_data("chest_inventory", var_3_3, true)
		end
	end

	var_2_0:request_queue():enqueue(var_2_1, var_2_2, false)
end

local var_0_2 = {
	{
		description = "* Open and close menu using right and left keyboard arrows (no gamepad support yet).\n\t\t* Use the same keys to 'open' a category.\n\t\t* Use CTRL+up/down/left/right for quick-travel and quick-change.\n\t\t* Press \"F\" to add something as a favorite. Press \"F\" on a favorite to remove it.\n\t\t* Press a key on your numpad on a category to assign that key as a hotkey to flip through the options.",
		bitmap = "hud_debug_screen_logo",
		setting_name = "Debug menu instructions (press right arrow key to open)",
		category = "Allround useful stuff!",
		bitmap_size = 128
	},
	{
		description = "Takes you straight to the menu. Great to combine with auto_host_level.",
		is_boolean = true,
		setting_name = "skip_splash",
		category = "Allround useful stuff!"
	},
	{
		description = "Skips trailer. Always.",
		is_boolean = true,
		setting_name = "skip_intro_trailer",
		category = "Allround useful stuff!"
	},
	{
		description = "Shows which keys can be used for debug stuff.",
		is_boolean = true,
		setting_name = "debug_key_handler_visible",
		category = "Allround useful stuff!"
	},
	{
		description = "Activates Third Person Mode",
		is_boolean = true,
		setting_name = "third_person_mode",
		category = "Allround useful stuff!"
	},
	{
		description = "Caps the maximum frame time to 0.2 seconds. Really useful when you're debugging.",
		is_boolean = true,
		setting_name = "disable_long_timesteps",
		category = "Allround useful stuff!"
	},
	{
		description = "Allows clients to join an ongoing weave game mode",
		is_boolean = true,
		setting_name = "allow_weave_joining",
		category = "Allround useful stuff!"
	},
	{
		description = "Allows items from different mechanisms to show in the inventory",
		is_boolean = true,
		setting_name = "disable_mechanism_item_filter",
		category = "Allround useful stuff!"
	},
	{
		description = "Disables the network hash check when connecting (WARNING: Both clients need to have this enabled)",
		is_boolean = true,
		setting_name = "force_ignore_network_hash",
		category = "Allround useful stuff!"
	},
	{
		description = "Disables the engine revision network hash check when connecting",
		is_boolean = true,
		setting_name = "ignore_engine_revision_in_network_hash",
		category = "Allround useful stuff!"
	},
	{
		description = "Takes you in the game as fast as possible, skipping delays and picking etc",
		is_boolean = true,
		setting_name = "dev_quick_start",
		category = "Allround useful stuff!"
	},
	{
		description = "Displays information about registered puzzles in the world",
		is_boolean = true,
		setting_name = "debug_puzzles",
		category = "Allround useful stuff!"
	},
	{
		setting_name = "teleport player",
		description = "Teleports the player to a portal hub element",
		category = "Allround useful stuff!",
		item_source = {},
		load_items_source_func = function (arg_4_0)
			table.clear(arg_4_0)

			local var_4_0 = ConflictUtils.get_teleporter_portals()

			for iter_4_0, iter_4_1 in pairs(var_4_0) do
				arg_4_0[#arg_4_0 + 1] = iter_4_0
			end

			if Managers.player.is_server then
				local var_4_1 = Managers.state.conflict.level_analysis:get_main_paths()
				local var_4_2 = table.mirror_array(arg_4_0)

				table.sort(arg_4_0, function (arg_5_0, arg_5_1)
					local var_5_0 = var_4_0[arg_5_0][1]:unbox()
					local var_5_1 = var_4_0[arg_5_1][1]:unbox()
					local var_5_2, var_5_3 = MainPathUtils.closest_pos_at_main_path(var_4_1, var_5_0)
					local var_5_4, var_5_5 = MainPathUtils.closest_pos_at_main_path(var_4_1, var_5_1)

					var_5_3 = var_5_3 or math.huge
					var_5_5 = var_5_5 or math.huge

					if var_5_3 ~= var_5_5 then
						return var_5_3 < var_5_5
					end

					return var_4_2[arg_5_0] < var_4_2[arg_5_1]
				end)
			else
				local var_4_3 = Managers.player:local_player()
				local var_4_4 = var_4_3 and var_4_3.player_unit

				if not ALIVE[var_4_4] then
					return
				end

				local var_4_5 = Managers.state.entity:get_entities("EndZoneExtension")
				local var_4_6 = next(var_4_5)

				if not var_4_6 then
					return
				end

				local var_4_7 = Unit.world_position(var_4_6, 0)
				local var_4_8 = Unit.world_position(var_4_4, 0)
				local var_4_9 = var_4_7 - var_4_8
				local var_4_10 = table.mirror_array(arg_4_0)

				table.sort(arg_4_0, function (arg_6_0, arg_6_1)
					local var_6_0 = var_4_0[arg_6_0][1]:unbox()
					local var_6_1 = var_4_0[arg_6_1][1]:unbox()
					local var_6_2 = var_6_0 - var_4_8
					local var_6_3 = var_6_1 - var_4_8
					local var_6_4 = Vector3.dot(var_6_2, var_4_9)
					local var_6_5 = Vector3.dot(var_6_3, var_4_9)

					if var_6_4 == var_6_5 then
						return var_4_10[arg_6_0] < var_4_10[arg_6_1]
					end

					return var_6_4 < var_6_5
				end)
			end
		end,
		func = function (arg_7_0, arg_7_1)
			local var_7_0 = Managers.player:local_player()

			if var_7_0 then
				local var_7_1 = var_7_0.player_unit

				if Unit.alive(var_7_1) then
					local var_7_2 = ConflictUtils.get_teleporter_portals()

					if table.is_empty(var_7_2) then
						return
					end

					local var_7_3 = arg_7_0[arg_7_1]
					local var_7_4 = var_7_2[var_7_3][1]:unbox()
					local var_7_5 = var_7_2[var_7_3][2]:unbox()
					local var_7_6 = ScriptUnit.extension(var_7_1, "locomotion_system")
					local var_7_7 = Managers.world:world("level_world")

					LevelHelper:flow_event(var_7_7, "teleport_" .. arg_7_0[arg_7_1])
					var_7_6:teleport_to(var_7_4, var_7_5)
				end
			end

			print("TELEPORT")
		end
	},
	{
		setting_name = "teleport player to player",
		description = "Teleports the player to another player.",
		category = "Allround useful stuff!",
		item_source = {},
		load_items_source_func = function (arg_8_0)
			table.clear(arg_8_0)

			local var_8_0 = {}

			arg_8_0.data = var_8_0

			local var_8_1 = Managers.player:players()
			local var_8_2 = Managers.player:local_player()

			for iter_8_0, iter_8_1 in pairs(var_8_1) do
				if iter_8_1 ~= var_8_2 then
					arg_8_0[#arg_8_0 + 1] = iter_8_1:name()
					var_8_0[#var_8_0 + 1] = iter_8_1
				end
			end
		end,
		func = function (arg_9_0, arg_9_1)
			local var_9_0 = Managers.player:local_player()
			local var_9_1 = arg_9_0.data

			if var_9_0 then
				local var_9_2 = var_9_0.player_unit

				if not Unit.alive(var_9_2) then
					return
				end

				if table.is_empty(var_9_1) then
					return
				end

				local var_9_3 = var_9_1[arg_9_1].player_unit

				if not Unit.alive(var_9_3) then
					return
				end

				local var_9_4 = ScriptUnit.extension(var_9_2, "locomotion_system")
				local var_9_5 = ScriptUnit.extension(var_9_3, "locomotion_system")
				local var_9_6 = Unit.mover(var_9_3)
				local var_9_7 = Mover.position(var_9_6)
				local var_9_8 = var_9_5:current_rotation()

				var_9_4:teleport_to(var_9_7, var_9_8)
			end
		end
	},
	{
		setting_name = "teleport player to player repeatedly",
		description = "Teleports the player to another player every 2 seconds.",
		category = "Allround useful stuff!",
		item_source = {},
		load_items_source_func = function (arg_10_0)
			table.clear(arg_10_0)

			local var_10_0 = {}

			arg_10_0.data = var_10_0

			local var_10_1 = Managers.player:players()
			local var_10_2 = Managers.player:local_player()

			for iter_10_0, iter_10_1 in pairs(var_10_1) do
				if iter_10_1 ~= var_10_2 then
					arg_10_0[#arg_10_0 + 1] = iter_10_1:name()
					var_10_0[#var_10_0 + 1] = iter_10_1
				end
			end

			arg_10_0[#arg_10_0 + 1] = "Turn Off"
			var_10_0[#var_10_0 + 1] = {}
		end,
		func = function (arg_11_0, arg_11_1)
			local var_11_0 = arg_11_0.data

			if table.is_empty(var_11_0) then
				return
			end

			local var_11_1 = "teleport player to player repeatedly"

			if Managers.updator:has(var_11_1) then
				Managers.updator:remove(var_11_1)
			end

			local var_11_2 = 0
			local var_11_3 = var_11_0[arg_11_1].player_unit

			Managers.updator:add(function (arg_12_0)
				var_11_2 = var_11_2 - arg_12_0

				if var_11_2 > 0 then
					return
				end

				var_11_2 = 2

				UPDATE_POSITION_LOOKUP()

				local var_12_0 = Managers.player:local_player()

				if not var_12_0 then
					return
				end

				local var_12_1 = var_12_0.player_unit

				if not Unit.alive(var_12_1) then
					return
				end

				if not Unit.alive(var_11_3) then
					Managers.updator:remove(var_11_1)

					return
				end

				local var_12_2 = ScriptUnit.extension(var_12_1, "locomotion_system")
				local var_12_3 = ScriptUnit.extension(var_11_3, "locomotion_system")
				local var_12_4 = Unit.mover(var_11_3)
				local var_12_5 = Mover.position(var_12_4)
				local var_12_6 = var_12_3:current_rotation()

				var_12_2:teleport_to(var_12_5, var_12_6)
			end, var_11_1)
		end
	},
	{
		description = "Teleports the bots to the local player.",
		category = "Allround useful stuff!",
		setting_name = "teleport bots to local player",
		func = function ()
			local var_13_0 = Managers.player:bots()
			local var_13_1 = Managers.player:local_player()

			if var_13_1 and var_13_1.player_unit then
				local var_13_2 = var_13_1.player_unit
				local var_13_3 = ScriptUnit.extension(var_13_2, "locomotion_system")
				local var_13_4 = Unit.mover(var_13_2)
				local var_13_5 = Mover.position(var_13_4)
				local var_13_6 = var_13_3:current_rotation()

				for iter_13_0, iter_13_1 in pairs(var_13_0) do
					ScriptUnit.extension(iter_13_1.player_unit, "locomotion_system"):teleport_to(var_13_5, var_13_6)
				end
			end
		end
	},
	{
		description = "Will change the network pong timeout from 15 seconds to 10000 seconds.",
		is_boolean = true,
		setting_name = "network_timeout_really_long",
		category = "Allround useful stuff!"
	},
	{
		description = "Disables the auto-start of tutorial if it's not completed.",
		is_boolean = true,
		setting_name = "disable_tutorial_at_start",
		category = "Allround useful stuff!"
	},
	{
		description = "Will disable afk kick",
		is_boolean = true,
		setting_name = "debug_disable_afk_kick",
		category = "Allround useful stuff!"
	},
	{
		description = "Will enable gift popup debug (use F3 to spawn)",
		is_boolean = true,
		setting_name = "debug_gift_popup",
		category = "Allround useful stuff!"
	},
	{
		description = "Do not clear the unseen_rewards field",
		is_boolean = true,
		setting_name = "dont_clear_unseen_rewards",
		category = "Allround useful stuff!"
	},
	{
		description = "Do not show unseen rewards at login",
		is_boolean = true,
		setting_name = "dont_show_unseen_rewards",
		category = "Allround useful stuff!"
	},
	{
		description = "When resetting saves, give all items",
		is_boolean = true,
		setting_name = "give_all_lan_backend_items",
		category = "Allround useful stuff!"
	},
	{
		description = "In the shop, write the master list key on each item icon",
		is_boolean = true,
		setting_name = "show_shop_item_keys",
		category = "Allround useful stuff!"
	},
	{
		description = "hide version info hud",
		is_boolean = true,
		setting_name = "hide_version_info",
		category = "Allround useful stuff!"
	},
	{
		description = "hide fps counter hud",
		is_boolean = true,
		setting_name = "hide_fps",
		category = "Allround useful stuff!"
	},
	{
		description = "Will change all true booleans to false, and if there are no true ones, then all will be set to nil (cleared). Press right arrow to do it!",
		category = "Allround useful stuff!",
		setting_name = "reset_settings",
		func = function ()
			DebugScreen.reset_settings()
		end
	},
	{
		description = "Requires restart. Gives you all items of a certain rarity",
		setting_name = "all_items_of_rarity",
		category = "Allround useful stuff!",
		item_source = {
			common = true,
			plentiful = true,
			rare = true,
			exotic = true
		}
	},
	{
		description = "Disable popup warning when trying to exit the game",
		is_boolean = true,
		setting_name = "disable_exit_popup_warning",
		category = "Allround useful stuff!"
	},
	{
		description = "Sets the fadeout time to zero when exiting the game",
		is_boolean = true,
		setting_name = "zero_exit_time",
		category = "Allround useful stuff!"
	},
	{
		setting_name = "load_level",
		description = "Loads the selected level.",
		category = "Allround useful stuff!",
		item_source = {},
		load_items_source_func = function (arg_15_0)
			table.clear(arg_15_0)
			table.keys(LevelSettings, arg_15_0)

			local var_15_0 = {}

			for iter_15_0 = #arg_15_0, 1, -1 do
				local var_15_1 = arg_15_0[iter_15_0]
				local var_15_2 = LevelSettings[var_15_1].environment_variations

				if var_15_2 then
					for iter_15_1 = #var_15_2, 1, -1 do
						local var_15_3 = var_15_1 .. "_" .. var_15_2[iter_15_1]

						table.insert(arg_15_0, var_15_3)

						arg_15_0[var_15_3] = {
							var_15_1,
							iter_15_1
						}
						var_15_0[var_15_3] = true
					end
				end
			end

			local var_15_4 = table.mirror_array_inplace({
				"inn_level",
				"whitebox"
			})
			local var_15_5 = table.mirror_array_inplace({
				"adventure",
				"versus",
				"deus",
				"weaves"
			})

			table.sort(arg_15_0, function (arg_16_0, arg_16_1)
				if var_15_4[arg_16_0] or var_15_4[arg_16_1] then
					return (var_15_4[arg_16_0] or math.huge) < (var_15_4[arg_16_1] or math.huge)
				end

				if var_15_0[arg_16_0] or var_15_0[arg_16_1] then
					if not var_15_0[arg_16_0] or not var_15_0[arg_16_1] then
						return not var_15_0[arg_16_0]
					else
						return arg_16_0 < arg_16_1
					end
				end

				local var_16_0 = LevelSettings[arg_16_0]
				local var_16_1 = LevelSettings[arg_16_1]

				if var_16_0.mechanism ~= var_16_1.mechanism then
					return (var_15_5[var_16_0.mechanism] or math.huge) < (var_15_5[var_16_1.mechanism] or math.huge)
				end

				local var_16_2 = table.find(GameActsOrder, var_16_0.act) or math.huge
				local var_16_3 = table.find(GameActsOrder, var_16_1.act) or math.huge

				if var_16_2 < var_16_3 then
					return true
				elseif var_16_2 == var_16_3 then
					local var_16_4 = var_16_0.act_presentation_order
					local var_16_5 = var_16_1.act_presentation_order

					if var_16_4 or var_16_5 then
						return (var_16_4 or math.huge) < (var_16_5 or math.huge)
					else
						local var_16_6 = var_16_0.map_settings and var_16_0.map_settings.sorting
						local var_16_7 = var_16_1.map_settings and var_16_1.map_settings.sorting

						if var_16_6 or var_16_7 then
							return (var_16_6 or math.huge) < (var_16_7 or math.huge)
						else
							return arg_16_0 < arg_16_1
						end
					end
				else
					return false
				end
			end)
		end,
		func = function (arg_17_0, arg_17_1)
			local var_17_0 = arg_17_0[arg_17_1]
			local var_17_1 = 0
			local var_17_2 = arg_17_0[var_17_0]

			if var_17_2 then
				var_17_0 = var_17_2[1]
				var_17_1 = var_17_2[2]
			end

			local var_17_3 = LevelSettings[var_17_0]

			if var_17_3.hub_level then
				Managers.mechanism:override_hub_level(var_17_0)
			end

			Debug.load_level(var_17_0, var_17_1, var_17_3.debug_environment_level_flow_event)
		end
	},
	{
		description = "Converts all IRC messages to a random vote",
		is_boolean = true,
		setting_name = "twitch_randomize_votes",
		category = "Twitch"
	},
	{
		description = "Allow multiple votes from the same user",
		is_boolean = true,
		setting_name = "twitch_allow_multiple_votes",
		category = "Twitch"
	},
	{
		description = "Disables the effect of the Twitch vote",
		is_boolean = true,
		setting_name = "twitch_disable_result",
		category = "Twitch"
	},
	{
		description = "Activates twitch game mode and randomized twich votes without connected to stream",
		setting_name = "twitch_debug_voting",
		category = "Twitch",
		is_boolean = true,
		func = function ()
			Managers.twitch:debug_activate_twitch_game_mode()
		end
	},
	{
		description = "Display your current matchmaking settings on the screen for easier testing/debug",
		is_boolean = true,
		setting_name = "debug_weave_matchmaking",
		category = "Weave Matchmaking"
	},
	{
		description = "",
		setting_name = "Default development settings",
		category = "Presets",
		preset = {
			skippable_cutscenes = true,
			disable_long_timesteps = true,
			disable_mechanism_item_filter = false,
			use_lan_backend = true,
			network_timeout_really_long = true,
			skip_splash = true
		}
	},
	{
		description = "",
		setting_name = "Make player imba kthx",
		category = "Presets",
		preset = {
			ledge_hanging_turned_off = true,
			player_mechanics_goodness_debug = true,
			infinite_ammo = true,
			disable_gamemode_end = true,
			disable_fatigue_system = true,
			player_invincible = true,
			use_super_jumps = true
		}
	},
	{
		description = "",
		setting_name = "Disable all specials",
		category = "Presets",
		preset = {
			disable_globadier = true,
			disable_ratling_gunner = true,
			disable_warpfire_thrower = true,
			disable_gutter_runner = true,
			disable_vortex_sorcerer = true,
			disable_pack_master = true,
			disable_plague_sorcerer = true
		}
	},
	{
		description = "",
		setting_name = "Enable all specials",
		category = "Presets",
		preset = {
			disable_globadier = false,
			disable_ratling_gunner = false,
			disable_warpfire_thrower = false,
			disable_gutter_runner = false,
			disable_vortex_sorcerer = false,
			disable_pack_master = false,
			disable_plague_sorcerer = false
		}
	},
	{
		description = "",
		setting_name = "No bots or AI spawn",
		category = "Presets",
		preset = {
			ai_mini_patrol_disabled = true,
			ai_critter_spawning_disabled = true,
			ai_horde_spawning_disabled = true,
			ai_roaming_spawning_disabled = true,
			ai_boss_spawning_disabled = true,
			ai_rush_intervention_disabled = true,
			ai_terror_events_disabled = true,
			ai_bots_disabled = true,
			ai_specials_spawning_disabled = true,
			ai_pacing_disabled = true,
			ai_speed_run_intervention_disabled = true
		}
	},
	{
		description = "",
		setting_name = "Bots or AI can spawn",
		category = "Presets",
		preset = {
			ai_mini_patrol_disabled = false,
			ai_critter_spawning_disabled = false,
			ai_horde_spawning_disabled = false,
			ai_roaming_spawning_disabled = false,
			ai_boss_spawning_disabled = false,
			ai_rush_intervention_disabled = false,
			ai_terror_events_disabled = false,
			ai_bots_disabled = false,
			ai_specials_spawning_disabled = false,
			ai_pacing_disabled = false,
			ai_speed_run_intervention_disabled = false
		}
	},
	{
		description = "",
		setting_name = "Main Path Boss Debug",
		category = "Presets",
		preset = {
			ai_mini_patrol_disabled = true,
			ai_critter_spawning_disabled = true,
			ai_horde_spawning_disabled = true,
			ai_roaming_spawning_disabled = true,
			ai_boss_spawning_disabled = false,
			debug_ai_recycler = true,
			debug_ai_pacing = true,
			ai_terror_events_disabled = true,
			debug_player_intensity = true,
			ai_bots_disabled = true,
			ai_specials_spawning_disabled = true,
			ai_pacing_disabled = false,
			ai_rush_intervention_disabled = true,
			ai_speed_run_intervention_disabled = true
		}
	},
	{
		description = "",
		setting_name = "QA - General stuff",
		category = "Presets",
		preset = {
			debug_player_position = true,
			paste_revision_to_clipboard = true
		}
	},
	{
		description = "",
		setting_name = "QA-Network/join/sync/matchmaking",
		category = "Presets",
		preset = {
			network_log_messages = true,
			network_debug = true,
			debug_interactions = true,
			package_debug = true,
			matchmaking_debug = true,
			network_debug_connections = true
		}
	},
	{
		description = "",
		setting_name = "QA - Player debug",
		category = "Presets",
		preset = {
			debug_interactions = true,
			debug_player_animations = true,
			debug_state_machines = true
		}
	},
	{
		description = "",
		setting_name = "Screenshot mode",
		category = "Presets",
		preset = {
			disable_info_slate_ui = true,
			disable_debug_draw = true,
			disable_tutorial_ui = true,
			bone_lod_disable = true,
			hide_version_info = true,
			hide_fps = true
		}
	},
	{
		description = "",
		setting_name = "Screenshot mode - no hud",
		category = "Presets",
		preset = {
			disable_debug_draw = true,
			disable_info_slate_ui = true,
			disable_loading_icon = true,
			hide_version_info = true,
			disable_ui = true,
			disable_water_mark = true,
			bone_lod_disable = true,
			disable_outlines = true,
			disable_tutorial_ui = true,
			hide_fps = true
		}
	},
	{
		description = "",
		setting_name = "Disable screenshot mode",
		category = "Presets",
		preset = {
			disable_debug_draw = false,
			disable_info_slate_ui = false,
			disable_loading_icon = false,
			hide_version_info = false,
			disable_ui = false,
			disable_water_mark = false,
			bone_lod_disable = false,
			disable_outlines = false,
			disable_tutorial_ui = false,
			hide_fps = false
		}
	},
	{
		description = "ctrl+F to cycle between graphs, ctrl+G to use special function in graph. (respawn level atm)",
		setting_name = "Show Graphs",
		category = "Presets",
		preset = {
			debug_player_intensity = true,
			debug_ai_pacing = true,
			ai_pacing_disabled = false
		}
	},
	{
		description = "This is used to turn off screen effects affecting the main character in case the camera is changed into a 3rd person view.",
		setting_name = "Replay Settings",
		category = "Presets",
		preset = {
			screen_space_player_camera_reactions = false,
			fade_on_camera_ai_collision = false
		}
	},
	{
		description = "This is used to restore settings after working with replays.",
		setting_name = "Non-Replay Settings",
		category = "Presets",
		preset = {
			screen_space_player_camera_reactions = true,
			fade_on_camera_ai_collision = true
		}
	},
	{
		description = "Make the player unkillable.",
		is_boolean = true,
		setting_name = "player_invincible",
		category = "Player mechanics recommended",
		propagate_to_server = true,
		never_save = true
	},
	{
		description = "Make the player unkillable.",
		is_boolean = true,
		setting_name = "player_unkillable",
		category = "Player mechanics recommended"
	},
	{
		description = "Everything dies instantly when it receives damage",
		is_boolean = true,
		setting_name = "insta_death",
		category = "Player mechanics recommended"
	},
	{
		description = "Sets player invisibility for local player.",
		setting_name = "player_invisibility",
		category = "Player mechanics recommended",
		is_boolean = true,
		func = function (arg_19_0, arg_19_1)
			local var_19_0 = arg_19_0[arg_19_1]
			local var_19_1 = Managers.player:local_player()
			local var_19_2 = var_19_1 and var_19_1.player_unit

			if Unit.alive(var_19_2) then
				local var_19_3 = ScriptUnit.extension(var_19_2, "status_system")

				if var_19_3:is_invisible() ~= var_19_0 then
					var_19_3:set_invisible(var_19_0, nil, "debug_invis")

					local var_19_4 = var_19_0 and "Local player is now invisible" or "Local player is now visible"

					Debug.sticky_text(var_19_4)
				end
			end
		end
	},
	{
		description = "Features that make player mechanics nicer to work with.\n * Enables increasing/decreasing the player run speed via ALT+MouseScroll.\n * Allows you to press 'B' to take debug damage.\n * Kill yourself on 'CTRL' + 'V'\n * Revive yourself on 'CTRL' + 'B'\n * Playable pactsworn can stagger them self on 'ALT' + 'X'\n * (requests go here...)",
		is_boolean = true,
		setting_name = "player_mechanics_goodness_debug",
		category = "Player mechanics recommended"
	},
	{
		description = "Increases jump height and allows you to jump multiple times whilst in the air.",
		is_boolean = true,
		setting_name = "use_super_jumps",
		category = "Player mechanics recommended"
	},
	{
		description = "Sets the profile you would like to start the game with.",
		setting_name = "wanted_profile",
		category = "Player mechanics recommended",
		item_source = {
			witch_hunter = true,
			empire_soldier = true,
			dwarf_ranger = true,
			wood_elf = true,
			bright_wizard = true
		}
	},
	{
		description = "Sets the career index you would like to start the game with.",
		setting_name = "wanted_career_index",
		category = "Player mechanics recommended",
		item_source = {
			1,
			2,
			3,
			4
		}
	},
	{
		setting_name = "switch_class",
		description = "Switch player class to play",
		category = "Player mechanics recommended",
		item_source = {},
		load_items_source_func = function (arg_20_0)
			table.clear(arg_20_0)

			local var_20_0 = {}

			arg_20_0.data = var_20_0

			local var_20_1 = Managers.player:local_player()
			local var_20_2 = var_20_1:network_id()
			local var_20_3 = var_20_1:local_player_id()
			local var_20_4 = Managers.party:get_party_from_player_id(var_20_2, var_20_3)
			local var_20_5 = Managers.state.side.side_by_party[var_20_4].available_profiles or PROFILES_BY_AFFILIATION.heroes

			for iter_20_0 = 1, #var_20_5 do
				local var_20_6 = var_20_5[iter_20_0]
				local var_20_7 = #arg_20_0 + 1

				arg_20_0[var_20_7] = var_20_6
				var_20_0[var_20_7] = var_20_6
			end
		end,
		func = function (arg_21_0, arg_21_1)
			local var_21_0 = arg_21_0.data[arg_21_1]

			if var_21_0 then
				local var_21_1 = FindProfileIndex(var_21_0)
				local var_21_2 = SPProfiles[var_21_1].careers
				local var_21_3 = var_21_2[script_data.wanted_career_index] or var_21_2[1]
				local var_21_4 = true

				if var_21_3.display_name == "vs_undecided" then
					return
				end

				Managers.state.network:request_profile(1, var_21_0, var_21_3.display_name, var_21_4)
			end
		end
	},
	{
		setting_name = "switch_party",
		description = "Switch party you you want to spawn in. Note: you need to 'switch_class' for it to be fulfilled",
		category = "Player mechanics recommended",
		item_source = {},
		load_items_source_func = function (arg_22_0)
			local var_22_0 = Managers.party:parties()

			table.clear(arg_22_0)

			local var_22_1 = {}

			arg_22_0.data = var_22_1

			for iter_22_0, iter_22_1 in ipairs(var_22_0) do
				local var_22_2 = #arg_22_0 + 1
				local var_22_3 = iter_22_1.num_used_slots - iter_22_1.num_bots
				local var_22_4 = iter_22_1.num_slots

				if var_22_3 < var_22_4 then
					arg_22_0[var_22_2] = string.format("%s (%d/%d)", iter_22_1.party_id, var_22_3, var_22_4)
				else
					arg_22_0[var_22_2] = string.format("%s (%d/%d) FULL!", iter_22_1.party_id, var_22_3, var_22_4)
				end

				var_22_1[var_22_2] = iter_22_1.party_id
			end
		end,
		func = function (arg_23_0, arg_23_1)
			local var_23_0 = arg_23_0.data[arg_23_1]

			if var_23_0 then
				local var_23_1 = Managers.party:get_party(var_23_0)

				if var_23_1.num_open_slots + var_23_1.num_bots > 0 then
					print("Debug switching wanted party to:", var_23_0)

					local var_23_2 = Managers.player:local_player()
					local var_23_3 = var_23_2:local_player_id()
					local var_23_4 = var_23_2:network_id()
					local var_23_5 = Managers.mechanism:current_mechanism_name()
					local var_23_6 = Managers.state.side.side_by_party[var_23_1]

					Managers.party:request_join_party(var_23_4, var_23_3, var_23_0)

					if var_23_2 and var_23_2:needs_despawn() then
						Managers.state.spawn:delayed_despawn(var_23_2)
					end

					local var_23_7 = Managers.state.entity:system("camera_system")

					if var_23_1.name == "spectators" then
						local var_23_8 = PROFILES_BY_NAME.spectator

						var_23_7:initialize_camera_states(var_23_2, var_23_8.index, 1)
					else
						local var_23_9 = FindProfileIndex("witch_hunter")

						var_23_7:initialize_camera_states(var_23_2, var_23_9, 1)
					end

					local var_23_10 = Managers.state.side:sides()
					local var_23_11
					local var_23_12

					for iter_23_0 = 1, #var_23_10 do
						local var_23_13 = var_23_10[iter_23_0]
						local var_23_14 = string.format("%s_%s", var_23_5, var_23_13:name())
						local var_23_15 = var_23_13 == var_23_6

						Managers.state.game_mode:set_object_set_enabled(var_23_14, var_23_15)
					end
				end
			end
		end
	},
	{
		setting_name = "wanted_party",
		description = "automatically puts you in selected party on join",
		category = "Player mechanics",
		item_source = {},
		load_items_source_func = function (arg_24_0)
			local var_24_0 = Managers.party:parties()

			table.clear(arg_24_0)

			arg_24_0[#arg_24_0 + 1] = "none"

			for iter_24_0 = 1, #var_24_0 do
				local var_24_1 = var_24_0[iter_24_0]

				arg_24_0[#arg_24_0 + 1] = var_24_1.party_id
			end
		end,
		func = function (arg_25_0, arg_25_1)
			if arg_25_0[arg_25_1] then
				-- Nothing
			end
		end
	},
	{
		setting_name = "switch_ai_debug_spawning_party",
		description = "Switch what party you want debugging spawning (P) AI units to belong to",
		category = "Player mechanics recommended",
		item_source = {},
		load_items_source_func = function (arg_26_0)
			local var_26_0 = Managers.state.side:sides()

			table.clear(arg_26_0)

			for iter_26_0, iter_26_1 in pairs(var_26_0) do
				arg_26_0[#arg_26_0 + 1] = iter_26_1.side_id
			end
		end,
		func = function (arg_27_0, arg_27_1)
			local var_27_0 = arg_27_0[arg_27_1]

			if var_27_0 then
				Managers.state.conflict:set_debug_spawn_side(var_27_0)
			end
		end
	},
	{
		description = "Show the units currently equipped in left/right hand.",
		is_boolean = true,
		setting_name = "show_equipped_weapon_units",
		category = "Player mechanics"
	},
	{
		description = "Show fatigue information about human players",
		is_boolean = true,
		setting_name = "debug_fatigue",
		category = "Player mechanics"
	},
	{
		description = "For enabling melee weapon debugging.",
		is_boolean = true,
		setting_name = "debug_weapons",
		category = "Player mechanics"
	},
	{
		description = "The enemy that got target will always get hit",
		is_boolean = true,
		setting_name = "debug_weapons_always_hit_target",
		category = "Player mechanics"
	},
	{
		description = "Damage debugging.",
		is_boolean = true,
		setting_name = "damage_debug",
		category = "Player mechanics"
	},
	{
		description = "Enables ground targetting.",
		is_boolean = true,
		setting_name = "debug_ground_target",
		category = "Player mechanics"
	},
	{
		description = "Logs a ton of stuff, and adds a debug arrow to the knee... err.. screen.",
		is_boolean = true,
		setting_name = "camera_debug",
		category = "Player mechanics"
	},
	{
		description = "Shows area of active AreaDamageExtensions",
		is_boolean = true,
		setting_name = "debug_area_damage",
		category = "Player mechanics"
	},
	{
		description = "Enable state logging for all state machines",
		is_boolean = true,
		setting_name = "debug_state_machines",
		category = "Player mechanics"
	},
	{
		description = "Enable interactor/interactable debugging.",
		is_boolean = true,
		setting_name = "debug_interactions",
		category = "Player mechanics"
	},
	{
		description = "Disables the nice movement by Markus, Peder and Platt.",
		is_boolean = true,
		setting_name = "disable_nice_movement",
		category = "Player mechanics"
	},
	{
		description = "Adds informative text on screen about ladder climbing",
		is_boolean = true,
		setting_name = "debug_ladder_climbing",
		category = "Player mechaniscs"
	},
	{
		description = "Disables the aim lead/rig motion",
		is_boolean = true,
		setting_name = "disable_aim_lead_rig_motion",
		category = "Player mechanics"
	},
	{
		description = "Shows debug spheres for the first rig motion",
		is_boolean = true,
		setting_name = "debug_rig_motion",
		category = "Player mechanics"
	},
	{
		description = "When enabled you will no longer get fatigued.",
		is_boolean = true,
		setting_name = "disable_fatigue_system",
		category = "Player mechanics"
	},
	{
		description = "Can always reload.",
		is_boolean = true,
		setting_name = "infinite_ammo",
		category = "Player mechanics"
	},
	{
		description = "Exits ghost mode automatically",
		is_boolean = true,
		setting_name = "disable_ghost_mode",
		category = "Versus"
	},
	{
		description = "Activated ability cooldowns set to 5 seconds",
		is_boolean = true,
		setting_name = "short_ability_cooldowns",
		category = "Player mechanics"
	},
	{
		description = "Unlock all talent points - Requires Restart",
		is_boolean = true,
		setting_name = "debug_unlock_talents",
		category = "Player mechanics"
	},
	{
		description = "Resets all talents for the current career. Needs to be done outside of a menu to take effect",
		category = "Player mechanics",
		setting_name = "reset_career_talents",
		func = function ()
			local var_28_0 = Managers.backend
			local var_28_1 = Managers.player:local_player():career_name()

			var_28_0:get_interface("talents"):set_talents(var_28_1, {
				0,
				0,
				0,
				0,
				0
			})
			var_28_0:commit(true)
		end
	},
	{
		description = "Enable hero stats in inventory",
		is_boolean = true,
		setting_name = "hero_statistics",
		category = "Player mechanics"
	},
	{
		description = "Enable Animation Logging In The Console For The First Person Local Player.",
		is_boolean = true,
		setting_name = "debug_player_animations",
		category = "Player mechanics"
	},
	{
		description = "Enable \"legendary\" traits for all weapons, and adds some debug prints/draws",
		is_boolean = true,
		setting_name = "debug_legendary_traits",
		category = "Player mechanics"
	},
	{
		description = "Show damage numbers above enemies heads. - Requires restart of level",
		is_boolean = true,
		setting_name = "debug_show_damage_numbers",
		category = "Player mechanics"
	},
	{
		description = "Show Debug sticky text whenever the 1p SM changes.",
		is_boolean = true,
		setting_name = "show_state_machine_changes",
		category = "Player mechanics"
	},
	{
		description = "Enable Animation Logging In The Console For The Local Player.",
		is_boolean = true,
		setting_name = "debug_first_person_player_animations",
		category = "Player mechanics"
	},
	{
		description = "Show animation events triggered via actions.",
		is_boolean = true,
		setting_name = "debug_action_anim_events",
		category = "Player mechanics"
	},
	{
		description = "Show animation variables as they are written to the local player unit",
		is_boolean = true,
		setting_name = "debug_player_anim_variables",
		category = "Player mechanics"
	},
	{
		description = "Show movement settings as they are written to the local player unit",
		is_boolean = true,
		setting_name = "debug_movement_settings",
		category = "Player mechanics"
	},
	{
		description = "Show animation events called for selected unit.",
		is_boolean = true,
		setting_name = "debug_selected_unit_anim_events",
		category = "AI"
	},
	{
		description = "Visualize ledges",
		is_boolean = true,
		setting_name = "visualize_ledges",
		category = "Player mechanics"
	},
	{
		description = "Enable Buff Debug Information",
		is_boolean = true,
		setting_name = "buff_debug",
		category = "Player mechanics"
	},
	{
		description = "Disable Buff system optimization",
		is_boolean = true,
		setting_name = "buff_no_opt",
		category = "Player mechanics"
	},
	{
		description = "Adds any buff in the game to player.",
		setting_name = "Add Buff",
		category = "Player mechanics",
		item_source = {},
		load_items_source_func = function (arg_29_0)
			table.clear(arg_29_0)

			local var_29_0 = BuffTemplates

			for iter_29_0, iter_29_1 in pairs(var_29_0) do
				iter_29_1 = BuffUtils.get_buff_template(iter_29_0)

				if iter_29_1.buffs and iter_29_1.buffs[1] and not iter_29_1.buffs[1].dormant then
					arg_29_0[#arg_29_0 + 1] = iter_29_0
				end
			end

			table.sort(arg_29_0)
		end,
		func = function (arg_30_0, arg_30_1)
			local var_30_0 = arg_30_0[arg_30_1]
			local var_30_1 = Managers.player:local_player().player_unit
			local var_30_2 = Managers.state.entity:system("buff_system")
			local var_30_3 = false

			var_30_2:add_buff(var_30_1, var_30_0, var_30_1, var_30_3)
		end
	},
	{
		description = "Enable OverCharge Debug Information",
		is_boolean = true,
		setting_name = "overcharge_debug",
		category = "Player mechanics"
	},
	{
		description = "Enable OverCharge Debug Information",
		is_boolean = true,
		setting_name = "disable_overcharge",
		category = "Player mechanics"
	},
	{
		description = "Enable Energy Debug Information",
		is_boolean = true,
		setting_name = "energy_debug",
		category = "Player mechanics"
	},
	{
		description = "Disables Energy loss",
		is_boolean = true,
		setting_name = "disable_energy",
		category = "Player mechanics"
	},
	{
		description = "Makes it so you cant fall and hang from ledges.",
		is_boolean = true,
		setting_name = "ledge_hanging_turned_off",
		category = "Player mechanics"
	},
	{
		description = "Visualizes hang ledges positioning and rotation",
		is_boolean = true,
		setting_name = "debug_hang_ledges",
		category = "Player mechanics"
	},
	{
		description = "Makes it so you dont die when you hang from ledge and fall.",
		is_boolean = true,
		setting_name = "ledge_hanging_fall_and_die_turned_off",
		category = "Player mechanics"
	},
	{
		description = "Tutorial stuffs",
		is_boolean = true,
		setting_name = "tutorial_disabled",
		category = "Player mechanics"
	},
	{
		description = "Tutorial stuffs",
		is_boolean = true,
		setting_name = "tutorial_debug",
		category = "Player mechanics"
	},
	{
		description = "Debug statistics stuff",
		is_boolean = true,
		setting_name = "statistics_debug",
		category = "Player mechanics"
	},
	{
		description = "Debug achievements/trophies",
		is_boolean = true,
		setting_name = "achievement_debug",
		category = "Player mechanics"
	},
	{
		description = "Use debug platform for achievements",
		is_boolean = true,
		setting_name = "achievement_debug_platform",
		category = "Player mechanics"
	},
	{
		description = "RESETS all achievements/trophies",
		category = "Player mechanics",
		setting_name = "achievement_reset",
		func = function ()
			Managers.state.achievement:reset()
		end
	},
	{
		description = "Debug in game challenges",
		is_boolean = true,
		setting_name = "debug_in_game_challenges",
		category = "Player mechanics"
	},
	{
		description = "Debug info for missions",
		is_boolean = true,
		setting_name = "debug_mission_system",
		category = "Player mechanics"
	},
	{
		description = "Show the player's position on the screen",
		is_boolean = true,
		setting_name = "debug_player_position",
		category = "Player mechanics"
	},
	{
		description = "Never causes critical strikes",
		is_boolean = true,
		setting_name = "no_critical_strikes",
		category = "Player mechanics"
	},
	{
		description = "Always causes critical strikes",
		is_boolean = true,
		setting_name = "always_critical_strikes",
		category = "Player mechanics"
	},
	{
		description = "Causes a critical strike every second attack",
		is_boolean = true,
		setting_name = "alternating_critical_strikes",
		category = "Player mechanics"
	},
	{
		description = "Draws debug lines to show your blocking arcs",
		is_boolean = true,
		setting_name = "debug_draw_block_arcs",
		category = "Player mechanics"
	},
	{
		description = "Draws debug lines to show your pushing arcs",
		is_boolean = true,
		setting_name = "debug_draw_push_arcs",
		category = "Player mechanics"
	},
	{
		description = "Sets a static power level, ignoring actual career and equipment power",
		category = "Player mechanics",
		setting_name = "power_level_override",
		item_source = {
			200,
			225,
			250,
			275,
			300,
			325,
			350,
			375,
			400,
			425,
			450,
			475,
			500,
			525,
			550,
			575,
			600,
			625,
			650,
			675,
			700,
			725,
			750,
			775,
			800,
			825,
			850,
			875,
			900,
			925,
			950,
			975,
			1000,
			1200,
			1400,
			1600
		},
		custom_item_source_order = function (arg_32_0, arg_32_1)
			for iter_32_0, iter_32_1 in ipairs(arg_32_0) do
				local var_32_0 = iter_32_1

				arg_32_1[#arg_32_1 + 1] = var_32_0
			end
		end
	},
	{
		description = "Sets the power level of the damage dealt when triggering debug damage.",
		category = "Player mechanics",
		setting_name = "debug_damage_power_level",
		item_source = {
			100,
			200,
			225,
			250,
			275,
			300,
			325,
			350,
			375,
			400,
			425,
			450,
			475,
			500,
			525,
			550,
			575,
			600,
			625,
			650,
			675,
			700,
			725,
			750,
			775,
			800
		},
		custom_item_source_order = function (arg_33_0, arg_33_1)
			for iter_33_0, iter_33_1 in ipairs(arg_33_0) do
				local var_33_0 = iter_33_1

				arg_33_1[#arg_33_1 + 1] = var_33_0
			end
		end
	},
	{
		description = "Show player health",
		is_boolean = true,
		setting_name = "show_player_health",
		category = "Player mechanics"
	},
	{
		description = "Show player ammo",
		is_boolean = true,
		setting_name = "show_player_ammo",
		category = "Player mechanics"
	},
	{
		description = "Enables players and bots to respawn quickly at respawn points",
		is_boolean = true,
		setting_name = "fast_respawns",
		category = "Player mechanics"
	},
	{
		description = "Disables triggering weapon animations for third person. Useful for testing new weapons. öddfg (to spite Seb)",
		is_boolean = true,
		setting_name = "disable_third_person_weapon_animation_events",
		category = "Player mechanics"
	},
	{
		description = "Enables players to leave ghost mode while in los",
		is_boolean = true,
		setting_name = "allow_ghost_mode_los",
		category = "Player mechanics"
	},
	{
		description = "Enables players to leave ghost mode while in within range",
		is_boolean = true,
		setting_name = "allow_ghost_mode_range",
		category = "Player mechanics"
	},
	{
		description = "Enables players to leave ghost mode always",
		is_boolean = true,
		setting_name = "always_allow_leave_ghost_mode",
		category = "Player mechanics"
	},
	{
		description = "Disable blacklisting servers in search / matchmaking",
		is_boolean = true,
		setting_name = "blacklisting_disabled_vs",
		category = "Versus"
	},
	{
		description = "Skips to a set in VS. Will mess up UI paramaters",
		setting_name = "vs_skip_to_set",
		category = "Versus",
		close_when_selected = true,
		item_source = {},
		load_items_source_func = function (arg_34_0)
			table.clear(arg_34_0)

			if Managers.level_transition_handler:in_hub_level() or Managers.mechanism:current_mechanism_name() ~= "versus" then
				return
			end

			local var_34_0 = Managers.mechanism:game_mechanism()
			local var_34_1 = var_34_0:get_objective_settings().num_sets
			local var_34_2 = var_34_0:get_current_set()

			for iter_34_0 = 1, var_34_1 do
				if var_34_2 < iter_34_0 then
					arg_34_0[#arg_34_0 + 1] = iter_34_0
				end
			end
		end,
		func = function (arg_35_0, arg_35_1)
			local var_35_0 = arg_35_0[arg_35_1]

			if not var_35_0 then
				return
			end

			Managers.mechanism:game_mechanism():debug_skip_to_set(var_35_0)
		end
	},
	{
		description = "Ends a vs match. UI might get messed",
		close_when_selected = true,
		setting_name = "vs_end_match",
		category = "Versus",
		propagate_to_server = true,
		func = function (arg_36_0, arg_36_1)
			if Managers.level_transition_handler:in_hub_level() or Managers.mechanism:current_mechanism_name() ~= "versus" then
				return
			end

			Managers.state.game_mode:round_started()

			script_data.disable_gamemode_end = nil
			script_data.disable_gamemode_end_hero_check = nil

			Managers.mechanism:game_mechanism():win_conditions():debug_end_match()
		end
	},
	{
		description = "Add score for the current scoring party",
		setting_name = "vs_add_score",
		category = "Versus",
		item_source = {
			1,
			2,
			3,
			5,
			10,
			15,
			25,
			50,
			100
		},
		custom_item_source_order = function (arg_37_0, arg_37_1)
			for iter_37_0, iter_37_1 in ipairs(arg_37_0) do
				local var_37_0 = iter_37_1

				arg_37_1[#arg_37_1 + 1] = var_37_0
			end
		end,
		func = function (arg_38_0, arg_38_1)
			if Managers.level_transition_handler:in_hub_level() then
				return
			end

			local var_38_0 = arg_38_0[arg_38_1]

			Managers.mechanism:game_mechanism():win_conditions():debug_add_score(var_38_0)
		end
	},
	{
		description = "Draws sphere cast on ratogers ability",
		is_boolean = true,
		setting_name = "debug_vs_ratogre_ability",
		category = "Versus"
	},
	{
		description = "Unhoists local player",
		setting_name = "vs_unhoist_local_player",
		category = "Versus",
		func = function (arg_39_0, arg_39_1)
			local var_39_0 = Managers.player:local_player(1).player_unit

			StatusUtils.set_grabbed_by_pack_master_network("pack_master_dropping", var_39_0, true, nil)
		end
	},
	{
		setting_name = "Add Versus Experience",
		description = "Adds Versus Experience to your account.",
		category = "Versus",
		item_source = {},
		load_items_source_func = function (arg_40_0)
			table.clear(arg_40_0)

			arg_40_0[1] = 100
			arg_40_0[2] = 500
			arg_40_0[3] = 2000
			arg_40_0[4] = 5000
			arg_40_0[5] = 10000
			arg_40_0[6] = 100000
		end,
		func = function (arg_41_0, arg_41_1)
			local var_41_0 = Managers.backend
			local var_41_1 = arg_41_0[arg_41_1] or 1
			local var_41_2 = Managers.player:local_player(1)

			local function var_41_3(arg_42_0)
				local var_42_0 = arg_42_0.FunctionResult
				local var_42_1 = arg_42_0.FunctionResult.data.player_profile_data

				Managers.backend:get_backend_mirror():set_read_only_data("vs_profile_data", cjson.encode(var_42_1), true)
			end

			local var_41_4 = {
				FunctionName = "devAddVersusExperience",
				FunctionParameter = {
					experience = var_41_1
				}
			}

			var_41_0._backend_mirror:request_queue():enqueue(var_41_4, var_41_3, false)
		end
	},
	{
		setting_name = "Add Versus Currency",
		description = "Adds Versus Versus Currency.",
		category = "Versus",
		item_source = {},
		load_items_source_func = function (arg_43_0)
			table.clear(arg_43_0)

			arg_43_0[1] = 1
			arg_43_0[2] = 5
			arg_43_0[3] = 10
			arg_43_0[4] = 50
			arg_43_0[5] = 100
		end,
		func = function (arg_44_0, arg_44_1)
			local var_44_0 = Managers.backend
			local var_44_1 = arg_44_0[arg_44_1] or 1
			local var_44_2 = var_44_0:get_interface("peddler")
			local var_44_3 = var_44_2:get_chips("VS")
			local var_44_4 = Managers.player:local_player(1)

			local function var_44_5(arg_45_0)
				local var_45_0 = arg_45_0.FunctionResult

				var_44_2:set_chips("VS", var_45_0.new_vs_currency)
			end

			local var_44_6 = {
				FunctionName = "devGrantVersusCurrency",
				FunctionParameter = {
					amount = var_44_1
				}
			}

			var_44_0._backend_mirror:request_queue():enqueue(var_44_6, var_44_5, false)
		end
	},
	{
		description = "draws spheres where player is teleported to",
		is_boolean = true,
		setting_name = "vs_debug_hoist",
		category = "Versus"
	},
	{
		description = "Draw some helpful lines for player leaps",
		is_boolean = true,
		setting_name = "debug_draw_player_leap",
		category = "Player mechanics"
	},
	{
		description = "Stops Manny from cheating in playtests. Hopefully.",
		is_boolean = true,
		setting_name = "disable_time_travel",
		category = "Player mechanics"
	},
	{
		description = "Disables external velocity influences (Knockback from punches or enemies pushing the player)",
		is_boolean = true,
		setting_name = "disable_external_velocity",
		category = "Player mechanics"
	},
	{
		description = "Disables catapulting players (Ratogre has a attack that catapults the player for example)",
		is_boolean = true,
		setting_name = "disable_catapulting",
		category = "Player mechanics"
	},
	{
		description = "Will show debug lines for projectiles when true",
		is_boolean = true,
		setting_name = "debug_projectiles",
		category = "Weapons"
	},
	{
		description = "Will show debug lines for projectiles when true",
		is_boolean = true,
		setting_name = "debug_light_weight_projectiles",
		category = "Weapons"
	},
	{
		description = "Writes into the console whenever a new action starts or finishes",
		is_boolean = true,
		setting_name = "log_actions",
		category = "Weapons"
	},
	{
		description = "Add/remove test attachments",
		is_boolean = true,
		setting_name = "attachment_debug",
		category = "Attachments"
	},
	{
		description = "Turns on chieftain spawn debug",
		is_boolean = true,
		setting_name = "ai_champion_spawn_debug",
		category = "AI recommended"
	},
	{
		description = "Disables AI spawning due to pacing.",
		is_boolean = true,
		setting_name = "ai_pacing_disabled",
		category = "AI recommended"
	},
	{
		description = "Disables AI rush intervention (specials & hordes)",
		is_boolean = true,
		setting_name = "ai_rush_intervention_disabled",
		category = "AI recommended"
	},
	{
		description = "Disables AI speed run intervention(specials and small hordes)",
		is_boolean = true,
		setting_name = "ai_speed_run_intervention_disabled",
		category = "AI recommended"
	},
	{
		description = "Disables AI roam spawning.",
		is_boolean = true,
		setting_name = "ai_roaming_spawning_disabled",
		category = "AI recommended"
	},
	{
		description = "Disables AI roaming patrols spawning. (there will only be normal packs)",
		is_boolean = true,
		setting_name = "ai_roaming_patrols_disabled",
		category = "AI recommended"
	},
	{
		description = "Disables boss/rare event spawning.",
		is_boolean = true,
		setting_name = "ai_boss_spawning_disabled",
		category = "AI recommended"
	},
	{
		description = "Disables specials spawning",
		is_boolean = true,
		setting_name = "ai_specials_spawning_disabled",
		category = "AI recommended"
	},
	{
		description = "Disables critter spawning",
		is_boolean = true,
		setting_name = "ai_critter_spawning_disabled",
		category = "AI recommended"
	},
	{
		description = "Disables AI terror events spawning",
		is_boolean = true,
		setting_name = "ai_terror_events_disabled",
		category = "AI recommended"
	},
	{
		description = "Disables gutter runners from spawning (requires restart!!!)",
		is_boolean = true,
		setting_name = "disable_gutter_runner",
		category = "AI recommended"
	},
	{
		description = "Disables globadiers from spawning (requires restart!!!)",
		is_boolean = true,
		setting_name = "disable_globadier",
		category = "AI recommended"
	},
	{
		description = "Disables pack masters from spawning (requires restart!!!)",
		is_boolean = true,
		setting_name = "disable_pack_master",
		category = "AI recommended"
	},
	{
		description = "Disables ratling gunners from spawning (requires restart!!!)",
		is_boolean = true,
		setting_name = "disable_ratling_gunner",
		category = "AI recommended"
	},
	{
		description = "Disables warpfire throwers from spawning (requires restart!!!)",
		is_boolean = true,
		setting_name = "disable_warpfire_thrower",
		category = "AI recommended"
	},
	{
		description = "Disables vortex sorcerers from spawning (requires restart!!!)",
		is_boolean = true,
		setting_name = "disable_vortex_sorcerer",
		category = "AI recommended"
	},
	{
		description = "Disables plague sorcerers from spawning (requires restart!!!)",
		is_boolean = true,
		setting_name = "disable_plague_sorcerer",
		category = "AI recommended"
	},
	{
		description = "Disables hordes spawning",
		is_boolean = true,
		setting_name = "ai_horde_spawning_disabled",
		category = "AI recommended"
	},
	{
		description = "When pressing 'h for a debug horde, set what kind of horde will spawn, instead of a random variant",
		setting_name = "ai_set_horde_type_debug",
		category = "AI recommended",
		item_source = {
			vector_blob = "vector_blob",
			vector = "vector",
			ambush = "ambush",
			random = "random"
		}
	},
	{
		description = "Disables mini patrols from spawning",
		is_boolean = true,
		setting_name = "ai_mini_patrol_disabled",
		category = "AI recommended"
	},
	{
		setting_name = "debug spawn mini patrol",
		description = "Spawns a mini patrol right now",
		category = "AI",
		item_source = {},
		load_items_source_func = function (arg_46_0)
			table.clear(arg_46_0)

			for iter_46_0, iter_46_1 in pairs(HordeSettings) do
				arg_46_0[#arg_46_0 + 1] = iter_46_1.mini_patrol_composition
			end
		end,
		func = function (arg_47_0, arg_47_1)
			local var_47_0 = arg_47_0[arg_47_1]

			if var_47_0 then
				print("Debug spawning mini patrol of composition:", var_47_0)

				local var_47_1 = {
					size = 0,
					template = "mini_patrol",
					id = Managers.state.entity:system("ai_group_system"):generate_group_id()
				}
				local var_47_2 = Managers.time:time("game")
				local var_47_3

				Managers.state.conflict:mini_patrol(var_47_2, nil, var_47_3, var_47_0, var_47_1)
			end
		end
	},
	{
		description = "Enemy ragdolls are despawned immediately.",
		is_boolean = true,
		setting_name = "disable_ragdolls",
		category = "AI"
	},
	{
		description = "Players deal no direct damage to enemies.",
		is_boolean = true,
		setting_name = "players_deal_no_damage",
		category = "AI"
	},
	{
		description = "Cap num controlled units",
		category = "AI",
		setting_name = "cap_num_controlled_units",
		item_source = {
			0,
			1,
			2,
			3
		},
		custom_item_source_order = function (arg_48_0, arg_48_1)
			for iter_48_0, iter_48_1 in ipairs(arg_48_0) do
				local var_48_0 = iter_48_1

				arg_48_1[#arg_48_1 + 1] = var_48_0
			end
		end
	},
	{
		description = "Disable controlled unit rotation based follow",
		is_boolean = true,
		setting_name = "disable_rotation_based_follow",
		category = "AI"
	},
	{
		description = "Colors the different sides of ai-units in red, blue, green and yellow",
		is_boolean = true,
		setting_name = "faction_colored_ai",
		category = "AI"
	},
	{
		description = "Disable Necromancer Pets",
		is_boolean = true,
		setting_name = "disable_necromancer_pets",
		category = "AI"
	},
	{
		description = "Enables horde logging in console",
		is_boolean = true,
		setting_name = "ai_horde_logging",
		category = "AI recommended"
	},
	{
		description = "Presents current amount of alive breeds on screen.",
		is_boolean = true,
		setting_name = "show_alive_ai",
		category = "AI recommended"
	},
	{
		description = "Writes out max-health / current health above ai units",
		is_boolean = true,
		setting_name = "show_ai_health",
		category = "AI recommended"
	},
	{
		description = "Writes out from what BreedPack the unit was picked. What zone he spawned in. If he was replaced.",
		is_boolean = true,
		setting_name = "show_ai_spawn_info",
		category = "AI recommended"
	},
	{
		description = "Draws a spinning line abouve each pickup in game",
		is_boolean = true,
		setting_name = "show_spawned_pickups",
		category = "AI recommended"
	},
	{
		description = "Collects the data needed for drawing pickup spawners and spawn sections. Restart required.",
		is_boolean = true,
		setting_name = "debug_pickup_spawners",
		category = "Pickup Spawners"
	},
	{
		description = "The debug_pickup_spawners option must be set to true when using this feature",
		category = "Pickup Spawners",
		setting_name = "Toggle Pickup Spawners Draw Mode",
		func = function ()
			Managers.state.entity:system("pickup_system"):debug_draw_spread_pickups()
		end
	},
	{
		description = "Shows which dynamic packages that have been loaded or unloaded.",
		is_boolean = true,
		setting_name = "debug_pickup_package_loader",
		category = "Network"
	},
	{
		description = "Shows which dynamic packages that have been loaded or unloaded",
		is_boolean = true,
		setting_name = "debug_general_package_loader",
		category = "Network"
	},
	{
		description = "Draws lines up in the sky where each ai is",
		is_boolean = true,
		setting_name = "show_where_ai_is",
		category = "AI recommended"
	},
	{
		description = "Draws lines up in the sky where each inactive ai is",
		is_boolean = true,
		setting_name = "show_where_inactive_ai_is",
		category = "AI recommended"
	},
	{
		description = "turns on animation debug on your current ai debug target.",
		is_boolean = true,
		setting_name = "anim_debug_ai_debug_target",
		category = "AI recommended"
	},
	{
		description = "Choose between different conflict director settings.",
		setting_name = "override_conflict_settings",
		category = "Conflict & Pacing",
		item_source = ConflictDirectors
	},
	{
		description = "Displays current conflict settings on screen.",
		is_boolean = true,
		setting_name = "show_current_conflict_settings",
		category = "Conflict & Pacing"
	},
	{
		description = "Shows the contained breeds of the current conflict_director.",
		is_boolean = true,
		setting_name = "debug_conflict_director_breeds",
		category = "Conflict & Pacing"
	},
	{
		description = "Displays current threat value from aggroed enemies, and what systems will delay their spawning.",
		is_boolean = true,
		setting_name = "debug_current_threat_value",
		category = "Conflict & Pacing"
	},
	{
		description = "Dump lots of debug in the console when constructing the zones & packs. Will draw 1m spheres around units that gets replaced via BreedPacks zone_checks. Each hi/low segment will have the same colored spheres. Units that are not replaced, but counted will have small spheres.",
		is_boolean = true,
		setting_name = "debug_zone_baker",
		category = "Conflict & Pacing"
	},
	{
		description = "Draws zones on screen, and lots of debug on ground",
		is_boolean = true,
		setting_name = "debug_zone_baker_on_screen",
		category = "Conflict & Pacing"
	},
	{
		description = "Show all hidden spawners with vertical lines.",
		is_boolean = true,
		setting_name = "show_hidden_spawners",
		category = "Conflict & Pacing"
	},
	{
		description = "Shows clustering, loneliness, crumbs...",
		is_boolean = true,
		setting_name = "debug_player_positioning",
		category = "Conflict & Pacing"
	},
	{
		description = "Shows rushing player...",
		is_boolean = true,
		setting_name = "debug_rush_intervention",
		category = "Conflict & Pacing"
	},
	{
		description = "Handles speedrunners by spawning specials or small hordes ahead of players, activate this to see its states",
		is_boolean = true,
		setting_name = "debug_speed_running_intervention",
		category = "Conflict & Pacing"
	},
	{
		description = "Show data for pacing of the game",
		is_boolean = true,
		setting_name = "debug_ai_pacing",
		category = "Conflict & Pacing"
	},
	{
		description = "Shows player intensity",
		is_boolean = true,
		setting_name = "debug_player_intensity",
		category = "Conflict & Pacing"
	},
	{
		description = "debug the peak delayer.",
		is_boolean = true,
		setting_name = "debug_peak_delayer",
		category = "Conflict & Pacing"
	},
	{
		description = "Show exclamation point icon above heads of alerted skaven",
		is_boolean = true,
		setting_name = "enable_alert_icon",
		category = "AI"
	},
	{
		description = "Make AI not perceive anyone",
		is_boolean = true,
		setting_name = "disable_ai_perception",
		category = "AI"
	},
	{
		description = "Check no spawn volumes when spawning specials",
		is_boolean = true,
		setting_name = "check_no_spawn_volumes_for_special_spawning",
		category = "AI"
	},
	{
		description = "Shows perception for some units",
		is_boolean = true,
		setting_name = "debug_ai_perception",
		category = "AI"
	},
	{
		description = "Shows attack patterns for enemies. Gray -> has no slot. Lime -> has slot. Red -> is attacking. Orange -> is in attack cooldown. Blue -> is staggered or blocked.",
		is_boolean = true,
		setting_name = "debug_ai_attack_pattern",
		category = "AI"
	},
	{
		description = "Automagically destroys AI that are at a far enough distance from all the players.",
		is_boolean = true,
		setting_name = "ai_far_off_despawn_disabled",
		category = "AI"
	},
	{
		description = "Shows the workings of the ai recycler and area sets",
		is_boolean = true,
		setting_name = "debug_ai_recycler",
		category = "AI"
	},
	{
		description = "Shows frozen breed units",
		is_boolean = true,
		setting_name = "debug_breed_freeze",
		category = "AI"
	},
	{
		description = "Disables AI freeze optimization",
		is_boolean = true,
		setting_name = "disable_breed_freeze_opt",
		category = "AI"
	},
	{
		description = "Enemy recycler will spawn rats wile in free-flight",
		is_boolean = true,
		setting_name = "recycler_in_freeflight",
		category = "AI"
	},
	{
		description = "Shows the active respawns as yellow spheres with distance from start. removed respawns due to crossroads are bluish spheres",
		is_boolean = true,
		setting_name = "debug_player_respawns",
		category = "AI"
	},
	{
		description = "Horde debugging, shows how it picks spawn points",
		is_boolean = true,
		setting_name = "debug_hordes",
		category = "AI"
	},
	{
		description = "Mini patrol debugging",
		is_boolean = true,
		setting_name = "debug_mini_patrols",
		category = "AI"
	},
	{
		description = "Draws patrols routes",
		category = "AI",
		setting_name = "draw_patrol_routes",
		func = function ()
			Managers.state.conflict.level_analysis:draw_patrol_routes()
		end
	},
	{
		description = "Draws patrol start positions",
		category = "AI",
		setting_name = "draw_patrol_start_positions",
		func = function ()
			Managers.state.conflict.level_analysis:draw_patrol_start_positions()
		end
	},
	{
		description = "Mulitply number of enemies in hordes",
		category = "AI",
		setting_name = "big_hordes",
		item_source = {
			1,
			2,
			4,
			8,
			16
		},
		custom_item_source_order = function (arg_52_0, arg_52_1)
			table.append(arg_52_1, arg_52_0)
		end
	},
	{
		description = "Spawns a boss patrol at the closest spawner, use draw_patrol_start_positions to see spawners",
		category = "AI",
		setting_name = "spawn_patrol_at_closest_spawner",
		func = function ()
			Managers.state.conflict:debug_spawn_spline_patrol_closest_spawner()
		end
	},
	{
		description = "AI behviour trees text over unit.",
		is_boolean = true,
		setting_name = "debug_behaviour_trees",
		category = "AI"
	},
	{
		description = "Show debug data for terror events.",
		is_boolean = true,
		setting_name = "debug_terror",
		category = "AI"
	},
	{
		description = "Change which difficulty terror events will be played at",
		setting_name = "terror_event_difficulty",
		category = "AI",
		item_source = DifficultySettings
	},
	{
		setting_name = "terror_event_difficulty_tweak",
		category = "AI",
		description = "Change which difficulty tweak terror events will be played at.",
		item_source = {},
		load_items_source_func = function (arg_54_0)
			table.clear(arg_54_0)

			for iter_54_0 = -DifficultyTweak.range, DifficultyTweak.range do
				arg_54_0[#arg_54_0 + 1] = iter_54_0
			end

			table.sort(arg_54_0)

			arg_54_0[#arg_54_0 + 1] = "[clear value]"
		end
	},
	{
		description = "Draws a sphere and text at each respawner unit in the level. Must set 'debug_ai_recycler=true'",
		category = "AI",
		setting_name = "debug_spawn_ogre_from_closest_boss_spawner",
		func = function ()
			if script_data.debug_ai_recycler then
				local var_55_0 = false

				Managers.state.conflict.level_analysis:debug_spawn_boss_from_closest_spawner_to_player(var_55_0)
			end
		end
	},
	{
		description = "Injects all patrols into the main path'",
		category = "AI",
		setting_name = "debug_spawn_all_boss_patrols",
		func = function ()
			print("All boss patrols injected into the main path now")
			Managers.state.conflict.level_analysis:spawn_all_boss_spline_patrols()
		end
	},
	{
		description = "Injects all bosses into the main path'",
		category = "AI",
		setting_name = "debug_inject_bosses_in_all_boss_spawners",
		func = function ()
			print("All boss enemies are now injected into the main path!")
			Managers.state.conflict.level_analysis:inject_all_bosses_into_main_path()
		end
	},
	{
		description = "Debug spawns one special through the specials spawning system.",
		category = "AI",
		setting_name = "debug_spawn_special",
		func = function ()
			Managers.state.conflict.specials_pacing:debug_spawn()
		end
	},
	{
		description = "Enable navigation group debugging.",
		is_boolean = true,
		setting_name = "debug_navigation_group_manager",
		category = "AI"
	},
	{
		description = "Draws lines between all navigation-groups. Remove lines by pressing 'X'. ",
		category = "AI",
		setting_name = "draw_navigation_group_connections",
		func = function ()
			Managers.state.conflict.navigation_group_manager:draw_group_connections()
		end
	},
	{
		description = "Enables debugging for spawning packs using perlin noise.",
		is_boolean = true,
		setting_name = "debug_perlin_noise_spawning",
		category = "AI"
	},
	{
		description = "Visual debugging for movement.",
		setting_name = "debug_ai_movement",
		category = "AI",
		item_source = {
			graphics_only = "graphics_only",
			text_and_graphics = "text_and_graphics"
		}
	},
	{
		description = "Shows which of nav tag volume layer 20-29 that are enabled.",
		is_boolean = true,
		setting_name = "debug_nav_tag_volume_layers",
		category = "AI"
	},
	{
		description = "Visual debugging for skeleton for debug_unit.",
		is_boolean = true,
		setting_name = "debug_skeleton",
		category = "AI"
	},
	{
		description = "Fades out debug_unit.",
		is_boolean = true,
		setting_name = "fade_debug_unit",
		category = "AI"
	},
	{
		description = "Visual debugging for big boy turning.",
		is_boolean = true,
		setting_name = "debug_big_boy_turning",
		category = "AI"
	},
	{
		description = "Visual debugging when enemy AI pathfinding fails.",
		is_boolean = true,
		setting_name = "ai_debug_failed_pathing",
		category = "AI"
	},
	{
		description = "Will hide then node-history list on the left side of the screen, when in the behavior debugger screen. (CTRL+B)",
		is_boolean = true,
		setting_name = "hide_behavior_tree_node_history",
		category = "AI"
	},
	{
		description = "Displays engine debug for EngineOptimizedExtensions",
		is_boolean = true,
		setting_name = "show_engine_locomotion_debug",
		category = "AI"
	},
	{
		description = "Policy to use for the enemy package loader (see EnemyPackageLoaderSettings). [NEED TO RESTART GAME]",
		setting_name = "enemy_package_loader_policy",
		category = "AI",
		item_source = {
			console = "console"
		}
	},
	{
		description = "Shows which dynamic packages that have been loaded or unloaded.",
		is_boolean = true,
		setting_name = "debug_enemy_package_loader",
		category = "AI"
	},
	{
		description = "Visual debugging for ai attacks",
		is_boolean = true,
		setting_name = "debug_ai_attack",
		category = "AI"
	},
	{
		description = "Visual debugging for ai targeting.",
		is_boolean = true,
		setting_name = "debug_ai_targets",
		category = "AI"
	},
	{
		description = "Only enables AI debugger during freeflight",
		is_boolean = true,
		setting_name = "ai_debugger_freeflight_only",
		category = "AI"
	},
	{
		description = "Shows the aoe targeting alternatives and which target position chosen",
		is_boolean = true,
		setting_name = "ai_debug_aoe_targeting",
		category = "AI"
	},
	{
		description = "Shows the raycasts when testing trajectories",
		is_boolean = true,
		setting_name = "ai_debug_trajectory_raycast",
		category = "AI"
	},
	{
		description = "Visualize AI slots",
		is_boolean = true,
		setting_name = "ai_debug_slots",
		category = "AI"
	},
	{
		description = "Will log when stuff happens",
		is_boolean = true,
		setting_name = "ai_debug_inventory",
		category = "AI"
	},
	{
		description = "Will visualize ai sound detection and reactions",
		is_boolean = true,
		setting_name = "ai_debug_sound_detection",
		category = "AI"
	},
	{
		description = "Visual debugging and logging for groups/patrols",
		is_boolean = true,
		setting_name = "ai_debug_smartobject",
		category = "AI"
	},
	{
		description = "Pack master will attack regardless of if the player is already under attack or not.",
		is_boolean = true,
		setting_name = "ai_packmaster_ignore_dogpile",
		category = "AI"
	},
	{
		description = "If not true, when quick-spawning enemies the ai debugger will auto select them.",
		is_boolean = true,
		setting_name = "ai_disable_auto_ai_debugger_target",
		category = "AI"
	},
	{
		description = "show globadiers areas for decision making",
		is_boolean = true,
		setting_name = "ai_globadier_behavior",
		category = "AI"
	},
	{
		description = "show gutter runner debug",
		is_boolean = true,
		setting_name = "ai_gutter_runner_behavior",
		category = "AI"
	},
	{
		description = "show loot rat debug",
		is_boolean = true,
		setting_name = "ai_loot_rat_behavior",
		category = "AI"
	},
	{
		description = "Toggle navmesh debug draw mode.",
		setting_name = "nav_mesh_debug",
		category = "AI",
		item_source = {
			retained = "retained",
			continuous = "continuous"
		}
	},
	{
		description = "Shows cover points as green spheres. Bad cover points as red capsules, only draws at level startup.",
		is_boolean = true,
		setting_name = "show_hidden_cover_points",
		category = "AI"
	},
	{
		description = "Shows all coverpoints within 35m from the player",
		is_boolean = true,
		setting_name = "debug_near_cover_points",
		category = "AI"
	},
	{
		description = "AI group/patrols",
		is_boolean = true,
		setting_name = "ai_group_debug",
		category = "AI"
	},
	{
		description = "Debug patrols",
		is_boolean = true,
		setting_name = "debug_patrols",
		category = "AI"
	},
	{
		description = "Debug which groups are being considered for despawning by recycler",
		is_boolean = true,
		setting_name = "debug_group_recycling",
		category = "AI"
	},
	{
		description = "Debug chaos troll",
		is_boolean = true,
		setting_name = "debug_chaos_troll",
		category = "AI"
	},
	{
		description = "Debug Skaven Stormfiend",
		is_boolean = true,
		setting_name = "debug_stormfiend",
		category = "AI"
	},
	{
		description = "Debug the Chaos Vortex",
		is_boolean = true,
		setting_name = "debug_vortex",
		category = "AI"
	},
	{
		description = "Debug liquid system used for AoE effects.",
		is_boolean = true,
		setting_name = "debug_liquid_system",
		category = "AI"
	},
	{
		description = "Debug damage wave used for AoE attacks.",
		is_boolean = true,
		setting_name = "debug_damage_wave",
		category = "AI"
	},
	{
		description = "Debug damage blobs used for AoE attacks.",
		is_boolean = true,
		setting_name = "debug_damage_blobs",
		category = "AI"
	},
	{
		description = "AI interest points",
		is_boolean = true,
		setting_name = "ai_interest_point_debug",
		category = "AI"
	},
	{
		description = "AI interest points gets randomly disabled without this",
		is_boolean = true,
		setting_name = "ai_dont_randomize_interest_points",
		category = "AI"
	},
	{
		description = "ratling gunner debug",
		is_boolean = true,
		setting_name = "ai_ratling_gunner_debug",
		category = "AI"
	},
	{
		description = "disable to debug crashes more clearly or to profile.",
		is_boolean = true,
		setting_name = "navigation_thread_disabled",
		category = "AI"
	},
	{
		description = "Disable rats spreading out more.",
		is_boolean = true,
		setting_name = "disable_crowd_dispersion",
		category = "AI"
	},
	{
		description = "Sets the time available for pathfinding",
		setting_name = "navigation_pathfinder_budget",
		category = "AI",
		item_source = {
			default = true,
			short = true,
			long = true
		},
		func = function (arg_60_0, arg_60_1)
			local var_60_0 = arg_60_0[arg_60_1]
			local var_60_1 = Managers.state.entity:system("ai_system"):nav_world()

			if var_60_0 == "off" then
				print("Not changing pathfinding budget")
			elseif var_60_0 == "short" then
				local var_60_2 = 0.1

				printf("Changing pathfinding budget to %.1fms", var_60_2)
				GwNavWorld.set_pathfinder_budget(var_60_1, var_60_2 * 0.001)
			else
				local var_60_3 = 100

				printf("Changing pathfinding budget to %.1fms", var_60_3)
				GwNavWorld.set_pathfinder_budget(var_60_1, var_60_3 * 0.001)
			end
		end
	},
	{
		description = "Enables visual debugging.",
		category = "AI",
		setting_name = "navigation_visual_debug_enabled",
		callback = "enable_navigation_visual_debug",
		is_boolean = true
	},
	{
		description = "Show stagger immunity info on enemies.",
		is_boolean = true,
		setting_name = "debug_stagger",
		category = "AI"
	},
	{
		description = "Shows the values for current attack intensity",
		is_boolean = true,
		setting_name = "debug_attack_intensity",
		category = "AI"
	},
	{
		description = "Find it annoying that the game ends every time you die? Well enable this setting then!",
		setting_name = "disable_gamemode_end",
		category = "Gamemode/level",
		propagate_to_server = true,
		is_boolean = true
	},
	{
		description = "Find it annoying that the game ends every time you die? Well enable this setting then!",
		setting_name = "disable_gamemode_end_hero_check",
		category = "Gamemode/level",
		propagate_to_server = true,
		is_boolean = true
	},
	{
		description = "Game will not end even though if all players die",
		is_boolean = true,
		setting_name = "lose_condition_disabled",
		category = "Gamemode/level"
	},
	{
		description = "Game will not end until bots have died. (Only for Versus now)",
		is_boolean = true,
		setting_name = "lose_condition_also_count_bots",
		category = "Gamemode/level"
	},
	{
		description = "Unlock all levels in the map",
		is_boolean = true,
		setting_name = "unlock_all_levels",
		category = "Gamemode/level"
	},
	{
		description = "Unlock all difficulties in the map",
		is_boolean = true,
		setting_name = "unlock_all_difficulties",
		category = "Gamemode/level"
	},
	{
		description = "Various level debug stuff",
		is_boolean = true,
		setting_name = "debug_level",
		category = "Gamemode/level"
	},
	{
		description = "Shows debug information about Weave spawning",
		is_boolean = true,
		setting_name = "debug_weave_spawning",
		category = "Gamemode/level"
	},
	{
		description = "Save debug info for server seeded randoms, can be printed on server/client with debug_print_random_values() in console",
		is_boolean = true,
		setting_name = "debug_server_seeded_random",
		category = "Gamemode/level"
	},
	{
		description = "Normally the level_seed will be 0 when starting a map from toolcenter, but with this you will get a random level-seed.",
		is_boolean = true,
		setting_name = "random_level_seed_from_toolcenter",
		category = "Gamemode/level"
	},
	{
		description = "Enables room debuging using f1-f4",
		is_boolean = true,
		setting_name = "debug_rooms",
		category = "Gamemode/level"
	},
	{
		description = "Allows you to skip ingame cutscenes",
		is_boolean = true,
		setting_name = "skippable_cutscenes",
		category = "Gamemode/level"
	},
	{
		description = "Change which difficulty you play at. Restart required.",
		setting_name = "current_difficulty_setting",
		category = "Gamemode/level",
		item_source = DifficultySettings
	},
	{
		setting_name = "current_difficulty_tweak_setting",
		category = "Gamemode/level",
		description = "Change which difficulty tweak you play at. Restart required.",
		item_source = {},
		load_items_source_func = function (arg_61_0)
			table.clear(arg_61_0)

			for iter_61_0 = -DifficultyTweak.range, DifficultyTweak.range do
				arg_61_0[#arg_61_0 + 1] = iter_61_0
			end

			table.sort(arg_61_0)

			arg_61_0[#arg_61_0 + 1] = "[clear value]"
		end
	},
	{
		description = "Set difficulty. No restart required for most stuff, mostly used for testing enemies. Some stuff might need restart of level.",
		setting_name = "set_difficulty",
		category = "Gamemode/level",
		item_source = {},
		load_items_source_func = function (arg_62_0)
			table.clear(arg_62_0)

			for iter_62_0, iter_62_1 in pairs(Difficulties) do
				arg_62_0[#arg_62_0 + 1] = iter_62_1
			end

			table.sort(arg_62_0)
		end,
		func = function (arg_63_0, arg_63_1)
			local var_63_0 = arg_63_0[arg_63_1]
			local var_63_1, var_63_2 = Managers.state.difficulty:get_difficulty()

			Managers.state.difficulty:set_difficulty(var_63_0, var_63_2)

			local var_63_3 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

			for iter_63_0 = 1, #var_63_3 do
				local var_63_4 = var_63_3[iter_63_0]
				local var_63_5 = ScriptUnit.has_extension(var_63_4, "attack_intensity_system")

				if var_63_5 then
					var_63_5:refresh_difficulty()
				end
			end

			print("Set difficulty to " .. var_63_0 .. var_63_2)
		end
	},
	{
		setting_name = "set_difficulty_tweak",
		category = "Gamemode/level",
		description = "Set difficulty tweak to make the current difficulty slightly easier/harder. " .. "No restart required for most stuff, mostly used for testing enemies. Some stuff might need restart of level.",
		item_source = {},
		load_items_source_func = function (arg_64_0)
			table.clear(arg_64_0)

			for iter_64_0 = -DifficultyTweak.range, DifficultyTweak.range do
				arg_64_0[#arg_64_0 + 1] = iter_64_0
			end

			table.sort(arg_64_0)
		end,
		func = function (arg_65_0, arg_65_1)
			local var_65_0, var_65_1 = Managers.state.difficulty:get_difficulty()
			local var_65_2 = arg_65_0[arg_65_1]

			Managers.state.difficulty:set_difficulty(var_65_0, var_65_2)
			print("Set difficulty to " .. var_65_0 .. var_65_2)
		end
	},
	{
		description = "Enables debug options for mutators",
		is_boolean = true,
		setting_name = "debug_mutators",
		category = "Gamemode/level"
	},
	{
		description = "Debug for darkness in drachenfells castle dungeon level.",
		is_boolean = true,
		setting_name = "debug_darkness",
		category = "Gamemode/level"
	},
	{
		description = "Shows state of the game-mode and in what parties different players are.",
		is_boolean = true,
		setting_name = "show_gamemode_debug",
		category = "Gamemode/level"
	},
	{
		description = "Disable horde surge events.",
		is_boolean = true,
		setting_name = "disable_horde_surge",
		category = "Gamemode/level"
	},
	{
		description = "Displays debug info for Horde Surge events.",
		is_boolean = true,
		setting_name = "debug_horde_surge",
		category = "Gamemode/level"
	},
	{
		description = "Disables the level introduction by Lohner / Olesya",
		is_boolean = true,
		setting_name = "disable_level_intro_dialogue",
		category = "Visual/audio"
	},
	{
		description = "Debug print Hit Effects Templates",
		is_boolean = true,
		setting_name = "debug_hit_effects_templates",
		category = "Visual/audio"
	},
	{
		description = "Prints total ammount of particles currently simulated in the game world",
		is_boolean = true,
		setting_name = "debug_particle_simulation",
		category = "Visual/audio"
	},
	{
		description = "Disabled blood splatter on screen from other players' kills",
		is_boolean = true,
		setting_name = "disable_remote_blood_splatter",
		category = "Visual/audio"
	},
	{
		description = "Disabled blood splatter on screen from behind camera",
		is_boolean = true,
		setting_name = "disable_behind_blood_splatter",
		category = "Visual/audio"
	},
	{
		description = "Disable combat music",
		is_boolean = true,
		setting_name = "debug_disable_combat_music",
		category = "Visual/audio"
	},
	{
		description = "Show material effect visual debug info.",
		is_boolean = true,
		setting_name = "debug_material_effects",
		category = "Visual/audio"
	},
	{
		description = "Sound debugging",
		is_boolean = true,
		setting_name = "sound_debug",
		category = "Visual/audio"
	},
	{
		description = "Triggers breakpoint when selected cue is triggered from Lua. (Requires attached debugger). Listen will fill the list with sounds that are played this session.",
		setting_name = "sound_cue_breakpoint",
		category = "Visual/audio",
		item_source = {
			"Listen",
			"[clear value]"
		},
		load_items_source_func = function (arg_66_0)
			table.clear(arg_66_0)

			arg_66_0[1] = "Listen"
			arg_66_0[2] = "[clear value]"

			local var_66_0 = rawget(_G, "_sound_cue_breakpoint_set")

			if var_66_0 then
				local var_66_1 = #arg_66_0

				for iter_66_0 in pairs(var_66_0) do
					var_66_1 = var_66_1 + 1
					arg_66_0[var_66_1] = iter_66_0
				end
			end
		end
	},
	{
		description = "Shows Wwise Timestamp.",
		is_boolean = true,
		setting_name = "debug_wwise_timestamp",
		category = "Visual/audio"
	},
	{
		description = "Visual debug for the sound sector system",
		is_boolean = true,
		setting_name = "sound_sector_system_debug",
		category = "Visual/audio"
	},
	{
		description = "debug info for sound environments",
		is_boolean = true,
		setting_name = "debug_sound_environments",
		category = "Visual/audio"
	},
	{
		description = "music stuff",
		is_boolean = true,
		setting_name = "debug_music",
		category = "Visual/audio"
	},
	{
		description = "debug lua_elevation parameter sent to wwise",
		is_boolean = true,
		setting_name = "debug_wwise_elevation",
		category = "Visual/audio"
	},
	{
		description = "debug current environment blend",
		is_boolean = true,
		setting_name = "debug_environment_blend",
		category = "Visual/audio"
	},
	{
		description = "debug nav mesh pasted particle effects",
		is_boolean = true,
		setting_name = "debug_nav_mesh_vfx",
		category = "Visual/audio"
	},
	{
		description = "debug sorting for proximity dependent sfx and vfx",
		is_boolean = true,
		setting_name = "debug_proximity_fx",
		category = "Visual/audio"
	},
	{
		description = "show values sent to wwise",
		is_boolean = true,
		setting_name = "debug_drunk_sound_values",
		category = "Visual/audio"
	},
	{
		description = "maximum allowed skaven to play proximity dependent sfx and vfx settings: 5/10/12/15/20/25/30/40/60",
		setting_name = "max_allowed_proximity_fx",
		category = "Visual/audio",
		item_source = {
			nil,
			nil,
			nil,
			nil,
			true,
			nil,
			nil,
			nil,
			nil,
			true,
			nil,
			true,
			nil,
			nil,
			true,
			nil,
			nil,
			nil,
			nil,
			true,
			nil,
			nil,
			nil,
			nil,
			true,
			nil,
			nil,
			nil,
			nil,
			true,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			true,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			true,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			true
		}
	},
	{
		no_nil = true,
		description = "Stuffs",
		setting_name = "visual_debug",
		category = "Visual/audio",
		command_list = {
			{
				description = "off",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Albedo XYZ Luminance",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Albedo XYZ Luminance Clipping",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Albedo Lab Luminance",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Albedo Lab Luminance Clipping",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Albedo",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Normals",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Roughness",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Specular",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Metallic",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Ambient Diffuse",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Velocity",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Ambient Occlusion",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Sun Shadow",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"true"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Bloom",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Light Shafts",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Eye Adaptation",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Cascaded shadow map",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Atlased shadow mapping",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Cached atlased shadow mapping",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"true"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"false"
					}
				}
			},
			{
				description = "Static Shadow Map",
				commands = {
					{
						"renderer",
						"settings",
						"debug_rendering",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_xyz_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_lab_luminance_clipping_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_albedo_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_normal_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_roughness_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_specular_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_metallic_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ambient_diffuse_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_velocity_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_ao_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"gbuffer_sun_shadow_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"bloom_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"light_shafts_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"eye_adaptation_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"cached_shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"shadow_atlas_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"sun_shadow_map_visualization",
						"false"
					},
					{
						"renderer",
						"settings",
						"static_shadow_visualization",
						"true"
					}
				}
			}
		}
	},
	{
		description = "Bind to a numpad key and do it.",
		category = "Visual/audio",
		setting_name = "take_screenshot",
		func = function ()
			FrameCapture.screen_shot("console_send", 2)
		end
	},
	{
		description = "Disables all debug draws",
		is_boolean = true,
		setting_name = "disable_debug_draw",
		category = "Visual/audio"
	},
	{
		description = "Draw pretty lines for sound occlusion.",
		setting_name = "visualize_sound_occlusion",
		callback = "visualize_sound_occlusion",
		category = "Visual/audio",
		item_source = {
			["toggle sound occlusion"] = true
		}
	},
	{
		description = "Print out debugging for VoIP",
		is_boolean = true,
		setting_name = "debug_voip",
		category = "Visual/audio"
	},
	{
		description = "Disable VoIP",
		is_boolean = true,
		setting_name = "disable_voip",
		category = "Visual/audio"
	},
	{
		setting_name = "simulate_color_blindness",
		category = "Visual/audio",
		description = BUILD == "dev" and "Enables or disables different color blindness simulations." or "This is only available in dev builds for performance reasons. Switch exe to dev to see the effects of the changes.",
		item_source = {
			common_deuteranomaly = true,
			off = true,
			rare_protanomaly = true,
			very_rare_tritanomaly = true
		},
		func = function (arg_68_0, arg_68_1)
			local var_68_0 = arg_68_0[arg_68_1]
			local var_68_1 = true
			local var_68_2 = 0

			if var_68_0 == "off" then
				var_68_1 = false
			else
				var_68_2 = var_68_0 == "rare_protanomaly" and 0 or var_68_0 == "common_deuteranomaly" and 1 or 2
			end

			if var_68_1 then
				printf("Turning on mode %d of color blindness simulation.", var_68_2)
				Application.set_user_setting("render_settings", "color_blindness_mode", var_68_2)
			else
				printf("Turning off color blindness simulation.")
			end

			Application.set_user_setting("render_settings", "simulate_color_blindness", var_68_1)
			Application.apply_user_settings()
			GlobalShaderFlags.apply_settings()
		end
	},
	{
		description = "This is used to turn off the fading of AI characters that collide with the camera. This is useful when recording cutscenes.",
		is_boolean = true,
		setting_name = "fade_on_camera_ai_collision",
		category = "Replay"
	},
	{
		description = "This is used to turn off the screenspace effects that is aimed at a first person view. This is useful when recording cutscenes.",
		is_boolean = true,
		setting_name = "screen_space_player_camera_reactions",
		category = "Replay"
	},
	{
		no_nil = true,
		description = "Enables chain constraints",
		setting_name = "enable_chain_constraints",
		callback = "enable_chain_constraints",
		category = "Constraints",
		is_boolean = true
	},
	{
		description = "Network debugging",
		is_boolean = true,
		setting_name = "network_debug",
		category = "Network"
	},
	{
		description = "Fakes mismatching network hash",
		is_boolean = true,
		setting_name = "fake_network_hash",
		category = "Network"
	},
	{
		description = "Keeps track of the number of times an rpc send request has been triggered from a certain code row and prints the top 5 most occurring ones. Note: Disregards exclusive local rpc send calls.",
		is_boolean = true,
		setting_name = "rpc_send_count_debug",
		category = "Network"
	},
	{
		description = "Set network logging to Network.MESSAGES on startup",
		is_boolean = true,
		setting_name = "network_log_messages",
		category = "Network"
	},
	{
		description = "Set network logging to Network.SPEW on startup",
		is_boolean = true,
		setting_name = "network_log_spew",
		category = "Network"
	},
	{
		description = "matchmaking debug logging",
		is_boolean = true,
		setting_name = "matchmaking_debug",
		category = "Network"
	},
	{
		no_nil = true,
		description = "Sets latency",
		setting_name = "network_latency",
		category = "Network",
		command_list = {
			{
				description = "off",
				commands = {
					{
						"network",
						"latency",
						"0",
						"0"
					}
				}
			},
			{
				description = "0.05-0.2 seconds",
				commands = {
					{
						"network",
						"latency",
						"0.05",
						"0.2"
					}
				}
			},
			{
				description = "0.2-0.5 seconds",
				commands = {
					{
						"network",
						"latency",
						"0.2",
						"0.5"
					}
				}
			},
			{
				description = "1 seconds",
				commands = {
					{
						"network",
						"latency",
						"1",
						"1"
					}
				}
			},
			{
				description = "1-2 seconds",
				commands = {
					{
						"network",
						"latency",
						"1",
						"2"
					}
				}
			},
			{
				description = "5 seconds",
				commands = {
					{
						"network",
						"latency",
						"5",
						"5"
					}
				}
			},
			{
				description = "15 seconds",
				commands = {
					{
						"network",
						"latency",
						"15",
						"15"
					}
				}
			},
			{
				description = "30 seconds",
				commands = {
					{
						"network",
						"latency",
						"30",
						"30"
					}
				}
			},
			{
				description = "low latency",
				commands = {
					{
						"network",
						"latency",
						"0.010",
						"0.012"
					}
				}
			},
			{
				description = "medium latency",
				commands = {
					{
						"network",
						"latency",
						"0.035",
						"0.040"
					}
				}
			},
			{
				description = "high latency",
				commands = {
					{
						"network",
						"latency",
						"0.070",
						"0.080"
					}
				}
			},
			{
				description = "very high latency",
				commands = {
					{
						"network",
						"latency",
						"0.090",
						"0.100"
					}
				}
			}
		}
	},
	{
		description = "Sets Backend Response Latency",
		setting_name = "backend_response_latency",
		category = "Network",
		item_source = {
			0,
			1,
			2,
			4,
			8,
			16
		},
		custom_item_source_order = function (arg_69_0, arg_69_1)
			for iter_69_0, iter_69_1 in ipairs(arg_69_0) do
				local var_69_0 = iter_69_1

				arg_69_1[#arg_69_1 + 1] = var_69_0
			end
		end,
		func = function (arg_70_0, arg_70_1)
			local var_70_0 = arg_70_0[arg_70_1]

			script_data.backend_response_latency = var_70_0
		end
	},
	{
		no_nil = true,
		description = "Sets packet loss",
		setting_name = "packet_loss",
		category = "Network",
		command_list = {
			{
				description = "off",
				commands = {
					{
						"network",
						"packet_loss",
						"0",
						"0"
					}
				}
			},
			{
				description = "0.5%",
				commands = {
					{
						"network",
						"packet_loss",
						"0.005"
					}
				}
			},
			{
				description = "1%",
				commands = {
					{
						"network",
						"packet_loss",
						"0.01"
					}
				}
			},
			{
				description = "2%",
				commands = {
					{
						"network",
						"packet_loss",
						"0.02"
					}
				}
			}
		}
	},
	{
		no_nil = true,
		description = "Sets bandwidth limits",
		setting_name = "network connection",
		category = "Network",
		command_list = {
			{
				description = "off",
				commands = {
					{
						"network",
						"limit"
					}
				}
			},
			{
				description = "Crappy cable 192/192",
				commands = {
					{
						"network",
						"limit",
						"192",
						"192"
					}
				}
			},
			{
				description = "Crappy cable, 128/512",
				commands = {
					{
						"network",
						"limit",
						"128",
						"512"
					}
				}
			},
			{
				description = "Crappy ADSL, 512/2048",
				commands = {
					{
						"network",
						"limit",
						"512",
						"2048"
					}
				}
			},
			{
				description = "4mbit half duplex",
				commands = {
					{
						"network",
						"limit",
						"2048",
						"2048"
					}
				}
			},
			{
				description = "10mbit half duplex",
				commands = {
					{
						"network",
						"limit",
						"5000",
						"5000"
					}
				}
			}
		}
	},
	{
		description = "Shows the current clock time",
		is_boolean = true,
		setting_name = "network_clock_debug",
		category = "Network"
	},
	{
		description = "Debug Print Profile Package Loading",
		is_boolean = true,
		setting_name = "profile_package_loading_debug",
		category = "Network"
	},
	{
		description = "Debugs connections for the network",
		is_boolean = true,
		setting_name = "network_debug_connections",
		category = "Network"
	},
	{
		description = "Debugs lobbies and matchmaking",
		is_boolean = true,
		setting_name = "debug_lobbies",
		category = "Network"
	},
	{
		description = "Shows lobby data key/values",
		is_boolean = true,
		setting_name = "debug_lobby_data",
		category = "Network"
	},
	{
		description = "Debug draw peer state machine states.",
		is_boolean = true,
		setting_name = "network_draw_peer_states",
		category = "Network"
	},
	{
		description = "Logs information about the profile synchronizer. Best used together with shared_state_debug.",
		is_boolean = true,
		setting_name = "profile_synchronizer_debug_logging",
		category = "Network"
	},
	{
		description = "Allows host to query himself. Fixes the time_left of votes to 1s.",
		is_boolean = true,
		setting_name = "debug_vote_manager",
		category = "Network"
	},
	{
		description = "Do not check the network hash when joining a game as a client.",
		is_boolean = true,
		setting_name = "do_not_check_network_hash_when_joining",
		category = "Network"
	},
	{
		description = "Do not blacklist lobbies when exiting/cancelling as a client.",
		is_boolean = true,
		setting_name = "do_not_add_broken_lobby_client",
		category = "Network"
	},
	{
		description = "Debug All Contexts",
		is_boolean = true,
		setting_name = "dialogue_debug_all_contexts",
		category = "Dialogue"
	},
	{
		description = "Debug Last Query",
		is_boolean = true,
		setting_name = "dialogue_debug_last_query",
		category = "Dialogue"
	},
	{
		description = "Debug Print Successful Queries",
		is_boolean = true,
		setting_name = "dialogue_debug_last_played_query",
		category = "Dialogue"
	},
	{
		description = "Debug Print Queries",
		is_boolean = true,
		setting_name = "dialogue_debug_queries",
		category = "Dialogue"
	},
	{
		description = "Debug show Proximities",
		is_boolean = true,
		setting_name = "dialogue_debug_proximity_system",
		category = "Dialogue"
	},
	{
		description = "Visualize lookat system",
		is_boolean = true,
		setting_name = "dialogue_debug_lookat",
		category = "Dialogue"
	},
	{
		description = "Debug subtitles",
		is_boolean = true,
		setting_name = "subtitle_debug",
		category = "Dialogue"
	},
	{
		description = "Loop through active dialogue rules and filter a single one. No other rules will be loaded. (Requires restart)",
		setting_name = "filter_single_dialogue_rule",
		category = "Dialogue",
		item_source = {
			"[clear value]"
		},
		load_items_source_func = function (arg_71_0)
			table.clear(arg_71_0)

			local var_71_0 = Managers.state.entity:system("dialogue_system")

			if var_71_0 then
				local var_71_1 = var_71_0:tagquery_database().rule_id_mapping

				for iter_71_0 = 1, #var_71_1 do
					arg_71_0[iter_71_0] = var_71_1[iter_71_0].name
				end
			end

			table.insert(arg_71_0, 1, "[clear value]")
		end
	},
	{
		description = "Displays loaded dialogue files and filter a single one. No other files will be loaded on level load. (Requires restart)",
		setting_name = "filter_single_dialogue_file",
		category = "Dialogue",
		item_source = {},
		load_items_source_func = function (arg_72_0)
			table.clear(arg_72_0)

			if Managers.state.entity:system("dialogue_system") then
				local var_72_0 = Managers.state.entity:system("dialogue_system"):tagquery_loader().debug_loaded_files

				if var_72_0 then
					for iter_72_0 in pairs(var_72_0) do
						arg_72_0[#arg_72_0 + 1] = string.match(iter_72_0, "^.+/(.+)$")
					end

					table.sort(arg_72_0)
				end
			end

			table.insert(arg_72_0, 1, "[clear value]")
		end
	},
	{
		setting_name = "debug_dialogue_files",
		description = "Used to debug dialog files, facial expressions and missing vo/subtitles. To skip use: DebugVo.jump_to(('line_number/line_id')",
		category = "Dialogue",
		item_source = {},
		load_items_source_func = function (arg_73_0)
			table.clear(arg_73_0)

			local var_73_0 = Managers.state.entity:system("dialogue_system")

			if var_73_0 then
				local var_73_1 = var_73_0:tagquery_loader().debug_loaded_files

				if var_73_1 then
					for iter_73_0 in pairs(var_73_1) do
						arg_73_0[#arg_73_0 + 1] = string.match(iter_73_0, "^.+/(.+)$")
					end

					table.sort(arg_73_0)
				end
			end

			table.insert(arg_73_0, 1, "[clear value]")
		end,
		func = function (arg_74_0, arg_74_1)
			Managers.state.entity:system("dialogue_system"):debug_vo_by_file(arg_74_0[arg_74_1], false)
		end
	},
	{
		description = "Missing vo sound event triggers an error sound",
		is_boolean = true,
		setting_name = "dialogue_debug_missing_vo_trigger_error_sound",
		category = "Dialogue"
	},
	{
		description = "Enables Text-To-Speech for ALL dialogues",
		is_boolean = true,
		setting_name = "debug_text_to_speech_forced",
		category = "Dialogue"
	},
	{
		description = "Enables Text-To-Speech for dialogues with missing VO",
		is_boolean = true,
		setting_name = "debug_text_to_speech_missing",
		category = "Dialogue"
	},
	{
		description = "Disable auto block on input loss",
		is_boolean = true,
		setting_name = "disable_auto_block",
		category = "Input"
	},
	{
		description = "Debug print input device statuses",
		is_boolean = true,
		setting_name = "input_debug_device_state",
		category = "Input"
	},
	{
		description = "Debug input filters output",
		is_boolean = true,
		setting_name = "input_debug_filters",
		category = "Input"
	},
	{
		description = "Set to false to disable cursor clipping.",
		is_boolean = true,
		setting_name = "clip_cursor",
		category = "UI"
	},
	{
		description = "Enables additional assertions to help catch errors in UI code. Only has an effect when DEBUG is enabled.",
		is_boolean = true,
		setting_name = "strict_ui_checks",
		category = "UI"
	},
	{
		description = "Reverts back to the old Deus Map UI in case the new one is buggy",
		is_boolean = true,
		setting_name = "FEATURE_old_map_ui",
		category = "UI"
	},
	{
		description = "Debug UI Hover elements",
		is_boolean = true,
		setting_name = "ui_debug_hover",
		category = "UI"
	},
	{
		description = "Enable/Disable the Lorebook (need to restart level to spawn page pickups)",
		is_boolean = true,
		setting_name = "lorebook_enabled",
		category = "UI"
	},
	{
		description = "Debug UI Scenegraph Areas and Sizes",
		is_boolean = true,
		setting_name = "ui_debug_scenegraph",
		category = "UI"
	},
	{
		description = "Debug UI Pixeldistance (by keybinding",
		is_boolean = true,
		setting_name = "ui_debug_pixeldistance",
		category = "UI"
	},
	{
		description = "Debug ui textures.",
		is_boolean = true,
		setting_name = "ui_debug_draw_texture",
		category = "UI"
	},
	{
		description = "Disable UI Rendering.",
		is_boolean = true,
		setting_name = "disable_ui",
		category = "UI"
	},
	{
		description = "Disable Outlines.",
		category = "UI",
		setting_name = "disable_outlines",
		callback = "disable_outlines",
		is_boolean = true
	},
	{
		description = "Disables the screens at the end of the level, getting you directly back to the inn.",
		is_boolean = true,
		setting_name = "disable_end_screens",
		category = "UI"
	},
	{
		description = "Disable Tutorial UI Rendering.",
		is_boolean = true,
		setting_name = "disable_tutorial_ui",
		category = "UI"
	},
	{
		description = "Disable Info Slate UI Rendering.",
		is_boolean = true,
		setting_name = "disable_info_slate_ui",
		category = "UI"
	},
	{
		description = "Disables the loading icon.",
		is_boolean = true,
		setting_name = "disable_loading_icon",
		category = "UI"
	},
	{
		description = "Disables the Water Mark if present.",
		is_boolean = true,
		setting_name = "disable_water_mark",
		category = "UI"
	},
	{
		description = "Looks through all the localizations and selects the longest text for each item.",
		is_boolean = true,
		setting_name = "show_longest_localizations",
		category = "UI"
	},
	{
		description = "Disable localization and show the source strings instead. Useful to find the string being used somewhere.",
		is_boolean = true,
		setting_name = "disable_localization",
		category = "UI"
	},
	{
		description = "Disables rainbow colorization of unlocalized strings to prevent eyesore.",
		is_boolean = true,
		setting_name = "disable_colorize_unlocalized_strings",
		category = "UI"
	},
	{
		description = "Turns off positive reinforcement UI",
		is_boolean = true,
		setting_name = "disable_reinforcement_ui",
		category = "UI"
	},
	{
		description = "Switches reinforcement UI local sound",
		setting_name = "reinforcement_ui_local_sound",
		category = "UI",
		item_source = {
			hud_achievement_unlock_01 = true,
			hud_achievement_unlock_03 = true,
			hud_info = true,
			hud_achievement_unlock_02 = true
		}
	},
	{
		description = "Toggles reinforcement UI remote sound",
		is_boolean = true,
		setting_name = "enable_reinforcement_ui_remote_sound",
		category = "UI"
	},
	{
		description = "The whole menu is unlocked, there is no end to the possibilities!",
		is_boolean = true,
		setting_name = "pause_menu_full_access",
		category = "UI"
	},
	{
		description = "Enables option to give yourself lootboxes for free!",
		is_boolean = true,
		setting_name = "debug_loot_opening",
		category = "UI"
	},
	{
		description = "If inventory is open it will cycle select items automatically",
		is_boolean = true,
		setting_name = "debug_cycle_select_inventory_item",
		category = "UI"
	},
	{
		description = "Enables or disables detailed tooltips on weapns, accessable by pressing SHIFT or CTRL",
		is_boolean = true,
		setting_name = "enable_detailed_tooltips",
		category = "UI"
	},
	{
		description = "Always allow buying bundles (even if you already own them).",
		is_boolean = true,
		setting_name = "always_allow_buying_bundles",
		category = "UI"
	},
	{
		description = "Show all news feed items when entering the keep.",
		is_boolean = true,
		setting_name = "show_all_news_feed_items",
		category = "UI"
	},
	{
		description = "Marks all shop items as unseen.",
		category = "UI",
		setting_name = "mark_all_unseen",
		func = function ()
			PlayerData.seen_shop_items = {}

			Managers.save:auto_save(SaveFileName, SaveData)
		end
	},
	{
		description = "Disables position lookup validation. Can turn this on for extra performance.",
		is_boolean = true,
		setting_name = "disable_debug_position_lookup",
		category = "Misc"
	},
	{
		description = "Will paste the content and engine revision to the user's clipboard.",
		is_boolean = true,
		setting_name = "paste_revision_to_clipboard",
		category = "Misc"
	},
	{
		description = "Enable logging of telemetry debugging information.",
		is_boolean = true,
		setting_name = "debug_telemetry",
		category = "Misc"
	},
	{
		description = "Enable logging of leaderboard debugging information.",
		is_boolean = true,
		setting_name = "debug_leaderboard",
		category = "Misc"
	},
	{
		description = "Enable logging of the forge",
		is_boolean = true,
		setting_name = "forge_debug",
		category = "Misc"
	},
	{
		description = "Enables logging for the package manager",
		is_boolean = true,
		setting_name = "package_debug",
		category = "Misc"
	},
	{
		description = "Adds a delay to package loading requests",
		setting_name = "package_loading_latency",
		category = "Network",
		item_source = {
			"[clear value]",
			{
				0.05,
				0.2
			},
			{
				0.2,
				0.5
			},
			1,
			{
				1,
				2
			},
			5,
			15,
			30
		},
		custom_item_source_order = function (arg_76_0, arg_76_1)
			for iter_76_0, iter_76_1 in ipairs(arg_76_0) do
				local var_76_0 = iter_76_1

				if type(var_76_0) == "string" then
					arg_76_1[iter_76_0] = var_76_0
				elseif type(var_76_0) == "table" then
					arg_76_1[iter_76_0] = {
						var_76_0[1],
						var_76_0[2] or var_76_0[1]
					}
				else
					arg_76_1[iter_76_0] = {
						var_76_0,
						var_76_0
					}
				end
			end
		end,
		item_display_func = function (arg_77_0, arg_77_1, arg_77_2)
			if type(arg_77_0) == "string" then
				return arg_77_0
			elseif type(arg_77_0) == "table" then
				return string.format("%s - %s seconds", arg_77_0[1], arg_77_0[2] or arg_77_0[1])
			else
				return string.format("%s second%s", arg_77_0, arg_77_0 == 1 and "s" or "")
			end
		end,
		func = function (arg_78_0, arg_78_1)
			local var_78_0 = arg_78_0[arg_78_1]

			if var_78_0 == "[clear value]" then
				script_data.package_loading_latency = nil
			else
				script_data.package_loading_latency = type(var_78_0) == "table" and var_78_0 or {
					var_78_0,
					var_78_0
				}
			end
		end
	},
	{
		description = "Shows currently loaded levels and the level_seed.",
		is_boolean = true,
		setting_name = "debug_level_packages",
		category = "Misc"
	},
	{
		description = "Disable luajit ",
		category = "Misc",
		setting_name = "luajit_disabled",
		callback = "update_using_luajit",
		is_boolean = true
	},
	{
		description = "Restart the game to view dice chances",
		is_boolean = true,
		setting_name = "dice_chance_simulation",
		category = "Misc"
	},
	{
		description = "Shows a rect in topcenter of the current color of lightfx. Restart required",
		is_boolean = true,
		setting_name = "debug_lightfx",
		category = "Misc"
	},
	{
		description = "Spawns all player characters base and husk units, and prints to console if any unit is missing any hit-zone actors etc. Units will spawn in base/husk pairs at (0,0,0) upwards into the sky. They will not be removed.",
		category = "Misc",
		setting_name = "check_player_base_and_husk_hitzones",
		func = function ()
			CHECK_PLAYER_HITZONES()
		end
	},
	{
		description = "Throttles FPS to a value. Default means no throttle. Note that this doesn't automatically gets set at startup.",
		setting_name = "force_limit_fps",
		category = "Misc",
		item_source = {
			default = true,
			throttle_fps_60 = true,
			throttle_fps_15 = true,
			throttle_fps_1 = true,
			throttle_fps_10 = true,
			throttle_fps_45 = true,
			throttle_fps_25 = true,
			throttle_fps_20 = true,
			throttle_fps_30 = true,
			throttle_fps_5 = true
		},
		func = function (arg_80_0, arg_80_1)
			local var_80_0 = arg_80_0[arg_80_1]
			local var_80_1 = 60

			if var_80_0 == "default" then
				Application.set_time_step_policy("no_throttle")

				return
			elseif var_80_0 == "throttle_fps_1" then
				var_80_1 = 1
			elseif var_80_0 == "throttle_fps_5" then
				var_80_1 = 5
			elseif var_80_0 == "throttle_fps_10" then
				var_80_1 = 10
			elseif var_80_0 == "throttle_fps_15" then
				var_80_1 = 15
			elseif var_80_0 == "throttle_fps_20" then
				var_80_1 = 20
			elseif var_80_0 == "throttle_fps_25" then
				var_80_1 = 25
			elseif var_80_0 == "throttle_fps_30" then
				var_80_1 = 30
			elseif var_80_0 == "throttle_fps_45" then
				var_80_1 = 45
			elseif var_80_0 == "throttle_fps_60" then
				var_80_1 = 60
			end

			Application.set_time_step_policy("throttle", var_80_1)
		end
	},
	{
		description = "Don't show dark background behind debug texts.",
		is_boolean = true,
		setting_name = "hide_debug_text_background",
		category = "Misc"
	},
	{
		description = "Will log transitions fade in/fade out",
		is_boolean = true,
		setting_name = "debug_transition_manager",
		category = "Misc"
	},
	{
		description = "Disable that the vortex can attract anything / swirl anything around in the air",
		is_boolean = true,
		setting_name = "disable_vortex_attraction",
		category = "Misc"
	},
	{
		no_nil = true,
		description = "Sets the time that a stall must take in order for it to be logged. Default is 0.1 seconds.",
		setting_name = "stall_time",
		category = "Performance",
		command_list = {
			{
				description = "default",
				commands = {
					{
						"profiler",
						"stall",
						0.1
					}
				}
			},
			{
				description = "0.05",
				commands = {
					{
						"profiler",
						"stall",
						0.05
					}
				}
			},
			{
				description = "0.2",
				commands = {
					{
						"profiler",
						"stall",
						0.2
					}
				}
			},
			{
				description = "0.5",
				commands = {
					{
						"profiler",
						"stall",
						0.5
					}
				}
			},
			{
				description = "1",
				commands = {
					{
						"profiler",
						"stall",
						1
					}
				}
			},
			{
				description = "10",
				commands = {
					{
						"profiler",
						"stall",
						10
					}
				}
			}
		}
	},
	{
		description = "Enable logging of mismatched profiling scopes.",
		is_boolean = true,
		setting_name = "debug_profiling_scopes",
		category = "Performance"
	},
	{
		description = "Enable visual 'profiling' of function calls.",
		is_boolean = true,
		setting_name = "profile_function_calls",
		category = "Performance"
	},
	{
		description = "Enable asserts on mismatched profiling scopes.",
		is_boolean = true,
		setting_name = "validate_profiling_scopes",
		category = "Performance"
	},
	{
		description = "Disable lodding of animation bones.",
		is_boolean = true,
		setting_name = "bone_lod_disable",
		category = "Performance"
	},
	{
		description = "Enable floating text over AI head which states the animation that animation merge is currently enabled for.",
		is_boolean = true,
		setting_name = "animation_merge_debug",
		category = "Performance"
	},
	{
		no_nil = false,
		description = "Gamma (2.2 default)",
		setting_name = "Gamma",
		category = "Render Settings",
		bitmap = "settings_debug_gamma_correction",
		bitmap_size = 512,
		command_list = {
			{
				description = "1.0",
				commands = {
					{
						"renderer",
						"settings",
						"gamma",
						"1.0"
					}
				}
			},
			{
				description = "2.0",
				commands = {
					{
						"renderer",
						"settings",
						"gamma",
						"2.0"
					}
				}
			},
			{
				description = "2.1",
				commands = {
					{
						"renderer",
						"settings",
						"gamma",
						"2.1"
					}
				}
			},
			{
				description = "2.2",
				commands = {
					{
						"renderer",
						"settings",
						"gamma",
						"2.2"
					}
				}
			},
			{
				description = "2.3",
				commands = {
					{
						"renderer",
						"settings",
						"gamma",
						"2.3"
					}
				}
			},
			{
				description = "2.4",
				commands = {
					{
						"renderer",
						"settings",
						"gamma",
						"2.4"
					}
				}
			},
			{
				description = "3.0",
				commands = {
					{
						"renderer",
						"settings",
						"gamma",
						"3.0"
					}
				}
			},
			{
				description = "3.5",
				commands = {
					{
						"renderer",
						"settings",
						"gamma",
						"3.5"
					}
				}
			},
			{
				description = "4.0",
				commands = {
					{
						"renderer",
						"settings",
						"gamma",
						"4.0"
					}
				}
			},
			{
				description = "4.5",
				commands = {
					{
						"renderer",
						"settings",
						"gamma",
						"4.5"
					}
				}
			},
			{
				description = "5.0",
				commands = {
					{
						"renderer",
						"settings",
						"gamma",
						"5.0"
					}
				}
			}
		}
	},
	{
		no_nil = false,
		description = "Enabled is default",
		setting_name = "Global Shadows",
		category = "Render Settings",
		command_list = {
			{
				description = "Sun Shadow Enabled",
				commands = {
					{
						"renderer",
						"settings",
						"sun_shadows",
						"true"
					}
				}
			},
			{
				description = "Sun Shadow Disabled",
				commands = {
					{
						"renderer",
						"settings",
						"sun_shadows",
						"false"
					}
				}
			}
		}
	},
	{
		no_nil = false,
		description = "Enabled is default. You'll need to restart game/engine.",
		setting_name = "Local Light Shadows",
		category = "Render Settings",
		command_list = {
			{
				description = "Local Light Shadow Enabled",
				commands = {
					{
						"renderer",
						"settings",
						"deferred_local_lights_cast_shadows",
						"true"
					},
					{
						"renderer",
						"settings",
						"forward_local_lights_cast_shadows",
						"true"
					}
				}
			},
			{
				description = "Local Light Shadow Disabled",
				commands = {
					{
						"renderer",
						"settings",
						"deferred_local_lights_cast_shadows",
						"false"
					},
					{
						"renderer",
						"settings",
						"forward_local_lights_cast_shadows",
						"false"
					}
				}
			}
		}
	},
	{
		no_nil = false,
		description = "Enabled is default",
		setting_name = "AO Enable/Disable",
		category = "Render Settings",
		command_list = {
			{
				description = "Enabled",
				commands = {
					{
						"renderer",
						"settings",
						"ao_enabled",
						"true"
					}
				}
			},
			{
				description = "Disabled",
				commands = {
					{
						"renderer",
						"settings",
						"ao_enabled",
						"false"
					}
				}
			}
		}
	},
	{
		no_nil = false,
		description = "Full is default. You'll need to restart game/engine.",
		setting_name = "AO Resolution",
		category = "Render Settings",
		command_list = {
			{
				description = "Full Res",
				commands = {
					{
						"renderer",
						"settings",
						"ao_half_res",
						"false"
					}
				}
			},
			{
				description = "Half Res",
				commands = {
					{
						"renderer",
						"settings",
						"ao_half_res",
						"true"
					}
				}
			}
		}
	},
	{
		description = "You have to restart the game for the settings to take effect",
		category = "Render Settings",
		setting_name = "Set high texture quality",
		func = function ()
			DebugScreen.set_texture_quality(0)
		end
	},
	{
		description = "You have to restart the game for the settings to take effect",
		category = "Render Settings",
		setting_name = "Set low texture quality",
		func = function ()
			DebugScreen.set_texture_quality(3)
		end
	},
	{
		description = "Don't render the game if the window is not focused",
		is_boolean = true,
		setting_name = "only_render_if_window_focused",
		category = "Render Settings"
	},
	{
		description = "Show bot debug visualizers",
		is_boolean = true,
		setting_name = "ai_bots_debug",
		category = "Bots"
	},
	{
		description = "Displays statistics for bots",
		is_boolean = true,
		setting_name = "ai_bots_debug_behavior",
		category = "Bots"
	},
	{
		description = "Make bots not see/attack anyone",
		is_boolean = true,
		setting_name = "ai_bots_disable_perception",
		category = "Bots"
	},
	{
		description = "Bot won't shot at enemy players, but still attack ai enemies. Versus Specific",
		is_boolean = true,
		setting_name = "ai_bots_disable_player_range_attacks",
		category = "Bots"
	},
	{
		description = "Make bots not dodge attacks",
		is_boolean = true,
		setting_name = "ai_bots_disable_dodging",
		category = "Bots"
	},
	{
		description = "Bot won't melee at enemy players, but still attack ai enemies. Versus Specific",
		is_boolean = true,
		setting_name = "ai_bots_disable_player_melee_attacks",
		category = "Bots"
	},
	{
		description = "THis will fill the Bot won't melee at enemy players, but still attack ai enemies. Versus Specific",
		is_boolean = true,
		setting_name = "disable_versus_darkpact_bots",
		category = "Bots"
	},
	{
		description = "Writes out the spawn status of darkpact bots on screen.",
		is_boolean = true,
		setting_name = "show_versus_darkpact_bot_debug",
		category = "Bots"
	},
	{
		description = "Bots will only use ranged attacks.",
		is_boolean = true,
		setting_name = "ai_bots_disable_ranged_attacks",
		category = "Bots"
	},
	{
		description = "Bots will only use melee attacks.",
		is_boolean = true,
		setting_name = "ai_bots_disable_melee_attacks",
		category = "Bots"
	},
	{
		description = "Bots use ranged attacks as much as possible.",
		is_boolean = true,
		setting_name = "ai_bots_ranged_attack_always_valid",
		category = "Bots"
	},
	{
		description = "Enable debug printing related to bot weapons.",
		is_boolean = true,
		setting_name = "ai_bots_weapon_debug",
		category = "Bots"
	},
	{
		description = "Enable debug information related to bot orders - press t to order bot to pickup item using raycast.",
		is_boolean = true,
		setting_name = "ai_bots_order_debug",
		category = "Bots"
	},
	{
		description = "Shows which inputs that the bot is doing at the moment.",
		is_boolean = true,
		setting_name = "ai_bots_input_debug",
		category = "Bots"
	},
	{
		description = "Visualizes the AoE threat that the bots are trying to avoid.",
		is_boolean = true,
		setting_name = "ai_bots_aoe_threat_debug",
		category = "Bots"
	},
	{
		description = "Visualizes nearby breakable smart objects for the selected bot.",
		is_boolean = true,
		setting_name = "ai_bots_proximity_breakables_debug",
		category = "Bots"
	},
	{
		description = "Bots will not follow player.",
		is_boolean = true,
		setting_name = "bots_dont_follow",
		category = "Bots"
	},
	{
		description = "Disables automatic spawning of bots",
		is_boolean = true,
		setting_name = "ai_bots_disabled",
		category = "Bots"
	},
	{
		description = "Enables bots on Weaves",
		is_boolean = true,
		setting_name = "enable_bots_in_weaves",
		category = "Bots"
	},
	{
		description = "Disables bot usage of career abilities.",
		is_boolean = true,
		setting_name = "ai_bots_career_abilities_disabled",
		category = "Bots"
	},
	{
		description = "Will cap the total number of bots in game",
		setting_name = "cap_num_bots",
		category = "Bots",
		item_source = {
			0,
			1,
			2
		}
	},
	{
		description = "Next spawned bot will use this profile if available (Tip: Toggle ai_bots_disabled on/off).",
		setting_name = "wanted_bot_profile",
		category = "Bots",
		item_source = {
			witch_hunter = true,
			empire_soldier = true,
			dwarf_ranger = true,
			wood_elf = true,
			bright_wizard = true
		}
	},
	{
		description = "Next spawned bot will use this career index, clear to use the last choosen one (Tip: Toggle ai_bots_disabled on/off).",
		setting_name = "wanted_bot_career_index",
		category = "Bots",
		item_source = {
			item_source = {
				1,
				2,
				3
			}
		}
	},
	{
		description = "Only works together with wanted_bot_profile. Will make all spawned the same as defined in wanted_bot_profile. (Might need to toggle_ai_bots on/off.)",
		is_boolean = true,
		setting_name = "allow_same_bots",
		category = "Bots"
	},
	{
		no_nil = false,
		description = "",
		setting_name = "Perfhud Artist",
		category = "Perfhud",
		command_list = {
			{
				description = "Default",
				commands = {
					{
						"perfhud",
						"artist"
					}
				}
			},
			{
				description = "Objects",
				commands = {
					{
						"perfhud",
						"artist",
						"objects"
					}
				}
			},
			{
				description = "Lighting",
				commands = {
					{
						"perfhud",
						"artist",
						"lighting"
					}
				}
			},
			{
				description = "Post Processing",
				commands = {
					{
						"perfhud",
						"artist",
						"post_processing"
					}
				}
			},
			{
				description = "GUI",
				commands = {
					{
						"perfhud",
						"artist",
						"gui"
					}
				}
			}
		}
	},
	{
		no_nil = false,
		description = "",
		setting_name = "Perfhud Memory",
		category = "Perfhud",
		command_list = {
			{
				description = "Memory",
				commands = {
					{
						"perfhud",
						"memory"
					}
				}
			}
		}
	},
	{
		description = "Performance Manager Debug",
		is_boolean = true,
		setting_name = "performance_debug",
		category = "Perfhud"
	},
	{
		description = "Sets the amount of logging on the backend",
		setting_name = "backend_logging_level",
		category = "Backend",
		item_source = {
			off = true,
			verbose = true,
			normal = true
		},
		func = function ()
			Managers.backend:refresh_log_level()
		end
	},
	{
		description = "Connect to a backend running locally. Can be set to a string to use that as a URL.",
		is_boolean = true,
		setting_name = "backend_base_url",
		category = "Backend"
	},
	{
		description = "Unlock all careers",
		is_boolean = true,
		setting_name = "unlock_all_careers",
		category = "Progression"
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		is_boolean = true,
		setting_name = "unlock_full_keep",
		category = "Progression"
	},
	{
		description = "Win",
		close_when_selected = true,
		setting_name = "Complete current level",
		propagate_to_server = true,
		category = "Progression",
		func = function ()
			Managers.state.game_mode:complete_level()
		end
	},
	{
		description = "End the current round (versus)",
		close_when_selected = true,
		setting_name = "End Round",
		propagate_to_server = true,
		category = "Versus",
		func = function ()
			Managers.state.game_mode:complete_level()

			script_data.disable_gamemode_end = nil
			script_data.disable_gamemode_end_hero_check = nil
		end
	},
	{
		description = "Automatically complete rounds",
		never_save = true,
		setting_name = "auto_complete_rounds",
		category = "Versus",
		propagate_to_server = true,
		is_boolean = true,
		close_when_selected = true
	},
	{
		description = "Displays information about early win",
		is_boolean = true,
		setting_name = "debug_early_win",
		category = "Versus"
	},
	{
		description = "Force start the connected dedicated server",
		close_when_selected = true,
		setting_name = "Force Start Dedicated Server",
		category = "Versus",
		func = function ()
			if Managers.mechanism:get_state() ~= "inn" then
				Debug.sticky_text("Tried force starting a dedicated server but was not in the keep.")

				return
			end

			local var_86_0 = Managers.mechanism:dedicated_server_peer_id()

			if not PEER_ID_TO_CHANNEL[var_86_0] then
				Debug.sticky_text("Tried force starting a dedicated server but is not connected to one.")

				return
			end

			Managers.mechanism:game_mechanism():force_start_dedicated_server()
		end
	},
	{
		description = "Skip the startup timer and start the round immediately",
		close_when_selected = true,
		setting_name = "Start Round",
		category = "Versus",
		func = function ()
			if Managers.level_transition_handler:in_hub_level() then
				return false, "Failed to start round - Match not started"
			end

			Managers.state.game_mode:round_started()

			return true, "Round started!"
		end
	},
	{
		description = "Restart",
		close_when_selected = true,
		setting_name = "Retry current level",
		category = "Progression",
		func = function ()
			Managers.state.game_mode:retry_level()
		end
	},
	{
		description = "Lose",
		close_when_selected = true,
		setting_name = "Fail current level",
		category = "Progression",
		func = function ()
			Managers.state.game_mode:fail_level()
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Complete act \"prologue\"",
		func = function ()
			LevelUnlockUtils.debug_completed_act_levels("prologue", true)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Uncomplete act \"prologue\"",
		func = function ()
			LevelUnlockUtils.debug_completed_act_levels("prologue", false)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Complete act \"act_1\"",
		func = function ()
			LevelUnlockUtils.debug_completed_act_levels("act_1", true)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Uncomplete act \"act_1\"",
		func = function ()
			LevelUnlockUtils.debug_completed_act_levels("act_1", false)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Complete act \"act_2\"",
		func = function ()
			LevelUnlockUtils.debug_completed_act_levels("act_2", true)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Uncomplete act \"act_2\"",
		func = function ()
			LevelUnlockUtils.debug_completed_act_levels("act_2", false)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Complete act \"act_3\"",
		func = function ()
			LevelUnlockUtils.debug_completed_act_levels("act_3", true)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Uncomplete act \"act_3\"",
		func = function ()
			LevelUnlockUtils.debug_completed_act_levels("act_3", false)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Complete act \"act_4\"",
		func = function ()
			LevelUnlockUtils.debug_completed_act_levels("act_4", true)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Uncomplete act \"act_4\"",
		func = function ()
			LevelUnlockUtils.debug_completed_act_levels("act_4", false)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Set completed game difficulty Normal",
		func = function ()
			LevelUnlockUtils.debug_set_completed_game_difficulty(2)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Set completed game difficulty Hard",
		func = function ()
			LevelUnlockUtils.debug_set_completed_game_difficulty(3)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Set completed game difficulty Nightmare",
		func = function ()
			LevelUnlockUtils.debug_set_completed_game_difficulty(4)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Set completed game difficulty Cataclysm",
		func = function ()
			LevelUnlockUtils.debug_set_completed_game_difficulty(5)
		end
	},
	{
		description = " ",
		category = "Progression",
		setting_name = "Complete DLC Celebrate",
		func = function ()
			LevelUnlockUtils.debug_complete_level("dlc_celebrate_crawl")

			local var_104_0 = Managers.world:world("level_world")

			LevelHelper:flow_event(var_104_0, "lua_unlock_challenge_debug_event")
		end
	},
	{
		setting_name = "Add Experience",
		description = "Adds Experience to your account.",
		category = "Progression",
		item_source = {},
		load_items_source_func = function (arg_105_0)
			table.clear(arg_105_0)

			arg_105_0[1] = 1
			arg_105_0[2] = 10
			arg_105_0[3] = 100
			arg_105_0[4] = 1000
			arg_105_0[5] = 10000
			arg_105_0[6] = 60850
		end,
		func = function (arg_106_0, arg_106_1)
			local var_106_0 = Managers.backend
			local var_106_1 = arg_106_0[arg_106_1] or 1
			local var_106_2 = Managers.player:local_player(1):profile_index()
			local var_106_3 = SPProfiles[var_106_2].display_name

			local function var_106_4(arg_107_0)
				local var_107_0 = arg_107_0.FunctionResult
				local var_107_1 = var_106_0:get_interface("hero_attributes")

				var_107_1:set(var_106_3, "experience", var_107_0.data[var_106_3 .. "_experience"])
				var_107_1:set(var_106_3, "experience_pool", var_107_0.data[var_106_3 .. "_experience_pool"])
			end

			local var_106_5 = {
				FunctionName = "devAddExperience",
				FunctionParameter = {
					hero = var_106_3,
					experience = var_106_1
				}
			}

			var_106_0._backend_mirror:request_queue():enqueue(var_106_5, var_106_4, false)
		end
	},
	{
		description = "Sets experience to 0.",
		category = "Progression",
		setting_name = "Reset Level",
		func = function ()
			local var_108_0 = Managers.backend
			local var_108_1 = Managers.player:local_player(1):profile_index()
			local var_108_2 = SPProfiles[var_108_1].display_name
			local var_108_3 = var_108_0:get_interface("hero_attributes")

			local function var_108_4(arg_109_0)
				assert(arg_109_0.FunctionResult.data, arg_109_0.FunctionResult.reason)
				var_108_3:set(var_108_2, "experience", arg_109_0.FunctionResult.data[var_108_2 .. "_experience"])
			end

			local var_108_5 = {
				FunctionName = "devSetExperience",
				FunctionParameter = {
					experience = 1,
					hero = var_108_2
				}
			}

			var_108_0._backend_mirror:request_queue():enqueue(var_108_5, var_108_4, false)
		end
	},
	{
		description = "Will add experience to above prestige requirements",
		category = "Progression",
		setting_name = "Level up above prestige level requirements",
		func = function ()
			local var_110_0 = Managers.backend
			local var_110_1 = Managers.player:local_player(1):profile_index()
			local var_110_2 = SPProfiles[var_110_1].display_name

			local function var_110_3(arg_111_0)
				local var_111_0 = arg_111_0.FunctionResult

				var_110_0:get_interface("hero_attributes"):set(var_110_2, "experience", var_111_0.data[var_110_2 .. "_experience"])
				Debug.load_level("inn_level")
			end

			local var_110_4 = {
				FunctionName = "devSetExperience",
				FunctionParameter = {
					experience = 1000000,
					hero = var_110_2
				}
			}

			var_110_0._backend_mirror:request_queue():enqueue(var_110_4, var_110_3, false)
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Reset prestige level",
		func = function ()
			local var_112_0 = Managers.player:local_player(1):profile_index()
			local var_112_1 = SPProfiles[var_112_0]

			Managers.backend:get_interface("hero_attributes"):set(var_112_1.display_name, "prestige", 0)
			Debug.load_level("inn_level")
		end
	},
	{
		description = "You have to reload the inn for the setting to take effect",
		category = "Progression",
		setting_name = "Wipe all progression(used for prestige)",
		func = function ()
			LevelUnlockUtils.set_all_acts_incompleted()
		end
	},
	{
		description = "Set sum of best power levels, ignoring actual value in the backend",
		category = "Progression",
		setting_name = "sum_of_best_power_levels_override",
		item_source = {
			0,
			50,
			100,
			150,
			200,
			250,
			300,
			350,
			400,
			450,
			500,
			550,
			600,
			650,
			700,
			750,
			800,
			850,
			900,
			950,
			1000,
			1050,
			1100,
			1150,
			1200,
			1250,
			1300
		},
		custom_item_source_order = function (arg_114_0, arg_114_1)
			for iter_114_0, iter_114_1 in ipairs(arg_114_0) do
				local var_114_0 = iter_114_1

				arg_114_1[#arg_114_1 + 1] = var_114_0
			end
		end
	},
	{
		description = "Override the returned value to flow node \"Leader Achievement Completed\"",
		is_boolean = true,
		setting_name = "achievement_completed_flow_override",
		category = "Progression"
	},
	{
		description = "Override the returned value to flow node \"Leader Has DLC\" when checking for the Collectors Edition (Pre Order) DLC",
		is_boolean = true,
		setting_name = "has_dlc_pre_order_flow_override",
		category = "Progression"
	},
	{
		description = "Disables the hero power requirements for difficulties",
		is_boolean = true,
		setting_name = "disable_hero_power_requirement",
		category = "Progression"
	},
	{
		description = "Completely resets all stats for local player. Requires that the player is spawned inside a level. REQUIRES RESTART AFTERWARDS!",
		category = "Progression",
		setting_name = "reset_statistics_database",
		func = function ()
			print("Starting statistics reset!")
			Managers.backend:get_interface("statistics"):reset()
		end
	},
	{
		description = "Shows test buffs in the buff tray for debugging.",
		is_boolean = true,
		setting_name = "debug_buff_ui",
		category = "HUD"
	},
	{
		description = "Show more things in the player list UI right-hand panel for debugging.",
		is_boolean = true,
		setting_name = "debug_player_list_ui",
		category = "HUD"
	},
	{
		description = "Will display all properties on the player",
		is_boolean = true,
		setting_name = "debug_show_player_properties",
		category = "HUD"
	},
	{
		description = "Will display all properties on the player, all = all properties, limited = buffs chosen by QA",
		setting_name = "debug_show_player_active_buffs",
		category = "HUD",
		is_boolean = true,
		item_source = {
			all = "all",
			limited = "limited"
		}
	},
	{
		no_nil = false,
		setting_name = "debug_hud_visibility_group",
		description = "Force activate a specific HUD visibility group",
		category = "HUD",
		item_source = {},
		load_items_source_func = function (arg_116_0)
			if not arg_116_0.initialized then
				table.clear(arg_116_0)

				arg_116_0[#arg_116_0 + 1] = "none"

				local var_116_0 = local_require("scripts/ui/views/ingame_hud_definitions").visibility_groups

				for iter_116_0, iter_116_1 in ipairs(var_116_0) do
					local var_116_1 = iter_116_1.name

					arg_116_0[#arg_116_0 + 1] = var_116_1
				end

				arg_116_0.initialized = true
			end
		end,
		func = function (arg_117_0, arg_117_1)
			local var_117_0 = arg_117_0[arg_117_1]

			if not var_117_0 or var_117_0 == "none" then
				script_data.debug_hud_visibility_group = nil
			else
				script_data.debug_hud_visibility_group = var_117_0
			end
		end
	},
	{
		description = "Used for spawning world markers on ping input",
		is_boolean = true,
		setting_name = "debug_world_marker_ping",
		category = "UI"
	},
	{
		description = "Prints the number of server controlled buffs.",
		is_boolean = true,
		setting_name = "debug_server_controlled_buffs",
		category = "Player mechanics"
	},
	{
		description = "Shows the bones of the player units",
		is_boolean = true,
		setting_name = "debug_player_skeletons",
		category = "Player mechanics"
	},
	{
		description = "Shows current career sound state",
		is_boolean = true,
		setting_name = "debug_career_sound_state",
		category = "Player mechanics"
	},
	{
		description = "Disables the weave score UI on screen",
		is_boolean = true,
		setting_name = "disable_weave_score_ui",
		category = "Player mechanics"
	},
	{
		setting_name = "Add legend end of level chest.",
		description = "Works on non-local backend. Adds a legend vault",
		category = "Progression",
		item_source = {},
		load_items_source_func = function (arg_118_0)
			table.clear(arg_118_0)

			arg_118_0[#arg_118_0 + 1] = "tier_1"
			arg_118_0[#arg_118_0 + 1] = "tier_2"
			arg_118_0[#arg_118_0 + 1] = "tier_3"
			arg_118_0[#arg_118_0 + 1] = "tier_4"
			arg_118_0[#arg_118_0 + 1] = "tier_5"

			table.sort(arg_118_0)
		end,
		func = function (arg_119_0, arg_119_1)
			local var_119_0 = arg_119_0[arg_119_1]
			local var_119_1 = Managers.backend:get_interface("loot")
			local var_119_2 = Managers.player:local_player()
			local var_119_3 = SPProfiles[var_119_2:profile_index()].display_name
			local var_119_4 = "default"

			if var_119_0 == "tier_1" then
				local var_119_5 = {
					chest_upgrade_data = {
						grimoire = 0,
						tome = 0,
						game_won = true,
						loot_dice = 0
					}
				}

				var_119_1:generate_end_of_level_loot(true, true, "hardest", "bell", var_119_3, 0, 0, var_119_4, nil, nil, "adventure", 0, var_119_5)
			elseif var_119_0 == "tier_2" then
				local var_119_6 = {
					chest_upgrade_data = {
						grimoire = 0,
						tome = 2,
						game_won = true,
						loot_dice = 0
					}
				}

				var_119_1:generate_end_of_level_loot(true, true, "hardest", "bell", var_119_3, 0, 0, var_119_4, nil, nil, "adventure", 0, var_119_6)
			elseif var_119_0 == "tier_3" then
				local var_119_7 = {
					chest_upgrade_data = {
						grimoire = 1,
						tome = 2,
						game_won = true,
						loot_dice = 0
					}
				}

				var_119_1:generate_end_of_level_loot(true, true, "hardest", "bell", var_119_3, 0, 0, var_119_4, nil, nil, "adventure", 0, var_119_7)
			elseif var_119_0 == "tier_4" then
				local var_119_8 = {
					chest_upgrade_data = {
						grimoire = 2,
						tome = 2,
						game_won = true,
						loot_dice = 1
					}
				}

				var_119_1:generate_end_of_level_loot(true, true, "hardest", "bell", var_119_3, 0, 0, var_119_4, nil, nil, "adventure", 0, var_119_8)
			elseif var_119_0 == "tier_5" then
				local var_119_9 = {
					chest_upgrade_data = {
						grimoire = 3,
						tome = 2,
						game_won = true,
						loot_dice = 4
					}
				}

				var_119_1:generate_end_of_level_loot(true, true, "hardest", "bell", var_119_3, 0, 0, var_119_4, nil, nil, "adventure", 0, var_119_9)
			end
		end
	},
	{
		description = "Lists all items with functionality to add them to inventory.",
		setting_name = "Add Hat Items",
		category = "Items",
		item_source = {},
		load_items_source_func = function (arg_120_0)
			table.clear(arg_120_0)

			local var_120_0 = ItemMasterList

			for iter_120_0, iter_120_1 in pairs(var_120_0) do
				if iter_120_1.slot_type == "hat" then
					arg_120_0[#arg_120_0 + 1] = iter_120_0
				end
			end

			table.sort(arg_120_0)
		end,
		func = function (arg_121_0, arg_121_1)
			local var_121_0 = Managers.backend:get_interface("items")
			local var_121_1 = arg_121_0[arg_121_1]

			var_0_1({
				{
					ItemName = var_121_1
				}
			})
		end
	},
	{
		description = "Adds all hat items to your inventory.",
		setting_name = "Add All Hat Items",
		category = "Items",
		func = function ()
			local var_122_0 = ItemMasterList
			local var_122_1 = {}

			for iter_122_0, iter_122_1 in pairs(var_122_0) do
				if iter_122_1.slot_type == "hat" then
					var_122_1[#var_122_1 + 1] = {
						ItemName = iter_122_0
					}
				end
			end

			local var_122_2 = true

			var_0_1(var_122_1, var_122_2)
		end
	},
	{
		description = "Lists all items with functionality to add them to inventory.",
		setting_name = "Add Skin Items",
		category = "Items",
		item_source = {},
		load_items_source_func = function (arg_123_0)
			table.clear(arg_123_0)

			local var_123_0 = ItemMasterList

			for iter_123_0, iter_123_1 in pairs(var_123_0) do
				if iter_123_1.slot_type == "skin" then
					arg_123_0[#arg_123_0 + 1] = iter_123_0
				end
			end

			table.sort(arg_123_0)
		end,
		func = function (arg_124_0, arg_124_1)
			local var_124_0 = Managers.backend:get_interface("items")
			local var_124_1 = arg_124_0[arg_124_1]

			var_0_1({
				{
					ItemName = var_124_1
				}
			})
		end
	},
	{
		description = "Lists all items with functionality to add them to inventory. (hold left shift to add x10)",
		setting_name = "Add Chest Items",
		category = "Items",
		item_source = {},
		load_items_source_func = function (arg_125_0)
			table.clear(arg_125_0)

			local var_125_0 = ItemMasterList

			for iter_125_0, iter_125_1 in pairs(var_125_0) do
				if iter_125_1.slot_type == "loot_chest" then
					arg_125_0[#arg_125_0 + 1] = iter_125_0
				end
			end

			table.sort(arg_125_0)
		end,
		func = function (arg_126_0, arg_126_1)
			local var_126_0 = Managers.backend:get_interface("items")
			local var_126_1 = arg_126_0[arg_126_1]
			local var_126_2 = 1

			if Keyboard.button(Keyboard.button_index("left shift")) > 0 then
				var_126_2 = 10
			end

			var_0_1({
				{
					ItemName = var_126_1,
					Amount = var_126_2
				}
			})
		end
	},
	{
		description = "Lists all items with functionality to add them to inventory.",
		setting_name = "Add Frame Items",
		category = "Items",
		item_source = {},
		load_items_source_func = function (arg_127_0)
			table.clear(arg_127_0)

			local var_127_0 = ItemMasterList

			for iter_127_0, iter_127_1 in pairs(var_127_0) do
				if iter_127_1.slot_type == "frame" then
					arg_127_0[#arg_127_0 + 1] = iter_127_0
				end
			end

			table.sort(arg_127_0)
		end,
		func = function (arg_128_0, arg_128_1)
			local var_128_0 = Managers.backend:get_interface("items")
			local var_128_1 = arg_128_0[arg_128_1]

			var_0_1({
				{
					ItemName = var_128_1
				}
			})
		end
	},
	{
		description = "Lists all deeds with functionality to add them to inventory.",
		setting_name = "Add Deed Items",
		category = "Items",
		item_source = {},
		load_items_source_func = function (arg_129_0)
			table.clear(arg_129_0)

			local var_129_0 = ItemMasterList

			for iter_129_0, iter_129_1 in pairs(var_129_0) do
				if iter_129_1.slot_type == "deed" then
					arg_129_0[#arg_129_0 + 1] = iter_129_0
				end
			end

			table.sort(arg_129_0)
		end,
		func = function (arg_130_0, arg_130_1)
			local var_130_0 = Managers.backend:get_interface("items")
			local var_130_1 = arg_130_0[arg_130_1]
			local var_130_2 = ItemMasterList[var_130_1].difficulties[1]
			local var_130_3 = "farmlands"

			var_0_1({
				{
					ItemName = var_130_1,
					CustomData = {
						difficulty = var_130_2,
						level_key = var_130_3
					}
				}
			})
		end
	},
	{
		description = "Adds one weapon per skin with that skin applied.",
		setting_name = "Add All Weapon Skins",
		category = "Items",
		func = function ()
			local var_131_0 = ItemMasterList
			local var_131_1 = WeaponSkins
			local var_131_2 = Managers.backend:get_interface("items")
			local var_131_3 = {}
			local var_131_4 = {}

			for iter_131_0, iter_131_1 in pairs(var_131_0) do
				local var_131_5 = iter_131_1.slot_type
				local var_131_6 = iter_131_1.skin_combination_table

				if (var_131_5 == "melee" or var_131_5 == "ranged") and var_131_6 and iter_131_1.rarity ~= "magic" then
					local var_131_7 = var_131_1.skin_combinations[var_131_6]

					for iter_131_2, iter_131_3 in pairs(var_131_7) do
						for iter_131_4, iter_131_5 in ipairs(iter_131_3) do
							if not var_131_3[iter_131_5] then
								var_131_3[iter_131_5] = true
								var_131_4[#var_131_4 + 1] = {
									ItemName = iter_131_0,
									CustomData = {
										power_level = 5,
										skin = iter_131_5
									}
								}
							end
						end
					end
				end
			end

			local var_131_8 = Managers.backend._backend_mirror
			local var_131_9 = {
				FunctionName = "devUnlockAllWeaponSkins",
				FunctionParameter = {}
			}
			local var_131_10 = true

			local function var_131_11(arg_132_0)
				var_0_1(var_131_4, var_131_10)
			end

			var_131_8:request_queue():enqueue(var_131_9, var_131_11, false)
		end
	},
	{
		description = "Unlocks all the weapon poses in the social_wheel",
		is_boolean = true,
		setting_name = "unlock_all_weapon_poses",
		category = "Items"
	},
	{
		description = "Lists all mutators with functionality to activate them. Requires restart of level",
		setting_name = "Activate or Deactivate Mutator",
		category = "Items",
		item_source = {},
		load_items_source_func = function (arg_133_0)
			table.clear(arg_133_0)

			for iter_133_0, iter_133_1 in pairs(MutatorTemplates) do
				arg_133_0[#arg_133_0 + 1] = iter_133_0
			end

			table.sort(arg_133_0)
		end,
		func = function (arg_134_0, arg_134_1)
			local var_134_0 = script_data.debug_activated_mutators or {}
			local var_134_1 = arg_134_0[arg_134_1]
			local var_134_2

			for iter_134_0 = 1, #var_134_0 do
				if var_134_0[iter_134_0] == var_134_1 then
					var_134_2 = iter_134_0
				end
			end

			if var_134_2 then
				table.remove(var_134_0, var_134_2)
				Debug.sticky_text("Deactivated mutator %s", var_134_1)
			else
				var_134_0[#var_134_0 + 1] = var_134_1

				Debug.sticky_text("Activated mutator %s", var_134_1)
			end

			if #var_134_0 > 0 then
				script_data.debug_activated_mutators = var_134_0
			else
				script_data.debug_activated_mutators = nil
			end
		end
	},
	{
		description = "Lists all mutators with functionality to immediately start or stop them. Does not require restart of level. !! Does not work for every mutator.",
		setting_name = "Start or stop mutator",
		category = "Items",
		item_source = {},
		load_items_source_func = function (arg_135_0)
			table.clear(arg_135_0)

			for iter_135_0, iter_135_1 in pairs(MutatorTemplates) do
				arg_135_0[#arg_135_0 + 1] = iter_135_0
			end

			table.sort(arg_135_0)
		end,
		func = function (arg_136_0, arg_136_1)
			local var_136_0 = Managers.state.game_mode:mutator_handler()
			local var_136_1 = arg_136_0[arg_136_1]

			if not var_136_0:has_mutator(var_136_1) then
				var_136_0:initialize_mutators({
					var_136_1
				})
				Debug.sticky_text("Initialized mutator %s", var_136_1)
			end

			if var_136_0:has_activated_mutator(var_136_1) then
				var_136_0:deactivate_mutator(var_136_1)
				Debug.sticky_text("Stopped mutator %s", var_136_1)
			else
				var_136_0:activate_mutator(var_136_1)
				Debug.sticky_text("Started mutator %s", var_136_1)
			end
		end
	},
	{
		description = "Lists all blessings with functionality to activate them. Requires restart of a deus level or loading the next one",
		setting_name = "Activate or Deactivate Blessings",
		category = "Items",
		item_source = {},
		load_items_source_func = function (arg_137_0)
			table.clear(arg_137_0)

			for iter_137_0, iter_137_1 in pairs(DeusBlessingSettings) do
				arg_137_0[#arg_137_0 + 1] = iter_137_0
			end

			table.sort(arg_137_0)
		end,
		func = function (arg_138_0, arg_138_1)
			local var_138_0 = script_data.debug_activated_blessings or {}
			local var_138_1 = arg_138_0[arg_138_1]
			local var_138_2

			for iter_138_0 = 1, #var_138_0 do
				if var_138_0[iter_138_0] == var_138_1 then
					var_138_2 = iter_138_0
				end
			end

			if var_138_2 then
				table.remove(var_138_0, var_138_2)
				Debug.sticky_text("Deactivated blessing %s", var_138_1)
			else
				var_138_0[#var_138_0 + 1] = var_138_1

				Debug.sticky_text("Activated blessing %s", var_138_1)
			end

			if #var_138_0 > 0 then
				script_data.debug_activated_blessings = var_138_0
			else
				script_data.debug_activated_blessings = nil
			end
		end
	},
	{
		description = "Lists all Twitch Mode Vote Templates with functionality to activate them.",
		setting_name = "Force Twitch Mode Vote Template",
		category = "Items",
		item_source = {},
		load_items_source_func = function (arg_139_0)
			table.clear(arg_139_0)

			for iter_139_0, iter_139_1 in pairs(TwitchVoteTemplates) do
				arg_139_0[#arg_139_0 + 1] = iter_139_0
			end

			arg_139_0[#arg_139_0 + 1] = "clear_votes"

			table.sort(arg_139_0)
		end,
		func = function (arg_140_0, arg_140_1)
			if not script_data.debug_activated_mutators then
				local var_140_0 = {}
			end

			local var_140_1 = arg_140_0[arg_140_1]

			if var_140_1 == "clear_votes" then
				script_data.twitch_mode_force_vote_template = nil
			else
				local var_140_2 = TwitchVoteTemplates[var_140_1]

				script_data.twitch_mode_force_vote_template = var_140_2
			end
		end
	},
	{
		description = "Show all paintings etc. You have to reload the inn for the setting to take effect.",
		is_boolean = true,
		setting_name = "debug_keep_decorations",
		category = "Keep Decorations"
	},
	{
		description = "Unlocks a Challenge by setting by incrementing the appropriate statistics.",
		setting_name = "Unlock Challenges",
		category = "Progression",
		clear_when_selected = true,
		item_source = {},
		load_items_source_func = function (arg_141_0)
			table.clear(arg_141_0)

			for iter_141_0, iter_141_1 in pairs(AchievementTemplates.achievements) do
				if iter_141_1.debug_unlock then
					table.insert(arg_141_0, iter_141_0)
				end
			end

			table.sort(arg_141_0)
		end,
		func = function (arg_142_0, arg_142_1)
			if AchievementTemplates then
				local var_142_0 = AchievementTemplates.achievements[arg_142_0[arg_142_1]]

				if var_142_0 ~= nil then
					if var_142_0.debug_unlock then
						local var_142_1 = Managers.state.game_mode.statistics_db
						local var_142_2 = Managers.player:local_player():stats_id()

						if var_142_1 and var_142_2 then
							var_142_0.debug_unlock(var_142_1, var_142_2)
							print("Unlocked challenge ", arg_142_0[arg_142_1])

							local var_142_3 = Managers.world:world("level_world")

							LevelHelper:flow_event(var_142_3, "lua_unlock_challenge_debug_event")
							var_0_0()

							return
						end
					else
						print("Missing 'debug_unlock' on challenge")
					end
				end
			end

			print("Could not unlock challenge ", arg_142_0[arg_142_1])
		end
	},
	{
		description = "Clears a Challenge by setting the appropriate statistics to 0.",
		setting_name = "Clear Challenges",
		category = "Progression",
		clear_when_selected = true,
		item_source = {},
		load_items_source_func = function (arg_143_0)
			table.clear(arg_143_0)

			for iter_143_0, iter_143_1 in pairs(AchievementTemplates.achievements) do
				if iter_143_1.debug_reset then
					table.insert(arg_143_0, iter_143_0)
				end
			end

			table.sort(arg_143_0)
		end,
		func = function (arg_144_0, arg_144_1)
			if AchievementTemplates then
				local var_144_0 = AchievementTemplates.achievements[arg_144_0[arg_144_1]]

				if var_144_0 ~= nil then
					if var_144_0.debug_reset then
						local var_144_1 = Managers.state.game_mode.statistics_db
						local var_144_2 = Managers.player:local_player():stats_id()

						if var_144_1 and var_144_2 then
							var_144_0.debug_reset(var_144_1, var_144_2)
							print("Reset challenge ", arg_144_0[arg_144_1])
							var_0_0()

							return
						end
					else
						print("Missing 'debug_reset' function")
					end
				end
			end

			print("Could not reset challenge ", arg_144_0[arg_144_1])
		end
	},
	{
		description = "All challenges with progression will only require you to increase the progress by 1",
		is_boolean = true,
		setting_name = "simplify_challenge_progression",
		category = "Progression"
	},
	{
		description = "Sets all Okris challenges to be claimable in the UI",
		is_boolean = true,
		setting_name = "set_all_challenges_claimable",
		category = "Progression"
	},
	{
		description = "Draws debug information for each active objective",
		is_boolean = true,
		setting_name = "show_weave_objectives",
		category = "Gamemode/level"
	},
	{
		description = "Pause the objective timer for versus",
		is_boolean = true,
		setting_name = "versus_objective_timer_paused",
		category = "Versus"
	},
	{
		description = "Finishes a match after the first round",
		is_boolean = true,
		setting_name = "versus_quick_match_end",
		category = "Versus"
	},
	{
		description = "Generates fake stats to test the versus end screen",
		is_boolean = true,
		setting_name = "versus_generate_fake_stats",
		category = "Versus"
	},
	{
		description = "Generates fake players in the ceremony screen",
		is_boolean = true,
		setting_name = "versus_generate_fake_ceremony_players",
		category = "Versus"
	},
	{
		description = "Shows some information about the recharge of the horde ability.",
		is_boolean = true,
		setting_name = "vs_horde_ability_debug",
		category = "Versus"
	},
	{
		description = "Activates all objectives for the current weave",
		setting_name = "activate_all_weave_objectives",
		category = "Gamemode/level",
		func = function ()
			local var_145_0 = Managers.world:world("level_world")
			local var_145_1 = World.units(var_145_0)
			local var_145_2 = {}

			for iter_145_0, iter_145_1 in ipairs(var_145_1) do
				if not Unit.is_frozen(iter_145_1) then
					local var_145_3 = Unit.debug_name(iter_145_1)

					if var_145_3:match(".*weave_capture_point_spawner") or var_145_3:match(".*weave_interaction_spawner") or var_145_3:match(".*weave_prop_skaven_doom_wheel_01_spawner") or var_145_3:match(".*weave_limited_item_track_spawner") then
						local var_145_4 = Unit.get_data(iter_145_1, "weave_objective_id")
						local var_145_5 = #NetworkLookup.objective_names + 1

						NetworkLookup.objective_names[var_145_5] = var_145_4
						NetworkLookup.objective_names[var_145_4] = var_145_5
						var_145_2[var_145_4] = {}

						print(var_145_3)
					end
				end
			end

			local var_145_6 = #NetworkLookup.objective_names + 1

			NetworkLookup.objective_names[var_145_6] = "kill_enemies"
			NetworkLookup.objective_names.kill_enemies = var_145_6
			var_145_2.kill_enemies = {}
			script_data.temp_objective_list_counter = (script_data.temp_objective_list_counter or 0) + 1

			local var_145_7 = "temp_objective_list_" .. script_data.temp_objective_list_counter

			ObjectiveLists[var_145_7] = {
				var_145_2
			}

			local var_145_8 = Managers.state.entity:system("objective_system")

			var_145_8:server_register_objectives(var_145_7)
			var_145_8:server_activate_first_objective()
		end
	},
	{
		description = "Sets all players max health to 5000",
		is_boolean = true,
		setting_name = "player_lots_of_max_health",
		category = "Player mechanics"
	},
	{
		description = "Sets all players max knock down health to 5000",
		is_boolean = true,
		setting_name = "player_lots_of_max_kd_health",
		category = "Player mechanics"
	},
	{
		description = "Use the standard loadout in weaves (requires restart)",
		is_boolean = true,
		setting_name = "disable_weave_loadout",
		category = "Player mechanics"
	},
	{
		description = "Use the standard talents in weaves (requires restart)",
		is_boolean = true,
		setting_name = "disable_weave_talents",
		category = "Player mechanics"
	},
	{
		description = "sets the weave timer to 1 sec",
		setting_name = "deplete_weave_timer",
		category = "Player mechanics",
		func = function ()
			Managers.weave:_set_time_left(1)
		end
	},
	{
		description = "Adds 10 Weave Essence to your account",
		setting_name = "10 Weave Essence",
		category = "Gamemode/level",
		func = function ()
			Managers.backend:get_interface("weaves"):debug_grant_essence(10)
		end
	},
	{
		description = "Adds 100 Weave Essence to your account",
		setting_name = "100 Weave Essence",
		category = "Gamemode/level",
		func = function ()
			Managers.backend:get_interface("weaves"):debug_grant_essence(100)
		end
	},
	{
		description = "Adds 1000 Weave Essence to your account",
		setting_name = "1,000 Weave Essence",
		category = "Gamemode/level",
		func = function ()
			Managers.backend:get_interface("weaves"):debug_grant_essence(1000)
		end
	},
	{
		description = "Adds 10000 Weave Essence to your account",
		setting_name = "10,000 Weave Essence",
		category = "Gamemode/level",
		func = function ()
			Managers.backend:get_interface("weaves"):debug_grant_essence(10000)
		end
	},
	{
		description = "Adds $$$ ONE MILLION $$$ Weave Essence to your account",
		setting_name = "1,000,000 Weave Essence",
		category = "Gamemode/level",
		func = function ()
			Managers.backend:get_interface("weaves"):debug_grant_essence(1000000)
		end
	},
	{
		description = "Removes all magic weave weapons from the inventory except for default weapons equipped ones",
		setting_name = "Remove Magic Weave Weapons",
		category = "Gamemode/level",
		func = function ()
			Managers.backend:get_interface("weaves"):debug_remove_magic_items()
		end
	},
	{
		setting_name = "Weave Onboarding",
		description = "change onboarding stat",
		category = "Onboarding",
		item_source = {},
		load_items_source_func = function (arg_153_0)
			table.clear(arg_153_0)

			arg_153_0[#arg_153_0 + 1] = "1"
			arg_153_0[#arg_153_0 + 1] = "2"
			arg_153_0[#arg_153_0 + 1] = "3"
			arg_153_0[#arg_153_0 + 1] = "4"
			arg_153_0[#arg_153_0 + 1] = "5"
			arg_153_0[#arg_153_0 + 1] = "6"
			arg_153_0[#arg_153_0 + 1] = "7"
			arg_153_0[#arg_153_0 + 1] = "8"
			arg_153_0[#arg_153_0 + 1] = "9"
			arg_153_0[#arg_153_0 + 1] = "clear"

			table.sort(arg_153_0)
		end,
		func = function (arg_154_0, arg_154_1)
			local var_154_0 = arg_154_0[arg_154_1]
			local var_154_1 = Managers.player:statistics_db()
			local var_154_2 = Managers.player:local_player():stats_id()

			if var_154_0 == "clear" then
				var_154_1:set_stat(var_154_2, "scorpion_onboarding_step", 0)
			else
				var_154_1:set_stat(var_154_2, "scorpion_onboarding_step", tonumber(var_154_0))
			end

			var_0_0()
		end
	},
	{
		description = "complete the weave onboarding ui tutorial",
		setting_name = "Weave Onboarding UI",
		category = "Onboarding",
		func = function ()
			local var_155_0 = Managers.player:statistics_db()
			local var_155_1 = Managers.player:local_player():stats_id()

			var_155_0:set_stat(var_155_1, "scorpion_ui_onboarding_state", -1)
			var_0_0()
		end
	},
	{
		description = "resets weave onboarding ui tutorial",
		setting_name = "Weave Onboarding UI Reset",
		category = "Onboarding",
		func = function ()
			local var_156_0 = Managers.player:statistics_db()
			local var_156_1 = Managers.player:local_player():stats_id()

			var_156_0:set_stat(var_156_1, "scorpion_ui_onboarding_state", 0)
			var_0_0()
		end
	},
	{
		description = "resets the flag keeps track of Olesya's VO that is played when player first fails a weave.",
		setting_name = "Clear Olesya Failed VO Played Flag ",
		category = "Onboarding",
		func = function ()
			local var_157_0 = Managers.player:statistics_db()
			local var_157_1 = Managers.player:local_player():stats_id()

			var_157_0:set_stat(var_157_1, "scorpion_onboarding_weave_first_fail_vo_played", 0)
			var_0_0()
		end
	},
	{
		description = "Will make it so \"first_time_store_release\" is always triggered when players start the game and enter the keep",
		is_boolean = true,
		setting_name = "always_first_time_store_release",
		category = "Onboarding"
	},
	{
		description = "Will make it so \"store_new_items\" is always triggered when players start the game and enter the keep",
		is_boolean = true,
		setting_name = "always_store_new_items",
		category = "Onboarding"
	},
	{
		description = "Will make it so \"shop_closed_item_bought\" is always triggered when players close the store. Exclusive with other \"shop_closed\" events",
		is_boolean = true,
		setting_name = "always_shop_closed_item_bought",
		category = "Onboarding"
	},
	{
		description = "Will make it so \"shop_closed_golden_key_redeemed\" is always triggered when players close the store. Exclusive with other \"shop_closed\" events",
		is_boolean = true,
		setting_name = "always_shop_closed_golden_key_redeemed",
		category = "Onboarding"
	},
	{
		description = "Will make it so \"shop_closed_login_reward_claimed\" is always triggered when players close the store. Exclusive with other \"shop_closed\" events",
		is_boolean = true,
		setting_name = "always_shop_closed_login_reward_claimed",
		category = "Onboarding"
	},
	{
		description = "Trigger the \"first_time_store_release\" level flow event",
		setting_name = "Trigger \"first_time_store_release\"",
		category = "Onboarding",
		func = function ()
			local var_158_0 = Managers.world:world("level_world")

			LevelHelper:flow_event(var_158_0, "first_time_store_release")
		end
	},
	{
		description = "Trigger the \"store_new_items\" level flow event",
		setting_name = "Trigger \"store_new_items\"",
		category = "Onboarding",
		func = function ()
			local var_159_0 = Managers.world:world("level_world")

			LevelHelper:flow_event(var_159_0, "store_new_items")
		end
	},
	{
		description = "Trigger the \"first_time_started_game\" level flow event",
		setting_name = "Trigger \"first_time_started_game\"",
		category = "Onboarding",
		func = function ()
			local var_160_0 = Managers.world:world("level_world")

			LevelHelper:flow_event(var_160_0, "first_time_started_game")
			LevelHelper:flow_event(var_160_0, "first_time_started_deus_game")
			LevelHelper:flow_event(var_160_0, "first_time_started_versus_game")
		end
	},
	{
		description = "Clears the seen_handbook_pages table, allowing all popups to trigger again.",
		setting_name = "Clear seen_handbook_pages",
		category = "Onboarding",
		func = function ()
			local var_161_0 = SaveData.seen_handbook_pages

			if var_161_0 then
				table.clear(var_161_0)
			end

			local var_161_1 = SaveData.seen_handbook_popups

			if var_161_1 then
				table.clear(var_161_1)
			end
		end
	},
	{
		description = "Disregard the store items set by the backend",
		is_boolean = true,
		setting_name = "disregard_backend_store_items",
		category = "Store"
	},
	{
		description = "Prints out the current discounted items on screen",
		is_boolean = true,
		setting_name = "show_discounted_store_items",
		category = "Store"
	},
	{
		description = "Randomizes a bunch of items on sale",
		is_boolean = true,
		setting_name = "fake_store_sale",
		category = "Store"
	},
	{
		description = "Count owned DLCs as installed. Makes it easier to test DLCs through steam console with enable/disable_license",
		is_boolean = true,
		setting_name = "count_owned_dlc_as_installed",
		category = "DLC"
	},
	{
		description = "Displays the diorama prototype",
		close_when_selected = true,
		setting_name = "Run Diorama Prototype",
		category = "Diorama",
		func = function ()
			Managers.ui:handle_transition("diorama_prototype", {})
		end
	},
	{
		description = "Starts a Deus run directly on a map",
		setting_name = "Run Deus Map Node",
		category = "Deus",
		func = function ()
			local var_163_0 = Managers.mechanism:game_mechanism()

			if var_163_0.debug_load_map then
				var_163_0:debug_load_map()
			end
		end
	},
	{
		description = "Starts a Deus run directly on a shrine",
		setting_name = "Run Deus Shrine Node",
		category = "Deus",
		func = function ()
			local var_164_0 = Managers.mechanism:game_mechanism()

			if var_164_0.debug_load_shrine_node then
				var_164_0:debug_load_shrine_node()
			end
		end
	},
	{
		description = "Clears a finished a journey",
		setting_name = "Clear Finished Journey",
		category = "Deus",
		item_source = {},
		load_items_source_func = function (arg_165_0)
			table.clear(arg_165_0)

			for iter_165_0, iter_165_1 in pairs(DeusJourneySettings) do
				arg_165_0[#arg_165_0 + 1] = iter_165_0
			end

			table.sort(arg_165_0)
		end,
		func = function (arg_166_0, arg_166_1)
			local var_166_0 = arg_166_0[arg_166_1]

			LevelUnlockUtils.debug_set_completed_journey_difficulty(var_166_0, 0)
		end
	},
	{
		description = "Sets the completed difficulty for the selected journey temporary.",
		setting_name = "Set completed journey difficulty",
		category = "Deus",
		item_source = {},
		load_items_source_func = function (arg_167_0)
			table.clear(arg_167_0)

			for iter_167_0, iter_167_1 in ipairs(AvailableJourneyOrder) do
				for iter_167_2, iter_167_3 in ipairs(DefaultDifficulties) do
					arg_167_0[#arg_167_0 + 1] = iter_167_1 .. "/" .. iter_167_3
				end
			end
		end,
		func = function (arg_168_0, arg_168_1)
			local var_168_0 = string.split_deprecated(arg_168_0[arg_168_1], "/")
			local var_168_1 = var_168_0[1]
			local var_168_2 = var_168_0[2]
			local var_168_3 = table.index_of(DefaultDifficulties, var_168_2)

			LevelUnlockUtils.debug_set_completed_journey_difficulty(var_168_1, var_168_3)
		end
	},
	{
		description = "Sets the hero completed difficulty for the selected journey temporary.",
		setting_name = "Set completed hero journey difficulty",
		category = "Deus",
		item_source = {},
		load_items_source_func = function (arg_169_0)
			local var_169_0 = "journey_citadel"

			table.clear(arg_169_0)

			for iter_169_0, iter_169_1 in ipairs(SPProfilesAbbreviation) do
				for iter_169_2, iter_169_3 in ipairs(DefaultDifficulties) do
					arg_169_0[#arg_169_0 + 1] = iter_169_1 .. "/" .. var_169_0 .. "/" .. iter_169_3
				end
			end
		end,
		func = function (arg_170_0, arg_170_1)
			local var_170_0 = string.split_deprecated(arg_170_0[arg_170_1], "/")
			local var_170_1 = var_170_0[1]
			local var_170_2 = var_170_0[2]
			local var_170_3 = var_170_0[3]
			local var_170_4 = table.index_of(DefaultDifficulties, var_170_3)

			LevelUnlockUtils.debug_set_completed_hero_journey_difficulty(var_170_1, var_170_2, var_170_4)
		end
	},
	{
		description = "Clears all deus meta progression, which is just rolled over coins at the moment.",
		setting_name = "Clear Deus meta progression",
		category = "Deus",
		func = function ()
			Managers.backend:get_interface("deus"):debug_clear_meta_progression()
		end
	},
	{
		description = "Lists all powerups with functionality to activate them. Needs to be in a deus run.",
		setting_name = "Activate Deus PowerUp",
		category = "Deus",
		item_source = {},
		load_items_source_func = function (arg_172_0)
			table.clear(arg_172_0)

			for iter_172_0, iter_172_1 in pairs(DeusPowerUps) do
				for iter_172_2, iter_172_3 in pairs(iter_172_1) do
					arg_172_0[#arg_172_0 + 1] = iter_172_0 .. "/" .. iter_172_2
				end
			end

			table.sort(arg_172_0)
		end,
		func = function (arg_173_0, arg_173_1)
			if not Managers.mechanism:current_mechanism_name() == "deus" then
				return
			end

			local var_173_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()

			if not var_173_0 then
				return
			end

			local var_173_1 = Managers.player:local_player()
			local var_173_2 = var_173_1:local_player_id()
			local var_173_3 = arg_173_0[arg_173_1]
			local var_173_4 = string.split_deprecated(var_173_3, "/")
			local var_173_5 = var_173_4[1]
			local var_173_6 = var_173_4[2]
			local var_173_7 = var_173_0:get_player_power_ups(var_173_1.peer_id, var_173_2)
			local var_173_8

			for iter_173_0, iter_173_1 in ipairs(var_173_7) do
				if iter_173_1.name == var_173_6 then
					var_173_8 = true

					break
				end
			end

			if not var_173_8 then
				local var_173_9 = DeusPowerUpUtils.generate_specific_power_up(var_173_6, var_173_5)

				var_173_0:add_power_ups({
					var_173_9
				}, var_173_2, false)
			end
		end
	},
	{
		description = "Adds 10.000 deus soft currency",
		setting_name = "add_soft_currency",
		category = "Deus",
		func = function (arg_174_0, arg_174_1)
			local var_174_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()
			local var_174_1 = var_174_0._run_state:get_own_peer_id()

			var_174_0:_add_soft_currency_to_peer(var_174_1, 10000)
		end
	},
	{
		description = "Adds a random boon, the type obtained from boon shrines",
		setting_name = "add_random_boon",
		category = "Deus",
		func = function (arg_175_0, arg_175_1)
			local var_175_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()
			local var_175_1 = var_175_0:generate_random_power_ups(DeusPowerUpSettings.weapon_chest_choice_amount, DeusPowerUpAvailabilityTypes.weapon_chest, math.random_seed())[1]
			local var_175_2 = Managers.player:local_player():local_player_id()

			var_175_0:add_power_ups({
				var_175_1
			}, var_175_2, true)
			Managers.state.event:trigger("present_rewards", {
				{
					type = "deus_power_up",
					power_up = var_175_1
				}
			})
		end
	},
	{
		description = "Activates all Deus PowerUps ",
		setting_name = "Activate all Deus PowerUps",
		category = "Deus",
		item_source = {},
		func = function (arg_176_0, arg_176_1)
			if not Managers.mechanism:current_mechanism_name() == "deus" then
				return
			end

			local var_176_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()

			if not var_176_0 then
				return
			end

			local var_176_1 = Managers.player:local_player()
			local var_176_2 = var_176_1:local_player_id()
			local var_176_3 = var_176_1:network_id()
			local var_176_4 = var_176_0:get_player_power_ups(var_176_3, var_176_2)
			local var_176_5 = 50
			local var_176_6 = 0
			local var_176_7 = {}

			for iter_176_0, iter_176_1 in pairs(DeusPowerUps) do
				for iter_176_2, iter_176_3 in pairs(iter_176_1) do
					local var_176_8

					for iter_176_4, iter_176_5 in ipairs(var_176_4) do
						if iter_176_5.name == iter_176_2 then
							var_176_8 = true

							break
						end
					end

					local var_176_9 = iter_176_3.mutators
					local var_176_10 = table.is_empty(var_176_9)

					for iter_176_6 = 1, #var_176_9 do
						if Managers.state.game_mode:has_activated_mutator(var_176_9[iter_176_6]) then
							var_176_10 = true

							break
						end
					end

					if var_176_10 and not var_176_8 then
						var_176_6 = var_176_6 + 1

						local var_176_11 = math.ceil(var_176_6 / var_176_5)

						var_176_7[var_176_11] = var_176_7[var_176_11] or {}
						var_176_7[var_176_11][#var_176_7[var_176_11] + 1] = DeusPowerUpUtils.generate_specific_power_up(iter_176_2, iter_176_0)
					end
				end
			end

			for iter_176_7 = 1, #var_176_7 do
				var_176_0:add_power_ups(var_176_7[iter_176_7], var_176_2, false)
			end
		end
	},
	{
		description = "Draw the positions of the weapons as a path",
		setting_name = "Draw Weapon Position",
		category = "Weapons",
		item_source = {},
		load_items_source_func = function (arg_177_0)
			table.clear(arg_177_0)
			table.insert(arg_177_0, "all")
			table.insert(arg_177_0, "right_hand")
			table.insert(arg_177_0, "left_hand")
			table.insert(arg_177_0, "right_hand_ammo")
			table.insert(arg_177_0, "left_hand_ammo")
			table.insert(arg_177_0, "[clear value]")
			table.sort(arg_177_0)
		end,
		func = function (arg_178_0, arg_178_1)
			script_data.debug_draw_weapon_position = arg_178_0[arg_178_1]
		end
	},
	{
		description = "Unlocks every deus chest aka weapon shrine",
		is_boolean = true,
		setting_name = "unlock_all_deus_chests",
		category = "Deus"
	},
	{
		description = "debug any changes to the deus shared state.",
		is_boolean = true,
		setting_name = "shared_state_debug",
		category = "Deus"
	},
	{
		description = "log any relevant event in the deus run controller.",
		is_boolean = true,
		setting_name = "deus_run_controller_debug",
		category = "Deus"
	},
	{
		description = "draw a map with debug ui. This will draw either the current run seed being played, or the seed set by imgui_deus_map_gen",
		is_boolean = true,
		setting_name = "deus_debug_draw_map",
		category = "Deus"
	},
	{
		description = "test fog without saving already seen nodes, essentially everything not accessed is fully foggy",
		is_boolean = true,
		setting_name = "deus_fog_with_no_memory",
		category = "Deus"
	},
	{
		setting_name = "deus_force_load_run_progress",
		category = "Deus",
		description = "override the run progress when using this menu's load level. 900 == 0.9 ",
		item_source = {},
		load_items_source_func = function (arg_179_0)
			table.clear(arg_179_0)

			for iter_179_0 = 0, 999, 10 do
				arg_179_0[#arg_179_0 + 1] = iter_179_0
			end

			table.sort(arg_179_0)

			arg_179_0[#arg_179_0 + 1] = "[clear value]"
		end
	},
	{
		setting_name = "deus_seed",
		category = "Deus",
		description = "Force a default graph seed",
		item_source = {},
		load_items_source_func = function (arg_180_0)
			table.clear(arg_180_0)

			for iter_180_0, iter_180_1 in pairs(DeusDefaultGraphs) do
				arg_180_0[#arg_180_0 + 1] = iter_180_0
			end

			arg_180_0[#arg_180_0 + 1] = "[clear value]"

			table.sort(arg_180_0)
		end
	},
	{
		setting_name = "deus_journey",
		category = "Deus",
		description = "Force a deus journey",
		item_source = {},
		load_items_source_func = function (arg_181_0)
			table.clear(arg_181_0)

			for iter_181_0, iter_181_1 in pairs(AvailableJourneyOrder) do
				arg_181_0[#arg_181_0 + 1] = iter_181_1
			end

			arg_181_0[#arg_181_0 + 1] = "[clear value]"

			table.sort(arg_181_0)
		end
	},
	{
		setting_name = "deus_dominant_god",
		category = "Deus",
		description = "Force a deus dominant god",
		item_source = {},
		load_items_source_func = function (arg_182_0)
			table.clear(arg_182_0)

			for iter_182_0, iter_182_1 in pairs(DEUS_GOD_INDEX) do
				arg_182_0[#arg_182_0 + 1] = iter_182_1
			end

			arg_182_0[#arg_182_0 + 1] = "[clear value]"

			table.sort(arg_182_0)
		end
	},
	{
		description = "Journeys will work in 10minute cycles for debugging. Only works in local backend.",
		is_boolean = true,
		setting_name = "deus_journey_ten_minute_cycle",
		category = "Deus"
	},
	{
		description = "Shows how many enemies are marked by a curse",
		is_boolean = true,
		setting_name = "debug_deus_marked_enemies",
		category = "Deus"
	},
	{
		description = "Check how the curse UI looks with all the different curses. Use left shift + q in order to cycle all the variations",
		is_boolean = true,
		setting_name = "deus_curse_ui",
		category = "Deus"
	},
	{
		description = "Requires a restart/loading the next level/switching career. Unlocks all weapons in the pool used for generating random weapon at reliquaries.",
		is_boolean = true,
		setting_name = "deus_full_weapon_pool",
		category = "Deus"
	},
	{
		description = "When active the next run you will start will consist only of shops (except start node and arena)",
		is_boolean = true,
		setting_name = "deus_shoppify_run",
		category = "Deus"
	},
	{
		description = "Force only the new boons to be in the pool",
		is_boolean = true,
		setting_name = "belakor_force_new_boons",
		category = "Deus"
	},
	{
		description = "Force a specific map layout on the belakor journey for the vertical slice build",
		is_boolean = true,
		setting_name = "belakor_force_vertical_slice_seed",
		category = "Deus"
	},
	{
		description = "Forces all levels to be cursed by belakor where applicable",
		is_boolean = true,
		setting_name = "belakor_force_curses_on_map",
		category = "Deus"
	},
	{
		description = "Hides the belakor journey from the UI",
		is_boolean = true,
		setting_name = "belakor_hide_journey",
		category = "Deus"
	},
	{
		description = "While playing a belakor level, all possible positions for a Locus will be occupied by one",
		is_boolean = true,
		setting_name = "belakor_force_locus_on_all_positions",
		category = "Deus"
	},
	{
		description = "Primes your user setting to trigger the new UI popup",
		category = "New UI Popup",
		setting_name = "Activate New Popup UI Prompt",
		func = function ()
			Application.set_user_setting("use_pc_menu_layout", false)
			Application.set_user_setting("use_gamepad_menu_layout", false)
			Managers.save:auto_save(SaveFileName, SaveData)
			Application.save_user_settings()
		end
	},
	{
		description = "Displays career counters",
		is_boolean = true,
		setting_name = "debug_dark_pact_delegator",
		category = "Versus"
	},
	{
		description = "",
		setting_name = "Number of Crafted Items",
		category = "Crafting",
		item_source = {
			0,
			10,
			20,
			30,
			40,
			50,
			60,
			70,
			80,
			90,
			100,
			200,
			300,
			400,
			500,
			600,
			700,
			800,
			900,
			1000,
			2000,
			3000,
			4000,
			5000
		},
		custom_item_source_order = function (arg_184_0, arg_184_1)
			for iter_184_0, iter_184_1 in ipairs(arg_184_0) do
				local var_184_0 = iter_184_1

				arg_184_1[#arg_184_1 + 1] = var_184_0
			end
		end,
		func = function (arg_185_0, arg_185_1)
			local var_185_0 = arg_185_0[arg_185_1]

			Managers.state.crafting:debug_set_crafted_items_stat(var_185_0)
		end
	},
	{
		description = "",
		setting_name = "Number of Salvaged Items",
		category = "Crafting",
		item_source = {
			0,
			10,
			20,
			30,
			40,
			50,
			60,
			70,
			80,
			90,
			100,
			200,
			300,
			400,
			500,
			600,
			700,
			800,
			900,
			1000,
			2000,
			3000,
			4000,
			5000
		},
		custom_item_source_order = function (arg_186_0, arg_186_1)
			for iter_186_0, iter_186_1 in ipairs(arg_186_0) do
				local var_186_0 = iter_186_1

				arg_186_1[#arg_186_1 + 1] = var_186_0
			end
		end,
		func = function (arg_187_0, arg_187_1)
			local var_187_0 = arg_187_0[arg_187_1]

			Managers.state.crafting:debug_set_salvaged_items_stat(var_187_0)
		end
	},
	{
		description = "Debug crafting crafting recipes",
		is_boolean = true,
		setting_name = "craft_recipe_debug",
		category = "Crafting"
	},
	{
		description = "Allows the player to force start a versus game with only one player",
		is_boolean = true,
		setting_name = "allow_versus_force_start_single_player",
		category = "Versus"
	},
	{
		description = "starts the round",
		setting_name = "start_player_hosted_round",
		category = "Versus",
		func = function (arg_188_0, arg_188_1)
			Managers.state.game_mode:round_started()
			printf("Round started!")
		end
	},
	{
		description = "Trigger boss terror event",
		setting_name = "inject_playable_boss_into_main_path",
		category = "Versus",
		func = function (arg_189_0, arg_189_1)
			print("Playable boss patrols injected into the main path now")
			Managers.state.conflict.level_analysis:inject_playable_boss_into_main_path()
		end
	},
	{
		description = "Trigger boss terror event",
		setting_name = "trigger_playable_boss_event",
		category = "Versus",
		func = function (arg_190_0, arg_190_1)
			print("[DEBUG] Triggered Playable boss")
			Managers.state.game_mode:game_mode():set_playable_boss_can_be_picked(true)
		end
	},
	{
		description = "Trigger boss terror event",
		is_boolean = true,
		setting_name = "debug_playable_boss",
		category = "Versus"
	},
	{
		description = "Debug versus chaos troll puke sweep",
		is_boolean = true,
		setting_name = "versus_debug_chaos_troll_sweep",
		category = "AI"
	},
	{
		description = "starts the round",
		setting_name = "end_player_hosted_round",
		category = "Versus",
		func = function (arg_191_0, arg_191_1)
			if Managers.level_transition_handler:in_hub_level() then
				printf("Failed to end round - Match not started")

				return false
			end

			if not Managers.mechanism:game_mechanism().win_conditions then
				printf("Wrong game-mode, cannot end round here")

				return false
			end

			Managers.state.game_mode:round_started()
			Managers.mechanism:game_mechanism():win_conditions():set_time(0)

			DebugScreen.active = false

			printf("Round ended!")

			return true
		end
	},
	{
		description = "Displays elevator context on screen",
		is_boolean = true,
		setting_name = "debug_elevators",
		category = "Allround useful stuff!"
	}
}

local function var_0_3(arg_192_0)
	return {
		{
			description = "Lists all items with functionality to add them to inventory.",
			category = "Items",
			setting_name = "Add Melee Items (" .. arg_192_0 .. ")",
			item_source = {},
			load_items_source_func = function (arg_193_0)
				table.clear(arg_193_0)

				local var_193_0 = ItemMasterList

				for iter_193_0, iter_193_1 in pairs(var_193_0) do
					if iter_193_1.slot_type == "melee" then
						arg_193_0[#arg_193_0 + 1] = iter_193_0
					end
				end

				table.sort(arg_193_0)
			end,
			func = function (arg_194_0, arg_194_1)
				local var_194_0 = Managers.backend:get_interface("items")
				local var_194_1 = arg_194_0[arg_194_1]

				if var_194_1 then
					var_194_0:award_item(var_194_1, nil, nil, arg_192_0)
				end
			end
		}
	}
end

local function var_0_4(arg_195_0)
	return {
		{
			description = "Lists all items with functionality to add them to inventory.",
			category = "Items",
			setting_name = "Add Ranged Items (" .. arg_195_0 .. ")",
			item_source = {},
			load_items_source_func = function (arg_196_0)
				table.clear(arg_196_0)

				local var_196_0 = ItemMasterList

				for iter_196_0, iter_196_1 in pairs(var_196_0) do
					if iter_196_1.slot_type == "ranged" then
						arg_196_0[#arg_196_0 + 1] = iter_196_0
					end
				end

				table.sort(arg_196_0)
			end,
			func = function (arg_197_0, arg_197_1)
				local var_197_0 = Managers.backend:get_interface("items")
				local var_197_1 = arg_197_0[arg_197_1]

				if var_197_1 then
					var_197_0:award_item(var_197_1, nil, nil, arg_195_0)
				end
			end
		}
	}
end

local function var_0_5(arg_198_0)
	return {
		{
			description = "Lists all items with functionality to add them to inventory.",
			category = "Items",
			setting_name = "Add Ring Items (" .. arg_198_0 .. ")",
			item_source = {},
			load_items_source_func = function (arg_199_0)
				table.clear(arg_199_0)

				local var_199_0 = ItemMasterList

				for iter_199_0, iter_199_1 in pairs(var_199_0) do
					if iter_199_1.slot_type == "ring" then
						arg_199_0[#arg_199_0 + 1] = iter_199_0
					end
				end

				table.sort(arg_199_0)
			end,
			func = function (arg_200_0, arg_200_1)
				local var_200_0 = Managers.backend:get_interface("items")
				local var_200_1 = arg_200_0[arg_200_1]

				if var_200_1 then
					var_200_0:award_item(var_200_1, nil, nil, arg_198_0)
				end
			end
		}
	}
end

local function var_0_6(arg_201_0)
	return {
		{
			no_nil = true,
			description = "Lists all items with functionality to add them to inventory.",
			category = "Items",
			setting_name = "Add Necklace Items (" .. arg_201_0 .. ")",
			item_source = {},
			load_items_source_func = function (arg_202_0)
				table.clear(arg_202_0)

				local var_202_0 = ItemMasterList

				for iter_202_0, iter_202_1 in pairs(var_202_0) do
					if iter_202_1.slot_type == "necklace" then
						arg_202_0[#arg_202_0 + 1] = iter_202_0
					end
				end

				table.sort(arg_202_0)
			end,
			func = function (arg_203_0, arg_203_1)
				local var_203_0 = Managers.backend:get_interface("items")
				local var_203_1 = arg_203_0[arg_203_1]

				if var_203_1 then
					var_203_0:award_item(var_203_1, nil, nil, arg_201_0)
				end
			end
		}
	}
end

local function var_0_7(arg_204_0)
	return {
		{
			description = "Lists all items with functionality to add them to inventory.",
			category = "Items",
			setting_name = "Add Trinket Items (" .. arg_204_0 .. ")",
			item_source = {},
			load_items_source_func = function (arg_205_0)
				table.clear(arg_205_0)

				local var_205_0 = ItemMasterList

				for iter_205_0, iter_205_1 in pairs(var_205_0) do
					if iter_205_1.slot_type == "trinket" then
						arg_205_0[#arg_205_0 + 1] = iter_205_0
					end
				end

				table.sort(arg_205_0)
			end,
			func = function (arg_206_0, arg_206_1)
				local var_206_0 = Managers.backend:get_interface("items")
				local var_206_1 = arg_206_0[arg_206_1]

				if var_206_1 then
					var_206_0:award_item(var_206_1, nil, nil, arg_204_0)
				end
			end
		}
	}
end

local var_0_8 = {
	"plentiful",
	"common",
	"rare",
	"exotic",
	"unique"
}

for iter_0_0, iter_0_1 in ipairs(var_0_8) do
	table.append(var_0_2, var_0_3(iter_0_1))
end

for iter_0_2, iter_0_3 in ipairs(var_0_8) do
	table.append(var_0_2, var_0_4(iter_0_3))
end

for iter_0_4, iter_0_5 in ipairs(var_0_8) do
	table.append(var_0_2, var_0_5(iter_0_5))
end

for iter_0_6, iter_0_7 in ipairs(var_0_8) do
	table.append(var_0_2, var_0_6(iter_0_7))
end

for iter_0_8, iter_0_9 in ipairs(var_0_8) do
	table.append(var_0_2, var_0_7(iter_0_9))
end

local function var_0_9(arg_207_0, arg_207_1)
	local function var_207_0(arg_208_0)
		table.clear(arg_208_0)

		local var_208_0 = Managers.player:local_player()
		local var_208_1 = var_208_0:profile_index()
		local var_208_2 = SPProfiles[var_208_1]
		local var_208_3 = var_208_0:career_index()
		local var_208_4 = var_208_2.careers[var_208_3].name
		local var_208_5 = ItemMasterList
		local var_208_6 = Managers.backend:get_interface("common")

		for iter_208_0, iter_208_1 in pairs(var_208_5) do
			if iter_208_1.slot_type == arg_207_0 and var_208_6:can_wield(var_208_4, iter_208_1) then
				arg_208_0[#arg_208_0 + 1] = iter_208_0
			end
		end

		table.sort(arg_208_0)
	end

	local function var_207_1(arg_209_0, arg_209_1)
		local var_209_0 = arg_209_0[arg_209_1]

		if not var_209_0 then
			return
		end

		local var_209_1 = Managers.backend:get_interface("items")
		local var_209_2 = var_209_1:get_item_from_key(var_209_0)

		if not var_209_2 then
			var_209_1:award_item(var_209_0, nil, nil, arg_207_1)

			var_209_2 = var_209_1:get_item_from_key(var_209_0)
		end

		if not var_209_2 then
			return
		end

		local var_209_3 = ItemMasterList[var_209_0]
		local var_209_4 = Managers.player:local_player()
		local var_209_5 = var_209_4.player_unit
		local var_209_6 = ScriptUnit.extension(var_209_5, "inventory_system")

		if var_209_6:resyncing_loadout() then
			return
		end

		local var_209_7 = var_209_2.backend_id
		local var_209_8 = var_209_3.slot_type
		local var_209_9 = InventorySettings.slots_by_slot_index
		local var_209_10

		for iter_209_0, iter_209_1 in pairs(var_209_9) do
			if var_209_8 == iter_209_1.type then
				var_209_10 = iter_209_1.name

				break
			end
		end

		local var_209_11 = var_209_4:profile_index()
		local var_209_12 = SPProfiles[var_209_11]
		local var_209_13 = var_209_12.display_name
		local var_209_14 = Managers.backend:get_interface("hero_attributes"):get(var_209_13, "career")
		local var_209_15 = var_209_12.careers[var_209_14].name

		BackendUtils.set_loadout_item(var_209_7, var_209_15, var_209_10)
		var_209_6:create_equipment_in_slot(var_209_10, var_209_7)
	end

	return {
		{
			description = "Lists all items for current career to equip them, adding to inventory if necessary.",
			category = "Items",
			setting_name = "Equip " .. arg_207_0 .. " Items (" .. arg_207_1 .. ")",
			item_source = {},
			load_items_source_func = var_207_0,
			func = var_207_1
		}
	}
end

for iter_0_10, iter_0_11 in ipairs(var_0_8) do
	table.append(var_0_2, var_0_9("melee", iter_0_11))
end

for iter_0_12, iter_0_13 in ipairs(var_0_8) do
	table.append(var_0_2, var_0_9("ranged", iter_0_13))
end

local var_0_10 = PLATFORM

if IS_PS4 then
	local var_0_11 = {
		{
			description = "Debug PSN Features",
			is_boolean = true,
			setting_name = "debug_psn",
			category = "PS4"
		}
	}

	table.append(var_0_2, var_0_11)
end

if IS_CONSOLE then
	local var_0_12 = {
		{
			setting_name = "Spawn/Unspawn",
			description = "",
			category = "Breed",
			item_source = {},
			load_items_source_func = function (arg_210_0)
				table.clear(arg_210_0)

				arg_210_0[1] = "Switch Breed"
				arg_210_0[2] = "Spawn Breed"
				arg_210_0[3] = "Spawn Group"
				arg_210_0[4] = "Spawn Horde"
				arg_210_0[5] = "Unspawn All Breed"
				arg_210_0[6] = "Unspawn Nearby Breed"
				arg_210_0[7] = "Unspawn Specials"
			end,
			func = function (arg_211_0, arg_211_1)
				local var_211_0 = Managers.state.conflict

				if var_211_0 then
					local var_211_1 = arg_211_0[arg_211_1]

					if var_211_1 == "Switch Breed" then
						local var_211_2 = Managers.time:time("main")

						var_211_0:debug_spawn_switch_breed(var_211_2)
					elseif var_211_1 == "Spawn Breed" then
						local var_211_3 = Managers.time:time("main")

						var_211_0:debug_spawn_breed(var_211_3)
					elseif var_211_1 == "Spawn Group" then
						local var_211_4 = Managers.time:time("main")

						var_211_0:debug_spawn_group(var_211_4)
					elseif var_211_1 == "Spawn Horde" then
						var_211_0:debug_spawn_horde()
					elseif var_211_1 == "Unspawn All Breed" then
						var_211_0:destroy_all_units()
					elseif var_211_1 == "Unspawn Nearby Breed" then
						var_211_0:destroy_close_units(nil, nil, 144)
					elseif var_211_1 == "Unspawn Specials" then
						var_211_0:destroy_specials()
					end
				end
			end
		},
		{
			setting_name = "Set Time Scale (%)",
			description = "",
			category = "Time",
			item_source = {},
			load_items_source_func = function (arg_212_0)
				table.clear(arg_212_0)

				arg_212_0[1] = 1
				arg_212_0[2] = 50
				arg_212_0[3] = 100
				arg_212_0[4] = 200
			end,
			func = function (arg_213_0, arg_213_1)
				local var_213_0 = Managers.state.debug

				if var_213_0 then
					local var_213_1 = arg_213_0[arg_213_1]
					local var_213_2 = table.find(var_213_0.time_scale_list, var_213_1)

					assert(var_213_2, "[DebugScreen] Selected time scale not found in Managers.state.debug.time_scale_list")
					var_213_0:set_time_scale(var_213_2)
				end
			end
		}
	}

	table.append(var_0_2, var_0_12)
end

for iter_0_14, iter_0_15 in pairs(var_0_2) do
	if iter_0_15.preset then
		for iter_0_16, iter_0_17 in pairs(iter_0_15.preset) do
			iter_0_15.description = string.format("%s¤ %s = %s \n", iter_0_15.description, iter_0_16, tostring(iter_0_17))
		end
	end
end

local var_0_13 = {
	visualize_sound_occlusion = function (arg_214_0)
		World.visualize_sound_occlusion()
	end,
	enable_chain_constraints = function (arg_215_0)
		World.enable_chain_constraints(arg_215_0)
	end,
	update_using_luajit = function (arg_216_0)
		if script_data.luajit_disabled then
			jit.off()
			print("lua jit is disabled")
		else
			jit.on()
			print("lua jit is enabled")
		end
	end,
	enable_navigation_visual_debug = function (arg_217_0)
		if arg_217_0 and not VISUAL_DEBUGGING_ENABLED and Managers.state.entity then
			VISUAL_DEBUGGING_ENABLED = true

			local var_217_0 = Managers.state.entity:system("ai_system"):nav_world()

			GwNavWorld.init_visual_debug_server(var_217_0, 4888)
		end
	end,
	disable_outlines = function (arg_218_0)
		if Managers.state and Managers.state.entity then
			Managers.state.entity:system("outline_system"):set_disabled(arg_218_0)
		end
	end
}

return {
	settings = var_0_2,
	callbacks = var_0_13
}
