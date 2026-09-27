-- chunkname: @scripts/utils/debug_screen_config.lua

require("scripts/utils/debug_hero_templates")

local function fn()
	-- function 1
	local backend = Managers.backend

	backend:get_interface("statistics"):save()
	backend:commit(true)
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local _backend_mirror = Managers.backend._backend_mirror
	local tbl = {
		FunctionName = "devGrantItems",
		FunctionParameter = {
			items = arg_2_0
		}
	}

	local function fn(self)
		-- function 3
		local items = self.FunctionResult.items
		local get_interface = Managers.backend:get_interface("items")

		for i = 1, #items do
			if not (not arg_2_1 and i ~= #items) then
				arg_2_1 = nil
			end

			local var_3_2 = items[i]

			_backend_mirror:add_item(var_3_2.ItemInstanceId, var_3_2, arg_2_1)
		end

		local chest_inventory = self.FunctionResult.chest_inventory

		if not chest_inventory then
			_backend_mirror:set_read_only_data("chest_inventory", chest_inventory, true)
		end
	end

	_backend_mirror:request_queue():enqueue(tbl, fn, false)
end

local tbl = {
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
		load_items_source_func = function (self)
			-- function 4
			table.clear(self)

			local get_teleporter_portals = ConflictUtils.get_teleporter_portals()

			for k, v in pairs(get_teleporter_portals) do
				self[#self + 1] = k
			end

			if not Managers.player.is_server then
				local get_main_paths = Managers.state.conflict.level_analysis:get_main_paths()
				local mirror_array = table.mirror_array(self)

				table.sort(self, function (arg_5_0, arg_5_1)
					-- function 5
					local unbox = get_teleporter_portals[arg_5_0][1]:unbox()
					local unbox_2 = get_teleporter_portals[arg_5_1][1]:unbox()
					local closest_pos_at_main_path, var_5_3 = MainPathUtils.closest_pos_at_main_path(get_main_paths, unbox)
					local closest_pos_at_main_path_2, var_5_5 = MainPathUtils.closest_pos_at_main_path(get_main_paths, unbox_2)

					var_5_3 = var_5_3 or math.huge
					var_5_5 = var_5_5 or math.huge

					if var_5_3 ~= var_5_5 then
						return var_5_3 < var_5_5
					end

					return mirror_array[arg_5_0] < mirror_array[arg_5_1]
				end)
			else
				local local_player = Managers.player:local_player()
				local flag = not local_player and local_player.player_unit

				if not ALIVE[flag] then
					return
				end

				local get_entities = Managers.state.entity:get_entities("EndZoneExtension")
				local var_4_6 = next(get_entities)

				if not var_4_6 then
					return
				end

				local world_position = Unit.world_position(var_4_6, 0)
				local world_position_2 = Unit.world_position(flag, 0)
				local num = world_position - world_position_2
				local mirror_array_2 = table.mirror_array(self)

				table.sort(self, function (arg_6_0, arg_6_1)
					-- function 6
					local unbox = get_teleporter_portals[arg_6_0][1]:unbox()
					local unbox_2 = get_teleporter_portals[arg_6_1][1]:unbox()
					local num_2 = unbox - world_position_2
					local num_3 = unbox_2 - world_position_2
					local dot = Vector3.dot(num_2, num)
					local dot_2 = Vector3.dot(num_3, num)

					if dot == dot_2 then
						return mirror_array_2[arg_6_0] < mirror_array_2[arg_6_1]
					end

					return dot < dot_2
				end)
			end
		end,
		func = function (self, arg_7_1)
			-- function 7
			local local_player = Managers.player:local_player()

			if not local_player then
				local player_unit = local_player.player_unit

				if not Unit.alive(player_unit) then
					local get_teleporter_portals = ConflictUtils.get_teleporter_portals()

					if not table.is_empty(get_teleporter_portals) then
						return
					end

					local var_7_3 = self[arg_7_1]
					local unbox = get_teleporter_portals[var_7_3][1]:unbox()
					local unbox_2 = get_teleporter_portals[var_7_3][2]:unbox()
					local extension = ScriptUnit.extension(player_unit, "locomotion_system")
					local world = Managers.world:world("level_world")

					LevelHelper:flow_event(world, "teleport_" .. self[arg_7_1])
					extension:teleport_to(unbox, unbox_2)
				end
			end

			print("TELEPORT")
		end
	},
	{
		setting_name = "teleport player when enter game",
		description = "When entering a level, Teleports the player to a portal hub element",
		category = "Allround useful stuff!",
		item_source = {},
		load_items_source_func = function (self)
			-- function 8
			if not Managers.level_transition_handler:get_current_level_keys() then
				return
			end

			table.clear(self)

			self[1] = "[clear value]"

			local get_teleporter_portals = ConflictUtils.get_teleporter_portals()

			for k, v in pairs(get_teleporter_portals) do
				self[#self + 1] = k
			end

			if not Managers.player.is_server then
				local get_main_paths = Managers.state.conflict.level_analysis:get_main_paths()
				local mirror_array = table.mirror_array(self)

				table.sort(self, function (arg_9_0, arg_9_1)
					-- function 9
					if not (arg_9_0 == "[clear value]" or arg_9_1 ~= "[clear value]") then
						return arg_9_0 == "[clear value]"
					end

					local unbox = get_teleporter_portals[arg_9_0][1]:unbox()
					local unbox_2 = get_teleporter_portals[arg_9_1][1]:unbox()
					local closest_pos_at_main_path, var_9_3 = MainPathUtils.closest_pos_at_main_path(get_main_paths, unbox)
					local closest_pos_at_main_path_2, var_9_5 = MainPathUtils.closest_pos_at_main_path(get_main_paths, unbox_2)

					var_9_3 = var_9_3 or math.huge
					var_9_5 = var_9_5 or math.huge

					if var_9_3 ~= var_9_5 then
						return var_9_3 < var_9_5
					end

					return mirror_array[arg_9_0] < mirror_array[arg_9_1]
				end)
			else
				local local_player = Managers.player:local_player()
				local flag = not local_player and local_player.player_unit

				if not ALIVE[flag] then
					return
				end

				local get_entities = Managers.state.entity:get_entities("EndZoneExtension")
				local var_8_6 = next(get_entities)

				if not var_8_6 then
					return
				end

				local world_position = Unit.world_position(var_8_6, 0)
				local world_position_2 = Unit.world_position(flag, 0)
				local num = world_position - world_position_2
				local mirror_array_2 = table.mirror_array(self)

				table.sort(self, function (arg_10_0, arg_10_1)
					-- function 10
					if not (arg_10_0 == "[clear value]" or arg_10_1 ~= "[clear value]") then
						return arg_10_0 == "[clear value]"
					end

					local unbox = get_teleporter_portals[arg_10_0][1]:unbox()
					local unbox_2 = get_teleporter_portals[arg_10_1][1]:unbox()
					local num_2 = unbox - world_position_2
					local num_3 = unbox_2 - world_position_2
					local dot = Vector3.dot(num_2, num)
					local dot_2 = Vector3.dot(num_3, num)

					if dot == dot_2 then
						return mirror_array_2[arg_10_0] < mirror_array_2[arg_10_1]
					end

					return dot < dot_2
				end)
			end
		end,
		func = function (self, arg_11_1)
			-- function 11
			if self[arg_11_1] == "[clear value]" then
				return
			end

			local local_player = Managers.player:local_player()

			if not local_player then
				local player_unit = local_player.player_unit

				if not Unit.alive(player_unit) then
					local get_teleporter_portals = ConflictUtils.get_teleporter_portals()

					if not table.is_empty(get_teleporter_portals) then
						return
					end

					local var_11_3 = self[arg_11_1]
					local unbox = get_teleporter_portals[var_11_3][1]:unbox()
					local unbox_2 = get_teleporter_portals[var_11_3][2]:unbox()
					local extension = ScriptUnit.extension(player_unit, "locomotion_system")
					local world = Managers.world:world("level_world")

					LevelHelper:flow_event(world, "teleport_" .. var_11_3)
					extension:teleport_to(unbox, unbox_2)
				end
			end

			local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()

			script_data["teleport player when enter game"] = get_current_level_keys .. ":" .. self[arg_11_1]

			Development.set_setting("teleport player when enter game", get_current_level_keys .. ":" .. self[arg_11_1])
			Development.clear_param_cache("teleport player when enter game")
			print("TELEPORT")
		end
	},
	{
		setting_name = "teleport player to player",
		description = "Teleports the player to another player.",
		category = "Allround useful stuff!",
		item_source = {},
		load_items_source_func = function (self)
			-- function 12
			table.clear(self)

			local tbl = {}

			self.data = tbl

			local players = Managers.player:players()
			local local_player = Managers.player:local_player()

			for k, v in pairs(players) do
				if v ~= local_player then
					self[#self + 1] = v:name()
					tbl[#tbl + 1] = v
				end
			end
		end,
		func = function (self, arg_13_1)
			-- function 13
			local local_player = Managers.player:local_player()
			local data = self.data

			if not local_player then
				local player_unit = local_player.player_unit

				if not Unit.alive(player_unit) then
					return
				end

				if not table.is_empty(data) then
					return
				end

				local player_unit_2 = data[arg_13_1].player_unit

				if not Unit.alive(player_unit_2) then
					return
				end

				local extension = ScriptUnit.extension(player_unit, "locomotion_system")
				local extension_2 = ScriptUnit.extension(player_unit_2, "locomotion_system")
				local mover = Unit.mover(player_unit_2)
				local position = Mover.position(mover)
				local current_rotation = extension_2:current_rotation()

				extension:teleport_to(position, current_rotation)
			end
		end
	},
	{
		setting_name = "teleport player to player repeatedly",
		description = "Teleports the player to another player every 2 seconds.",
		category = "Allround useful stuff!",
		item_source = {},
		load_items_source_func = function (self)
			-- function 14
			table.clear(self)

			local tbl = {}

			self.data = tbl

			local players = Managers.player:players()
			local local_player = Managers.player:local_player()

			for k, v in pairs(players) do
				if v ~= local_player then
					self[#self + 1] = v:name()
					tbl[#tbl + 1] = v
				end
			end

			self[#self + 1] = "Turn Off"
			tbl[#tbl + 1] = {}
		end,
		func = function (self, arg_15_1)
			-- function 15
			local data = self.data

			if not table.is_empty(data) then
				return
			end

			local str = "teleport player to player repeatedly"

			if not Managers.updator:has(str) then
				Managers.updator:remove(str)
			end

			local num = 0
			local player_unit = data[arg_15_1].player_unit

			Managers.updator:add(function (arg_16_0)
				-- function 16
				num = num - arg_16_0

				if num > 0 then
					return
				end

				num = 2

				UPDATE_POSITION_LOOKUP()

				local local_player = Managers.player:local_player()

				if not local_player then
					return
				end

				local player_unit_2 = local_player.player_unit

				if not Unit.alive(player_unit_2) then
					return
				end

				if not Unit.alive(player_unit) then
					Managers.updator:remove(str)

					return
				end

				local extension = ScriptUnit.extension(player_unit_2, "locomotion_system")
				local extension_2 = ScriptUnit.extension(player_unit, "locomotion_system")
				local mover = Unit.mover(player_unit)
				local position = Mover.position(mover)
				local current_rotation = extension_2:current_rotation()

				extension:teleport_to(position, current_rotation)
			end, str)
		end
	},
	{
		description = "Teleports the bots to the local player.",
		category = "Allround useful stuff!",
		setting_name = "teleport bots to local player",
		func = function ()
			-- function 17
			local bots = Managers.player:bots()
			local local_player = Managers.player:local_player()

			if not local_player and not local_player.player_unit then
				local player_unit = local_player.player_unit
				local extension = ScriptUnit.extension(player_unit, "locomotion_system")
				local mover = Unit.mover(player_unit)
				local position = Mover.position(mover)
				local current_rotation = extension:current_rotation()

				for k, v in pairs(bots) do
					ScriptUnit.extension(v.player_unit, "locomotion_system"):teleport_to(position, current_rotation)
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
			-- function 18
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
		load_items_source_func = function (self)
			-- function 19
			table.clear(self)
			table.keys(LevelSettings, self)

			local tbl = {}

			for i = #self, 1, -1 do
				local var_19_1 = self[i]
				local environment_variations = LevelSettings[var_19_1].environment_variations

				if not environment_variations then
					for j = #environment_variations, 1, -1 do
						local str = var_19_1 .. "_" .. environment_variations[j]

						table.insert(self, str)

						self[str] = {
							var_19_1,
							j
						}
						tbl[str] = true
					end
				end
			end

			local mirror_array_inplace = table.mirror_array_inplace({
				"inn_level",
				"whitebox"
			})
			local mirror_array_inplace_2 = table.mirror_array_inplace({
				"adventure",
				"versus",
				"deus",
				"weaves"
			})

			table.sort(self, function (arg_20_0, arg_20_1)
				-- function 20
				if mirror_array_inplace[arg_20_0] or not mirror_array_inplace[arg_20_1] then
					local var_20_0 = mirror_array_inplace[arg_20_0]

					var_20_0 = var_20_0 or math.huge

					local var_20_1 = mirror_array_inplace[arg_20_1]

					var_20_1 = var_20_1 or math.huge

					return var_20_0 < var_20_1
				end

				if tbl[arg_20_0] or not tbl[arg_20_1] then
					if not (not tbl[arg_20_0] and tbl[arg_20_1]) then
						return not tbl[arg_20_0]
					else
						return arg_20_0 < arg_20_1
					end
				end

				local var_20_2 = LevelSettings[arg_20_0]
				local var_20_3 = LevelSettings[arg_20_1]

				if var_20_2.mechanism ~= var_20_3.mechanism then
					local var_20_4 = mirror_array_inplace_2[var_20_2.mechanism]

					var_20_4 = var_20_4 or math.huge

					local var_20_5 = mirror_array_inplace_2[var_20_3.mechanism]

					var_20_5 = var_20_5 or math.huge

					return var_20_4 < var_20_5
				end

				local find = table.find(GameActsOrder, var_20_2.act)

				find = find or math.huge

				local find_2 = table.find(GameActsOrder, var_20_3.act)

				find_2 = find_2 or math.huge

				if find < find_2 then
					return true
				elseif find == find_2 then
					local act_presentation_order = var_20_2.act_presentation_order
					local act_presentation_order_2 = var_20_3.act_presentation_order

					if act_presentation_order or not act_presentation_order_2 then
						return (act_presentation_order or math.huge) < (act_presentation_order_2 or math.huge)
					else
						local map_settings = var_20_2.map_settings

						map_settings = not map_settings and var_20_2.map_settings.sorting

						local map_settings_2 = var_20_3.map_settings

						map_settings_2 = not map_settings_2 and var_20_3.map_settings.sorting

						if map_settings or not map_settings_2 then
							return (map_settings or math.huge) < (map_settings_2 or math.huge)
						else
							return arg_20_0 < arg_20_1
						end
					end
				else
					return false
				end
			end)
		end,
		func = function (self, arg_21_1)
			-- function 21
			if not Managers.state.network.is_server then
				return
			end

			local var_21_0 = self[arg_21_1]
			local num = 0
			local var_21_2 = self[var_21_0]

			if not var_21_2 then
				var_21_0 = var_21_2[1]
				num = var_21_2[2]
			end

			local var_21_3 = LevelSettings[var_21_0]

			if not var_21_3.hub_level then
				Managers.mechanism:override_hub_level(var_21_0)
			end

			Debug.load_level(var_21_0, num, var_21_3.debug_environment_level_flow_event)
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
			-- function 22
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
		func = function (self, arg_23_1)
			-- function 23
			local var_23_0 = self[arg_23_1]
			local local_player = Managers.player:local_player()
			local flag = not local_player and local_player.player_unit

			if not Unit.alive(flag) then
				local extension = ScriptUnit.extension(flag, "status_system")

				if extension:is_invisible() ~= var_23_0 then
					extension:set_invisible(var_23_0, nil, "debug_invis")

					local flag_2

					flag_2 = not var_23_0 and "Local player is now invisible" and "Local player is now visible"

					Debug.sticky_text(flag_2)
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
		load_items_source_func = function (self)
			-- function 24
			table.clear(self)

			local tbl = {}

			self.data = tbl

			local local_player = Managers.player:local_player()
			local network_id = local_player:network_id()
			local local_player_id = local_player:local_player_id()
			local get_party_from_player_id = Managers.party:get_party_from_player_id(network_id, local_player_id)
			local available_profiles = Managers.state.side.side_by_party[get_party_from_player_id].available_profiles

			available_profiles = available_profiles or PROFILES_BY_AFFILIATION.heroes

			for i = 1, #available_profiles do
				local var_24_6 = available_profiles[i]
				local num = #self + 1

				self[num] = var_24_6
				tbl[num] = var_24_6
			end
		end,
		func = function (self, arg_25_1)
			-- function 25
			local var_25_0 = self.data[arg_25_1]

			if not var_25_0 then
				local var_25_1 = FindProfileIndex(var_25_0)
				local careers = SPProfiles[var_25_1].careers
				local var_25_3 = careers[script_data.wanted_career_index]

				var_25_3 = var_25_3 or careers[1]

				local flag = true

				if var_25_3.display_name == "vs_undecided" then
					return
				end

				Managers.state.network:request_profile(1, var_25_0, var_25_3.display_name, flag)
			end
		end
	},
	{
		setting_name = "switch_party",
		description = "Switch party you you want to spawn in. Note: you need to 'switch_class' for it to be fulfilled",
		category = "Player mechanics recommended",
		item_source = {},
		load_items_source_func = function (self)
			-- function 26
			local parties = Managers.party:parties()

			table.clear(self)

			local tbl = {}

			self.data = tbl

			for i, v in ipairs(parties) do
				local num = #self + 1
				local num_2 = v.num_used_slots - v.num_bots
				local num_slots = v.num_slots

				if num_2 < num_slots then
					self[num] = string.format("%s (%d/%d)", v.party_id, num_2, num_slots)
				else
					self[num] = string.format("%s (%d/%d) FULL!", v.party_id, num_2, num_slots)
				end

				tbl[num] = v.party_id
			end
		end,
		func = function (self, arg_27_1)
			-- function 27
			local var_27_0 = self.data[arg_27_1]

			if not var_27_0 then
				local get_party = Managers.party:get_party(var_27_0)

				if get_party.num_open_slots + get_party.num_bots > 0 then
					print("Debug switching wanted party to:", var_27_0)

					local local_player = Managers.player:local_player()
					local local_player_id = local_player:local_player_id()
					local network_id = local_player:network_id()
					local current_mechanism_name = Managers.mechanism:current_mechanism_name()
					local var_27_6 = Managers.state.side.side_by_party[get_party]

					Managers.party:request_join_party(network_id, local_player_id, var_27_0)

					if not local_player and not local_player:needs_despawn() then
						Managers.state.spawn:delayed_despawn(local_player)
					end

					local system = Managers.state.entity:system("camera_system")

					if get_party.name == "spectators" then
						local spectator = PROFILES_BY_NAME.spectator

						system:initialize_camera_states(local_player, spectator.index, 1)
					else
						local var_27_9 = FindProfileIndex("witch_hunter")

						system:initialize_camera_states(local_player, var_27_9, 1)
					end

					local sides = Managers.state.side:sides()
					local var_27_11
					local var_27_12

					for i = 1, #sides do
						local var_27_13 = sides[i]
						local format = string.format("%s_%s", current_mechanism_name, var_27_13:name())
						local flag = var_27_13 == var_27_6

						Managers.state.game_mode:set_object_set_enabled(format, flag)
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
		load_items_source_func = function (self)
			-- function 28
			local parties = Managers.party:parties()

			table.clear(self)

			self[#self + 1] = "none"

			for i = 1, #parties do
				local var_28_1 = parties[i]

				self[#self + 1] = var_28_1.party_id
			end
		end,
		func = function (self, arg_29_1)
			-- function 29
			if not self[arg_29_1] then
				-- Nothing
			end
		end
	},
	{
		setting_name = "switch_ai_debug_spawning_party",
		description = "Switch what party you want debugging spawning (P) AI units to belong to",
		category = "Player mechanics recommended",
		item_source = {},
		load_items_source_func = function (self)
			-- function 30
			local sides = Managers.state.side:sides()

			table.clear(self)

			for k, v in pairs(sides) do
				self[#self + 1] = v.side_id
			end
		end,
		func = function (self, arg_31_1)
			-- function 31
			local var_31_0 = self[arg_31_1]

			if not var_31_0 then
				Managers.state.conflict:set_debug_spawn_side(var_31_0)
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
			-- function 32
			local backend = Managers.backend
			local career_name = Managers.player:local_player():career_name()

			backend:get_interface("talents"):set_talents(career_name, {
				0,
				0,
				0,
				0,
				0
			})
			backend:commit(true)
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
		load_items_source_func = function (self)
			-- function 33
			table.clear(self)

			local BuffTemplates = BuffTemplates

			for k, v in pairs(BuffTemplates) do
				v = BuffUtils.get_buff_template(k)

				if not (not v.buffs and not v.buffs[1] and v.buffs[1].dormant) then
					self[#self + 1] = k
				end
			end

			table.sort(self)
		end,
		func = function (self, arg_34_1)
			-- function 34
			local var_34_0 = self[arg_34_1]
			local player_unit = Managers.player:local_player().player_unit
			local system = Managers.state.entity:system("buff_system")
			local flag = false

			system:add_buff(player_unit, var_34_0, player_unit, flag)
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
			-- function 35
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
		custom_item_source_order = function (arg_36_0, arg_36_1)
			-- function 36
			for i, v in ipairs(arg_36_0) do
				local var_36_0 = v

				arg_36_1[#arg_36_1 + 1] = var_36_0
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
		custom_item_source_order = function (arg_37_0, arg_37_1)
			-- function 37
			for i, v in ipairs(arg_37_0) do
				local var_37_0 = v

				arg_37_1[#arg_37_1 + 1] = var_37_0
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
		load_items_source_func = function (self)
			-- function 38
			table.clear(self)

			if not (Managers.level_transition_handler:in_hub_level() or Managers.mechanism:current_mechanism_name() == "versus") then
				return
			end

			local game_mechanism = Managers.mechanism:game_mechanism()
			local num_sets = game_mechanism:get_objective_settings().num_sets
			local get_current_set = game_mechanism:get_current_set()

			for i = 1, num_sets do
				if get_current_set < i then
					self[#self + 1] = i
				end
			end
		end,
		func = function (self, arg_39_1)
			-- function 39
			local var_39_0 = self[arg_39_1]

			if not var_39_0 then
				return
			end

			Managers.mechanism:game_mechanism():debug_skip_to_set(var_39_0)
		end
	},
	{
		description = "Ends a vs match. UI might get messed",
		close_when_selected = true,
		setting_name = "vs_end_match",
		category = "Versus",
		propagate_to_server = true,
		func = function (arg_40_0, arg_40_1)
			-- function 40
			if not (Managers.level_transition_handler:in_hub_level() or Managers.mechanism:current_mechanism_name() == "versus") then
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
		custom_item_source_order = function (arg_41_0, arg_41_1)
			-- function 41
			for i, v in ipairs(arg_41_0) do
				local var_41_0 = v

				arg_41_1[#arg_41_1 + 1] = var_41_0
			end
		end,
		func = function (self, arg_42_1)
			-- function 42
			if not Managers.level_transition_handler:in_hub_level() then
				return
			end

			local var_42_0 = self[arg_42_1]

			Managers.mechanism:game_mechanism():win_conditions():debug_add_score(var_42_0)
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
		func = function (arg_43_0, arg_43_1)
			-- function 43
			local player_unit = Managers.player:local_player(1).player_unit

			StatusUtils.set_grabbed_by_pack_master_network("pack_master_dropping", player_unit, true, nil)
		end
	},
	{
		setting_name = "Add Versus Experience",
		description = "Adds Versus Experience to your account.",
		category = "Versus",
		item_source = {},
		load_items_source_func = function (self)
			-- function 44
			table.clear(self)

			self[1] = 100
			self[2] = 500
			self[3] = 2000
			self[4] = 5000
			self[5] = 10000
			self[6] = 100000
		end,
		func = function (self, arg_45_1)
			-- function 45
			local backend = Managers.backend
			local var_45_1 = self[arg_45_1]

			var_45_1 = var_45_1 or 1

			local local_player = Managers.player:local_player(1)

			local function fn(self)
				-- function 46
				local FunctionResult = self.FunctionResult
				local player_profile_data = self.FunctionResult.data.player_profile_data

				Managers.backend:get_backend_mirror():set_read_only_data("vs_profile_data", cjson.encode(player_profile_data), true)
			end

			local tbl = {
				FunctionName = "devAddVersusExperience",
				FunctionParameter = {
					experience = var_45_1
				}
			}

			backend._backend_mirror:request_queue():enqueue(tbl, fn, false)
		end
	},
	{
		setting_name = "Add Versus Currency",
		description = "Adds Versus Versus Currency.",
		category = "Versus",
		item_source = {},
		load_items_source_func = function (self)
			-- function 47
			table.clear(self)

			self[1] = 1
			self[2] = 5
			self[3] = 10
			self[4] = 50
			self[5] = 100
		end,
		func = function (self, arg_48_1)
			-- function 48
			local backend = Managers.backend
			local var_48_1 = self[arg_48_1]

			var_48_1 = var_48_1 or 1

			local get_interface = backend:get_interface("peddler")
			local get_chips = get_interface:get_chips("VS")
			local local_player = Managers.player:local_player(1)

			local function fn(self)
				-- function 49
				local FunctionResult = self.FunctionResult

				get_interface:set_chips("VS", FunctionResult.new_vs_currency)
			end

			local tbl = {
				FunctionName = "devGrantVersusCurrency",
				FunctionParameter = {
					amount = var_48_1
				}
			}

			backend._backend_mirror:request_queue():enqueue(tbl, fn, false)
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
		load_items_source_func = function (self)
			-- function 50
			table.clear(self)

			for k, v in pairs(HordeSettings) do
				self[#self + 1] = v.mini_patrol_composition
			end
		end,
		func = function (self, arg_51_1)
			-- function 51
			local var_51_0 = self[arg_51_1]

			if not var_51_0 then
				print("Debug spawning mini patrol of composition:", var_51_0)

				local tbl = {
					size = 0,
					template = "mini_patrol",
					id = Managers.state.entity:system("ai_group_system"):generate_group_id()
				}
				local time = Managers.time:time("game")
				local var_51_3

				Managers.state.conflict:mini_patrol(time, nil, var_51_3, var_51_0, tbl)
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
		custom_item_source_order = function (arg_52_0, arg_52_1)
			-- function 52
			for i, v in ipairs(arg_52_0) do
				local var_52_0 = v

				arg_52_1[#arg_52_1 + 1] = var_52_0
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
			-- function 53
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
			-- function 54
			Managers.state.conflict.level_analysis:draw_patrol_routes()
		end
	},
	{
		description = "Draws patrol start positions",
		category = "AI",
		setting_name = "draw_patrol_start_positions",
		func = function ()
			-- function 55
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
		custom_item_source_order = function (arg_56_0, arg_56_1)
			-- function 56
			table.append(arg_56_1, arg_56_0)
		end
	},
	{
		description = "Spawns a boss patrol at the closest spawner, use draw_patrol_start_positions to see spawners",
		category = "AI",
		setting_name = "spawn_patrol_at_closest_spawner",
		func = function ()
			-- function 57
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
		load_items_source_func = function (self)
			-- function 58
			table.clear(self)

			for i = -DifficultyTweak.range, DifficultyTweak.range do
				self[#self + 1] = i
			end

			table.sort(self)

			self[#self + 1] = "[clear value]"
		end
	},
	{
		description = "Draws a sphere and text at each respawner unit in the level. Must set 'debug_ai_recycler=true'",
		category = "AI",
		setting_name = "debug_spawn_ogre_from_closest_boss_spawner",
		func = function ()
			-- function 59
			if not script_data.debug_ai_recycler then
				local flag = false

				Managers.state.conflict.level_analysis:debug_spawn_boss_from_closest_spawner_to_player(flag)
			end
		end
	},
	{
		description = "Injects all patrols into the main path'",
		category = "AI",
		setting_name = "debug_spawn_all_boss_patrols",
		func = function ()
			-- function 60
			print("All boss patrols injected into the main path now")
			Managers.state.conflict.level_analysis:spawn_all_boss_spline_patrols()
		end
	},
	{
		description = "Injects all bosses into the main path'",
		category = "AI",
		setting_name = "debug_inject_bosses_in_all_boss_spawners",
		func = function ()
			-- function 61
			print("All boss enemies are now injected into the main path!")
			Managers.state.conflict.level_analysis:inject_all_bosses_into_main_path()
		end
	},
	{
		description = "Debug spawns one special through the specials spawning system.",
		category = "AI",
		setting_name = "debug_spawn_special",
		func = function ()
			-- function 62
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
			-- function 63
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
		func = function (self, arg_64_1)
			-- function 64
			local var_64_0 = self[arg_64_1]
			local nav_world = Managers.state.entity:system("ai_system"):nav_world()

			if var_64_0 == "off" then
				print("Not changing pathfinding budget")
			elseif var_64_0 == "short" then
				local num = 0.1

				printf("Changing pathfinding budget to %.1fms", num)
				GwNavWorld.set_pathfinder_budget(nav_world, num * 0.001)
			else
				local num_2 = 100

				printf("Changing pathfinding budget to %.1fms", num_2)
				GwNavWorld.set_pathfinder_budget(nav_world, num_2 * 0.001)
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
		load_items_source_func = function (self)
			-- function 65
			table.clear(self)

			for i = -DifficultyTweak.range, DifficultyTweak.range do
				self[#self + 1] = i
			end

			table.sort(self)

			self[#self + 1] = "[clear value]"
		end
	},
	{
		description = "Set difficulty. No restart required for most stuff, mostly used for testing enemies. Some stuff might need restart of level.",
		setting_name = "set_difficulty",
		category = "Gamemode/level",
		item_source = {},
		load_items_source_func = function (self)
			-- function 66
			table.clear(self)

			for k, v in pairs(Difficulties) do
				self[#self + 1] = v
			end

			table.sort(self)
		end,
		func = function (self, arg_67_1)
			-- function 67
			local var_67_0 = self[arg_67_1]
			local get_difficulty, var_67_2 = Managers.state.difficulty:get_difficulty()

			Managers.state.difficulty:set_difficulty(var_67_0, var_67_2)

			local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

			for i = 1, #PLAYER_AND_BOT_UNITS do
				local var_67_4 = PLAYER_AND_BOT_UNITS[i]
				local has_extension = ScriptUnit.has_extension(var_67_4, "attack_intensity_system")

				if not has_extension then
					has_extension:refresh_difficulty()
				end
			end

			print("Set difficulty to " .. var_67_0 .. var_67_2)
		end
	},
	{
		setting_name = "set_difficulty_tweak",
		category = "Gamemode/level",
		description = "Set difficulty tweak to make the current difficulty slightly easier/harder. " .. "No restart required for most stuff, mostly used for testing enemies. Some stuff might need restart of level.",
		item_source = {},
		load_items_source_func = function (self)
			-- function 68
			table.clear(self)

			for i = -DifficultyTweak.range, DifficultyTweak.range do
				self[#self + 1] = i
			end

			table.sort(self)
		end,
		func = function (self, arg_69_1)
			-- function 69
			local get_difficulty, var_69_1 = Managers.state.difficulty:get_difficulty()
			local var_69_2 = self[arg_69_1]

			Managers.state.difficulty:set_difficulty(get_difficulty, var_69_2)
			print("Set difficulty to " .. get_difficulty .. var_69_2)
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
		load_items_source_func = function (self)
			-- function 70
			table.clear(self)

			self[1] = "Listen"
			self[2] = "[clear value]"

			local var_70_0 = rawget(_G, "_sound_cue_breakpoint_set")

			if not var_70_0 then
				local count = #self

				for k in pairs(var_70_0) do
					count = count + 1
					self[count] = k
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
			-- function 71
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
	}
}
local tbl_2 = {
	setting_name = "simulate_color_blindness",
	category = "Visual/audio"
}
local flag

flag = BUILD ~= "dev" or not "Enables or disables different color blindness simulations." or "This is only available in dev builds for performance reasons. Switch exe to dev to see the effects of the changes."
tbl_2.description = flag
tbl_2.item_source = {
	common_deuteranomaly = true,
	off = true,
	rare_protanomaly = true,
	very_rare_tritanomaly = true
}

tbl_2.func = function (self, arg_72_1)
	-- function 72
	local var_72_0 = self[arg_72_1]
	local flag = true
	local num = 0

	if var_72_0 == "off" then
		flag = false
	else
		num = (var_72_0 ~= "rare_protanomaly" or not 0 or var_72_0 ~= "common_deuteranomaly") and (not 1 or 2)
	end

	if not flag then
		printf("Turning on mode %d of color blindness simulation.", num)
		Application.set_user_setting("render_settings", "color_blindness_mode", num)
	else
		printf("Turning off color blindness simulation.")
	end

	Application.set_user_setting("render_settings", "simulate_color_blindness", flag)
	Application.apply_user_settings()
	GlobalShaderFlags.apply_settings()
end

tbl[318] = tbl_2

local tbl_3 = {
	description = "This is used to turn off the fading of AI characters that collide with the camera. This is useful when recording cutscenes.",
	is_boolean = true,
	setting_name = "fade_on_camera_ai_collision",
	category = "Replay"
}

tbl[319] = tbl_3

local tbl_4 = {
	description = "This is used to turn off the screenspace effects that is aimed at a first person view. This is useful when recording cutscenes.",
	is_boolean = true,
	setting_name = "screen_space_player_camera_reactions",
	category = "Replay"
}

tbl[320] = tbl_4

local tbl_5 = {
	no_nil = true,
	description = "Enables chain constraints",
	setting_name = "enable_chain_constraints",
	callback = "enable_chain_constraints",
	category = "Constraints",
	is_boolean = true
}

tbl[321] = tbl_5

local tbl_6 = {
	description = "Network debugging",
	is_boolean = true,
	setting_name = "network_debug",
	category = "Network"
}

tbl[322] = tbl_6

local tbl_7 = {
	description = "Fakes mismatching network hash",
	is_boolean = true,
	setting_name = "fake_network_hash",
	category = "Network"
}

tbl[323] = tbl_7

local tbl_8 = {
	description = "Keeps track of the number of times an rpc send request has been triggered from a certain code row and prints the top 5 most occurring ones. Note: Disregards exclusive local rpc send calls.",
	is_boolean = true,
	setting_name = "rpc_send_count_debug",
	category = "Network"
}

tbl[324] = tbl_8

local tbl_9 = {
	description = "Set network logging to Network.MESSAGES on startup",
	is_boolean = true,
	setting_name = "network_log_messages",
	category = "Network"
}

tbl[325] = tbl_9

local tbl_10 = {
	description = "Set network logging to Network.SPEW on startup",
	is_boolean = true,
	setting_name = "network_log_spew",
	category = "Network"
}

tbl[326] = tbl_10

local tbl_11 = {
	description = "matchmaking debug logging",
	is_boolean = true,
	setting_name = "matchmaking_debug",
	category = "Network"
}

tbl[327] = tbl_11

local tbl_12 = {
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
}

tbl[328] = tbl_12

local tbl_13 = {
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
	custom_item_source_order = function (arg_73_0, arg_73_1)
		-- function 73
		for i, v in ipairs(arg_73_0) do
			local var_73_0 = v

			arg_73_1[#arg_73_1 + 1] = var_73_0
		end
	end,
	func = function (self, arg_74_1)
		-- function 74
		local var_74_0 = self[arg_74_1]

		script_data.backend_response_latency = var_74_0
	end
}

tbl[329] = tbl_13

local tbl_14 = {
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
}

tbl[330] = tbl_14

local tbl_15 = {
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
}

tbl[331] = tbl_15

local tbl_16 = {
	description = "Shows the current clock time",
	is_boolean = true,
	setting_name = "network_clock_debug",
	category = "Network"
}

tbl[332] = tbl_16

local tbl_17 = {
	description = "Debug Print Profile Package Loading",
	is_boolean = true,
	setting_name = "profile_package_loading_debug",
	category = "Network"
}

tbl[333] = tbl_17

local tbl_18 = {
	description = "Debugs connections for the network",
	is_boolean = true,
	setting_name = "network_debug_connections",
	category = "Network"
}

tbl[334] = tbl_18

local tbl_19 = {
	description = "Debugs lobbies and matchmaking",
	is_boolean = true,
	setting_name = "debug_lobbies",
	category = "Network"
}

tbl[335] = tbl_19

local tbl_20 = {
	description = "Shows lobby data key/values",
	is_boolean = true,
	setting_name = "debug_lobby_data",
	category = "Network"
}

tbl[336] = tbl_20

local tbl_21 = {
	description = "Debug draw peer state machine states.",
	is_boolean = true,
	setting_name = "network_draw_peer_states",
	category = "Network"
}

tbl[337] = tbl_21

local tbl_22 = {
	description = "Logs information about the profile synchronizer. Best used together with shared_state_debug.",
	is_boolean = true,
	setting_name = "profile_synchronizer_debug_logging",
	category = "Network"
}

tbl[338] = tbl_22

local tbl_23 = {
	description = "Allows host to query himself. Fixes the time_left of votes to 1s.",
	is_boolean = true,
	setting_name = "debug_vote_manager",
	category = "Network"
}

tbl[339] = tbl_23

local tbl_24 = {
	description = "Do not check the network hash when joining a game as a client.",
	is_boolean = true,
	setting_name = "do_not_check_network_hash_when_joining",
	category = "Network"
}

tbl[340] = tbl_24

local tbl_25 = {
	description = "Do not blacklist lobbies when exiting/cancelling as a client.",
	is_boolean = true,
	setting_name = "do_not_add_broken_lobby_client",
	category = "Network"
}

tbl[341] = tbl_25

local tbl_26 = {
	description = "Debug All Contexts",
	is_boolean = true,
	setting_name = "dialogue_debug_all_contexts",
	category = "Dialogue"
}

tbl[342] = tbl_26

local tbl_27 = {
	description = "Debug Last Query",
	is_boolean = true,
	setting_name = "dialogue_debug_last_query",
	category = "Dialogue"
}

tbl[343] = tbl_27

local tbl_28 = {
	description = "Debug Print Successful Queries",
	is_boolean = true,
	setting_name = "dialogue_debug_last_played_query",
	category = "Dialogue"
}

tbl[344] = tbl_28

local tbl_29 = {
	description = "Debug Print Queries",
	is_boolean = true,
	setting_name = "dialogue_debug_queries",
	category = "Dialogue"
}

tbl[345] = tbl_29

local tbl_30 = {
	description = "Debug show Proximities",
	is_boolean = true,
	setting_name = "dialogue_debug_proximity_system",
	category = "Dialogue"
}

tbl[346] = tbl_30

local tbl_31 = {
	description = "Visualize lookat system",
	is_boolean = true,
	setting_name = "dialogue_debug_lookat",
	category = "Dialogue"
}

tbl[347] = tbl_31

local tbl_32 = {
	description = "Debug subtitles",
	is_boolean = true,
	setting_name = "subtitle_debug",
	category = "Dialogue"
}

tbl[348] = tbl_32

local tbl_33 = {
	description = "Loop through active dialogue rules and filter a single one. No other rules will be loaded. (Requires restart)",
	setting_name = "filter_single_dialogue_rule",
	category = "Dialogue",
	item_source = {
		"[clear value]"
	},
	load_items_source_func = function (self)
		-- function 75
		table.clear(self)

		local system = Managers.state.entity:system("dialogue_system")

		if not system then
			local rule_id_mapping = system:tagquery_database().rule_id_mapping

			for i = 1, #rule_id_mapping do
				self[i] = rule_id_mapping[i].name
			end
		end

		table.insert(self, 1, "[clear value]")
	end
}

tbl[349] = tbl_33

local tbl_34 = {
	description = "Displays loaded dialogue files and filter a single one. No other files will be loaded on level load. (Requires restart)",
	setting_name = "filter_single_dialogue_file",
	category = "Dialogue",
	item_source = {},
	load_items_source_func = function (self)
		-- function 76
		table.clear(self)

		if not Managers.state.entity:system("dialogue_system") then
			local debug_loaded_files = Managers.state.entity:system("dialogue_system"):tagquery_loader().debug_loaded_files

			if not debug_loaded_files then
				for k in pairs(debug_loaded_files) do
					self[#self + 1] = string.match(k, "^.+/(.+)$")
				end

				table.sort(self)
			end
		end

		table.insert(self, 1, "[clear value]")
	end
}

tbl[350] = tbl_34

local tbl_35 = {
	setting_name = "debug_dialogue_files",
	description = "Used to debug dialog files, facial expressions and missing vo/subtitles. To skip use: DebugVo.jump_to(('line_number/line_id')",
	category = "Dialogue",
	item_source = {},
	load_items_source_func = function (self)
		-- function 77
		table.clear(self)

		local system = Managers.state.entity:system("dialogue_system")

		if not system then
			local debug_loaded_files = system:tagquery_loader().debug_loaded_files

			if not debug_loaded_files then
				for k in pairs(debug_loaded_files) do
					self[#self + 1] = string.match(k, "^.+/(.+)$")
				end

				table.sort(self)
			end
		end

		table.insert(self, 1, "[clear value]")
	end,
	func = function (self, arg_78_1)
		-- function 78
		Managers.state.entity:system("dialogue_system"):debug_vo_by_file(self[arg_78_1], false)
	end
}

tbl[351] = tbl_35

local tbl_36 = {
	description = "Missing vo sound event triggers an error sound",
	is_boolean = true,
	setting_name = "dialogue_debug_missing_vo_trigger_error_sound",
	category = "Dialogue"
}

tbl[352] = tbl_36

local tbl_37 = {
	description = "Enables Text-To-Speech for ALL dialogues",
	is_boolean = true,
	setting_name = "debug_text_to_speech_forced",
	category = "Dialogue"
}

tbl[353] = tbl_37

local tbl_38 = {
	description = "Enables Text-To-Speech for dialogues with missing VO",
	is_boolean = true,
	setting_name = "debug_text_to_speech_missing",
	category = "Dialogue"
}

tbl[354] = tbl_38

local tbl_39 = {
	description = "Disable auto block on input loss",
	is_boolean = true,
	setting_name = "disable_auto_block",
	category = "Input"
}

tbl[355] = tbl_39

local tbl_40 = {
	description = "Debug print input device statuses",
	is_boolean = true,
	setting_name = "input_debug_device_state",
	category = "Input"
}

tbl[356] = tbl_40

local tbl_41 = {
	description = "Debug input filters output",
	is_boolean = true,
	setting_name = "input_debug_filters",
	category = "Input"
}

tbl[357] = tbl_41

local tbl_42 = {
	description = "Set to false to disable cursor clipping.",
	is_boolean = true,
	setting_name = "clip_cursor",
	category = "UI"
}

tbl[358] = tbl_42

local tbl_43 = {
	description = "Enables additional assertions to help catch errors in UI code. Only has an effect when DEBUG is enabled.",
	is_boolean = true,
	setting_name = "strict_ui_checks",
	category = "UI"
}

tbl[359] = tbl_43

local tbl_44 = {
	description = "Reverts back to the old Deus Map UI in case the new one is buggy",
	is_boolean = true,
	setting_name = "FEATURE_old_map_ui",
	category = "UI"
}

tbl[360] = tbl_44

local tbl_45 = {
	description = "Debug UI Hover elements",
	is_boolean = true,
	setting_name = "ui_debug_hover",
	category = "UI"
}

tbl[361] = tbl_45

local tbl_46 = {
	description = "Enable/Disable the Lorebook (need to restart level to spawn page pickups)",
	is_boolean = true,
	setting_name = "lorebook_enabled",
	category = "UI"
}

tbl[362] = tbl_46

local tbl_47 = {
	description = "Debug UI Scenegraph Areas and Sizes",
	is_boolean = true,
	setting_name = "ui_debug_scenegraph",
	category = "UI"
}

tbl[363] = tbl_47

local tbl_48 = {
	description = "Debug UI Pixeldistance (by keybinding",
	is_boolean = true,
	setting_name = "ui_debug_pixeldistance",
	category = "UI"
}

tbl[364] = tbl_48

local tbl_49 = {
	description = "Debug ui textures.",
	is_boolean = true,
	setting_name = "ui_debug_draw_texture",
	category = "UI"
}

tbl[365] = tbl_49

local tbl_50 = {
	description = "Disable UI Rendering.",
	is_boolean = true,
	setting_name = "disable_ui",
	category = "UI"
}

tbl[366] = tbl_50

local tbl_51 = {
	description = "Disable Outlines.",
	category = "UI",
	setting_name = "disable_outlines",
	callback = "disable_outlines",
	is_boolean = true
}

tbl[367] = tbl_51

local tbl_52 = {
	description = "Disables the screens at the end of the level, getting you directly back to the inn.",
	is_boolean = true,
	setting_name = "disable_end_screens",
	category = "UI"
}

tbl[368] = tbl_52

local tbl_53 = {
	description = "Disable Tutorial UI Rendering.",
	is_boolean = true,
	setting_name = "disable_tutorial_ui",
	category = "UI"
}

tbl[369] = tbl_53

local tbl_54 = {
	description = "Disable Info Slate UI Rendering.",
	is_boolean = true,
	setting_name = "disable_info_slate_ui",
	category = "UI"
}

tbl[370] = tbl_54

local tbl_55 = {
	description = "Disables the loading icon.",
	is_boolean = true,
	setting_name = "disable_loading_icon",
	category = "UI"
}

tbl[371] = tbl_55

local tbl_56 = {
	description = "Disables the Water Mark if present.",
	is_boolean = true,
	setting_name = "disable_water_mark",
	category = "UI"
}

tbl[372] = tbl_56

local tbl_57 = {
	description = "Looks through all the localizations and selects the longest text for each item.",
	is_boolean = true,
	setting_name = "show_longest_localizations",
	category = "UI"
}

tbl[373] = tbl_57

local tbl_58 = {
	description = "Disable localization and show the source strings instead. Useful to find the string being used somewhere.",
	is_boolean = true,
	setting_name = "disable_localization",
	category = "UI"
}

tbl[374] = tbl_58

local tbl_59 = {
	description = "Turns off positive reinforcement UI",
	is_boolean = true,
	setting_name = "disable_reinforcement_ui",
	category = "UI"
}

tbl[375] = tbl_59

local tbl_60 = {
	description = "Switches reinforcement UI local sound",
	setting_name = "reinforcement_ui_local_sound",
	category = "UI",
	item_source = {
		hud_achievement_unlock_01 = true,
		hud_achievement_unlock_03 = true,
		hud_info = true,
		hud_achievement_unlock_02 = true
	}
}

tbl[376] = tbl_60

local tbl_61 = {
	description = "Toggles reinforcement UI remote sound",
	is_boolean = true,
	setting_name = "enable_reinforcement_ui_remote_sound",
	category = "UI"
}

tbl[377] = tbl_61

local tbl_62 = {
	description = "The whole menu is unlocked, there is no end to the possibilities!",
	is_boolean = true,
	setting_name = "pause_menu_full_access",
	category = "UI"
}

tbl[378] = tbl_62

local tbl_63 = {
	description = "Enables option to give yourself lootboxes for free!",
	is_boolean = true,
	setting_name = "debug_loot_opening",
	category = "UI"
}

tbl[379] = tbl_63

local tbl_64 = {
	description = "If inventory is open it will cycle select items automatically",
	is_boolean = true,
	setting_name = "debug_cycle_select_inventory_item",
	category = "UI"
}

tbl[380] = tbl_64

local tbl_65 = {
	description = "Enables or disables detailed tooltips on weapns, accessable by pressing SHIFT or CTRL",
	is_boolean = true,
	setting_name = "enable_detailed_tooltips",
	category = "UI"
}

tbl[381] = tbl_65

local tbl_66 = {
	description = "Always allow buying bundles (even if you already own them).",
	is_boolean = true,
	setting_name = "always_allow_buying_bundles",
	category = "UI"
}

tbl[382] = tbl_66

local tbl_67 = {
	description = "Show all news feed items when entering the keep.",
	is_boolean = true,
	setting_name = "show_all_news_feed_items",
	category = "UI"
}

tbl[383] = tbl_67

local tbl_68 = {
	description = "Marks all shop items as unseen.",
	category = "UI",
	setting_name = "mark_all_unseen",
	func = function ()
		-- function 79
		PlayerData.seen_shop_items = {}

		Managers.save:auto_save(SaveFileName, SaveData)
	end
}

tbl[384] = tbl_68

local tbl_69 = {
	description = "Disables position lookup validation. Can turn this on for extra performance.",
	is_boolean = true,
	setting_name = "disable_debug_position_lookup",
	category = "Misc"
}

tbl[385] = tbl_69

local tbl_70 = {
	description = "Will paste the content and engine revision to the user's clipboard.",
	is_boolean = true,
	setting_name = "paste_revision_to_clipboard",
	category = "Misc"
}

tbl[386] = tbl_70

local tbl_71 = {
	description = "Enable logging of telemetry debugging information.",
	is_boolean = true,
	setting_name = "debug_telemetry",
	category = "Misc"
}

tbl[387] = tbl_71

local tbl_72 = {
	description = "Enable logging of leaderboard debugging information.",
	is_boolean = true,
	setting_name = "debug_leaderboard",
	category = "Misc"
}

tbl[388] = tbl_72

local tbl_73 = {
	description = "Enable logging of the forge",
	is_boolean = true,
	setting_name = "forge_debug",
	category = "Misc"
}

tbl[389] = tbl_73

local tbl_74 = {
	description = "Enables logging for the package manager",
	is_boolean = true,
	setting_name = "package_debug",
	category = "Misc"
}

tbl[390] = tbl_74

local tbl_75 = {
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
	custom_item_source_order = function (arg_80_0, arg_80_1)
		-- function 80
		for i, v in ipairs(arg_80_0) do
			local var_80_0 = v

			if type(var_80_0) == "string" then
				arg_80_1[i] = var_80_0
			elseif type(var_80_0) == "table" then
				local tbl = {
					var_80_0[1]
				}
				local var_80_2 = var_80_0[2]

				var_80_2 = var_80_2 or var_80_0[1]
				tbl[2] = var_80_2
				arg_80_1[i] = tbl
			else
				arg_80_1[i] = {
					var_80_0,
					var_80_0
				}
			end
		end
	end,
	item_display_func = function (self, arg_81_1, arg_81_2)
		-- function 81
		if type(self) == "string" then
			return self
		elseif type(self) == "table" then
			local format = string.format
			local str = "%s - %s seconds"
			local var_81_2 = self[1]
			local var_81_3 = self[2]

			var_81_3 = var_81_3 or self[1]

			return format(str, var_81_2, var_81_3)
		else
			local format_2 = string.format
			local str_2 = "%s second%s"
			local var_81_6 = self
			local flag

			flag = self ~= 1 or not "s" or ""

			return format_2(str_2, var_81_6, flag)
		end
	end,
	func = function (self, arg_82_1)
		-- function 82
		local var_82_0 = self[arg_82_1]

		if var_82_0 == "[clear value]" then
			script_data.package_loading_latency = nil
		else
			script_data.package_loading_latency = type(var_82_0) ~= "table" or not var_82_0 or {
				var_82_0,
				var_82_0
			}
		end
	end
}

tbl[391] = tbl_75

local tbl_76 = {
	description = "Shows currently loaded levels and the level_seed.",
	is_boolean = true,
	setting_name = "debug_level_packages",
	category = "Misc"
}

tbl[392] = tbl_76

local tbl_77 = {
	description = "Disable luajit ",
	category = "Misc",
	setting_name = "luajit_disabled",
	callback = "update_using_luajit",
	is_boolean = true
}

tbl[393] = tbl_77

local tbl_78 = {
	description = "Restart the game to view dice chances",
	is_boolean = true,
	setting_name = "dice_chance_simulation",
	category = "Misc"
}

tbl[394] = tbl_78

local tbl_79 = {
	description = "Shows a rect in topcenter of the current color of lightfx. Restart required",
	is_boolean = true,
	setting_name = "debug_lightfx",
	category = "Misc"
}

tbl[395] = tbl_79

local tbl_80 = {
	description = "Spawns all player characters base and husk units, and prints to console if any unit is missing any hit-zone actors etc. Units will spawn in base/husk pairs at (0,0,0) upwards into the sky. They will not be removed.",
	category = "Misc",
	setting_name = "check_player_base_and_husk_hitzones",
	func = function ()
		-- function 83
		CHECK_PLAYER_HITZONES()
	end
}

tbl[396] = tbl_80

local tbl_81 = {
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
	func = function (self, arg_84_1)
		-- function 84
		local var_84_0 = self[arg_84_1]
		local num = 60

		if var_84_0 == "default" then
			Application.set_time_step_policy("no_throttle")

			return
		elseif var_84_0 == "throttle_fps_1" then
			num = 1
		elseif var_84_0 == "throttle_fps_5" then
			num = 5
		elseif var_84_0 == "throttle_fps_10" then
			num = 10
		elseif var_84_0 == "throttle_fps_15" then
			num = 15
		elseif var_84_0 == "throttle_fps_20" then
			num = 20
		elseif var_84_0 == "throttle_fps_25" then
			num = 25
		elseif var_84_0 == "throttle_fps_30" then
			num = 30
		elseif var_84_0 == "throttle_fps_45" then
			num = 45
		elseif var_84_0 == "throttle_fps_60" then
			num = 60
		end

		Application.set_time_step_policy("throttle", num)
	end
}

tbl[397] = tbl_81

local tbl_82 = {
	description = "Don't show dark background behind debug texts.",
	is_boolean = true,
	setting_name = "hide_debug_text_background",
	category = "Misc"
}

tbl[398] = tbl_82

local tbl_83 = {
	description = "Will log transitions fade in/fade out",
	is_boolean = true,
	setting_name = "debug_transition_manager",
	category = "Misc"
}

tbl[399] = tbl_83

local tbl_84 = {
	description = "Disable that the vortex can attract anything / swirl anything around in the air",
	is_boolean = true,
	setting_name = "disable_vortex_attraction",
	category = "Misc"
}

tbl[400] = tbl_84

local tbl_85 = {
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
}

tbl[401] = tbl_85

local tbl_86 = {
	description = "Enable logging of mismatched profiling scopes.",
	is_boolean = true,
	setting_name = "debug_profiling_scopes",
	category = "Performance"
}

tbl[402] = tbl_86

local tbl_87 = {
	description = "Enable visual 'profiling' of function calls.",
	is_boolean = true,
	setting_name = "profile_function_calls",
	category = "Performance"
}

tbl[403] = tbl_87

local tbl_88 = {
	description = "Enable asserts on mismatched profiling scopes.",
	is_boolean = true,
	setting_name = "validate_profiling_scopes",
	category = "Performance"
}

tbl[404] = tbl_88

local tbl_89 = {
	description = "Disable lodding of animation bones.",
	is_boolean = true,
	setting_name = "bone_lod_disable",
	category = "Performance"
}

tbl[405] = tbl_89

local tbl_90 = {
	description = "Enable floating text over AI head which states the animation that animation merge is currently enabled for.",
	is_boolean = true,
	setting_name = "animation_merge_debug",
	category = "Performance"
}

tbl[406] = tbl_90

local tbl_91 = {
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
}

tbl[407] = tbl_91

local tbl_92 = {
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
}

tbl[408] = tbl_92

local tbl_93 = {
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
}

tbl[409] = tbl_93

local tbl_94 = {
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
}

tbl[410] = tbl_94

local tbl_95 = {
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
}

tbl[411] = tbl_95

local tbl_96 = {
	description = "You have to restart the game for the settings to take effect",
	category = "Render Settings",
	setting_name = "Set high texture quality",
	func = function ()
		-- function 85
		DebugScreen.set_texture_quality(0)
	end
}

tbl[412] = tbl_96

local tbl_97 = {
	description = "You have to restart the game for the settings to take effect",
	category = "Render Settings",
	setting_name = "Set low texture quality",
	func = function ()
		-- function 86
		DebugScreen.set_texture_quality(3)
	end
}

tbl[413] = tbl_97

local tbl_98 = {
	description = "Don't render the game if the window is not focused",
	is_boolean = true,
	setting_name = "only_render_if_window_focused",
	category = "Render Settings"
}

tbl[414] = tbl_98

local tbl_99 = {
	description = "Show bot debug visualizers",
	is_boolean = true,
	setting_name = "ai_bots_debug",
	category = "Bots"
}

tbl[415] = tbl_99

local tbl_100 = {
	description = "Displays statistics for bots",
	is_boolean = true,
	setting_name = "ai_bots_debug_behavior",
	category = "Bots"
}

tbl[416] = tbl_100

local tbl_101 = {
	description = "Make bots not see/attack anyone",
	is_boolean = true,
	setting_name = "ai_bots_disable_perception",
	category = "Bots"
}

tbl[417] = tbl_101

local tbl_102 = {
	description = "Bot won't shot at enemy players, but still attack ai enemies. Versus Specific",
	is_boolean = true,
	setting_name = "ai_bots_disable_player_range_attacks",
	category = "Bots"
}

tbl[418] = tbl_102

local tbl_103 = {
	description = "Make bots not dodge attacks",
	is_boolean = true,
	setting_name = "ai_bots_disable_dodging",
	category = "Bots"
}

tbl[419] = tbl_103

local tbl_104 = {
	description = "Bot won't melee at enemy players, but still attack ai enemies. Versus Specific",
	is_boolean = true,
	setting_name = "ai_bots_disable_player_melee_attacks",
	category = "Bots"
}

tbl[420] = tbl_104

local tbl_105 = {
	description = "THis will fill the Bot won't melee at enemy players, but still attack ai enemies. Versus Specific",
	is_boolean = true,
	setting_name = "disable_versus_darkpact_bots",
	category = "Bots"
}

tbl[421] = tbl_105

local tbl_106 = {
	description = "Writes out the spawn status of darkpact bots on screen.",
	is_boolean = true,
	setting_name = "show_versus_darkpact_bot_debug",
	category = "Bots"
}

tbl[422] = tbl_106

local tbl_107 = {
	description = "Bots will only use ranged attacks.",
	is_boolean = true,
	setting_name = "ai_bots_disable_ranged_attacks",
	category = "Bots"
}

tbl[423] = tbl_107

local tbl_108 = {
	description = "Bots will only use melee attacks.",
	is_boolean = true,
	setting_name = "ai_bots_disable_melee_attacks",
	category = "Bots"
}

tbl[424] = tbl_108

local tbl_109 = {
	description = "Bots use ranged attacks as much as possible.",
	is_boolean = true,
	setting_name = "ai_bots_ranged_attack_always_valid",
	category = "Bots"
}

tbl[425] = tbl_109

local tbl_110 = {
	description = "Enable debug printing related to bot weapons.",
	is_boolean = true,
	setting_name = "ai_bots_weapon_debug",
	category = "Bots"
}

tbl[426] = tbl_110

local tbl_111 = {
	description = "Enable debug information related to bot orders - press t to order bot to pickup item using raycast.",
	is_boolean = true,
	setting_name = "ai_bots_order_debug",
	category = "Bots"
}

tbl[427] = tbl_111

local tbl_112 = {
	description = "Shows which inputs that the bot is doing at the moment.",
	is_boolean = true,
	setting_name = "ai_bots_input_debug",
	category = "Bots"
}

tbl[428] = tbl_112

local tbl_113 = {
	description = "Visualizes the AoE threat that the bots are trying to avoid.",
	is_boolean = true,
	setting_name = "ai_bots_aoe_threat_debug",
	category = "Bots"
}

tbl[429] = tbl_113

local tbl_114 = {
	description = "Visualizes nearby breakable smart objects for the selected bot.",
	is_boolean = true,
	setting_name = "ai_bots_proximity_breakables_debug",
	category = "Bots"
}

tbl[430] = tbl_114

local tbl_115 = {
	description = "Bots will not follow player.",
	is_boolean = true,
	setting_name = "bots_dont_follow",
	category = "Bots"
}

tbl[431] = tbl_115

local tbl_116 = {
	description = "Disables automatic spawning of bots",
	is_boolean = true,
	setting_name = "ai_bots_disabled",
	category = "Bots"
}

tbl[432] = tbl_116

local tbl_117 = {
	description = "Enables bots on Weaves",
	is_boolean = true,
	setting_name = "enable_bots_in_weaves",
	category = "Bots"
}

tbl[433] = tbl_117

local tbl_118 = {
	description = "Disables bot usage of career abilities.",
	is_boolean = true,
	setting_name = "ai_bots_career_abilities_disabled",
	category = "Bots"
}

tbl[434] = tbl_118

local tbl_119 = {
	description = "Will cap the total number of bots in game",
	setting_name = "cap_num_bots",
	category = "Bots",
	item_source = {
		0,
		1,
		2
	}
}

tbl[435] = tbl_119

local tbl_120 = {
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
}

tbl[436] = tbl_120

local tbl_121 = {
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
}

tbl[437] = tbl_121

local tbl_122 = {
	description = "Only works together with wanted_bot_profile. Will make all spawned the same as defined in wanted_bot_profile. (Might need to toggle_ai_bots on/off.)",
	is_boolean = true,
	setting_name = "allow_same_bots",
	category = "Bots"
}

tbl[438] = tbl_122

local tbl_123 = {
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
}

tbl[439] = tbl_123

local tbl_124 = {
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
}

tbl[440] = tbl_124

local tbl_125 = {
	description = "Performance Manager Debug",
	is_boolean = true,
	setting_name = "performance_debug",
	category = "Perfhud"
}

tbl[441] = tbl_125

local tbl_126 = {
	description = "Sets the amount of logging on the backend",
	setting_name = "backend_logging_level",
	category = "Backend",
	item_source = {
		off = true,
		verbose = true,
		normal = true
	},
	func = function ()
		-- function 87
		Managers.backend:refresh_log_level()
	end
}

tbl[442] = tbl_126

local tbl_127 = {
	description = "Connect to a backend running locally. Can be set to a string to use that as a URL.",
	is_boolean = true,
	setting_name = "backend_base_url",
	category = "Backend"
}

tbl[443] = tbl_127

local tbl_128 = {
	description = "Unlock all careers",
	is_boolean = true,
	setting_name = "unlock_all_careers",
	category = "Progression"
}

tbl[444] = tbl_128

local tbl_129 = {
	description = "You have to reload the inn for the setting to take effect",
	is_boolean = true,
	setting_name = "unlock_full_keep",
	category = "Progression"
}

tbl[445] = tbl_129

local tbl_130 = {
	description = "Win",
	close_when_selected = true,
	setting_name = "Complete current level",
	propagate_to_server = true,
	category = "Progression",
	func = function ()
		-- function 88
		Managers.state.game_mode:complete_level()
	end
}

tbl[446] = tbl_130

local tbl_131 = {
	description = "End the current round (versus)",
	close_when_selected = true,
	setting_name = "End Round",
	propagate_to_server = true,
	category = "Versus",
	func = function ()
		-- function 89
		Managers.state.game_mode:complete_level()

		script_data.disable_gamemode_end = nil
		script_data.disable_gamemode_end_hero_check = nil
	end
}

tbl[447] = tbl_131

local tbl_132 = {
	description = "Automatically complete rounds",
	never_save = true,
	setting_name = "auto_complete_rounds",
	category = "Versus",
	propagate_to_server = true,
	is_boolean = true,
	close_when_selected = true
}

tbl[448] = tbl_132

local tbl_133 = {
	description = "Displays information about early win",
	is_boolean = true,
	setting_name = "debug_early_win",
	category = "Versus"
}

tbl[449] = tbl_133

local tbl_134 = {
	description = "Force start the connected dedicated server",
	close_when_selected = true,
	setting_name = "Force Start Dedicated Server",
	category = "Versus",
	func = function ()
		-- function 90
		if Managers.mechanism:get_state() ~= "inn" then
			Debug.sticky_text("Tried force starting a dedicated server but was not in the keep.")

			return
		end

		local dedicated_server_peer_id = Managers.mechanism:dedicated_server_peer_id()

		if not PEER_ID_TO_CHANNEL[dedicated_server_peer_id] then
			Debug.sticky_text("Tried force starting a dedicated server but is not connected to one.")

			return
		end

		Managers.mechanism:game_mechanism():force_start_dedicated_server()
	end
}

tbl[450] = tbl_134

local tbl_135 = {
	description = "Skip the startup timer and start the round immediately",
	close_when_selected = true,
	setting_name = "Start Round",
	category = "Versus",
	func = function ()
		-- function 91
		if not Managers.level_transition_handler:in_hub_level() then
			return false, "Failed to start round - Match not started"
		end

		Managers.state.game_mode:round_started()

		return true, "Round started!"
	end
}

tbl[451] = tbl_135

local tbl_136 = {
	description = "Restart",
	close_when_selected = true,
	setting_name = "Retry current level",
	propagate_to_server = true,
	category = "Progression",
	func = function ()
		-- function 92
		if not Managers.state.network.is_server then
			Managers.state.game_mode:retry_level()
		end
	end
}

tbl[452] = tbl_136

local tbl_137 = {
	description = "Lose",
	close_when_selected = true,
	setting_name = "Fail current level",
	category = "Progression",
	func = function ()
		-- function 93
		Managers.state.game_mode:fail_level()
	end
}

tbl[453] = tbl_137

local tbl_138 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Complete act \"prologue\"",
	func = function ()
		-- function 94
		LevelUnlockUtils.debug_completed_act_levels("prologue", true)
	end
}

tbl[454] = tbl_138

local tbl_139 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Uncomplete act \"prologue\"",
	func = function ()
		-- function 95
		LevelUnlockUtils.debug_completed_act_levels("prologue", false)
	end
}

tbl[455] = tbl_139

local tbl_140 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Complete act \"act_1\"",
	func = function ()
		-- function 96
		LevelUnlockUtils.debug_completed_act_levels("act_1", true)
	end
}

tbl[456] = tbl_140

local tbl_141 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Uncomplete act \"act_1\"",
	func = function ()
		-- function 97
		LevelUnlockUtils.debug_completed_act_levels("act_1", false)
	end
}

tbl[457] = tbl_141

local tbl_142 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Complete act \"act_2\"",
	func = function ()
		-- function 98
		LevelUnlockUtils.debug_completed_act_levels("act_2", true)
	end
}

tbl[458] = tbl_142

local tbl_143 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Uncomplete act \"act_2\"",
	func = function ()
		-- function 99
		LevelUnlockUtils.debug_completed_act_levels("act_2", false)
	end
}

tbl[459] = tbl_143

local tbl_144 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Complete act \"act_3\"",
	func = function ()
		-- function 100
		LevelUnlockUtils.debug_completed_act_levels("act_3", true)
	end
}

tbl[460] = tbl_144

local tbl_145 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Uncomplete act \"act_3\"",
	func = function ()
		-- function 101
		LevelUnlockUtils.debug_completed_act_levels("act_3", false)
	end
}

tbl[461] = tbl_145

local tbl_146 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Complete act \"act_4\"",
	func = function ()
		-- function 102
		LevelUnlockUtils.debug_completed_act_levels("act_4", true)
	end
}

tbl[462] = tbl_146

local tbl_147 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Uncomplete act \"act_4\"",
	func = function ()
		-- function 103
		LevelUnlockUtils.debug_completed_act_levels("act_4", false)
	end
}

tbl[463] = tbl_147

local tbl_148 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Set completed game difficulty Normal",
	func = function ()
		-- function 104
		LevelUnlockUtils.debug_set_completed_game_difficulty(2)
	end
}

tbl[464] = tbl_148

local tbl_149 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Set completed game difficulty Hard",
	func = function ()
		-- function 105
		LevelUnlockUtils.debug_set_completed_game_difficulty(3)
	end
}

tbl[465] = tbl_149

local tbl_150 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Set completed game difficulty Nightmare",
	func = function ()
		-- function 106
		LevelUnlockUtils.debug_set_completed_game_difficulty(4)
	end
}

tbl[466] = tbl_150

local tbl_151 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Set completed game difficulty Cataclysm",
	func = function ()
		-- function 107
		LevelUnlockUtils.debug_set_completed_game_difficulty(5)
	end
}

tbl[467] = tbl_151

local tbl_152 = {
	description = " ",
	category = "Progression",
	setting_name = "Complete DLC Celebrate",
	func = function ()
		-- function 108
		LevelUnlockUtils.debug_complete_level("dlc_celebrate_crawl")

		local world = Managers.world:world("level_world")

		LevelHelper:flow_event(world, "lua_unlock_challenge_debug_event")
	end
}

tbl[468] = tbl_152

local tbl_153 = {
	setting_name = "Add Experience",
	description = "Adds Experience to your account.",
	category = "Progression",
	item_source = {},
	load_items_source_func = function (self)
		-- function 109
		table.clear(self)

		self[1] = 1
		self[2] = 10
		self[3] = 100
		self[4] = 1000
		self[5] = 10000
		self[6] = 60850
	end,
	func = function (self, arg_110_1)
		-- function 110
		local backend = Managers.backend
		local var_110_1 = self[arg_110_1]

		var_110_1 = var_110_1 or 1

		local profile_index = Managers.player:local_player(1):profile_index()
		local display_name = SPProfiles[profile_index].display_name

		local function fn(self)
			-- function 111
			local FunctionResult = self.FunctionResult
			local get_interface = backend:get_interface("hero_attributes")

			get_interface:set(display_name, "experience", FunctionResult.data[display_name .. "_experience"])
			get_interface:set(display_name, "experience_pool", FunctionResult.data[display_name .. "_experience_pool"])
		end

		local tbl = {
			FunctionName = "devAddExperience",
			FunctionParameter = {
				hero = display_name,
				experience = var_110_1
			}
		}

		backend._backend_mirror:request_queue():enqueue(tbl, fn, false)
	end
}

tbl[469] = tbl_153

local tbl_154 = {
	description = "Sets experience to 0.",
	category = "Progression",
	setting_name = "Reset Level",
	func = function ()
		-- function 112
		local backend = Managers.backend
		local profile_index = Managers.player:local_player(1):profile_index()
		local display_name = SPProfiles[profile_index].display_name
		local get_interface = backend:get_interface("hero_attributes")

		local function fn(self)
			-- function 113
			assert(self.FunctionResult.data, self.FunctionResult.reason)
			get_interface:set(display_name, "experience", self.FunctionResult.data[display_name .. "_experience"])
		end

		local tbl = {
			FunctionName = "devSetExperience",
			FunctionParameter = {
				experience = 1,
				hero = display_name
			}
		}

		backend._backend_mirror:request_queue():enqueue(tbl, fn, false)
	end
}

tbl[470] = tbl_154

local tbl_155 = {
	description = "Will add experience to above prestige requirements",
	category = "Progression",
	setting_name = "Level up above prestige level requirements",
	func = function ()
		-- function 114
		local backend = Managers.backend
		local profile_index = Managers.player:local_player(1):profile_index()
		local display_name = SPProfiles[profile_index].display_name

		local function fn(self)
			-- function 115
			local FunctionResult = self.FunctionResult

			backend:get_interface("hero_attributes"):set(display_name, "experience", FunctionResult.data[display_name .. "_experience"])
			Debug.load_level("inn_level")
		end

		local tbl = {
			FunctionName = "devSetExperience",
			FunctionParameter = {
				experience = 1000000,
				hero = display_name
			}
		}

		backend._backend_mirror:request_queue():enqueue(tbl, fn, false)
	end
}

tbl[471] = tbl_155

local tbl_156 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Reset prestige level",
	func = function ()
		-- function 116
		local profile_index = Managers.player:local_player(1):profile_index()
		local var_116_1 = SPProfiles[profile_index]

		Managers.backend:get_interface("hero_attributes"):set(var_116_1.display_name, "prestige", 0)
		Debug.load_level("inn_level")
	end
}

tbl[472] = tbl_156

local tbl_157 = {
	description = "You have to reload the inn for the setting to take effect",
	category = "Progression",
	setting_name = "Wipe all progression(used for prestige)",
	func = function ()
		-- function 117
		LevelUnlockUtils.set_all_acts_incompleted()
	end
}

tbl[473] = tbl_157

local tbl_158 = {
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
	custom_item_source_order = function (arg_118_0, arg_118_1)
		-- function 118
		for i, v in ipairs(arg_118_0) do
			local var_118_0 = v

			arg_118_1[#arg_118_1 + 1] = var_118_0
		end
	end
}

tbl[474] = tbl_158

local tbl_159 = {
	description = "Override the returned value to flow node \"Leader Achievement Completed\"",
	is_boolean = true,
	setting_name = "achievement_completed_flow_override",
	category = "Progression"
}

tbl[475] = tbl_159

local tbl_160 = {
	description = "Override the returned value to flow node \"Leader Has DLC\" when checking for the Collectors Edition (Pre Order) DLC",
	is_boolean = true,
	setting_name = "has_dlc_pre_order_flow_override",
	category = "Progression"
}

tbl[476] = tbl_160

local tbl_161 = {
	description = "Disables the hero power requirements for difficulties",
	is_boolean = true,
	setting_name = "disable_hero_power_requirement",
	category = "Progression"
}

tbl[477] = tbl_161

local tbl_162 = {
	description = "Completely resets all stats for local player. Requires that the player is spawned inside a level. REQUIRES RESTART AFTERWARDS!",
	category = "Progression",
	setting_name = "reset_statistics_database",
	func = function ()
		-- function 119
		print("Starting statistics reset!")
		Managers.backend:get_interface("statistics"):reset()
	end
}

tbl[478] = tbl_162

local tbl_163 = {
	description = "Shows test buffs in the buff tray for debugging.",
	is_boolean = true,
	setting_name = "debug_buff_ui",
	category = "HUD"
}

tbl[479] = tbl_163

local tbl_164 = {
	description = "Show more things in the player list UI right-hand panel for debugging.",
	is_boolean = true,
	setting_name = "debug_player_list_ui",
	category = "HUD"
}

tbl[480] = tbl_164

local tbl_165 = {
	description = "Will display all properties on the player",
	is_boolean = true,
	setting_name = "debug_show_player_properties",
	category = "HUD"
}

tbl[481] = tbl_165

local tbl_166 = {
	description = "Will display all properties on the player, all = all properties, limited = buffs chosen by QA",
	setting_name = "debug_show_player_active_buffs",
	category = "HUD",
	is_boolean = true,
	item_source = {
		all = "all",
		limited = "limited"
	}
}

tbl[482] = tbl_166

local tbl_167 = {
	no_nil = false,
	setting_name = "debug_hud_visibility_group",
	description = "Force activate a specific HUD visibility group",
	category = "HUD",
	item_source = {},
	load_items_source_func = function (self)
		-- function 120
		if not self.initialized then
			table.clear(self)

			self[#self + 1] = "none"

			local visibility_groups = local_require("scripts/ui/views/ingame_hud_definitions").visibility_groups

			for i, v in ipairs(visibility_groups) do
				local name = v.name

				self[#self + 1] = name
			end

			self.initialized = true
		end
	end,
	func = function (self, arg_121_1)
		-- function 121
		local var_121_0 = self[arg_121_1]

		if not (not var_121_0 and var_121_0 ~= "none") then
			script_data.debug_hud_visibility_group = nil
		else
			script_data.debug_hud_visibility_group = var_121_0
		end
	end
}

tbl[483] = tbl_167

local tbl_168 = {
	description = "Used for spawning world markers on ping input",
	is_boolean = true,
	setting_name = "debug_world_marker_ping",
	category = "UI"
}

tbl[484] = tbl_168

local tbl_169 = {
	description = "Prints the number of server controlled buffs.",
	is_boolean = true,
	setting_name = "debug_server_controlled_buffs",
	category = "Player mechanics"
}

tbl[485] = tbl_169

local tbl_170 = {
	description = "Shows the bones of the player units",
	is_boolean = true,
	setting_name = "debug_player_skeletons",
	category = "Player mechanics"
}

tbl[486] = tbl_170

local tbl_171 = {
	description = "Shows current career sound state",
	is_boolean = true,
	setting_name = "debug_career_sound_state",
	category = "Player mechanics"
}

tbl[487] = tbl_171

local tbl_172 = {
	description = "Disables the weave score UI on screen",
	is_boolean = true,
	setting_name = "disable_weave_score_ui",
	category = "Player mechanics"
}

tbl[488] = tbl_172

local tbl_173 = {
	setting_name = "Add legend end of level chest.",
	description = "Works on non-local backend. Adds a legend vault",
	category = "Progression",
	item_source = {},
	load_items_source_func = function (self)
		-- function 122
		table.clear(self)

		self[#self + 1] = "tier_1"
		self[#self + 1] = "tier_2"
		self[#self + 1] = "tier_3"
		self[#self + 1] = "tier_4"
		self[#self + 1] = "tier_5"

		table.sort(self)
	end,
	func = function (self, arg_123_1)
		-- function 123
		local var_123_0 = self[arg_123_1]
		local get_interface = Managers.backend:get_interface("loot")
		local local_player = Managers.player:local_player()
		local display_name = SPProfiles[local_player:profile_index()].display_name
		local str = "default"

		if var_123_0 == "tier_1" then
			local tbl = {
				chest_upgrade_data = {
					grimoire = 0,
					tome = 0,
					game_won = true,
					loot_dice = 0
				}
			}

			get_interface:generate_end_of_level_loot(true, true, "hardest", "bell", display_name, 0, 0, str, nil, nil, "adventure", 0, tbl)
		elseif var_123_0 == "tier_2" then
			local tbl_2 = {
				chest_upgrade_data = {
					grimoire = 0,
					tome = 2,
					game_won = true,
					loot_dice = 0
				}
			}

			get_interface:generate_end_of_level_loot(true, true, "hardest", "bell", display_name, 0, 0, str, nil, nil, "adventure", 0, tbl_2)
		elseif var_123_0 == "tier_3" then
			local tbl_3 = {
				chest_upgrade_data = {
					grimoire = 1,
					tome = 2,
					game_won = true,
					loot_dice = 0
				}
			}

			get_interface:generate_end_of_level_loot(true, true, "hardest", "bell", display_name, 0, 0, str, nil, nil, "adventure", 0, tbl_3)
		elseif var_123_0 == "tier_4" then
			local tbl_4 = {
				chest_upgrade_data = {
					grimoire = 2,
					tome = 2,
					game_won = true,
					loot_dice = 1
				}
			}

			get_interface:generate_end_of_level_loot(true, true, "hardest", "bell", display_name, 0, 0, str, nil, nil, "adventure", 0, tbl_4)
		elseif var_123_0 == "tier_5" then
			local tbl_5 = {
				chest_upgrade_data = {
					grimoire = 3,
					tome = 2,
					game_won = true,
					loot_dice = 4
				}
			}

			get_interface:generate_end_of_level_loot(true, true, "hardest", "bell", display_name, 0, 0, str, nil, nil, "adventure", 0, tbl_5)
		end
	end
}

tbl[489] = tbl_173

local tbl_174 = {
	description = "Lists all items with functionality to add them to inventory.",
	setting_name = "Add Hat Items",
	category = "Items",
	item_source = {},
	load_items_source_func = function (self)
		-- function 124
		table.clear(self)

		local ItemMasterList = ItemMasterList

		for k, v in pairs(ItemMasterList) do
			if v.slot_type == "hat" then
				self[#self + 1] = k
			end
		end

		table.sort(self)
	end,
	func = function (self, arg_125_1)
		-- function 125
		local get_interface = Managers.backend:get_interface("items")
		local var_125_1 = self[arg_125_1]

		fn_2({
			{
				ItemName = var_125_1
			}
		})
	end
}

tbl[490] = tbl_174

local tbl_175 = {
	description = "Adds all hat items to your inventory.",
	setting_name = "Add All Hat Items",
	category = "Items",
	func = function ()
		-- function 126
		local ItemMasterList = ItemMasterList
		local tbl = {}

		for k, v in pairs(ItemMasterList) do
			if v.slot_type == "hat" then
				tbl[#tbl + 1] = {
					ItemName = k
				}
			end
		end

		local flag = true

		fn_2(tbl, flag)
	end
}

tbl[491] = tbl_175

local tbl_176 = {
	description = "Lists all items with functionality to add them to inventory.",
	setting_name = "Add Skin Items",
	category = "Items",
	item_source = {},
	load_items_source_func = function (self)
		-- function 127
		table.clear(self)

		local ItemMasterList = ItemMasterList

		for k, v in pairs(ItemMasterList) do
			if v.slot_type == "skin" then
				self[#self + 1] = k
			end
		end

		table.sort(self)
	end,
	func = function (self, arg_128_1)
		-- function 128
		local get_interface = Managers.backend:get_interface("items")
		local var_128_1 = self[arg_128_1]

		fn_2({
			{
				ItemName = var_128_1
			}
		})
	end
}

tbl[492] = tbl_176

local tbl_177 = {
	description = "Lists all items with functionality to add them to inventory. (hold left shift to add x10)",
	setting_name = "Add Chest Items",
	category = "Items",
	item_source = {},
	load_items_source_func = function (self)
		-- function 129
		table.clear(self)

		local ItemMasterList = ItemMasterList

		for k, v in pairs(ItemMasterList) do
			if v.slot_type == "loot_chest" then
				self[#self + 1] = k
			end
		end

		table.sort(self)
	end,
	func = function (self, arg_130_1)
		-- function 130
		local get_interface = Managers.backend:get_interface("items")
		local var_130_1 = self[arg_130_1]
		local num = 1

		if Keyboard.button(Keyboard.button_index("left shift")) > 0 then
			num = 10
		end

		fn_2({
			{
				ItemName = var_130_1,
				Amount = num
			}
		})
	end
}

tbl[493] = tbl_177

local tbl_178 = {
	description = "Lists all items with functionality to add them to inventory.",
	setting_name = "Add Frame Items",
	category = "Items",
	item_source = {},
	load_items_source_func = function (self)
		-- function 131
		table.clear(self)

		local ItemMasterList = ItemMasterList

		for k, v in pairs(ItemMasterList) do
			if v.slot_type == "frame" then
				self[#self + 1] = k
			end
		end

		table.sort(self)
	end,
	func = function (self, arg_132_1)
		-- function 132
		local get_interface = Managers.backend:get_interface("items")
		local var_132_1 = self[arg_132_1]

		fn_2({
			{
				ItemName = var_132_1
			}
		})
	end
}

tbl[494] = tbl_178

local tbl_179 = {
	description = "Lists all deeds with functionality to add them to inventory.",
	setting_name = "Add Deed Items",
	category = "Items",
	item_source = {},
	load_items_source_func = function (self)
		-- function 133
		table.clear(self)

		local ItemMasterList = ItemMasterList

		for k, v in pairs(ItemMasterList) do
			if v.slot_type == "deed" then
				self[#self + 1] = k
			end
		end

		table.sort(self)
	end,
	func = function (self, arg_134_1)
		-- function 134
		local get_interface = Managers.backend:get_interface("items")
		local var_134_1 = self[arg_134_1]
		local var_134_2 = ItemMasterList[var_134_1].difficulties[1]
		local str = "farmlands"

		fn_2({
			{
				ItemName = var_134_1,
				CustomData = {
					difficulty = var_134_2,
					level_key = str
				}
			}
		})
	end
}

tbl[495] = tbl_179

local tbl_180 = {
	description = "Adds one weapon per skin with that skin applied.",
	setting_name = "Add All Weapon Skins",
	category = "Items",
	func = function ()
		-- function 135
		local ItemMasterList = ItemMasterList
		local WeaponSkins = WeaponSkins
		local get_interface = Managers.backend:get_interface("items")
		local tbl = {}
		local tbl_2 = {}

		for k, v in pairs(ItemMasterList) do
			local slot_type = v.slot_type
			local skin_combination_table = v.skin_combination_table

			if not ((slot_type == "melee" or slot_type == "ranged" or not skin_combination_table) and v.rarity == "magic") then
				local var_135_7 = WeaponSkins.skin_combinations[skin_combination_table]

				for k_2, v_2 in pairs(var_135_7) do
					for i, v_3 in ipairs(v_2) do
						if not tbl[v_3] then
							tbl[v_3] = true
							tbl_2[#tbl_2 + 1] = {
								ItemName = k,
								CustomData = {
									power_level = 5,
									skin = v_3
								}
							}
						end
					end
				end
			end
		end

		local _backend_mirror = Managers.backend._backend_mirror
		local tbl_3 = {
			FunctionName = "devUnlockAllWeaponSkins",
			FunctionParameter = {}
		}
		local flag = true

		local function fn(arg_136_0)
			-- function 136
			fn_2(tbl_2, flag)
		end

		_backend_mirror:request_queue():enqueue(tbl_3, fn, false)
	end
}

tbl[496] = tbl_180

local tbl_181 = {
	description = "Unlocks all the weapon poses in the social_wheel",
	is_boolean = true,
	setting_name = "unlock_all_weapon_poses",
	category = "Items"
}

tbl[497] = tbl_181

local tbl_182 = {
	description = "Lists all mutators with functionality to activate them. Requires restart of level",
	setting_name = "Activate or Deactivate Mutator",
	category = "Items",
	item_source = {},
	load_items_source_func = function (self)
		-- function 137
		table.clear(self)

		for k, v in pairs(MutatorTemplates) do
			self[#self + 1] = k
		end

		table.sort(self)
	end,
	func = function (self, arg_138_1)
		-- function 138
		local debug_activated_mutators = script_data.debug_activated_mutators

		debug_activated_mutators = debug_activated_mutators or {}

		local var_138_1 = self[arg_138_1]
		local var_138_2

		for i = 1, #debug_activated_mutators do
			if debug_activated_mutators[i] == var_138_1 then
				var_138_2 = i
			end
		end

		if not var_138_2 then
			table.remove(debug_activated_mutators, var_138_2)
			Debug.sticky_text("Deactivated mutator %s", var_138_1)
		else
			debug_activated_mutators[#debug_activated_mutators + 1] = var_138_1

			Debug.sticky_text("Activated mutator %s", var_138_1)
		end

		if #debug_activated_mutators > 0 then
			script_data.debug_activated_mutators = debug_activated_mutators
		else
			script_data.debug_activated_mutators = nil
		end
	end
}

tbl[498] = tbl_182

local tbl_183 = {
	description = "Lists all mutators with functionality to immediately start or stop them. Does not require restart of level. !! Does not work for every mutator.",
	setting_name = "Start or stop mutator",
	category = "Items",
	item_source = {},
	load_items_source_func = function (self)
		-- function 139
		table.clear(self)

		for k, v in pairs(MutatorTemplates) do
			self[#self + 1] = k
		end

		table.sort(self)
	end,
	func = function (self, arg_140_1)
		-- function 140
		local mutator_handler = Managers.state.game_mode:mutator_handler()
		local var_140_1 = self[arg_140_1]

		if not mutator_handler:has_mutator(var_140_1) then
			mutator_handler:initialize_mutators({
				var_140_1
			})
			Debug.sticky_text("Initialized mutator %s", var_140_1)
		end

		if not mutator_handler:has_activated_mutator(var_140_1) then
			mutator_handler:deactivate_mutator(var_140_1)
			Debug.sticky_text("Stopped mutator %s", var_140_1)
		else
			mutator_handler:activate_mutator(var_140_1)
			Debug.sticky_text("Started mutator %s", var_140_1)
		end
	end
}

tbl[499] = tbl_183

local tbl_184 = {
	description = "Lists all blessings with functionality to activate them. Requires restart of a deus level or loading the next one",
	setting_name = "Activate or Deactivate Blessings",
	category = "Items",
	item_source = {},
	load_items_source_func = function (self)
		-- function 141
		table.clear(self)

		for k, v in pairs(DeusBlessingSettings) do
			self[#self + 1] = k
		end

		table.sort(self)
	end,
	func = function (self, arg_142_1)
		-- function 142
		local debug_activated_blessings = script_data.debug_activated_blessings

		debug_activated_blessings = debug_activated_blessings or {}

		local var_142_1 = self[arg_142_1]
		local var_142_2

		for i = 1, #debug_activated_blessings do
			if debug_activated_blessings[i] == var_142_1 then
				var_142_2 = i
			end
		end

		if not var_142_2 then
			table.remove(debug_activated_blessings, var_142_2)
			Debug.sticky_text("Deactivated blessing %s", var_142_1)
		else
			debug_activated_blessings[#debug_activated_blessings + 1] = var_142_1

			Debug.sticky_text("Activated blessing %s", var_142_1)
		end

		if #debug_activated_blessings > 0 then
			script_data.debug_activated_blessings = debug_activated_blessings
		else
			script_data.debug_activated_blessings = nil
		end
	end
}

tbl[500] = tbl_184

local tbl_185 = {
	description = "Lists all Twitch Mode Vote Templates with functionality to activate them.",
	setting_name = "Force Twitch Mode Vote Template",
	category = "Items",
	item_source = {},
	load_items_source_func = function (self)
		-- function 143
		table.clear(self)

		for k, v in pairs(TwitchVoteTemplates) do
			self[#self + 1] = k
		end

		self[#self + 1] = "clear_votes"

		table.sort(self)
	end,
	func = function (self, arg_144_1)
		-- function 144
		if not script_data.debug_activated_mutators then
			local tbl = {}
		end

		local var_144_1 = self[arg_144_1]

		if var_144_1 == "clear_votes" then
			script_data.twitch_mode_force_vote_template = nil
		else
			local var_144_2 = TwitchVoteTemplates[var_144_1]

			script_data.twitch_mode_force_vote_template = var_144_2
		end
	end
}

tbl[501] = tbl_185

local tbl_186 = {
	description = "Show all paintings etc. You have to reload the inn for the setting to take effect.",
	is_boolean = true,
	setting_name = "debug_keep_decorations",
	category = "Keep Decorations"
}

tbl[502] = tbl_186

local tbl_187 = {
	description = "Unlocks a Challenge by setting by incrementing the appropriate statistics.",
	setting_name = "Unlock Challenges",
	category = "Progression",
	clear_when_selected = true,
	item_source = {},
	load_items_source_func = function (arg_145_0)
		-- function 145
		table.clear(arg_145_0)

		for k, v in pairs(AchievementTemplates.achievements) do
			if not v.debug_unlock then
				table.insert(arg_145_0, k)
			end
		end

		table.sort(arg_145_0)
	end,
	func = function (self, arg_146_1)
		-- function 146
		if not AchievementTemplates then
			local var_146_0 = AchievementTemplates.achievements[self[arg_146_1]]

			if var_146_0 ~= nil then
				if not var_146_0.debug_unlock then
					local statistics_db = Managers.state.game_mode.statistics_db
					local stats_id = Managers.player:local_player():stats_id()

					if not statistics_db and not stats_id then
						var_146_0.debug_unlock(statistics_db, stats_id)
						print("Unlocked challenge ", self[arg_146_1])

						local world = Managers.world:world("level_world")

						LevelHelper:flow_event(world, "lua_unlock_challenge_debug_event")
						fn()

						return
					end
				else
					print("Missing 'debug_unlock' on challenge")
				end
			end
		end

		print("Could not unlock challenge ", self[arg_146_1])
	end
}

tbl[503] = tbl_187

local tbl_188 = {
	description = "Clears a Challenge by setting the appropriate statistics to 0.",
	setting_name = "Clear Challenges",
	category = "Progression",
	clear_when_selected = true,
	item_source = {},
	load_items_source_func = function (arg_147_0)
		-- function 147
		table.clear(arg_147_0)

		for k, v in pairs(AchievementTemplates.achievements) do
			if not v.debug_reset then
				table.insert(arg_147_0, k)
			end
		end

		table.sort(arg_147_0)
	end,
	func = function (self, arg_148_1)
		-- function 148
		if not AchievementTemplates then
			local var_148_0 = AchievementTemplates.achievements[self[arg_148_1]]

			if var_148_0 ~= nil then
				if not var_148_0.debug_reset then
					local statistics_db = Managers.state.game_mode.statistics_db
					local stats_id = Managers.player:local_player():stats_id()

					if not statistics_db and not stats_id then
						var_148_0.debug_reset(statistics_db, stats_id)
						print("Reset challenge ", self[arg_148_1])
						fn()

						return
					end
				else
					print("Missing 'debug_reset' function")
				end
			end
		end

		print("Could not reset challenge ", self[arg_148_1])
	end
}

tbl[504] = tbl_188

local tbl_189 = {
	description = "All challenges with progression will only require you to increase the progress by 1",
	is_boolean = true,
	setting_name = "simplify_challenge_progression",
	category = "Progression"
}

tbl[505] = tbl_189

local tbl_190 = {
	description = "Sets all Okris challenges to be claimable in the UI",
	is_boolean = true,
	setting_name = "set_all_challenges_claimable",
	category = "Progression"
}

tbl[506] = tbl_190

local tbl_191 = {
	description = "Draws debug information for each active objective",
	is_boolean = true,
	setting_name = "show_weave_objectives",
	category = "Gamemode/level"
}

tbl[507] = tbl_191

local tbl_192 = {
	description = "Pause the objective timer for versus",
	is_boolean = true,
	setting_name = "versus_objective_timer_paused",
	category = "Versus"
}

tbl[508] = tbl_192

local tbl_193 = {
	description = "Finishes a match after the first round",
	is_boolean = true,
	setting_name = "versus_quick_match_end",
	category = "Versus"
}

tbl[509] = tbl_193

local tbl_194 = {
	description = "Generates fake stats to test the versus end screen",
	is_boolean = true,
	setting_name = "versus_generate_fake_stats",
	category = "Versus"
}

tbl[510] = tbl_194

local tbl_195 = {
	description = "Generates fake players in the ceremony screen",
	is_boolean = true,
	setting_name = "versus_generate_fake_ceremony_players",
	category = "Versus"
}

tbl[511] = tbl_195

local tbl_196 = {
	description = "Shows some information about the recharge of the horde ability.",
	is_boolean = true,
	setting_name = "vs_horde_ability_debug",
	category = "Versus"
}

tbl[512] = tbl_196

local tbl_197 = {
	description = "Activates all objectives for the current weave",
	setting_name = "activate_all_weave_objectives",
	category = "Gamemode/level",
	func = function ()
		-- function 149
		local world = Managers.world:world("level_world")
		local units = World.units(world)
		local tbl = {}

		for i, v in ipairs(units) do
			if not Unit.is_frozen(v) then
				local debug_name = Unit.debug_name(v)

				if debug_name:match(".*weave_capture_point_spawner") or debug_name:match(".*weave_interaction_spawner") or debug_name:match(".*weave_prop_skaven_doom_wheel_01_spawner") or not debug_name:match(".*weave_limited_item_track_spawner") then
					local get_data = Unit.get_data(v, "weave_objective_id")
					local num = #NetworkLookup.objective_names + 1

					NetworkLookup.objective_names[num] = get_data
					NetworkLookup.objective_names[get_data] = num
					tbl[get_data] = {}

					print(debug_name)
				end
			end
		end

		local num_2 = #NetworkLookup.objective_names + 1

		NetworkLookup.objective_names[num_2] = "kill_enemies"
		NetworkLookup.objective_names.kill_enemies = num_2
		tbl.kill_enemies = {}

		local script_data = script_data
		local temp_objective_list_counter = script_data.temp_objective_list_counter

		temp_objective_list_counter = temp_objective_list_counter or 0
		script_data.temp_objective_list_counter = temp_objective_list_counter + 1

		local str = "temp_objective_list_" .. script_data.temp_objective_list_counter

		ObjectiveLists[str] = {
			tbl
		}

		local system = Managers.state.entity:system("objective_system")

		system:server_register_objectives(str)
		system:server_activate_first_objective()
	end
}

tbl[513] = tbl_197

local tbl_198 = {
	description = "Sets all players max health to 5000",
	is_boolean = true,
	setting_name = "player_lots_of_max_health",
	category = "Player mechanics"
}

tbl[514] = tbl_198

local tbl_199 = {
	description = "Sets all players max knock down health to 5000",
	is_boolean = true,
	setting_name = "player_lots_of_max_kd_health",
	category = "Player mechanics"
}

tbl[515] = tbl_199

local tbl_200 = {
	description = "Use the standard loadout in weaves (requires restart)",
	is_boolean = true,
	setting_name = "disable_weave_loadout",
	category = "Player mechanics"
}

tbl[516] = tbl_200

local tbl_201 = {
	description = "Use the standard talents in weaves (requires restart)",
	is_boolean = true,
	setting_name = "disable_weave_talents",
	category = "Player mechanics"
}

tbl[517] = tbl_201

local tbl_202 = {
	description = "sets the weave timer to 1 sec",
	setting_name = "deplete_weave_timer",
	category = "Player mechanics",
	func = function ()
		-- function 150
		Managers.weave:_set_time_left(1)
	end
}

tbl[518] = tbl_202

local tbl_203 = {
	description = "Adds 10 Weave Essence to your account",
	setting_name = "10 Weave Essence",
	category = "Gamemode/level",
	func = function ()
		-- function 151
		Managers.backend:get_interface("weaves"):debug_grant_essence(10)
	end
}

tbl[519] = tbl_203

local tbl_204 = {
	description = "Adds 100 Weave Essence to your account",
	setting_name = "100 Weave Essence",
	category = "Gamemode/level",
	func = function ()
		-- function 152
		Managers.backend:get_interface("weaves"):debug_grant_essence(100)
	end
}

tbl[520] = tbl_204

local tbl_205 = {
	description = "Adds 1000 Weave Essence to your account",
	setting_name = "1,000 Weave Essence",
	category = "Gamemode/level",
	func = function ()
		-- function 153
		Managers.backend:get_interface("weaves"):debug_grant_essence(1000)
	end
}

tbl[521] = tbl_205

local tbl_206 = {
	description = "Adds 10000 Weave Essence to your account",
	setting_name = "10,000 Weave Essence",
	category = "Gamemode/level",
	func = function ()
		-- function 154
		Managers.backend:get_interface("weaves"):debug_grant_essence(10000)
	end
}

tbl[522] = tbl_206

local tbl_207 = {
	description = "Adds $$$ ONE MILLION $$$ Weave Essence to your account",
	setting_name = "1,000,000 Weave Essence",
	category = "Gamemode/level",
	func = function ()
		-- function 155
		Managers.backend:get_interface("weaves"):debug_grant_essence(1000000)
	end
}

tbl[523] = tbl_207

local tbl_208 = {
	description = "Removes all magic weave weapons from the inventory except for default weapons equipped ones",
	setting_name = "Remove Magic Weave Weapons",
	category = "Gamemode/level",
	func = function ()
		-- function 156
		Managers.backend:get_interface("weaves"):debug_remove_magic_items()
	end
}

tbl[524] = tbl_208

local tbl_209 = {
	setting_name = "Weave Onboarding",
	description = "change onboarding stat",
	category = "Onboarding",
	item_source = {},
	load_items_source_func = function (self)
		-- function 157
		table.clear(self)

		self[#self + 1] = "1"
		self[#self + 1] = "2"
		self[#self + 1] = "3"
		self[#self + 1] = "4"
		self[#self + 1] = "5"
		self[#self + 1] = "6"
		self[#self + 1] = "7"
		self[#self + 1] = "8"
		self[#self + 1] = "9"
		self[#self + 1] = "clear"

		table.sort(self)
	end,
	func = function (self, arg_158_1)
		-- function 158
		local var_158_0 = self[arg_158_1]
		local statistics_db = Managers.player:statistics_db()
		local stats_id = Managers.player:local_player():stats_id()

		if var_158_0 == "clear" then
			statistics_db:set_stat(stats_id, "scorpion_onboarding_step", 0)
		else
			statistics_db:set_stat(stats_id, "scorpion_onboarding_step", tonumber(var_158_0))
		end

		fn()
	end
}

tbl[525] = tbl_209

local tbl_210 = {
	description = "complete the weave onboarding ui tutorial",
	setting_name = "Weave Onboarding UI",
	category = "Onboarding",
	func = function ()
		-- function 159
		local statistics_db = Managers.player:statistics_db()
		local stats_id = Managers.player:local_player():stats_id()

		statistics_db:set_stat(stats_id, "scorpion_ui_onboarding_state", -1)
		fn()
	end
}

tbl[526] = tbl_210

local tbl_211 = {
	description = "resets weave onboarding ui tutorial",
	setting_name = "Weave Onboarding UI Reset",
	category = "Onboarding",
	func = function ()
		-- function 160
		local statistics_db = Managers.player:statistics_db()
		local stats_id = Managers.player:local_player():stats_id()

		statistics_db:set_stat(stats_id, "scorpion_ui_onboarding_state", 0)
		fn()
	end
}

tbl[527] = tbl_211

local tbl_212 = {
	description = "resets the flag keeps track of Olesya's VO that is played when player first fails a weave.",
	setting_name = "Clear Olesya Failed VO Played Flag ",
	category = "Onboarding",
	func = function ()
		-- function 161
		local statistics_db = Managers.player:statistics_db()
		local stats_id = Managers.player:local_player():stats_id()

		statistics_db:set_stat(stats_id, "scorpion_onboarding_weave_first_fail_vo_played", 0)
		fn()
	end
}

tbl[528] = tbl_212

local tbl_213 = {
	description = "Will make it so \"first_time_store_release\" is always triggered when players start the game and enter the keep",
	is_boolean = true,
	setting_name = "always_first_time_store_release",
	category = "Onboarding"
}

tbl[529] = tbl_213

local tbl_214 = {
	description = "Will make it so \"store_new_items\" is always triggered when players start the game and enter the keep",
	is_boolean = true,
	setting_name = "always_store_new_items",
	category = "Onboarding"
}

tbl[530] = tbl_214

local tbl_215 = {
	description = "Will make it so \"shop_closed_item_bought\" is always triggered when players close the store. Exclusive with other \"shop_closed\" events",
	is_boolean = true,
	setting_name = "always_shop_closed_item_bought",
	category = "Onboarding"
}

tbl[531] = tbl_215

local tbl_216 = {
	description = "Will make it so \"shop_closed_golden_key_redeemed\" is always triggered when players close the store. Exclusive with other \"shop_closed\" events",
	is_boolean = true,
	setting_name = "always_shop_closed_golden_key_redeemed",
	category = "Onboarding"
}

tbl[532] = tbl_216

local tbl_217 = {
	description = "Will make it so \"shop_closed_login_reward_claimed\" is always triggered when players close the store. Exclusive with other \"shop_closed\" events",
	is_boolean = true,
	setting_name = "always_shop_closed_login_reward_claimed",
	category = "Onboarding"
}

tbl[533] = tbl_217

local tbl_218 = {
	description = "Trigger the \"first_time_store_release\" level flow event",
	setting_name = "Trigger \"first_time_store_release\"",
	category = "Onboarding",
	func = function ()
		-- function 162
		local world = Managers.world:world("level_world")

		LevelHelper:flow_event(world, "first_time_store_release")
	end
}

tbl[534] = tbl_218

local tbl_219 = {
	description = "Trigger the \"store_new_items\" level flow event",
	setting_name = "Trigger \"store_new_items\"",
	category = "Onboarding",
	func = function ()
		-- function 163
		local world = Managers.world:world("level_world")

		LevelHelper:flow_event(world, "store_new_items")
	end
}

tbl[535] = tbl_219

local tbl_220 = {
	description = "Trigger the \"first_time_started_game\" level flow event",
	setting_name = "Trigger \"first_time_started_game\"",
	category = "Onboarding",
	func = function ()
		-- function 164
		local world = Managers.world:world("level_world")

		LevelHelper:flow_event(world, "first_time_started_game")
		LevelHelper:flow_event(world, "first_time_started_deus_game")
		LevelHelper:flow_event(world, "first_time_started_versus_game")
	end
}

tbl[536] = tbl_220

local tbl_221 = {
	description = "Clears the seen_handbook_pages table, allowing all popups to trigger again.",
	setting_name = "Clear seen_handbook_pages",
	category = "Onboarding",
	func = function ()
		-- function 165
		local seen_handbook_pages = SaveData.seen_handbook_pages

		if not seen_handbook_pages then
			table.clear(seen_handbook_pages)
		end

		local seen_handbook_popups = SaveData.seen_handbook_popups

		if not seen_handbook_popups then
			table.clear(seen_handbook_popups)
		end
	end
}

tbl[537] = tbl_221

local tbl_222 = {
	description = "Disregard the store items set by the backend",
	is_boolean = true,
	setting_name = "disregard_backend_store_items",
	category = "Store"
}

tbl[538] = tbl_222

local tbl_223 = {
	description = "Prints out the current discounted items on screen",
	is_boolean = true,
	setting_name = "show_discounted_store_items",
	category = "Store"
}

tbl[539] = tbl_223

local tbl_224 = {
	description = "Randomizes a bunch of items on sale",
	is_boolean = true,
	setting_name = "fake_store_sale",
	category = "Store"
}

tbl[540] = tbl_224

local tbl_225 = {
	description = "Count owned DLCs as installed. Makes it easier to test DLCs through steam console with enable/disable_license",
	is_boolean = true,
	setting_name = "count_owned_dlc_as_installed",
	category = "DLC"
}

tbl[541] = tbl_225

local tbl_226 = {
	description = "Displays the diorama prototype",
	close_when_selected = true,
	setting_name = "Run Diorama Prototype",
	category = "Diorama",
	func = function ()
		-- function 166
		Managers.ui:handle_transition("diorama_prototype", {})
	end
}

tbl[542] = tbl_226

local tbl_227 = {
	description = "Starts a Deus run directly on a map",
	setting_name = "Run Deus Map Node",
	category = "Deus",
	func = function ()
		-- function 167
		local game_mechanism = Managers.mechanism:game_mechanism()

		if not game_mechanism.debug_load_map then
			game_mechanism:debug_load_map()
		end
	end
}

tbl[543] = tbl_227

local tbl_228 = {
	description = "Starts a Deus run directly on a shrine",
	setting_name = "Run Deus Shrine Node",
	category = "Deus",
	func = function ()
		-- function 168
		local game_mechanism = Managers.mechanism:game_mechanism()

		if not game_mechanism.debug_load_shrine_node then
			game_mechanism:debug_load_shrine_node()
		end
	end
}

tbl[544] = tbl_228

local tbl_229 = {
	description = "Clears a finished a journey",
	setting_name = "Clear Finished Journey",
	category = "Deus",
	item_source = {},
	load_items_source_func = function (self)
		-- function 169
		table.clear(self)

		for k, v in pairs(DeusJourneySettings) do
			self[#self + 1] = k
		end

		table.sort(self)
	end,
	func = function (self, arg_170_1)
		-- function 170
		local var_170_0 = self[arg_170_1]

		LevelUnlockUtils.debug_set_completed_journey_difficulty(var_170_0, 0)
	end
}

tbl[545] = tbl_229

local tbl_230 = {
	description = "Sets the completed difficulty for the selected journey temporary.",
	setting_name = "Set completed journey difficulty",
	category = "Deus",
	item_source = {},
	load_items_source_func = function (self)
		-- function 171
		table.clear(self)

		for i, v in ipairs(AvailableJourneyOrder) do
			for i_2, v_2 in ipairs(DefaultDifficulties) do
				self[#self + 1] = v .. "/" .. v_2
			end
		end
	end,
	func = function (self, arg_172_1)
		-- function 172
		local split_deprecated = string.split_deprecated(self[arg_172_1], "/")
		local var_172_1 = split_deprecated[1]
		local var_172_2 = split_deprecated[2]
		local index_of = table.index_of(DefaultDifficulties, var_172_2)

		LevelUnlockUtils.debug_set_completed_journey_difficulty(var_172_1, index_of)
	end
}

tbl[546] = tbl_230

local tbl_231 = {
	description = "Sets the hero completed difficulty for the selected journey temporary.",
	setting_name = "Set completed hero journey difficulty",
	category = "Deus",
	item_source = {},
	load_items_source_func = function (self)
		-- function 173
		local str = "journey_citadel"

		table.clear(self)

		for i, v in ipairs(SPProfilesAbbreviation) do
			for i_2, v_2 in ipairs(DefaultDifficulties) do
				self[#self + 1] = v .. "/" .. str .. "/" .. v_2
			end
		end
	end,
	func = function (self, arg_174_1)
		-- function 174
		local split_deprecated = string.split_deprecated(self[arg_174_1], "/")
		local var_174_1 = split_deprecated[1]
		local var_174_2 = split_deprecated[2]
		local var_174_3 = split_deprecated[3]
		local index_of = table.index_of(DefaultDifficulties, var_174_3)

		LevelUnlockUtils.debug_set_completed_hero_journey_difficulty(var_174_1, var_174_2, index_of)
	end
}

tbl[547] = tbl_231

local tbl_232 = {
	description = "Clears all deus meta progression, which is just rolled over coins at the moment.",
	setting_name = "Clear Deus meta progression",
	category = "Deus",
	func = function ()
		-- function 175
		Managers.backend:get_interface("deus"):debug_clear_meta_progression()
	end
}

tbl[548] = tbl_232

local tbl_233 = {
	description = "Lists all powerups with functionality to activate them. Needs to be in a deus run.",
	setting_name = "Activate Deus PowerUp",
	category = "Deus",
	item_source = {},
	load_items_source_func = function (self)
		-- function 176
		table.clear(self)

		for k, v in pairs(DeusPowerUps) do
			for k_2, v_2 in pairs(v) do
				self[#self + 1] = k .. "/" .. k_2
			end
		end

		table.sort(self)
	end,
	func = function (self, arg_177_1)
		-- function 177
		if not Managers.mechanism:current_mechanism_name() == "deus" then
			return
		end

		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

		if not get_deus_run_controller then
			return
		end

		local local_player = Managers.player:local_player()
		local local_player_id = local_player:local_player_id()
		local var_177_3 = self[arg_177_1]
		local split_deprecated = string.split_deprecated(var_177_3, "/")
		local var_177_5 = split_deprecated[1]
		local var_177_6 = split_deprecated[2]
		local get_player_power_ups = get_deus_run_controller:get_player_power_ups(local_player.peer_id, local_player_id)
		local var_177_8

		for i, v in ipairs(get_player_power_ups) do
			if v.name == var_177_6 then
				var_177_8 = true

				break
			end
		end

		if not var_177_8 then
			local generate_specific_power_up = DeusPowerUpUtils.generate_specific_power_up(var_177_6, var_177_5)

			get_deus_run_controller:add_power_ups({
				generate_specific_power_up
			}, local_player_id, false)
		end
	end
}

tbl[549] = tbl_233

local tbl_234 = {
	description = "Adds 10.000 deus soft currency",
	setting_name = "add_soft_currency",
	category = "Deus",
	func = function (arg_178_0, arg_178_1)
		-- function 178
		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local get_own_peer_id = get_deus_run_controller._run_state:get_own_peer_id()

		get_deus_run_controller:_add_soft_currency_to_peer(get_own_peer_id, 10000)
	end
}

tbl[550] = tbl_234

local tbl_235 = {
	description = "Adds a random boon, the type obtained from boon shrines",
	setting_name = "add_random_boon",
	category = "Deus",
	func = function (arg_179_0, arg_179_1)
		-- function 179
		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local var_179_1 = get_deus_run_controller:generate_random_power_ups(DeusPowerUpSettings.weapon_chest_choice_amount, DeusPowerUpAvailabilityTypes.weapon_chest, math.random_seed())[1]
		local local_player_id = Managers.player:local_player():local_player_id()

		get_deus_run_controller:add_power_ups({
			var_179_1
		}, local_player_id, true)
		Managers.state.event:trigger("present_rewards", {
			{
				type = "deus_power_up",
				power_up = var_179_1
			}
		})
	end
}

tbl[551] = tbl_235

local tbl_236 = {
	description = "Activates all Deus PowerUps ",
	setting_name = "Activate all Deus PowerUps",
	category = "Deus",
	item_source = {},
	func = function (arg_180_0, arg_180_1)
		-- function 180
		if not Managers.mechanism:current_mechanism_name() == "deus" then
			return
		end

		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

		if not get_deus_run_controller then
			return
		end

		local local_player = Managers.player:local_player()
		local local_player_id = local_player:local_player_id()
		local network_id = local_player:network_id()
		local get_player_power_ups = get_deus_run_controller:get_player_power_ups(network_id, local_player_id)
		local num = 50
		local num_2 = 0
		local tbl = {}

		for k, v in pairs(DeusPowerUps) do
			for k_2, v_2 in pairs(v) do
				local var_180_8

				for i, v_3 in ipairs(get_player_power_ups) do
					if v_3.name == k_2 then
						var_180_8 = true

						break
					end
				end

				local mutators = v_2.mutators
				local is_empty = table.is_empty(mutators)

				for i6 = 1, #mutators do
					if not Managers.state.game_mode:has_activated_mutator(mutators[i6]) then
						is_empty = true

						break
					end
				end

				if not (not is_empty and var_180_8) then
					num_2 = num_2 + 1

					local ceil = math.ceil(num_2 / num)
					local var_180_12 = tbl[ceil]

					var_180_12 = var_180_12 or {}
					tbl[ceil] = var_180_12
					tbl[ceil][#tbl[ceil] + 1] = DeusPowerUpUtils.generate_specific_power_up(k_2, k)
				end
			end
		end

		for i7 = 1, #tbl do
			get_deus_run_controller:add_power_ups(tbl[i7], local_player_id, false)
		end
	end
}

tbl[552] = tbl_236

local tbl_237 = {
	description = "Draw the positions of the weapons as a path",
	setting_name = "Draw Weapon Position",
	category = "Weapons",
	item_source = {},
	load_items_source_func = function (arg_181_0)
		-- function 181
		table.clear(arg_181_0)
		table.insert(arg_181_0, "all")
		table.insert(arg_181_0, "right_hand")
		table.insert(arg_181_0, "left_hand")
		table.insert(arg_181_0, "right_hand_ammo")
		table.insert(arg_181_0, "left_hand_ammo")
		table.insert(arg_181_0, "[clear value]")
		table.sort(arg_181_0)
	end,
	func = function (self, arg_182_1)
		-- function 182
		script_data.debug_draw_weapon_position = self[arg_182_1]
	end
}

tbl[553] = tbl_237

local tbl_238 = {
	description = "Unlocks every deus chest aka weapon shrine",
	is_boolean = true,
	setting_name = "unlock_all_deus_chests",
	category = "Deus"
}

tbl[554] = tbl_238

local tbl_239 = {
	description = "debug any changes to the deus shared state.",
	is_boolean = true,
	setting_name = "shared_state_debug",
	category = "Deus"
}

tbl[555] = tbl_239

local tbl_240 = {
	description = "log any relevant event in the deus run controller.",
	is_boolean = true,
	setting_name = "deus_run_controller_debug",
	category = "Deus"
}

tbl[556] = tbl_240

local tbl_241 = {
	description = "draw a map with debug ui. This will draw either the current run seed being played, or the seed set by imgui_deus_map_gen",
	is_boolean = true,
	setting_name = "deus_debug_draw_map",
	category = "Deus"
}

tbl[557] = tbl_241

local tbl_242 = {
	description = "test fog without saving already seen nodes, essentially everything not accessed is fully foggy",
	is_boolean = true,
	setting_name = "deus_fog_with_no_memory",
	category = "Deus"
}

tbl[558] = tbl_242

local tbl_243 = {
	setting_name = "deus_force_load_run_progress",
	category = "Deus",
	description = "override the run progress when using this menu's load level. 900 == 0.9 ",
	item_source = {},
	load_items_source_func = function (self)
		-- function 183
		table.clear(self)

		for i = 0, 999, 10 do
			self[#self + 1] = i
		end

		table.sort(self)

		self[#self + 1] = "[clear value]"
	end
}

tbl[559] = tbl_243

local tbl_244 = {
	setting_name = "deus_seed",
	category = "Deus",
	description = "Force a default graph seed",
	item_source = {},
	load_items_source_func = function (self)
		-- function 184
		table.clear(self)

		for k, v in pairs(DeusDefaultGraphs) do
			self[#self + 1] = k
		end

		self[#self + 1] = "[clear value]"

		table.sort(self)
	end
}

tbl[560] = tbl_244

local tbl_245 = {
	setting_name = "deus_journey",
	category = "Deus",
	description = "Force a deus journey",
	item_source = {},
	load_items_source_func = function (self)
		-- function 185
		table.clear(self)

		for k, v in pairs(AvailableJourneyOrder) do
			self[#self + 1] = v
		end

		self[#self + 1] = "[clear value]"

		table.sort(self)
	end
}

tbl[561] = tbl_245

local tbl_246 = {
	setting_name = "deus_dominant_god",
	category = "Deus",
	description = "Force a deus dominant god",
	item_source = {},
	load_items_source_func = function (self)
		-- function 186
		table.clear(self)

		for k, v in pairs(DEUS_GOD_INDEX) do
			self[#self + 1] = v
		end

		self[#self + 1] = "[clear value]"

		table.sort(self)
	end
}

tbl[562] = tbl_246

local tbl_247 = {
	description = "Journeys will work in 10minute cycles for debugging. Only works in local backend.",
	is_boolean = true,
	setting_name = "deus_journey_ten_minute_cycle",
	category = "Deus"
}

tbl[563] = tbl_247

local tbl_248 = {
	description = "Shows how many enemies are marked by a curse",
	is_boolean = true,
	setting_name = "debug_deus_marked_enemies",
	category = "Deus"
}

tbl[564] = tbl_248

local tbl_249 = {
	description = "Check how the curse UI looks with all the different curses. Use left shift + q in order to cycle all the variations",
	is_boolean = true,
	setting_name = "deus_curse_ui",
	category = "Deus"
}

tbl[565] = tbl_249

local tbl_250 = {
	description = "Requires a restart/loading the next level/switching career. Unlocks all weapons in the pool used for generating random weapon at reliquaries.",
	is_boolean = true,
	setting_name = "deus_full_weapon_pool",
	category = "Deus"
}

tbl[566] = tbl_250

local tbl_251 = {
	description = "When active the next run you will start will consist only of shops (except start node and arena)",
	is_boolean = true,
	setting_name = "deus_shoppify_run",
	category = "Deus"
}

tbl[567] = tbl_251

local tbl_252 = {
	description = "Force only the new boons to be in the pool",
	is_boolean = true,
	setting_name = "belakor_force_new_boons",
	category = "Deus"
}

tbl[568] = tbl_252

local tbl_253 = {
	description = "Force a specific map layout on the belakor journey for the vertical slice build",
	is_boolean = true,
	setting_name = "belakor_force_vertical_slice_seed",
	category = "Deus"
}

tbl[569] = tbl_253

local tbl_254 = {
	description = "Forces all levels to be cursed by belakor where applicable",
	is_boolean = true,
	setting_name = "belakor_force_curses_on_map",
	category = "Deus"
}

tbl[570] = tbl_254

local tbl_255 = {
	description = "Hides the belakor journey from the UI",
	is_boolean = true,
	setting_name = "belakor_hide_journey",
	category = "Deus"
}

tbl[571] = tbl_255

local tbl_256 = {
	description = "While playing a belakor level, all possible positions for a Locus will be occupied by one",
	is_boolean = true,
	setting_name = "belakor_force_locus_on_all_positions",
	category = "Deus"
}

tbl[572] = tbl_256

local tbl_257 = {
	description = "Primes your user setting to trigger the new UI popup",
	category = "New UI Popup",
	setting_name = "Activate New Popup UI Prompt",
	func = function ()
		-- function 187
		Application.set_user_setting("use_pc_menu_layout", false)
		Application.set_user_setting("use_gamepad_menu_layout", false)
		Managers.save:auto_save(SaveFileName, SaveData)
		Application.save_user_settings()
	end
}

tbl[573] = tbl_257

local tbl_258 = {
	description = "Displays career counters",
	is_boolean = true,
	setting_name = "debug_dark_pact_delegator",
	category = "Versus"
}

tbl[574] = tbl_258

local tbl_259 = {
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
	custom_item_source_order = function (arg_188_0, arg_188_1)
		-- function 188
		for i, v in ipairs(arg_188_0) do
			local var_188_0 = v

			arg_188_1[#arg_188_1 + 1] = var_188_0
		end
	end,
	func = function (self, arg_189_1)
		-- function 189
		local var_189_0 = self[arg_189_1]

		Managers.state.crafting:debug_set_crafted_items_stat(var_189_0)
	end
}

tbl[575] = tbl_259

local tbl_260 = {
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
	custom_item_source_order = function (arg_190_0, arg_190_1)
		-- function 190
		for i, v in ipairs(arg_190_0) do
			local var_190_0 = v

			arg_190_1[#arg_190_1 + 1] = var_190_0
		end
	end,
	func = function (self, arg_191_1)
		-- function 191
		local var_191_0 = self[arg_191_1]

		Managers.state.crafting:debug_set_salvaged_items_stat(var_191_0)
	end
}

tbl[576] = tbl_260

local tbl_261 = {
	description = "Debug crafting crafting recipes",
	is_boolean = true,
	setting_name = "craft_recipe_debug",
	category = "Crafting"
}

tbl[577] = tbl_261

local tbl_262 = {
	description = "Allows the player to force start a versus game with only one player",
	is_boolean = true,
	setting_name = "allow_versus_force_start_single_player",
	category = "Versus"
}

tbl[578] = tbl_262

local tbl_263 = {
	description = "starts the round",
	setting_name = "start_player_hosted_round",
	category = "Versus",
	func = function (arg_192_0, arg_192_1)
		-- function 192
		Managers.state.game_mode:round_started()
		printf("Round started!")
	end
}

tbl[579] = tbl_263

local tbl_264 = {
	description = "Trigger boss terror event",
	setting_name = "inject_playable_boss_into_main_path",
	category = "Versus",
	func = function (arg_193_0, arg_193_1)
		-- function 193
		print("Playable boss patrols injected into the main path now")
		Managers.state.conflict.level_analysis:inject_playable_boss_into_main_path()
	end
}

tbl[580] = tbl_264

local tbl_265 = {
	description = "Trigger boss terror event",
	setting_name = "trigger_playable_boss_event",
	category = "Versus",
	func = function (arg_194_0, arg_194_1)
		-- function 194
		print("[DEBUG] Triggered Playable boss")
		Managers.state.game_mode:game_mode():set_playable_boss_can_be_picked(true)
	end
}

tbl[581] = tbl_265

local tbl_266 = {
	description = "Trigger boss terror event",
	is_boolean = true,
	setting_name = "debug_playable_boss",
	category = "Versus"
}

tbl[582] = tbl_266

local tbl_267 = {
	description = "Debug versus chaos troll puke sweep",
	is_boolean = true,
	setting_name = "versus_debug_chaos_troll_sweep",
	category = "AI"
}

tbl[583] = tbl_267

local tbl_268 = {
	description = "starts the round",
	setting_name = "end_player_hosted_round",
	category = "Versus",
	func = function (arg_195_0, arg_195_1)
		-- function 195
		if not Managers.level_transition_handler:in_hub_level() then
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
}

tbl[584] = tbl_268

local tbl_269 = {
	description = "Displays elevator context on screen",
	is_boolean = true,
	setting_name = "debug_elevators",
	category = "Allround useful stuff!"
}

tbl[585] = tbl_269

local function fn_3(arg_196_0)
	-- function 196
	return {
		{
			description = "Lists all items with functionality to add them to inventory.",
			category = "Items",
			setting_name = "Add Melee Items (" .. arg_196_0 .. ")",
			item_source = {},
			load_items_source_func = function (self)
				-- function 197
				table.clear(self)

				local ItemMasterList = ItemMasterList

				for k, v in pairs(ItemMasterList) do
					if v.slot_type == "melee" then
						self[#self + 1] = k
					end
				end

				table.sort(self)
			end,
			func = function (self, arg_198_1)
				-- function 198
				local get_interface = Managers.backend:get_interface("items")
				local var_198_1 = self[arg_198_1]

				if not var_198_1 then
					get_interface:award_item(var_198_1, nil, nil, arg_196_0)
				end
			end
		}
	}
end

local function fn_4(arg_199_0)
	-- function 199
	return {
		{
			description = "Lists all items with functionality to add them to inventory.",
			category = "Items",
			setting_name = "Add Ranged Items (" .. arg_199_0 .. ")",
			item_source = {},
			load_items_source_func = function (self)
				-- function 200
				table.clear(self)

				local ItemMasterList = ItemMasterList

				for k, v in pairs(ItemMasterList) do
					if v.slot_type == "ranged" then
						self[#self + 1] = k
					end
				end

				table.sort(self)
			end,
			func = function (self, arg_201_1)
				-- function 201
				local get_interface = Managers.backend:get_interface("items")
				local var_201_1 = self[arg_201_1]

				if not var_201_1 then
					get_interface:award_item(var_201_1, nil, nil, arg_199_0)
				end
			end
		}
	}
end

local function fn_5(arg_202_0)
	-- function 202
	return {
		{
			description = "Lists all items with functionality to add them to inventory.",
			category = "Items",
			setting_name = "Add Ring Items (" .. arg_202_0 .. ")",
			item_source = {},
			load_items_source_func = function (self)
				-- function 203
				table.clear(self)

				local ItemMasterList = ItemMasterList

				for k, v in pairs(ItemMasterList) do
					if v.slot_type == "ring" then
						self[#self + 1] = k
					end
				end

				table.sort(self)
			end,
			func = function (self, arg_204_1)
				-- function 204
				local get_interface = Managers.backend:get_interface("items")
				local var_204_1 = self[arg_204_1]

				if not var_204_1 then
					get_interface:award_item(var_204_1, nil, nil, arg_202_0)
				end
			end
		}
	}
end

local function fn_6(arg_205_0)
	-- function 205
	return {
		{
			no_nil = true,
			description = "Lists all items with functionality to add them to inventory.",
			category = "Items",
			setting_name = "Add Necklace Items (" .. arg_205_0 .. ")",
			item_source = {},
			load_items_source_func = function (self)
				-- function 206
				table.clear(self)

				local ItemMasterList = ItemMasterList

				for k, v in pairs(ItemMasterList) do
					if v.slot_type == "necklace" then
						self[#self + 1] = k
					end
				end

				table.sort(self)
			end,
			func = function (self, arg_207_1)
				-- function 207
				local get_interface = Managers.backend:get_interface("items")
				local var_207_1 = self[arg_207_1]

				if not var_207_1 then
					get_interface:award_item(var_207_1, nil, nil, arg_205_0)
				end
			end
		}
	}
end

local function fn_7(arg_208_0)
	-- function 208
	return {
		{
			description = "Lists all items with functionality to add them to inventory.",
			category = "Items",
			setting_name = "Add Trinket Items (" .. arg_208_0 .. ")",
			item_source = {},
			load_items_source_func = function (self)
				-- function 209
				table.clear(self)

				local ItemMasterList = ItemMasterList

				for k, v in pairs(ItemMasterList) do
					if v.slot_type == "trinket" then
						self[#self + 1] = k
					end
				end

				table.sort(self)
			end,
			func = function (self, arg_210_1)
				-- function 210
				local get_interface = Managers.backend:get_interface("items")
				local var_210_1 = self[arg_210_1]

				if not var_210_1 then
					get_interface:award_item(var_210_1, nil, nil, arg_208_0)
				end
			end
		}
	}
end

local tbl_270 = {
	"plentiful",
	"common",
	"rare",
	"exotic",
	"unique"
}

for i, v in ipairs(tbl_270) do
	table.append(tbl, fn_3(v))
end

for i_2, v_2 in ipairs(tbl_270) do
	table.append(tbl, fn_4(v_2))
end

for i_3, v_3 in ipairs(tbl_270) do
	table.append(tbl, fn_5(v_3))
end

for i_4, v_4 in ipairs(tbl_270) do
	table.append(tbl, fn_6(v_4))
end

for i_5, v_5 in ipairs(tbl_270) do
	table.append(tbl, fn_7(v_5))
end

local function fn_8(arg_211_0, arg_211_1)
	-- function 211
	local function fn(self)
		-- function 212
		table.clear(self)

		local local_player = Managers.player:local_player()
		local profile_index = local_player:profile_index()
		local var_212_2 = SPProfiles[profile_index]
		local career_index = local_player:career_index()
		local name = var_212_2.careers[career_index].name
		local ItemMasterList = ItemMasterList
		local get_interface = Managers.backend:get_interface("common")

		for k, v in pairs(ItemMasterList) do
			if v.slot_type ~= arg_211_0 or not get_interface:can_wield(name, v) then
				self[#self + 1] = k
			end
		end

		table.sort(self)
	end

	local function fn_2(self, arg_213_1)
		-- function 213
		local var_213_0 = self[arg_213_1]

		if not var_213_0 then
			return
		end

		local get_interface = Managers.backend:get_interface("items")
		local get_item_from_key = get_interface:get_item_from_key(var_213_0)

		if not get_item_from_key then
			get_interface:award_item(var_213_0, nil, nil, arg_211_1)

			get_item_from_key = get_interface:get_item_from_key(var_213_0)
		end

		if not get_item_from_key then
			return
		end

		local var_213_3 = ItemMasterList[var_213_0]
		local local_player = Managers.player:local_player()
		local player_unit = local_player.player_unit
		local extension = ScriptUnit.extension(player_unit, "inventory_system")

		if not extension:resyncing_loadout() then
			return
		end

		local backend_id = get_item_from_key.backend_id
		local slot_type = var_213_3.slot_type
		local slots_by_slot_index = InventorySettings.slots_by_slot_index
		local var_213_10

		for k, v in pairs(slots_by_slot_index) do
			if slot_type == v.type then
				var_213_10 = v.name

				break
			end
		end

		local profile_index = local_player:profile_index()
		local var_213_12 = SPProfiles[profile_index]
		local display_name = var_213_12.display_name
		local get = Managers.backend:get_interface("hero_attributes"):get(display_name, "career")
		local name = var_213_12.careers[get].name

		BackendUtils.set_loadout_item(backend_id, name, var_213_10)
		extension:create_equipment_in_slot(var_213_10, backend_id)
	end

	return {
		{
			description = "Lists all items for current career to equip them, adding to inventory if necessary.",
			category = "Items",
			setting_name = "Equip " .. arg_211_0 .. " Items (" .. arg_211_1 .. ")",
			item_source = {},
			load_items_source_func = fn,
			func = fn_2
		}
	}
end

for i_6, v_6 in ipairs(tbl_270) do
	table.append(tbl, fn_8("melee", v_6))
end

for i_7, v_7 in ipairs(tbl_270) do
	table.append(tbl, fn_8("ranged", v_7))
end

local PLATFORM = PLATFORM

if not IS_PS4 then
	local tbl_271 = {
		{
			description = "Debug PSN Features",
			is_boolean = true,
			setting_name = "debug_psn",
			category = "PS4"
		}
	}

	table.append(tbl, tbl_271)
end

if not IS_CONSOLE then
	local tbl_272 = {
		{
			setting_name = "Spawn/Unspawn",
			description = "",
			category = "Breed",
			item_source = {},
			load_items_source_func = function (self)
				-- function 214
				table.clear(self)

				self[1] = "Switch Breed"
				self[2] = "Spawn Breed"
				self[3] = "Spawn Group"
				self[4] = "Spawn Horde"
				self[5] = "Unspawn All Breed"
				self[6] = "Unspawn Nearby Breed"
				self[7] = "Unspawn Specials"
			end,
			func = function (self, arg_215_1)
				-- function 215
				local conflict = Managers.state.conflict

				if not conflict then
					local var_215_1 = self[arg_215_1]

					if var_215_1 == "Switch Breed" then
						local time = Managers.time:time("main")

						conflict:debug_spawn_switch_breed(time)
					elseif var_215_1 == "Spawn Breed" then
						local time_2 = Managers.time:time("main")

						conflict:debug_spawn_breed(time_2)
					elseif var_215_1 == "Spawn Group" then
						local time_3 = Managers.time:time("main")

						conflict:debug_spawn_group(time_3)
					elseif var_215_1 == "Spawn Horde" then
						conflict:debug_spawn_horde()
					elseif var_215_1 == "Unspawn All Breed" then
						conflict:destroy_all_units()
					elseif var_215_1 == "Unspawn Nearby Breed" then
						conflict:destroy_close_units(nil, nil, 144)
					elseif var_215_1 == "Unspawn Specials" then
						conflict:destroy_specials()
					end
				end
			end
		},
		{
			setting_name = "Set Time Scale (%)",
			description = "",
			category = "Time",
			item_source = {},
			load_items_source_func = function (self)
				-- function 216
				table.clear(self)

				self[1] = 1
				self[2] = 50
				self[3] = 100
				self[4] = 200
			end,
			func = function (self, arg_217_1)
				-- function 217
				local debug = Managers.state.debug

				if not debug then
					local var_217_1 = self[arg_217_1]
					local find = table.find(debug.time_scale_list, var_217_1)

					assert(find, "[DebugScreen] Selected time scale not found in Managers.state.debug.time_scale_list")
					debug:set_time_scale(find)
				end
			end
		}
	}

	table.append(tbl, tbl_272)
end

for k, v_8 in pairs(tbl) do
	if not v_8.preset then
		for k_2, v_9 in pairs(v_8.preset) do
			v_8.description = string.format("%s¤ %s = %s \n", v_8.description, k_2, tostring(v_9))
		end
	end
end

local tbl_273 = {
	visualize_sound_occlusion = function (arg_218_0)
		-- function 218
		World.visualize_sound_occlusion()
	end,
	enable_chain_constraints = function (arg_219_0)
		-- function 219
		World.enable_chain_constraints(arg_219_0)
	end,
	update_using_luajit = function (arg_220_0)
		-- function 220
		if not script_data.luajit_disabled then
			jit.off()
			print("lua jit is disabled")
		else
			jit.on()
			print("lua jit is enabled")
		end
	end,
	enable_navigation_visual_debug = function (arg_221_0)
		-- function 221
		if not arg_221_0 and VISUAL_DEBUGGING_ENABLED or not Managers.state.entity then
			VISUAL_DEBUGGING_ENABLED = true

			local nav_world = Managers.state.entity:system("ai_system"):nav_world()

			GwNavWorld.init_visual_debug_server(nav_world, 4888)
		end
	end,
	disable_outlines = function (arg_222_0)
		-- function 222
		if not Managers.state and not Managers.state.entity then
			Managers.state.entity:system("outline_system"):set_disabled(arg_222_0)
		end
	end
}

return {
	settings = tbl,
	callbacks = tbl_273
}
