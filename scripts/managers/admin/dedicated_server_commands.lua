-- chunkname: @scripts/managers/admin/dedicated_server_commands.lua

local scripts_managers_game_mode_mechanisms_reservation_handler_types = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

DedicatedServerCommands = class(DedicatedServerCommands)

local var_0_1
local var_0_2

local function fn(arg_1_0, ...)
	-- function 1
	local format = string.format(arg_1_0, ...)

	cprint(format)
end

local function fn_2(arg_2_0, ...)
	-- function 2
	local format = string.format(arg_2_0, ...)

	cprint(string.format("[ERROR] %s", format))
end

local function fn_3(arg_3_0, arg_3_1, ...)
	-- function 3
	if not arg_3_0 then
		fn(arg_3_1, ...)
	else
		fn_2(arg_3_1, ...)
	end
end

DedicatedServerCommands.init = function (arg_4_0)
	-- function 4
	return
end

DedicatedServerCommands.execute_command = function (arg_5_0, arg_5_1)
	-- function 5
	local split_deprecated = string.split_deprecated(arg_5_1, " ")

	if #split_deprecated == 0 then
		local str = "No command"

		fn_2(str)

		return false, str
	end

	local remove = table.remove(split_deprecated, 1)
	local var_5_3 = var_0_2[remove]

	if not var_5_3 then
		local var_5_4, var_5_5 = pcall(var_5_3)

		return var_5_4, string.format("meta;%s;%s", remove, var_5_5)
	end

	local var_5_6 = var_0_1[remove]

	if not var_5_6 then
		local format = string.format("Unknown command '%s'", remove)

		fn_2(format)

		return false, string.format("error;%s;%s", remove, format)
	end

	local func = var_5_6.func

	fassert(func, "Command function '%s' not implemented", remove)
	fassert(type(func) == "function", "Command function '%s' is not a function", remove)

	local min_args = var_5_6.min_args
	local max_args = var_5_6.max_args
	local count = #split_deprecated

	if count < min_args then
		local format_2 = string.format("Too few arguments. Got %d, expected %d", count, min_args)

		fn_2(format_2)

		return false, string.format("error;%s;%s", remove, format_2)
	end

	if max_args < count then
		local format_3 = string.format("Too many arguments. Got %d, expected %d", count, max_args)

		fn_2(format_3)

		return false, string.format("error;%s;%s", remove, format_3)
	end

	local var_5_14, var_5_15, var_5_16 = pcall(func, unpack(split_deprecated))

	if not var_5_14 then
		fn_2(tostring(var_5_15))

		return false, string.format("error;%s;%s", remove, var_5_16)
	end

	fassert(var_5_15 == true or var_5_15 == false, "Unexpected result value '%s'", tostring(var_5_15))
	fassert(var_5_16 ~= nil, "Missing response for '%s'", remove)

	local find = string.find(var_5_16, "\n+$")

	if not find then
		var_5_16 = string.sub(var_5_16, 1, find - 1)
	end

	fn_3(var_5_15, var_5_16)

	return var_5_15, string.format("command;%s;%s", remove, var_5_16)
end

var_0_1 = {
	list_commands = {
		description = "List all commands",
		min_args = 0,
		example = "list_commands",
		max_args = 0,
		func = function ()
			-- function 6
			local str = ""

			for k, v in pairs(var_0_1) do
				str = string.format("%s%s - %s\n", str, k, v.description)
			end

			return true, str
		end
	},
	help = {
		description = "Display the help for the command",
		min_args = 0,
		example = "help <command>",
		max_args = 1,
		func = function (arg_7_0)
			-- function 7
			if not arg_7_0 then
				local str = ""

				for k, v in pairs(var_0_1) do
					str = string.format("%s%s - %s\n", str, k, v.description)
				end

				return true, str
			end

			local var_7_1 = var_0_1[arg_7_0]

			if not var_7_1 then
				return false, string.format("Unknown command '%s'", arg_7_0)
			end

			local format = string.format("Command: %s\nDescription: %s\nExample: %s\n", arg_7_0, var_7_1.description, var_7_1.example)

			return true, format
		end
	},
	start = {
		description = "Start the server",
		min_args = 0,
		example = "start",
		max_args = 0,
		func = function ()
			-- function 8
			if Managers.mechanism:get_state() ~= "inn" then
				return false, string.format("Failed to start server - Match already started")
			end

			Managers.mechanism:game_mechanism():force_start_dedicated_server()

			return true, "Starting server!"
		end
	},
	stop = {
		description = "Stop the server",
		min_args = 0,
		example = "stop",
		max_args = 0,
		func = function ()
			-- function 9
			Application.quit()

			return true, "Server stopped!"
		end
	},
	restart = {
		description = "Restart the server",
		min_args = 0,
		example = "restart",
		max_args = 0,
		func = function ()
			-- function 10
			local game_mechanism = Managers.mechanism:game_mechanism()

			assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

			local get_slot_reservation_handler = game_mechanism:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session)
			local network = Managers.state.network
			local peers = get_slot_reservation_handler:peers()

			for k, v in pairs(peers) do
				if not PEER_ID_TO_CHANNEL[v] then
					network.network_server:kick_peer(v)
				end
			end

			Managers.game_server:restart()

			return true, "Restarting server!"
		end
	},
	set_party_size = {
		description = "Set the size of a party",
		min_args = 2,
		example = "set_party_size <party_id> <size>",
		max_args = 2,
		func = function (arg_11_0, arg_11_1)
			-- function 11
			if Managers.mechanism:get_state() ~= "inn" then
				return false, "Failed to set party size - Ongoing match"
			end

			arg_11_0 = tonumber(arg_11_0)
			arg_11_1 = tonumber(arg_11_1)

			assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

			local set_party_size, var_11_1 = Managers.mechanism:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session):set_party_size(arg_11_0, arg_11_1)

			if not set_party_size then
				return false, string.format("Failed to set party size - %s", var_11_1)
			end

			return true, string.format("Party %d's size set to %d", arg_11_0, arg_11_1)
		end
	},
	set_level = {
		description = "Force the server to use a level",
		min_args = 1,
		example = "set_level <level_key>",
		max_args = 1,
		func = function (arg_12_0)
			-- function 12
			if Managers.mechanism:get_state() ~= "inn" then
				return false, string.format("Failed to set level - Match started")
			end

			if type(arg_12_0) ~= "string" then
				return false, string.format("Failed to set level - Invalid level")
			end

			if not LevelSettings[arg_12_0] then
				return false, string.format("Failed to set level - Level not found")
			end

			Managers.state.game_mode:game_mode():force_map_pool({
				arg_12_0
			})

			return true, "Level set!"
		end
	},
	list_players = {
		description = "List all players",
		min_args = 0,
		example = "list_players",
		max_args = 0,
		func = function ()
			-- function 13
			local str = ""

			if not Managers.level_transition_handler:in_hub_level() then
				assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

				local peers = Managers.mechanism:game_mechanism():get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session):peers()

				for i = 1, #peers do
					local var_13_2 = peers[i]
					local format = string.format
					local str_2 = "%s%s - %s\n"
					local var_13_5 = str
					local flag = var_13_2 or "-"
					local peer_name = Managers.game_server:peer_name(var_13_2)

					peer_name = peer_name or "-"
					str = format(str_2, var_13_5, flag, peer_name)
				end

				return true, str
			end

			local human_and_bot_players = Managers.player:human_and_bot_players()

			for k, v in pairs(human_and_bot_players) do
				local format_2 = string.format
				local str_3 = "%s%s - %s (%s)\n"
				local var_13_11 = str
				local peer_id = v.peer_id

				peer_id = peer_id or "-"

				local name = v:name()

				name = name or "-"

				local career_name = v:career_name()

				career_name = career_name or "-"
				str = format_2(str_3, var_13_11, peer_id, name, career_name)
			end

			return true, str
		end
	},
	list_party = {
		description = "List all players in a party",
		min_args = 1,
		example = "list_party <party_id>",
		max_args = 1,
		func = function (arg_14_0)
			-- function 14
			arg_14_0 = tonumber(arg_14_0)

			if not Managers.level_transition_handler:in_hub_level() then
				assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

				local var_14_0 = Managers.mechanism:game_mechanism():get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session)._reserved_peers[arg_14_0]

				if not var_14_0 then
					return false, string.format("Failed to list party - Invalid party id %d", arg_14_0)
				end

				local str = ""

				for i = 1, #var_14_0 do
					local peer_id = var_14_0[i].peer_id

					if not peer_id then
						str = string.format("%s%s - %s\n", str, peer_id, Managers.game_server:peer_name(peer_id))
					end
				end

				return true, str
			end

			local get_party = Managers.party:get_party(arg_14_0)

			if not get_party then
				return false, string.format("Failed to list party - Invalid party id %d", arg_14_0)
			end

			local str_2 = ""
			local occupied_slots = get_party.occupied_slots

			for j = 1, #occupied_slots do
				local var_14_6 = occupied_slots[j]
				local player = var_14_6.player

				str_2 = string.format("%s%s - %s (%s)\n", str_2, var_14_6.peer_id, player:name(), player:career_name())
			end

			return true, str_2
		end
	},
	list_script_data = {
		description = "List all script_data settings",
		min_args = 0,
		example = "list_script_data",
		max_args = 0,
		func = function ()
			-- function 15
			return true, table.dump_string(script_data)
		end
	},
	set_script_data = {
		description = "Set a script_data setting",
		min_args = 2,
		example = "set_script_data <key> <value>",
		max_args = 2,
		func = function (arg_16_0, arg_16_1)
			-- function 16
			script_data[arg_16_0] = arg_16_1

			return true, "Script data changed!"
		end
	},
	set_disable_gamemode_end = {
		description = "Set disable game mode end setting",
		min_args = 1,
		example = "disable_gamemode_end <bool>",
		max_args = 1,
		func = function (arg_17_0)
			-- function 17
			script_data.disable_gamemode_end = arg_17_0

			return true, "Game mode end has changed"
		end
	},
	set_time = {
		description = "Set the objective timer",
		min_args = 1,
		example = "set_time <time>",
		max_args = 1,
		func = function (arg_18_0)
			-- function 18
			if not Managers.level_transition_handler:in_hub_level() then
				return false, string.format("Failed to set time - Match not started")
			end

			Managers.mechanism:game_mechanism():win_conditions():set_time(tonumber(arg_18_0))

			return true, "Time set!"
		end
	},
	add_time = {
		description = "Add time to the objective timer",
		min_args = 1,
		example = "add_time <time>",
		max_args = 1,
		func = function (arg_19_0)
			-- function 19
			if not Managers.level_transition_handler:in_hub_level() then
				return false, string.format("Failed to add time - Match not started")
			end

			Managers.mechanism:game_mechanism():win_conditions():add_time(tonumber(arg_19_0))

			return true, "Time added!"
		end
	},
	set_score = {
		description = "Set the score for the current hero team",
		min_args = 1,
		example = "set_score <score>",
		max_args = 1,
		func = function (arg_20_0)
			-- function 20
			if not Managers.level_transition_handler:in_hub_level() then
				return false, string.format("Failed to set time - Match not started")
			end

			Managers.mechanism:game_mechanism():win_conditions():set_score(tonumber(arg_20_0))

			return true, "Score set!"
		end
	},
	add_score = {
		description = "Add score to the current hero team",
		min_args = 1,
		example = "add_score <score>",
		max_args = 1,
		func = function (arg_21_0)
			-- function 21
			if not Managers.level_transition_handler:in_hub_level() then
				return false, string.format("Failed to add time - Match not started")
			end

			Managers.mechanism:game_mechanism():win_conditions():add_score(tonumber(arg_21_0))

			return true, "Score added!"
		end
	},
	start_round = {
		description = "Start the round",
		min_args = 0,
		example = "start_round",
		max_args = 0,
		func = function ()
			-- function 22
			if not Managers.level_transition_handler:in_hub_level() then
				return false, "Failed to start round - Match not started"
			end

			Managers.state.game_mode:round_started()

			return true, "Round started!"
		end
	},
	end_round = {
		description = "End the round",
		min_args = 0,
		example = "end_round",
		max_args = 0,
		func = function ()
			-- function 23
			if not Managers.level_transition_handler:in_hub_level() then
				return false, "Failed to end round - Match not started"
			end

			Managers.state.game_mode:round_started()
			Managers.mechanism:game_mechanism():win_conditions():set_time(0)

			return true, "Round ended!"
		end
	},
	end_match = {
		description = "End the match",
		min_args = 0,
		example = "end_round",
		max_args = 0,
		func = function ()
			-- function 24
			if not Managers.level_transition_handler:in_hub_level() then
				return false, "Failed to end match - Match not started"
			end

			Managers.state.game_mode:round_started()
			Managers.mechanism:game_mechanism():win_conditions():debug_end_match()

			return true, "Match ended!"
		end
	},
	skip_to_set = {
		description = "End current round and skip to the first round of the specified set",
		min_args = 1,
		example = "skip_to_set <set>",
		max_args = 1,
		func = function (arg_25_0)
			-- function 25
			do return false, "Failed to skip to set - only avaiable in DEBUG" end

			if not Managers.level_transition_handler:in_hub_level() then
				return false, "Failed to skip to set - Match not started"
			end

			local game_mechanism = Managers.mechanism:game_mechanism()

			arg_25_0 = tonumber(arg_25_0)

			if arg_25_0 <= game_mechanism:get_current_set() then
				return false, "Failed to skip to set - Can't skip to current / previous set"
			end

			game_mechanism:debug_skip_to_set(arg_25_0)

			return true, "Skipping to new set!"
		end
	},
	skip_picker = {
		description = "Skip the current picking player during character selection",
		min_args = 0,
		example = "skip_picker",
		max_args = 0,
		func = function ()
			-- function 26
			do return false, "Failed to skip to set - only avaiable in DEBUG" end

			if not Managers.mechanism:game_mechanism() then
				return false, "No active mechanism"
			end

			local game_mode = Managers.state.game_mode

			game_mode = not game_mode and Managers.state.game_mode:game_mode()

			if not game_mode then
				return false, "No current game mode is active"
			end

			local party_selection_logic = game_mode:party_selection_logic()

			if not party_selection_logic then
				return false, "Current game mode doesn't have a party selection"
			end

			party_selection_logic._timer = 0

			return true, "Skipping current picker"
		end
	},
	stop_selection_timer = {
		description = "Skip the current picking player during character selection",
		min_args = 0,
		example = "skip_picker",
		max_args = 0,
		func = function ()
			-- function 27
			do return false, "Failed to skip to set - only avaiable in DEBUG" end

			if not Managers.mechanism:game_mechanism() then
				return false, "No active mechanism"
			end

			local game_mode = Managers.state.game_mode

			game_mode = not game_mode and Managers.state.game_mode:game_mode()

			if not game_mode then
				return false, "No current game mode is active"
			end

			local party_selection_logic = game_mode:party_selection_logic()

			if not party_selection_logic then
				return false, "Current game mode doesn't have a party selection"
			end

			party_selection_logic._timer = 100000

			return true, "Stopping current picker"
		end
	},
	quick_start = {
		description = "Bypass mission select and round timers",
		min_args = 0,
		example = "quick_start",
		max_args = 0,
		func = function ()
			-- function 28
			script_data.dev_quick_start = true

			return true, "Quick start enabled. Bypassing mission select and round timers."
		end
	},
	say = {
		description = "Send a message to everyone on the server",
		min_args = 1,
		example = "say <message>",
		max_args = 1024,
		func = function (...)
			-- function 29
			local join = varargs.join(" ", ...)
			local chat = Managers.chat

			if not chat:has_channel(1) then
				chat:send_system_chat_message(1, "rcon_server_command_say_header", join, false, true)
			else
				return false, "Failed to send chat message - No channel 1"
			end

			return true, "Message sent"
		end
	},
	say_party = {
		description = "Send a message to everyone in a team",
		min_args = 2,
		example = "say_party <party_id> <message>",
		max_args = 1025,
		func = function ()
			-- function 30
			fassert("Not implemented")
		end
	},
	say_player = {
		description = "Send a message to a player",
		min_args = 2,
		example = "say_player <peer_id> <message>",
		max_args = 1025,
		func = function ()
			-- function 31
			fassert("Not implemented")
		end
	},
	swap_players = {
		description = "Swap party between two players",
		min_args = 2,
		example = "swap_players <peer_id> <peer_id>",
		max_args = 2,
		func = function (arg_32_0, arg_32_1)
			-- function 32
			if Managers.mechanism:get_state() ~= "inn" then
				return false, "Failed to move players - Match started"
			end

			if arg_32_0 == arg_32_1 then
				return false, "Failed to move players - peer_id_1 is same as peer_id_2"
			end

			local game_mechanism = Managers.mechanism:game_mechanism()

			assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

			local swap_players, var_32_2 = game_mechanism:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session):swap_players(arg_32_0, arg_32_1)

			if not swap_players then
				return false, string.format("Failed to swap players - %s", var_32_2)
			end

			return true, "Players swapped!"
		end
	},
	set_player_party = {
		description = "Move a player to another party",
		min_args = 2,
		example = "set_player_party <peer_id> <party_id>",
		max_args = 2,
		func = function (arg_33_0, arg_33_1)
			-- function 33
			if Managers.mechanism:get_state() ~= "inn" then
				return false, "Failed to move player - Match started"
			end

			arg_33_1 = tonumber(arg_33_1)

			assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

			local get_slot_reservation_handler = Managers.mechanism:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

			if not get_slot_reservation_handler:is_fully_reserved() then
				return false, "Failed to move player - All parties are full"
			end

			local flag = true
			local move_player, var_33_3 = get_slot_reservation_handler:move_player(arg_33_0, arg_33_1, flag)

			if not move_player then
				return false, var_33_3 or "Failed to move player - unknown"
			end

			return true, "Player moved!"
		end
	},
	kill = {
		description = "Kill a player",
		min_args = 1,
		example = "kill <peer_id>",
		max_args = 1,
		func = function (arg_34_0)
			-- function 34
			if not Managers.level_transition_handler:in_hub_level() then
				return false, "Failed to kill player - Match not started"
			end

			local player = Managers.player:player(arg_34_0, 1)

			if not player then
				return false, "Failed to kill player - Player not found"
			end

			local player_unit = player.player_unit

			if not (not player_unit and Unit.alive(player_unit)) then
				return false, "Failed to kill player - Player unit not found"
			end

			if not ScriptUnit.extension(player_unit, "status_system"):is_dead() then
				return false, "Failed to kill player - Player already dead"
			end

			ScriptUnit.extension(player_unit, "health_system"):die("forced")

			return true, "Player killed!"
		end
	},
	ban = {
		description = "Ban a player",
		min_args = 1,
		example = "ban <peer_id>/<ip>",
		max_args = 1,
		func = function (arg_35_0, arg_35_1)
			-- function 35
			if Application.hex64_to_dec(arg_35_0) == nil then
				return false, "Invalid peer id"
			end

			arg_35_1 = tonumber(arg_35_1)

			local var_35_0

			if arg_35_1 ~= nil then
				var_35_0 = os.time() + arg_35_1 * 24 * 60 * 60
			end

			local ban_list = Managers.ban_list

			ban_list:ban(arg_35_0, arg_35_0, var_35_0)
			ban_list:save(function (arg_36_0)
				-- function 36
				if arg_36_0 ~= nil then
					cprintf("Ban list save failed (%s)", arg_36_0)
				end
			end)

			return true, "Player banned"
		end
	},
	kick = {
		description = "Kick a player",
		min_args = 1,
		example = "kick <peer_id>/<ip>",
		max_args = 1,
		func = function (arg_37_0)
			-- function 37
			if not PEER_ID_TO_CHANNEL[arg_37_0] then
				return false, "Failed to kick player - Player not found"
			end

			Managers.state.network.network_server:kick_peer(arg_37_0)

			return true, "Player kicked from server"
		end
	},
	spawn_horde = {
		description = "spawns a horde",
		min_args = 0,
		max_args = 0,
		func = function ()
			-- function 38
			Managers.state.conflict:debug_spawn_horde()

			return true, "Spawning horde"
		end
	},
	trigger_playable_boss = {
		description = "lets pactsworn pick playable boss",
		min_args = 0,
		max_args = 0,
		func = function ()
			-- function 39
			cprint("[DEBUG] Triggered Playable boss")
			Managers.state.game_mode:game_mode():set_playable_boss_can_be_picked(true)

			return true, "trigger_playable_boss"
		end
	},
	enable_ai_and_bots = {
		description = "disables ai and bots",
		min_args = 0,
		max_args = 0,
		func = function ()
			-- function 40
			cprint("[DEBUG] disabling ai and bots")

			script_data.ai_pacing_disabled = false
			script_data.ai_roaming_spawning_disabled = false
			script_data.ai_specials_spawning_disabled = false
			script_data.ai_boss_spawning_disabled = false
			script_data.ai_horde_spawning_disabled = false
			script_data.ai_bots_disabled = false
			script_data.ai_critter_spawning_disabled = false
			script_data.ai_mini_patrol_disabled = false
			script_data.ai_rush_intervention_disabled = false
			script_data.ai_speed_run_intervention_disabled = false
			script_data.ai_terror_events_disabled = false

			return true, "disabling_ai_and_bots"
		end
	},
	disable_ai_and_bots = {
		description = "enables ai and bots",
		min_args = 0,
		max_args = 0,
		func = function ()
			-- function 41
			cprint("[DEBUG] enabling ai and bots")

			script_data.ai_pacing_disabled = true
			script_data.ai_roaming_spawning_disabled = true
			script_data.ai_boss_spawning_disabled = true
			script_data.ai_specials_spawning_disabled = true
			script_data.ai_horde_spawning_disabled = true
			script_data.ai_bots_disabled = true
			script_data.ai_critter_spawning_disabled = true
			script_data.ai_mini_patrol_disabled = true
			script_data.ai_rush_intervention_disabled = true
			script_data.ai_speed_run_intervention_disabled = true
			script_data.ai_terror_events_disabled = true

			return true, "enabling_ai_and_bots"
		end
	}
}
var_0_2 = {
	_num_players = function ()
		-- function 42
		local dedicated_server_reservation_slots = script_data.dedicated_server_reservation_slots
		local split_deprecated = string.split_deprecated(dedicated_server_reservation_slots, ",")
		local var_42_2
		local num = 0

		for i = 1, #split_deprecated do
			num = num + tonumber(split_deprecated[i])
		end

		if not Managers.level_transition_handler:in_hub_level() then
			assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

			var_42_2 = Managers.mechanism:game_mechanism():get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session)._num_slots_reserved
		else
			var_42_2 = Managers.player:num_human_players()
		end

		return string.format("%d/%d", var_42_2, num)
	end,
	_ping = function ()
		-- function 43
		return "pong"
	end
}
