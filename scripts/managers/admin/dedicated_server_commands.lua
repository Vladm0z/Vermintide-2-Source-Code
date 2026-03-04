-- chunkname: @scripts/managers/admin/dedicated_server_commands.lua

local var_0_0 = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

DedicatedServerCommands = class(DedicatedServerCommands)

local var_0_1
local var_0_2

local function var_0_3(arg_1_0, ...)
	local var_1_0 = string.format(arg_1_0, ...)

	cprint(var_1_0)
end

local function var_0_4(arg_2_0, ...)
	local var_2_0 = string.format(arg_2_0, ...)

	cprint(string.format("[ERROR] %s", var_2_0))
end

local function var_0_5(arg_3_0, arg_3_1, ...)
	if arg_3_0 then
		var_0_3(arg_3_1, ...)
	else
		var_0_4(arg_3_1, ...)
	end
end

DedicatedServerCommands.init = function (arg_4_0)
	return
end

DedicatedServerCommands.execute_command = function (arg_5_0, arg_5_1)
	local var_5_0 = string.split_deprecated(arg_5_1, " ")

	if #var_5_0 == 0 then
		local var_5_1 = "No command"

		var_0_4(var_5_1)

		return false, var_5_1
	end

	local var_5_2 = table.remove(var_5_0, 1)
	local var_5_3 = var_0_2[var_5_2]

	if var_5_3 then
		local var_5_4, var_5_5 = pcall(var_5_3)

		return var_5_4, string.format("meta;%s;%s", var_5_2, var_5_5)
	end

	local var_5_6 = var_0_1[var_5_2]

	if not var_5_6 then
		local var_5_7 = string.format("Unknown command '%s'", var_5_2)

		var_0_4(var_5_7)

		return false, string.format("error;%s;%s", var_5_2, var_5_7)
	end

	local var_5_8 = var_5_6.func

	fassert(var_5_8, "Command function '%s' not implemented", var_5_2)
	fassert(type(var_5_8) == "function", "Command function '%s' is not a function", var_5_2)

	local var_5_9 = var_5_6.min_args
	local var_5_10 = var_5_6.max_args
	local var_5_11 = #var_5_0

	if var_5_11 < var_5_9 then
		local var_5_12 = string.format("Too few arguments. Got %d, expected %d", var_5_11, var_5_9)

		var_0_4(var_5_12)

		return false, string.format("error;%s;%s", var_5_2, var_5_12)
	end

	if var_5_10 < var_5_11 then
		local var_5_13 = string.format("Too many arguments. Got %d, expected %d", var_5_11, var_5_10)

		var_0_4(var_5_13)

		return false, string.format("error;%s;%s", var_5_2, var_5_13)
	end

	local var_5_14, var_5_15, var_5_16 = pcall(var_5_8, unpack(var_5_0))

	if not var_5_14 then
		var_0_4(tostring(var_5_15))

		return false, string.format("error;%s;%s", var_5_2, var_5_16)
	end

	fassert(var_5_15 == true or var_5_15 == false, "Unexpected result value '%s'", tostring(var_5_15))
	fassert(var_5_16 ~= nil, "Missing response for '%s'", var_5_2)

	local var_5_17 = string.find(var_5_16, "\n+$")

	if var_5_17 then
		var_5_16 = string.sub(var_5_16, 1, var_5_17 - 1)
	end

	var_0_5(var_5_15, var_5_16)

	return var_5_15, string.format("command;%s;%s", var_5_2, var_5_16)
end

var_0_1 = {
	list_commands = {
		description = "List all commands",
		min_args = 0,
		example = "list_commands",
		max_args = 0,
		func = function ()
			local var_6_0 = ""

			for iter_6_0, iter_6_1 in pairs(var_0_1) do
				var_6_0 = string.format("%s%s - %s\n", var_6_0, iter_6_0, iter_6_1.description)
			end

			return true, var_6_0
		end
	},
	help = {
		description = "Display the help for the command",
		min_args = 0,
		example = "help <command>",
		max_args = 1,
		func = function (arg_7_0)
			if not arg_7_0 then
				local var_7_0 = ""

				for iter_7_0, iter_7_1 in pairs(var_0_1) do
					var_7_0 = string.format("%s%s - %s\n", var_7_0, iter_7_0, iter_7_1.description)
				end

				return true, var_7_0
			end

			local var_7_1 = var_0_1[arg_7_0]

			if not var_7_1 then
				return false, string.format("Unknown command '%s'", arg_7_0)
			end

			local var_7_2 = string.format("Command: %s\nDescription: %s\nExample: %s\n", arg_7_0, var_7_1.description, var_7_1.example)

			return true, var_7_2
		end
	},
	start = {
		description = "Start the server",
		min_args = 0,
		example = "start",
		max_args = 0,
		func = function ()
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
			local var_10_0 = Managers.mechanism:game_mechanism()

			assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

			local var_10_1 = var_10_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.session)
			local var_10_2 = Managers.state.network
			local var_10_3 = var_10_1:peers()

			for iter_10_0, iter_10_1 in pairs(var_10_3) do
				if PEER_ID_TO_CHANNEL[iter_10_1] then
					var_10_2.network_server:kick_peer(iter_10_1)
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
			if Managers.mechanism:get_state() ~= "inn" then
				return false, "Failed to set party size - Ongoing match"
			end

			arg_11_0 = tonumber(arg_11_0)
			arg_11_1 = tonumber(arg_11_1)

			assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

			local var_11_0, var_11_1 = Managers.mechanism:get_slot_reservation_handler(Network.peer_id(), var_0_0.session):set_party_size(arg_11_0, arg_11_1)

			if not var_11_0 then
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
			local var_13_0 = ""

			if Managers.level_transition_handler:in_hub_level() then
				assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

				local var_13_1 = Managers.mechanism:game_mechanism():get_slot_reservation_handler(Network.peer_id(), var_0_0.session):peers()

				for iter_13_0 = 1, #var_13_1 do
					local var_13_2 = var_13_1[iter_13_0]

					var_13_0 = string.format("%s%s - %s\n", var_13_0, var_13_2 or "-", Managers.game_server:peer_name(var_13_2) or "-")
				end

				return true, var_13_0
			end

			local var_13_3 = Managers.player:human_and_bot_players()

			for iter_13_1, iter_13_2 in pairs(var_13_3) do
				var_13_0 = string.format("%s%s - %s (%s)\n", var_13_0, iter_13_2.peer_id or "-", iter_13_2:name() or "-", iter_13_2:career_name() or "-")
			end

			return true, var_13_0
		end
	},
	list_party = {
		description = "List all players in a party",
		min_args = 1,
		example = "list_party <party_id>",
		max_args = 1,
		func = function (arg_14_0)
			arg_14_0 = tonumber(arg_14_0)

			if Managers.level_transition_handler:in_hub_level() then
				assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

				local var_14_0 = Managers.mechanism:game_mechanism():get_slot_reservation_handler(Network.peer_id(), var_0_0.session)._reserved_peers[arg_14_0]

				if not var_14_0 then
					return false, string.format("Failed to list party - Invalid party id %d", arg_14_0)
				end

				local var_14_1 = ""

				for iter_14_0 = 1, #var_14_0 do
					local var_14_2 = var_14_0[iter_14_0].peer_id

					if var_14_2 then
						var_14_1 = string.format("%s%s - %s\n", var_14_1, var_14_2, Managers.game_server:peer_name(var_14_2))
					end
				end

				return true, var_14_1
			end

			local var_14_3 = Managers.party:get_party(arg_14_0)

			if not var_14_3 then
				return false, string.format("Failed to list party - Invalid party id %d", arg_14_0)
			end

			local var_14_4 = ""
			local var_14_5 = var_14_3.occupied_slots

			for iter_14_1 = 1, #var_14_5 do
				local var_14_6 = var_14_5[iter_14_1]
				local var_14_7 = var_14_6.player

				var_14_4 = string.format("%s%s - %s (%s)\n", var_14_4, var_14_6.peer_id, var_14_7:name(), var_14_7:career_name())
			end

			return true, var_14_4
		end
	},
	list_script_data = {
		description = "List all script_data settings",
		min_args = 0,
		example = "list_script_data",
		max_args = 0,
		func = function ()
			return true, table.dump_string(script_data)
		end
	},
	set_script_data = {
		description = "Set a script_data setting",
		min_args = 2,
		example = "set_script_data <key> <value>",
		max_args = 2,
		func = function (arg_16_0, arg_16_1)
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
			if Managers.level_transition_handler:in_hub_level() then
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
			if Managers.level_transition_handler:in_hub_level() then
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
			if Managers.level_transition_handler:in_hub_level() then
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
			if Managers.level_transition_handler:in_hub_level() then
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
			if Managers.level_transition_handler:in_hub_level() then
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
			if Managers.level_transition_handler:in_hub_level() then
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
			if Managers.level_transition_handler:in_hub_level() then
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
			do return false, "Failed to skip to set - only avaiable in DEBUG" end

			if Managers.level_transition_handler:in_hub_level() then
				return false, "Failed to skip to set - Match not started"
			end

			local var_25_0 = Managers.mechanism:game_mechanism()

			arg_25_0 = tonumber(arg_25_0)

			if arg_25_0 <= var_25_0:get_current_set() then
				return false, "Failed to skip to set - Can't skip to current / previous set"
			end

			var_25_0:debug_skip_to_set(arg_25_0)

			return true, "Skipping to new set!"
		end
	},
	skip_picker = {
		description = "Skip the current picking player during character selection",
		min_args = 0,
		example = "skip_picker",
		max_args = 0,
		func = function ()
			do return false, "Failed to skip to set - only avaiable in DEBUG" end

			if not Managers.mechanism:game_mechanism() then
				return false, "No active mechanism"
			end

			local var_26_0 = Managers.state.game_mode and Managers.state.game_mode:game_mode()

			if not var_26_0 then
				return false, "No current game mode is active"
			end

			local var_26_1 = var_26_0:party_selection_logic()

			if not var_26_1 then
				return false, "Current game mode doesn't have a party selection"
			end

			var_26_1._timer = 0

			return true, "Skipping current picker"
		end
	},
	stop_selection_timer = {
		description = "Skip the current picking player during character selection",
		min_args = 0,
		example = "skip_picker",
		max_args = 0,
		func = function ()
			do return false, "Failed to skip to set - only avaiable in DEBUG" end

			if not Managers.mechanism:game_mechanism() then
				return false, "No active mechanism"
			end

			local var_27_0 = Managers.state.game_mode and Managers.state.game_mode:game_mode()

			if not var_27_0 then
				return false, "No current game mode is active"
			end

			local var_27_1 = var_27_0:party_selection_logic()

			if not var_27_1 then
				return false, "Current game mode doesn't have a party selection"
			end

			var_27_1._timer = 100000

			return true, "Stopping current picker"
		end
	},
	quick_start = {
		description = "Bypass mission select and round timers",
		min_args = 0,
		example = "quick_start",
		max_args = 0,
		func = function ()
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
			local var_29_0 = varargs.join(" ", ...)
			local var_29_1 = Managers.chat

			if var_29_1:has_channel(1) then
				var_29_1:send_system_chat_message(1, "rcon_server_command_say_header", var_29_0, false, true)
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
			fassert("Not implemented")
		end
	},
	say_player = {
		description = "Send a message to a player",
		min_args = 2,
		example = "say_player <peer_id> <message>",
		max_args = 1025,
		func = function ()
			fassert("Not implemented")
		end
	},
	swap_players = {
		description = "Swap party between two players",
		min_args = 2,
		example = "swap_players <peer_id> <peer_id>",
		max_args = 2,
		func = function (arg_32_0, arg_32_1)
			if Managers.mechanism:get_state() ~= "inn" then
				return false, "Failed to move players - Match started"
			end

			if arg_32_0 == arg_32_1 then
				return false, "Failed to move players - peer_id_1 is same as peer_id_2"
			end

			local var_32_0 = Managers.mechanism:game_mechanism()

			assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

			local var_32_1, var_32_2 = var_32_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.session):swap_players(arg_32_0, arg_32_1)

			if not var_32_1 then
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
			if Managers.mechanism:get_state() ~= "inn" then
				return false, "Failed to move player - Match started"
			end

			arg_33_1 = tonumber(arg_33_1)

			assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

			local var_33_0 = Managers.mechanism:get_slot_reservation_handler(Network.peer_id(), var_0_0.session)

			if var_33_0:is_fully_reserved() then
				return false, "Failed to move player - All parties are full"
			end

			local var_33_1 = true
			local var_33_2, var_33_3 = var_33_0:move_player(arg_33_0, arg_33_1, var_33_1)

			if not var_33_2 then
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
			if Managers.level_transition_handler:in_hub_level() then
				return false, "Failed to kill player - Match not started"
			end

			local var_34_0 = Managers.player:player(arg_34_0, 1)

			if not var_34_0 then
				return false, "Failed to kill player - Player not found"
			end

			local var_34_1 = var_34_0.player_unit

			if not var_34_1 or not Unit.alive(var_34_1) then
				return false, "Failed to kill player - Player unit not found"
			end

			if ScriptUnit.extension(var_34_1, "status_system"):is_dead() then
				return false, "Failed to kill player - Player already dead"
			end

			ScriptUnit.extension(var_34_1, "health_system"):die("forced")

			return true, "Player killed!"
		end
	},
	ban = {
		description = "Ban a player",
		min_args = 1,
		example = "ban <peer_id>/<ip>",
		max_args = 1,
		func = function (arg_35_0, arg_35_1)
			if Application.hex64_to_dec(arg_35_0) == nil then
				return false, "Invalid peer id"
			end

			arg_35_1 = tonumber(arg_35_1)

			local var_35_0

			if arg_35_1 ~= nil then
				var_35_0 = os.time() + arg_35_1 * 24 * 60 * 60
			end

			local var_35_1 = Managers.ban_list

			var_35_1:ban(arg_35_0, arg_35_0, var_35_0)
			var_35_1:save(function (arg_36_0)
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
			Managers.state.conflict:debug_spawn_horde()

			return true, "Spawning horde"
		end
	},
	trigger_playable_boss = {
		description = "lets pactsworn pick playable boss",
		min_args = 0,
		max_args = 0,
		func = function ()
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
		local var_42_0 = script_data.dedicated_server_reservation_slots
		local var_42_1 = string.split_deprecated(var_42_0, ",")
		local var_42_2
		local var_42_3 = 0

		for iter_42_0 = 1, #var_42_1 do
			var_42_3 = var_42_3 + tonumber(var_42_1[iter_42_0])
		end

		if Managers.level_transition_handler:in_hub_level() then
			assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

			var_42_2 = Managers.mechanism:game_mechanism():get_slot_reservation_handler(Network.peer_id(), var_0_0.session)._num_slots_reserved
		else
			var_42_2 = Managers.player:num_human_players()
		end

		return string.format("%d/%d", var_42_2, var_42_3)
	end,
	_ping = function ()
		return "pong"
	end
}
