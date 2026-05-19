-- chunkname: @scripts/managers/game_mode/mechanisms/versus_mechanism.lua

require("scripts/managers/irc/irc_manager")
require("scripts/managers/game_mode/mechanisms/versus_game_server_slot_reservation_handler")
require("scripts/managers/game_mode/mechanisms/player_hosted_slot_reservation_handler")
require("scripts/managers/game_mode/mechanisms/shared_state_versus")
require("scripts/managers/game_mode/mechanisms/game_mode_custom_settings_handler")

local var_0_0 = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

VersusMechanism = class(VersusMechanism)
VersusMechanism.name = "Versus"

local var_0_1 = {
	team = {
		message_target_key = "vs_msg_target_team",
		message_target = "Team",
		message_target_type = Irc.TEAM_MSG
	},
	all = {
		message_target_key = "vs_msg_target_all",
		message_target = "All",
		message_target_type = Irc.ALL_MSG
	}
}
local var_0_2 = {
	"rpc_versus_setup_match",
	"rpc_sync_vs_custom_game_slot_data",
	"rpc_move_slot_reservation_handler",
	"rpc_request_slot_reservation_sync"
}
local var_0_3 = 1
local var_0_4 = "VersusMechanism"
local var_0_5 = "carousel_hub"
local var_0_6 = DLCSettings.carousel

local function var_0_7(arg_1_0)
	local var_1_0 = arg_1_0.mission_id
	local var_1_1 = arg_1_0.preferred_level_keys
	local var_1_2 = arg_1_0.difficulty
	local var_1_3 = arg_1_0.quick_game
	local var_1_4 = arg_1_0.private_game
	local var_1_5 = arg_1_0.player_hosted
	local var_1_6 = arg_1_0.dedicated_servers_win
	local var_1_7 = arg_1_0.dedicated_servers_aws
	local var_1_8 = arg_1_0.join_method
	local var_1_9 = arg_1_0.matchmaking_type
	local var_1_10 = arg_1_0.mechanism

	print("............................................................................................................")
	print("............................................................................................................")
	printf("GAME START SETTINGS -> Mission: %s | Difficulty: %s | Find Player Hosted: %s | Find Dedicated Servers - WIN: %s | Find Dedicated Servers - AWS: %s | Quick Game: %s | Private Game: %s | Matchmaking Type: %s | Join Method: %s", var_1_0 and var_1_0 or "Not specified", var_1_2, var_1_5 and "yes" or "no", var_1_6 and "yes" or "no", var_1_7 and "yes" or "no", var_1_3 and "yes" or "no", var_1_4 and "yes" or "no", var_1_9 or "Not specified", var_1_8)
	print("............................................................................................................")
	print("............................................................................................................")
end

local var_0_8 = {
	default = function(arg_2_0)
		var_0_7(arg_2_0)

		local var_2_0 = {
			mission_id = arg_2_0.mission_id,
			preferred_level_keys = arg_2_0.preferred_level_keys,
			difficulty = arg_2_0.difficulty,
			quick_game = arg_2_0.quick_game,
			player_hosted = arg_2_0.player_hosted,
			use_dedicated_win_servers = arg_2_0.dedicated_servers_win,
			use_dedicated_aws_servers = arg_2_0.dedicated_servers_aws,
			join_method = arg_2_0.join_method,
			matchmaking_type = arg_2_0.matchmaking_type,
			mechanism = arg_2_0.mechanism,
			vote_type = arg_2_0.request_type
		}
		local var_2_1 = "carousel_settings_vote"

		Managers.state.voting:request_vote(var_2_1, var_2_0, Network.peer_id())
	end,
	versus_custom = function(arg_3_0)
		var_0_7(arg_3_0)

		local var_3_0 = {
			mission_id = arg_3_0.mission_id,
			any_level = arg_3_0.any_level,
			difficulty = arg_3_0.difficulty,
			private_game = arg_3_0.private_game,
			quick_game = arg_3_0.quick_game,
			player_hosted = arg_3_0.player_hosted,
			use_dedicated_win_servers = arg_3_0.dedicated_servers_win,
			use_dedicated_aws_servers = arg_3_0.dedicated_servers_aws,
			join_method = arg_3_0.join_method,
			matchmaking_type = arg_3_0.matchmaking_type,
			mechanism = arg_3_0.mechanism,
			vote_type = arg_3_0.request_type
		}
		local var_3_1 = "carousel_player_hosted_settings_vote"

		Managers.state.voting:request_vote(var_3_1, var_3_0, Network.peer_id())
	end
}

function VersusMechanism.init(arg_4_0, arg_4_1)
	arg_4_0._hero_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)

	fassert(PROFILES_BY_AFFILIATION.dark_pact, "You are missing dark-pact player profiles. See vs_profiles.lua")

	arg_4_0._dark_pact_profiles = table.clone(PROFILES_BY_AFFILIATION.dark_pact)
	arg_4_0._spectator_profiles = table.clone(PROFILES_BY_AFFILIATION.spectators)
	arg_4_0._message_targets_initiated = false
	arg_4_0._challenge_progression = {}
	arg_4_0._slot_reservation_handlers = {}

	arg_4_0:register_chats()
	arg_4_0:_reset(arg_4_1, true)

	if not DEDICATED_SERVER then
		arg_4_0._custom_game_settings_handler = GameModeCustomSettingsHandler:new("versus")
	end
end

function VersusMechanism.register_rpcs(arg_5_0, arg_5_1)
	arg_5_0:unregister_rpcs()

	arg_5_0._network_event_delegate = arg_5_1

	arg_5_1:register(arg_5_0, unpack(var_0_2))

	if arg_5_0._shared_state then
		arg_5_0._shared_state:register_rpcs(arg_5_0._network_event_delegate)
	end

	if not DEDICATED_SERVER then
		arg_5_0._custom_game_settings_handler:register_rpcs(arg_5_1)
	end
end

function VersusMechanism.unregister_rpcs(arg_6_0)
	if arg_6_0._network_event_delegate then
		if not DEDICATED_SERVER then
			arg_6_0._custom_game_settings_handler:unregister_rpcs(arg_6_0._network_event_delegate)
		end

		arg_6_0._network_event_delegate:unregister(arg_6_0)

		arg_6_0._network_event_delegate = nil
	end

	if arg_6_0._shared_state then
		arg_6_0._shared_state:unregister_rpcs()
	end
end

function VersusMechanism._reset(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0._settings = arg_7_1
	arg_7_0._level_override_key = nil
	arg_7_0._total_rounds_started = 0
	arg_7_0._profiles_reservable = false

	arg_7_0:_clear_horde_ability_data()

	local var_7_0 = arg_7_0._state ~= "inn"

	if arg_7_0._shared_state then
		arg_7_0._shared_state:destroy()

		arg_7_0._shared_state = nil
	end

	if var_7_0 then
		arg_7_0:set_current_state("inn")

		if not arg_7_2 then
			Managers.mechanism:reset_party_data(false)
		end

		if DEDICATED_SERVER and not Development.parameter("network_log_spew") and not Development.parameter("network_log_messages") and not Development.parameter("network_log_messages") then
			Network.log("info")
		end

		arg_7_0._local_match = false
		arg_7_0._private_lobby = true
		arg_7_0._using_dedicated_servers = true
		arg_7_0._using_dedicated_aws_servers = true
		arg_7_0._using_player_hosted = true
		arg_7_0._num_sets = 1
		arg_7_0._force_start_dedicated_server = false
		arg_7_0._join_signaling_timer = 0
		arg_7_0._queue_tickets = {}
	end

	if not arg_7_2 then
		if DEDICATED_SERVER and not Development.parameter("network_log_spew") and not Development.parameter("network_log_messages") and not Development.parameter("network_log_messages") then
			Network.log("warnings")
		end

		local var_7_1 = Managers.mechanism:network_server()

		if var_7_1 then
			for iter_7_0, iter_7_1 in ipairs(var_7_1:get_peers()) do
				Managers.party:assign_peer_to_party(iter_7_1, var_0_3)
			end
		end
	end

	if var_7_0 then
		arg_7_0._win_conditions = VersusWinConditions:new(arg_7_0)
	end

	arg_7_0._peer_backend_id = {}
end

function VersusMechanism.setup_mechanism_parties(arg_8_0, arg_8_1)
	arg_8_0:_create_party_info()
end

function VersusMechanism.make_profiles_reservable(arg_9_0)
	arg_9_0._profiles_reservable = true
end

function VersusMechanism.profiles_reservable(arg_10_0)
	return arg_10_0._profiles_reservable
end

function VersusMechanism.network_handler_set(arg_11_0, arg_11_1)
	arg_11_0._network_handler = arg_11_1

	if not arg_11_1 then
		return
	end

	local var_11_0 = arg_11_1.server_peer_id
	local var_11_1 = arg_11_1.my_peer_id

	for iter_11_0 in pairs(arg_11_0._slot_reservation_handlers) do
		if iter_11_0 ~= var_11_0 and iter_11_0 ~= var_11_1 then
			arg_11_0:destroy_slot_reservation_handler(iter_11_0)
		end
	end

	if not arg_11_0:get_slot_reservation_handler(var_11_0, var_0_0.session) then
		local var_11_2
		local var_11_3 = Managers.level_transition_handler:get_current_level_keys()
		local var_11_4 = var_11_3 and LevelSettings[var_11_3]

		if var_11_4 and var_11_4.hub_level and not DEDICATED_SERVER then
			var_11_2 = {
				heroes = MechanismSettings.versus.party_data.heroes
			}
		else
			var_11_2 = MechanismSettings.versus.party_data
		end

		arg_11_0:create_slot_reservation_handler(var_11_0, var_0_0.session, var_11_2)
	end
end

function VersusMechanism.network_context_created(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	if arg_12_0._shared_state then
		local var_12_0 = LevelSettings[Managers.level_transition_handler:get_current_level_key()]

		if arg_12_4 and not arg_12_0._shared_state:get_match_ended() and not var_12_0.hub_level then
			arg_12_0._shared_state:network_context_created(arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
		else
			arg_12_0._shared_state:destroy()

			arg_12_0._shared_state = nil
		end
	end

	local var_12_1 = arg_12_0:get_slot_reservation_handler(arg_12_3, var_0_0.session)

	if var_12_1 and var_12_1.network_context_created then
		var_12_1:network_context_created(arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	end

	arg_12_0._lobby = arg_12_1

	if arg_12_4 and arg_12_0._pending_set_lobby_max_members then
		arg_12_0:_update_lobby_max_members()
	else
		arg_12_0._pending_set_lobby_max_members = nil
	end
end

function VersusMechanism.network_context_destroyed(arg_13_0)
	arg_13_0:_reset(arg_13_0._settings)
end

function VersusMechanism.destroy(arg_14_0)
	local var_14_0 = arg_14_0._dark_pact_packages

	if var_14_0 then
		local var_14_1 = Managers.package

		for iter_14_0, iter_14_1 in pairs(var_14_0) do
			var_14_1:unload(iter_14_0, var_0_4)
		end
	end

	if not DEDICATED_SERVER then
		arg_14_0._custom_game_settings_handler:destroy()
	end

	for iter_14_2, iter_14_3 in pairs(arg_14_0._slot_reservation_handlers) do
		for iter_14_4, iter_14_5 in pairs(iter_14_3) do
			iter_14_5:destroy()
		end
	end

	arg_14_0._slot_reservation_handlers = nil

	arg_14_0:unregister_chats()
	arg_14_0:_unload_sound_bank()
end

function VersusMechanism._create_party_info(arg_15_0)
	arg_15_0._num_reserved_slots = 0
	arg_15_0._num_total_slots = 0
	arg_15_0._member_info_by_party = {}

	local var_15_0 = arg_15_0._member_info_by_party
	local var_15_1 = Managers.party:parties()

	for iter_15_0 = 1, #var_15_1 do
		local var_15_2 = var_15_1[iter_15_0].slots
		local var_15_3 = {}
		local var_15_4 = {}

		for iter_15_1 = 1, #var_15_2 do
			var_15_4[iter_15_1] = "?"
			var_15_3[iter_15_1] = "?"
		end

		var_15_0[iter_15_0] = {
			members = var_15_3,
			states = var_15_4
		}
	end
end

function VersusMechanism.reset_party_info(arg_16_0)
	local var_16_0 = arg_16_0._member_info_by_party

	for iter_16_0 = 1, #var_16_0 do
		local var_16_1 = var_16_0[iter_16_0]

		table.clear(var_16_1.members)
		table.clear(var_16_1.states)
	end
end

function VersusMechanism.max_instance_members(arg_17_0, arg_17_1)
	if not arg_17_1 then
		return DEDICATED_SERVER and Managers.mechanism:max_party_members() or Managers.party:max_party_members({
			heroes = MechanismSettings.versus.party_data.heroes
		})
	end

	local var_17_0 = arg_17_0._network_handler:get_match_handler():get_match_owner()

	if DEDICATED_SERVER then
		return arg_17_0:get_slot_reservation_handler(var_17_0, var_0_0.session):num_slots_total()
	elseif arg_17_0._local_match or arg_17_0._is_hosting_custom_game then
		return (arg_17_0:get_slot_reservation_handler(var_17_0, var_0_0.pending_custom_game) or arg_17_0:get_slot_reservation_handler(var_17_0, var_0_0.session)):num_slots_total()
	else
		return Managers.mechanism:max_party_members()
	end
end

function VersusMechanism.set_is_hosting_versus_custom_game(arg_18_0, arg_18_1)
	assert(arg_18_1 ~= arg_18_0._is_hosting_custom_game, "[VersusMechanism] Already hosting a versus custom game")

	arg_18_0._is_hosting_custom_game = arg_18_1

	local var_18_0 = Managers.mechanism
	local var_18_1 = Managers.state.game_mode
	local var_18_2 = var_18_1 and var_18_1:game_mode()
	local var_18_3
	local var_18_4 = Network.peer_id()

	if arg_18_1 then
		Managers.party:server_init_friend_parties(true)
		arg_18_0:create_slot_reservation_handler(var_18_4, var_0_0.pending_custom_game, MechanismSettings.versus.party_data)

		var_18_3 = "custom_game_lobby"
	else
		arg_18_0:set_custom_game_settings_handler_enabled(false)
		Managers.party:server_clear_friend_parties()

		if arg_18_0:get_slot_reservation_handler(var_18_4, var_0_0.pending_custom_game) then
			arg_18_0:destroy_slot_reservation_handler(var_18_4, var_0_0.pending_custom_game)
		else
			arg_18_0:destroy_slot_reservation_handler(var_18_4, var_0_0.session)

			local var_18_5 = {
				heroes = MechanismSettings.versus.party_data.heroes
			}

			arg_18_0:create_slot_reservation_handler(var_18_4, var_0_0.session, var_18_5)
		end

		var_18_3 = "party_lobby"
	end

	if var_18_0:is_server() and var_18_2 then
		var_18_2:change_game_mode_state(var_18_3)
	end
end

function VersusMechanism.can_join_custom_lobby(arg_19_0)
	local var_19_0 = Managers.state.game_mode

	return (var_19_0 and var_19_0:game_mode_key()) == "inn_vs"
end

function VersusMechanism.is_hosting_versus_custom_game(arg_20_0)
	return arg_20_0._is_hosting_custom_game
end

function VersusMechanism.sync_mechanism_data(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = PEER_ID_TO_CHANNEL[arg_21_1]

	if arg_21_0._local_match then
		RPC.rpc_carousel_set_local_match(var_21_0, arg_21_0._local_match)
	end

	if arg_21_0._private_lobby then
		RPC.rpc_carousel_set_private_lobby(var_21_0, arg_21_0._private_lobby)
	end

	RPC.rpc_dedicated_or_player_hosted_search(var_21_0, arg_21_0._using_dedicated_servers, arg_21_0._using_dedicated_aws_servers, arg_21_0._using_player_hosted)

	if arg_21_0._win_conditions then
		arg_21_0._win_conditions:hot_join_sync(arg_21_1)
	end

	if not arg_21_2 then
		return
	end

	if arg_21_0._shared_state then
		RPC.rpc_versus_setup_match(var_21_0)
	end
end

function VersusMechanism._load_sound_bank(arg_22_0)
	if not arg_22_0._sound_bank_loaded then
		local var_22_0 = "resource_packages/dlcs/ingame_sounds_carousel"

		print("Loading carousel mode sound bank resource package %s", var_22_0)
		Managers.package:load(var_22_0, "versus", nil, true)

		arg_22_0._sound_bank_loaded = true
	end
end

function VersusMechanism._unload_sound_bank(arg_23_0)
	if arg_23_0._sound_bank_loaded then
		local var_23_0 = "resource_packages/dlcs/ingame_sounds_carousel"

		print("Unloading carousel sound bank resource package %s", var_23_0)
		Managers.package:unload(var_23_0, "versus")

		arg_23_0._sound_bank_loaded = false
	end
end

function VersusMechanism._load_dark_pact_profiles(arg_24_0)
	local var_24_0 = {}

	local function var_24_1(arg_25_0, arg_25_1)
		for iter_25_0 = 1, #arg_25_1 do
			arg_25_0[arg_25_1[iter_25_0]] = true
		end
	end

	local var_24_2 = table.keys(table.filter(Cosmetics, function(arg_26_0)
		return arg_26_0.dark_pact
	end))

	for iter_24_0 = 1, #var_24_2 do
		local var_24_3 = var_24_2[iter_24_0]
		local var_24_4 = ItemMasterList[var_24_3]
		local var_24_5 = true
		local var_24_6 = CosmeticsUtils.retrieve_skin_packages(var_24_3, var_24_5)

		if var_24_6 then
			var_24_1(var_24_0, var_24_6)
		end

		local var_24_7 = CosmeticsUtils.retrieve_skin_packages(var_24_3, not var_24_5)

		if var_24_7 then
			var_24_1(var_24_0, var_24_7)
		end

		local var_24_8 = var_24_4.linked_weapon
		local var_24_9 = var_24_8 and ItemMasterList[var_24_8]

		if var_24_9 then
			local var_24_10 = var_24_9.temporary_template or var_24_9.template
			local var_24_11 = WeaponUtils.get_weapon_template(var_24_10)
			local var_24_12 = BackendUtils.get_item_units(var_24_9)
			local var_24_13 = var_24_9.can_wield[1]
			local var_24_14 = WeaponUtils.get_weapon_packages(var_24_11, var_24_12, var_24_5, var_24_13)

			if var_24_14 then
				var_24_1(var_24_0, var_24_14)
			end
		end
	end

	var_24_0["units/weapons/player/wpn_packmaster_claw_combo/wpn_packmaster_claw_combo"] = true
	var_24_0["units/weapons/player/wpn_packmaster_claw_combo/wpn_packmaster_claw_combo_3p"] = true

	local var_24_15 = Managers.package

	for iter_24_1, iter_24_2 in pairs(var_24_0) do
		local var_24_16
		local var_24_17 = true
		local var_24_18 = false

		var_24_15:load(iter_24_1, var_0_4, var_24_16, var_24_17, var_24_18)
	end

	arg_24_0._dark_pact_packages = var_24_0
end

function VersusMechanism.is_packages_loaded(arg_27_0)
	local var_27_0 = arg_27_0._dark_pact_packages

	if var_27_0 == nil then
		return false
	end

	local var_27_1 = Managers.package

	for iter_27_0, iter_27_1 in pairs(var_27_0) do
		if not var_27_1:has_loaded(iter_27_0, var_0_4) then
			return false
		end
	end

	return true
end

function VersusMechanism.load_packages(arg_28_0)
	arg_28_0:_load_sound_bank()

	if arg_28_0._dark_pact_packages then
		return
	end

	arg_28_0:_load_dark_pact_profiles()
end

function VersusMechanism.server_decide_side_order(arg_29_0)
	if not arg_29_0._settings.disadvantaged_team_starts then
		return
	end

	local var_29_0 = arg_29_0:get_current_set() == 0
	local var_29_1

	if var_29_0 then
		var_29_1 = math.random(1, 2)
	elseif arg_29_0._state == "round_2" then
		local var_29_2 = {}

		for iter_29_0 = 1, 2 do
			var_29_2[iter_29_0] = arg_29_0._win_conditions:get_total_score(iter_29_0)
		end

		if var_29_2[1] ~= var_29_2[2] then
			var_29_1 = table.max(var_29_2)
		else
			var_29_1 = math.random(1, 2)
		end
	elseif not var_29_0 then
		var_29_1 = Managers.party:get_party(1).name == "heroes" and 2 or 1
	end

	if arg_29_0:custom_settings_enabled() then
		local var_29_3 = arg_29_0:get_custom_game_setting("starting_as_heroes")

		if var_29_0 and var_29_3 ~= "random" then
			var_29_1 = var_29_3
		end
	end

	arg_29_0:set_side_order_state(var_29_1)
end

function VersusMechanism.set_side_order_state(arg_30_0, arg_30_1)
	arg_30_0._network_handler:set_side_order_state(arg_30_1)
end

function VersusMechanism._build_side_compositions(arg_31_0, arg_31_1)
	local var_31_0, var_31_1 = arg_31_0:_update_sides(arg_31_1)
	local var_31_2 = 3
	local var_31_3 = Managers.party

	return {
		{
			name = "heroes",
			show_damage_feedback = false,
			relations = {
				enemy = {
					"dark_pact"
				}
			},
			party = Managers.party:get_party(var_31_0),
			add_these_settings = {
				using_grims_and_tomes = true,
				show_damage_feedback = false,
				using_enemy_recycler = true,
				available_profiles = arg_31_0._hero_profiles
			}
		},
		{
			name = "dark_pact",
			relations = {
				enemy = {
					"heroes"
				}
			},
			party = Managers.party:get_party(var_31_1),
			add_these_settings = {
				using_grims_and_tomes = false,
				show_damage_feedback = true,
				available_profiles = arg_31_0._dark_pact_profiles
			}
		},
		{
			name = "spectators",
			relations = {
				neutral = {
					"heroes",
					"dark_pact"
				}
			},
			party = var_31_3:get_party(var_31_2),
			add_these_settings = {
				using_grims_and_tomes = false,
				show_damage_feedback = true,
				available_profiles = arg_31_0._spectator_profiles
			}
		},
		{
			name = "neutral",
			relations = {
				enemy = {}
			}
		}
	}
end

function VersusMechanism._update_sides(arg_32_0, arg_32_1)
	local var_32_0
	local var_32_1

	if arg_32_1 == "inn" then
		var_32_0 = 1
		var_32_1 = 2
	elseif arg_32_0._settings.disadvantaged_team_starts then
		local var_32_2 = arg_32_0._network_handler:get_side_order_state()

		if var_32_2 then
			var_32_0 = var_32_2
			var_32_1 = var_32_2 == 1 and 2 or 1
		else
			ferror("VersusMechanism:_update_sides - no side order state exists! Current state: %s", arg_32_1)
		end
	elseif arg_32_1 == "inn" then
		var_32_0 = 1
		var_32_1 = 2
	elseif arg_32_1 == "round_1" then
		var_32_0 = 1
		var_32_1 = 2
	elseif arg_32_1 == "round_2" then
		var_32_0 = 2
		var_32_1 = 1
	else
		ferror("Unknown state %s", arg_32_1)
	end

	arg_32_0._heroes_id = var_32_0
	arg_32_0._dark_pact_id = var_32_1

	arg_32_0:_set_party_side_data(var_32_0, "heroes")
	arg_32_0:_set_party_side_data(var_32_1, "dark_pact")

	return var_32_0, var_32_1
end

function VersusMechanism._set_party_side_data(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = Managers.party
	local var_33_1 = var_33_0:parties_by_name()
	local var_33_2 = var_33_0:get_party(arg_33_1)

	var_33_2.name = arg_33_2
	var_33_1[arg_33_2] = var_33_2
end

function VersusMechanism.progress_state(arg_34_0)
	local var_34_0 = arg_34_0._state

	if arg_34_0:match_ended_early() then
		if DEDICATED_SERVER then
			arg_34_0._force_start_dedicated_server = false
		end

		return arg_34_0._state
	end

	if var_34_0 == "inn" then
		arg_34_0:set_current_state("round_1")
	elseif var_34_0 == "round_1" then
		arg_34_0:set_current_state("round_2")
	elseif var_34_0 == "round_2" then
		if not arg_34_0:is_last_set() then
			arg_34_0:set_current_state("round_1")

			return arg_34_0._state
		end

		if DEDICATED_SERVER then
			arg_34_0._force_start_dedicated_server = false
		end
	else
		ferror("VersusMechanism: unknown state %s", var_34_0)
	end

	return arg_34_0._state
end

function VersusMechanism.debug_load_level(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = LevelSettings[arg_35_1]
	local var_35_1 = Managers.level_transition_handler

	var_35_1:set_next_level(arg_35_1, arg_35_2)
	var_35_1:promote_next_level_data()
	Managers.mechanism:progress_state()
end

function VersusMechanism.set_current_state(arg_36_0, arg_36_1)
	if DEDICATED_SERVER then
		cprintf("[Mechanism] State Changed from '%s' to '%s'", arg_36_0._state or "None", arg_36_1)
	end

	arg_36_0._state = arg_36_1
end

function VersusMechanism.generate_level_seed(arg_37_0)
	return Managers.mechanism:get_level_seed()
end

function VersusMechanism.get_end_of_level_rewards_arguments(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6)
	local var_38_0 = arg_38_3:get_stat(arg_38_4, "kills_total")

	return {
		kill_count = var_38_0
	}
end

function VersusMechanism.get_hub_level_key(arg_39_0)
	return var_0_5
end

function VersusMechanism.get_prior_state(arg_40_0)
	return nil
end

function VersusMechanism.is_final_round(arg_41_0)
	local var_41_0 = arg_41_0._win_conditions:is_final_round()

	return Development.parameter("versus_quick_match_end") or var_41_0 or arg_41_0._shared_state and arg_41_0._shared_state:get_party_won_early() or arg_41_0:match_ended_early()
end

function VersusMechanism.get_level_end_view(arg_42_0)
	return "LevelEndViewVersus"
end

local var_0_9 = {
	party_one_won = true,
	party_two_won_early = true,
	party_two_won = true,
	round_end = true,
	party_one_won_early = true,
	draw = true
}

function VersusMechanism.is_venture_over(arg_43_0)
	local var_43_0 = arg_43_0._game_round_ended_reason
	local var_43_1 = var_0_9[var_43_0]
	local var_43_2 = arg_43_0._state == "round_2" or var_43_0 == "party_one_won_early" or var_43_0 == "party_two_won_early"

	return var_43_1 and var_43_2
end

local var_0_10 = {
	party_one_won = true,
	party_two_won_early = true,
	party_one_won_early = true,
	party_two_won = true,
	draw = true
}

function VersusMechanism.game_round_ended(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	arg_44_0._game_round_ended_reason = arg_44_3
	arg_44_0._game_round_ended_reason_data = arg_44_4

	local var_44_0 = var_0_10[arg_44_3]
	local var_44_1 = arg_44_0._state
	local var_44_2
	local var_44_3
	local var_44_4

	arg_44_0._level_override_key = nil

	local var_44_5 = Managers.level_transition_handler

	if var_44_1 == "inn" then
		var_44_2 = var_44_5:get_next_level_key()
		var_44_4 = var_44_5:get_next_environment_variation_id()
	elseif var_44_0 and (arg_44_3 == "party_one_won_early" or true) then
		arg_44_0._shared_state:on_party_won_early()

		var_44_2 = var_0_5
		var_44_4 = LevelHelper:get_environment_variation_id(var_44_2)
		var_44_3 = Managers.mechanism:create_level_seed()

		arg_44_0._shared_state:on_match_ended()
	elseif var_44_1 == "round_1" then
		var_44_2 = var_44_5:get_current_level_key()
		var_44_4 = var_44_5:get_current_environment_variation_id()
	elseif var_44_1 == "round_2" then
		if not arg_44_0:is_last_set() then
			var_44_2 = var_44_5:get_current_level_key()
			var_44_4 = var_44_5:get_current_environment_variation_id()
		else
			var_44_2 = var_0_5
			var_44_4 = LevelHelper:get_environment_variation_id(var_44_2)
			var_44_3 = Managers.mechanism:create_level_seed()

			Managers.backend:get_interface("versus"):cancel_matchmaking()
		end
	else
		ferror("Bad state in mechanism versus: %s", tostring(var_44_1))
	end

	if arg_44_3 == "round_end" or arg_44_3 == "party_one_won" or arg_44_3 == "party_two_won" or arg_44_3 == "draw" or arg_44_3 == "party_one_won_early" or arg_44_3 == "party_two_won_early" then
		var_44_3 = var_44_3 or var_44_5:get_current_level_seed()

		var_44_5:set_next_level(var_44_2, var_44_4, var_44_3)
	elseif arg_44_3 == "start_game" then
		var_44_5:promote_next_level_data()
	elseif arg_44_3 == "reload" then
		local var_44_6 = Managers.state.network

		for iter_44_0, iter_44_1 in pairs(arg_44_0._slot_reservation_handlers) do
			local var_44_7 = iter_44_1:peers()

			for iter_44_2, iter_44_3 in pairs(var_44_7) do
				if PEER_ID_TO_CHANNEL[iter_44_3] then
					var_44_6.network_server:kick_peer(iter_44_3)
				end
			end
		end

		local var_44_8 = Managers.game_server

		if var_44_8 then
			local var_44_9 = Managers.matchmaking

			if var_44_9 and not var_44_9:on_dedicated_server() then
				var_44_8:set_leader_peer_id(nil)
			end

			var_44_8:restart()
		end
	else
		ferror("Unknown reason (%s)", arg_44_3)
	end
end

function VersusMechanism._get_next_game_mode_key(arg_45_0)
	local var_45_0
	local var_45_1 = arg_45_0._state

	if var_45_1 == "inn" then
		if LevelSettings[Managers.level_transition_handler:get_current_level_keys()].hub_level then
			var_45_0 = "inn_vs"
		else
			var_45_0 = "versus"
		end
	elseif var_45_1 == "round_1" then
		var_45_0 = "versus"
	elseif var_45_1 == "round_2" then
		var_45_0 = "versus"
	else
		ferror("Bad state in mechanism versus: %s", tostring(var_45_1))
	end

	return var_45_0
end

function VersusMechanism.start_next_round(arg_46_0)
	arg_46_0._game_round_ended_reason = nil
	arg_46_0._game_round_ended_reason_data = nil
	arg_46_0._join_signaling_timer = 0

	local var_46_0 = arg_46_0._state
	local var_46_1 = arg_46_0:_get_next_game_mode_key()
	local var_46_2

	if Managers.mechanism:is_server() then
		local var_46_3 = Managers.level_transition_handler:get_next_level_key()

		var_46_2 = not DEDICATED_SERVER and var_46_3 == var_0_5 or var_46_0 == "inn"
	end

	if var_46_2 then
		arg_46_0:_reset(arg_46_0._settings)
	end

	local var_46_4 = arg_46_0:_build_side_compositions(var_46_0)

	return var_46_1, var_46_4
end

function VersusMechanism.request_vote(arg_47_0, arg_47_1)
	local var_47_0 = var_0_8[arg_47_1.request_type] or var_0_8.default

	if var_47_0 then
		var_47_0(arg_47_1)
	end
end

function VersusMechanism.preferred_slot_id(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	if arg_48_1 == 0 then
		return nil
	end

	if arg_48_0._state == "inn" then
		return nil
	end

	local var_48_0 = Managers.party:get_party(arg_48_1)
	local var_48_1 = arg_48_0:update_wanted_hero_character(arg_48_2, arg_48_3, arg_48_1)
	local var_48_2
	local var_48_3 = Managers.mechanism:profile_synchronizer()

	if var_48_3 then
		for iter_48_0 = 1, var_48_0.num_slots do
			if not var_48_0.slots[iter_48_0].is_player and var_48_1 == var_48_3:get_bot_profile(arg_48_1, iter_48_0) then
				var_48_2 = iter_48_0

				break
			end
		end
	end

	if var_48_2 then
		printf("[VersusMechanism] Looked for party slot for peer %s:%s with profile %s, and found slot with matching bot data", arg_48_2, arg_48_3, var_48_1)

		return var_48_2
	end

	return nil
end

function VersusMechanism._get_fallback_hero_profile(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	local var_49_0 = arg_49_0:_find_available_hero_profiles(arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	local var_49_1 = var_49_0[math.random(1, #var_49_0)]
	local var_49_2 = PlayerUtils.get_random_enabled_non_dlc_career_index_by_profile(var_49_1)

	return var_49_1, var_49_2
end

local var_0_11 = {}

function VersusMechanism._find_available_hero_profiles(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	local var_50_0 = PROFILES_BY_AFFILIATION.heroes

	table.clear(var_0_11)

	for iter_50_0, iter_50_1 in ipairs(var_50_0) do
		local var_50_1 = PROFILES_BY_NAME[iter_50_1].index

		if Managers.mechanism:profile_available_for_peer(arg_50_1, arg_50_2, var_50_1) then
			var_0_11[#var_0_11 + 1] = var_50_1
		end
	end

	return var_0_11
end

function VersusMechanism.update_wanted_hero_character(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	local var_51_0 = Managers.party:get_player_status(arg_51_1, arg_51_2)
	local var_51_1, var_51_2 = Managers.mechanism:get_persistent_profile_index_reservation(arg_51_1)
	local var_51_3, var_51_4, var_51_5 = arg_51_0:parse_hero_profile_availability(var_51_1, arg_51_3, arg_51_1, arg_51_2)
	local var_51_6 = "saved"

	if var_51_1 ~= 0 and var_51_3 ~= var_51_1 then
		printf("[VersusMechanism] Saved profile %s no longer available: %s, %s", var_51_1, var_51_4, var_51_5)
	end

	if not var_51_3 then
		var_51_3, var_51_2 = Managers.mechanism:network_server():peer_wanted_profile(arg_51_1, arg_51_2)
		var_51_3 = arg_51_0:parse_hero_profile_availability(var_51_3, arg_51_3, arg_51_1, arg_51_2)
		var_51_6 = "wanted"
	end

	if not var_51_3 then
		var_51_3 = var_51_0.profile_index or var_51_0.preferred_profile_index
		var_51_2 = var_51_0.career_index or var_51_0.preferred_career_index
		var_51_3 = arg_51_0:parse_hero_profile_availability(var_51_3, arg_51_3, arg_51_1, arg_51_2)
		var_51_6 = "status_fallback"
	end

	if not var_51_3 and var_51_0.slot_id then
		local var_51_7 = Managers.mechanism:profile_synchronizer()

		if var_51_7 then
			var_51_3, var_51_2 = var_51_7:get_bot_profile(arg_51_3, var_51_0.slot_id)
		end

		if var_51_3 and var_51_2 and var_51_3 ~= 0 and var_51_2 ~= 0 and SPProfiles[var_51_3].careers[var_51_2].required_dlc then
			var_51_3, var_51_2 = nil
		end

		var_51_3 = arg_51_0:parse_hero_profile_availability(var_51_3, arg_51_3, arg_51_1, arg_51_2)
		var_51_6 = "bot_fallback"
	end

	if not var_51_3 then
		local var_51_8 = true

		var_51_3, var_51_2 = arg_51_0:_get_fallback_hero_profile(arg_51_3, arg_51_1, arg_51_2, var_51_8)
		var_51_6 = "available_fallback"
	end

	assert(var_51_3 and var_51_2, "[VersusMechanism] A profile could not be found in party")

	if var_51_6 ~= "saved" and arg_51_0._profiles_reservable then
		printf("[VersusMechanism] update profile, reason: %s, %d, %d ", var_51_6, var_51_3, var_51_2)

		if not Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(arg_51_1, var_51_3, var_51_2, true) then
			Crashify.print_exception("VersusMechanism", "updated hero character %s for peer %s in party %s, but the profile could not be reserved.", var_51_3, arg_51_1, arg_51_3)
		end
	end

	return var_51_3, var_51_2, var_51_6
end

function VersusMechanism.parse_hero_profile_availability(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
	if not arg_52_1 or arg_52_1 == 0 then
		return nil, "invalid_profile"
	end

	if SPProfiles[arg_52_1].affiliation ~= "heroes" then
		return nil, "not_a_hero"
	end

	if not Managers.mechanism:profile_available_for_peer(arg_52_2, arg_52_3, arg_52_1) then
		return nil, "profile_already_taken"
	end

	return arg_52_1
end

function VersusMechanism.uses_random_directors(arg_53_0)
	return true
end

function VersusMechanism.get_state(arg_54_0)
	return arg_54_0._state
end

function VersusMechanism.set_local_match(arg_55_0, arg_55_1)
	arg_55_0._local_match = arg_55_1

	local var_55_0 = Managers.mechanism

	if var_55_0:is_server() then
		var_55_0:send_rpc_clients("rpc_carousel_set_local_match", arg_55_1)
	end

	var_55_0:reset_party_data(false)
end

function VersusMechanism.set_private_lobby(arg_56_0, arg_56_1)
	arg_56_0._private_lobby = arg_56_1

	local var_56_0 = Managers.mechanism

	if var_56_0:is_server() then
		var_56_0:send_rpc_clients("rpc_carousel_set_private_lobby", arg_56_1)
	end
end

function VersusMechanism.set_dedicated_or_player_hosted_search(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	arg_57_0._using_dedicated_servers = arg_57_1
	arg_57_0._using_dedicated_aws_servers = arg_57_2
	arg_57_0._using_player_hosted = arg_57_3

	local var_57_0 = Managers.mechanism

	if var_57_0:is_server() then
		var_57_0:send_rpc_clients("rpc_dedicated_or_player_hosted_search", arg_57_1, arg_57_2, arg_57_3)
	end
end

function VersusMechanism.is_local_match(arg_58_0)
	return arg_58_0._local_match
end

function VersusMechanism.is_private_lobby(arg_59_0)
	return arg_59_0._private_lobby
end

function VersusMechanism.using_dedicated_servers(arg_60_0)
	return arg_60_0._using_dedicated_servers, arg_60_0._using_dedicated_aws_servers
end

function VersusMechanism.using_player_hosted(arg_61_0)
	return arg_61_0._using_player_hosted
end

local function var_0_12(arg_62_0)
	local var_62_0 = arg_62_0.server_peer_id

	return (Managers.player:player_from_peer_id(var_62_0))
end

function VersusMechanism.get_chat_channel(arg_63_0, arg_63_1, arg_63_2)
	if not arg_63_0._message_targets_initiated then
		return
	end

	if arg_63_2 then
		return 1, var_0_1.all.message_target
	end

	local var_63_0

	if arg_63_0._network_handler and var_0_12(arg_63_0._network_handler) then
		var_63_0 = arg_63_0:reserved_party_id_by_peer(arg_63_1)
	else
		local var_63_1
		local var_63_2

		var_63_2, var_63_0 = Managers.party:get_party_from_player_id(arg_63_1, 1)
	end

	if var_63_0 == 1 then
		return 2, var_0_1.team.message_target
	elseif var_63_0 == 2 then
		return 3, var_0_1.team.message_target
	else
		return 1, var_0_1.all.message_target
	end
end

local var_0_13 = {}

function VersusMechanism._get_chat_members(arg_64_0, arg_64_1)
	table.clear(var_0_13)

	local var_64_0 = arg_64_0._network_handler:get_match_handler()
	local var_64_1 = arg_64_0:get_slot_reservation_handler(var_64_0:get_match_owner(), var_0_0.pending_custom_game) or arg_64_0:get_slot_reservation_handler(var_64_0:get_match_owner(), var_0_0.session)

	if var_64_1 and arg_64_0._network_handler and var_0_12(arg_64_0._network_handler) then
		local var_64_2 = var_64_1:peers_by_party(arg_64_1)

		table.append(var_0_13, var_64_2)
	else
		local var_64_3 = Managers.party:get_party(arg_64_1).occupied_slots

		for iter_64_0 = 1, #var_64_3 do
			local var_64_4 = var_64_3[iter_64_0]

			if var_64_4.is_player then
				var_0_13[#var_0_13 + 1] = var_64_4.peer_id
			end
		end
	end

	return var_0_13
end

function VersusMechanism.register_chats(arg_65_0)
	if arg_65_0._message_targets_initiated or not Managers.chat then
		return
	end

	Managers.chat:register_channel(2, callback(arg_65_0, "_get_chat_members", 1))
	Managers.chat:register_channel(3, callback(arg_65_0, "_get_chat_members", 2))

	for iter_65_0, iter_65_1 in pairs(var_0_1) do
		Managers.chat:add_message_target(iter_65_1.message_target, iter_65_1.message_target_type, iter_65_1.message_target_key)
	end

	arg_65_0._message_targets_initiated = true
end

function VersusMechanism.unregister_chats(arg_66_0)
	if not arg_66_0._message_targets_initiated or not Managers.chat then
		return
	end

	Managers.chat:unregister_channel(2)
	Managers.chat:unregister_channel(3)

	for iter_66_0, iter_66_1 in pairs(var_0_1) do
		Managers.chat:remove_message_target(iter_66_1.message_target)
	end

	arg_66_0._message_targets_initiated = false
end

function VersusMechanism.try_reserve_game_server_slots(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

	local var_67_0 = arg_67_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.session):try_reserve_slots(arg_67_1, arg_67_2, arg_67_3)

	if not var_67_0 then
		print("[VersusMechanism] Rejected game server reservation because the server is full")
	elseif arg_67_0._state == "inn" then
		local var_67_1 = Managers.state.game_mode

		if not var_67_1 then
			print("[VersusMechanism] Rejected game server reservation because the server has not finished setting up.")

			return false
		end

		if DEDICATED_SERVER then
			local var_67_2 = var_67_1:game_mode()

			if var_67_2 and var_67_2.update_auto_force_start_conditions then
				var_67_2:update_auto_force_start_conditions(arg_67_2)
			end
		end
	end

	return var_67_0
end

function VersusMechanism.move_slot_reservation_handler(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	local var_68_0 = arg_68_0._slot_reservation_handlers[arg_68_1]

	if var_68_0[arg_68_3] then
		var_68_0[arg_68_3]:destroy()
	end

	var_68_0[arg_68_3] = var_68_0[arg_68_2]
	var_68_0[arg_68_2] = nil

	if arg_68_1 == Network.peer_id() then
		arg_68_0:_update_lobby_max_members()
	end

	var_68_0[arg_68_3]:set_reservation_handler_type(arg_68_3)

	local var_68_1 = NetworkLookup.reservation_handler_types[arg_68_2]
	local var_68_2 = NetworkLookup.reservation_handler_types[arg_68_3]

	arg_68_0._network_handler:get_match_handler():send_rpc_down("rpc_move_slot_reservation_handler", arg_68_1, var_68_1, var_68_2)
end

function VersusMechanism.create_slot_reservation_handler(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	local var_69_0 = arg_69_0._slot_reservation_handlers[arg_69_1] or {}

	arg_69_0._slot_reservation_handlers[arg_69_1] = var_69_0

	assert(not var_69_0[arg_69_2], "[VersusMechanism] Overriding existing slot reservation handler of peer %s and type %s", arg_69_1, arg_69_2)

	if DEDICATED_SERVER then
		arg_69_0._slot_reservation_handlers[arg_69_1][arg_69_2] = VersusGameServerSlotReservationHandler:new(arg_69_3, arg_69_1, arg_69_2)
	else
		arg_69_0._slot_reservation_handlers[arg_69_1][arg_69_2] = PlayerHostedSlotReservationHandler:new(arg_69_3, arg_69_1, arg_69_2)
	end

	if arg_69_1 == Network.peer_id() then
		arg_69_0:_update_lobby_max_members()
	end

	return arg_69_0._slot_reservation_handlers[arg_69_1][arg_69_2]
end

function VersusMechanism._update_lobby_max_members(arg_70_0)
	LobbySetup.update_network_options_max_members()

	local var_70_0 = arg_70_0._lobby

	if var_70_0 then
		if var_70_0.set_max_members then
			var_70_0:set_max_members(arg_70_0:max_instance_members(var_70_0))
		end
	else
		arg_70_0._pending_set_lobby_max_members = true
	end
end

function VersusMechanism.get_slot_reservation_handler(arg_71_0, arg_71_1, arg_71_2)
	local var_71_0 = arg_71_0._slot_reservation_handlers[arg_71_1]

	return var_71_0 and var_71_0[arg_71_2]
end

function VersusMechanism.get_all_reservation_handlers_by_owner(arg_72_0, arg_72_1)
	return arg_72_0._slot_reservation_handlers[arg_72_1]
end

function VersusMechanism.destroy_slot_reservation_handler(arg_73_0, arg_73_1, arg_73_2)
	local var_73_0 = arg_73_0._slot_reservation_handlers[arg_73_1]

	for iter_73_0, iter_73_1 in pairs(var_73_0) do
		if iter_73_0 == arg_73_2 or arg_73_2 == nil then
			iter_73_1:destroy()

			var_73_0[iter_73_0] = nil
		end
	end

	if arg_73_2 == nil then
		arg_73_0._slot_reservation_handlers[arg_73_1] = nil
	end
end

function VersusMechanism.num_dedicated_reserved_slots_changed(arg_74_0, arg_74_1, arg_74_2, arg_74_3)
	print("num_dedicated_reserved_slots_changed", arg_74_1, arg_74_2)

	arg_74_0._num_reserved_slots = arg_74_1
	arg_74_0._num_total_slots = arg_74_2
end

function VersusMechanism.reset_dedicated_slots_count(arg_75_0)
	arg_75_0._num_reserved_slots = 0
	arg_75_0._num_total_slots = 0

	local var_75_0 = arg_75_0._member_info_by_party

	for iter_75_0 = 1, #var_75_0 do
		local var_75_1 = var_75_0[iter_75_0]

		for iter_75_1 = 1, #var_75_1.members do
			var_75_1.states[iter_75_1] = "unreserved"
			var_75_1.members[iter_75_1] = ""
		end
	end

	arg_75_0._server_id = nil
end

function VersusMechanism.get_dedicated_slot_info(arg_76_0)
	return arg_76_0._num_reserved_slots, arg_76_0._num_total_slots, arg_76_0._member_info_by_party, arg_76_0._server_id
end

function VersusMechanism.rpc_sync_vs_custom_game_slot_data(arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4, arg_77_5, arg_77_6, arg_77_7)
	local var_77_0 = NetworkLookup.reservation_handler_types[arg_77_3]
	local var_77_1 = arg_77_0:get_slot_reservation_handler(arg_77_2, var_77_0) or arg_77_0:create_slot_reservation_handler(arg_77_2, var_77_0)

	printf("[VersusMechanism] 'rpc_sync_vs_custom_game_slot_data' received from peer %s", CHANNEL_TO_PEER_ID[arg_77_1])
	var_77_1:update_slots(arg_77_4, arg_77_5, arg_77_6, arg_77_7)
end

function VersusMechanism.rpc_move_slot_reservation_handler(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
	local var_78_0 = NetworkLookup.reservation_handler_types[arg_78_3]
	local var_78_1 = NetworkLookup.reservation_handler_types[arg_78_4]

	arg_78_0:move_slot_reservation_handler(arg_78_2, var_78_0, var_78_1)
end

function VersusMechanism.rpc_request_slot_reservation_sync(arg_79_0, arg_79_1)
	local var_79_0 = CHANNEL_TO_PEER_ID[arg_79_1]

	for iter_79_0, iter_79_1 in pairs(arg_79_0._slot_reservation_handlers) do
		for iter_79_2, iter_79_3 in pairs(iter_79_1) do
			if iter_79_3.slot_reservation_sync_requested then
				iter_79_3:slot_reservation_sync_requested(var_79_0)
			end
		end
	end
end

function VersusMechanism.dedicated_party_slot_status_changed(arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4)
	arg_80_0._server_id = arg_80_1

	local var_80_0 = arg_80_0._member_info_by_party[arg_80_2]

	if not var_80_0 then
		arg_80_0:_create_party_info()

		var_80_0 = arg_80_0._member_info_by_party[arg_80_2]
	end

	if not var_80_0 then
		return
	end

	local var_80_1 = var_80_0.members
	local var_80_2 = var_80_0.states

	for iter_80_0 = 1, #arg_80_3 do
		var_80_1[iter_80_0] = arg_80_3[iter_80_0]

		local var_80_3 = arg_80_4[iter_80_0]

		if var_80_3 == 1 then
			var_80_2[iter_80_0] = "unreserved"
		elseif var_80_3 == 2 then
			var_80_2[iter_80_0] = "client"
		elseif var_80_3 == 3 then
			var_80_2[iter_80_0] = "group_leader_client"
		end
	end
end

function VersusMechanism.game_server_slot_reservation_expired(arg_81_0, arg_81_1)
	local var_81_0 = true
	local var_81_1 = false

	arg_81_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.session):unreserve_slot(arg_81_1, var_81_1, var_81_0)
end

function VersusMechanism.force_start_dedicated_server(arg_82_0)
	if DEDICATED_SERVER then
		print("dedicated: got force start from a lobby host")

		arg_82_0._force_start_dedicated_server = true
	else
		local var_82_0 = Managers.mechanism:dedicated_server_peer_id()
		local var_82_1 = PEER_ID_TO_CHANNEL[var_82_0]

		if var_82_1 then
			print("Host sending request to dedicated server, to force start the game")
			RPC.rpc_force_start_dedicated_server(var_82_1)
		else
			print("Host trying to tell dedicated to force start server, but no dedicated peer id was found")
		end
	end
end

function VersusMechanism.switch_level_dedicated_server(arg_83_0, arg_83_1, arg_83_2)
	local var_83_0 = 0

	if arg_83_1 then
		var_83_0 = NetworkLookup.level_keys[arg_83_1]
	end

	arg_83_0._level_override_key = arg_83_1

	print("set level override key:", arg_83_1)

	if DEDICATED_SERVER then
		arg_83_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.session):send_rpc_to_all_reserving_clients("rpc_switch_level_dedicated_server", var_83_0)
	else
		local var_83_1 = Managers.mechanism:dedicated_server_peer_id()

		if var_83_1 and not arg_83_2 then
			local var_83_2 = PEER_ID_TO_CHANNEL[var_83_1]

			RPC.rpc_switch_level_dedicated_server(var_83_2, var_83_0)
		end
	end
end

function VersusMechanism.handle_ingame_enter(arg_84_0, arg_84_1)
	local var_84_0 = LevelSettings[Managers.level_transition_handler:get_current_level_key()]

	if not arg_84_0._shared_state and not var_84_0.hub_level and Managers.mechanism:is_server() then
		arg_84_0:_setup_match()
	end
end

function VersusMechanism.get_level_override_key(arg_85_0)
	return arg_85_0._level_override_key
end

function VersusMechanism.should_game_server_start_game(arg_86_0)
	if arg_86_0._force_start_dedicated_server then
		return true
	end

	assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

	return arg_86_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.session):is_fully_reserved()
end

function VersusMechanism.game_server_reservers(arg_87_0)
	assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

	return arg_87_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.session):reservers()
end

function VersusMechanism.is_all_reserved_peers_joined(arg_88_0, arg_88_1)
	assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

	return arg_88_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.session):is_all_reserved_peers_joined(arg_88_1)
end

function VersusMechanism.handle_party_assignment_for_joining_peer(arg_89_0, arg_89_1, arg_89_2)
	local var_89_0 = Managers.state.game_mode
	local var_89_1 = var_89_0 and var_89_0:game_mode()

	fassert(var_89_1, "No game mode exists")

	local var_89_2 = Managers.party
	local var_89_3 = Managers.mechanism:reserved_party_id_by_peer(arg_89_1)

	if not var_89_3 then
		Crashify.print_exception("[VersusMechanism]", "Peer %s has not been assigned to a party before entering the game.", arg_89_1)

		var_89_3 = Managers.mechanism:reserved_party_id_by_peer(arg_89_1)

		fassert(var_89_3, "[VersusMechanism] Peer %s could not be provided a party.", arg_89_1)
	end

	local var_89_4, var_89_5 = var_89_2:get_party_from_player_id(arg_89_1, arg_89_2)
	local var_89_6

	if var_89_5 == var_89_3 or not var_89_2:is_party_full(var_89_3) then
		var_89_6 = var_89_3
	else
		local var_89_7 = true
		local var_89_8 = true
		local var_89_9, var_89_10 = var_89_2:get_least_filled_party(var_89_7, var_89_8)

		Crashify.print_exception("[VersusMechanism]", "Joining peer %s was not able to join their reserved party %s. Attempting to join %s instead", arg_89_1)

		var_89_6 = var_89_10
	end

	return var_89_6
end

function VersusMechanism.should_run_tutorial(arg_90_0)
	return false, nil
end

function VersusMechanism.win_conditions(arg_91_0)
	return arg_91_0._win_conditions
end

function VersusMechanism.entered_mechanism_due_to_switch(arg_92_0)
	Managers.chat:set_chat_enabled(true)
end

function VersusMechanism.left_mechanism_due_to_switch(arg_93_0)
	Managers.chat:set_chat_enabled(false)
end

function VersusMechanism.should_play_level_introduction(arg_94_0)
	local var_94_0 = GameModeSettings.versus.show_level_introduction[arg_94_0._state]

	return var_94_0 ~= nil and var_94_0
end

function VersusMechanism.get_custom_lobby_sort(arg_95_0)
	return function(arg_96_0, arg_96_1)
		local var_96_0 = arg_96_0.server_info
		local var_96_1 = arg_96_1.server_info
		local var_96_2 = var_96_0.num_players
		local var_96_3 = var_96_1.num_players

		if var_96_2 == var_96_3 then
			local var_96_4 = var_96_0.ping
			local var_96_5 = var_96_1.ping

			if math.abs(var_96_4 - var_96_5) <= 40 then
				local var_96_6 = var_96_0.id or "ffffffffffffffff"
				local var_96_7 = var_96_1.id or "ffffffffffffffff"

				return PlayerUtils.peer_id_compare(var_96_6, var_96_7)
			end

			return var_96_4 < var_96_5
		end

		return var_96_3 < var_96_2
	end
end

function VersusMechanism.signal_reservers_to_join(arg_97_0, arg_97_1, arg_97_2)
	local var_97_0 = false

	assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler")

	local var_97_1 = arg_97_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.session)

	if arg_97_1 > arg_97_0._join_signaling_timer then
		local var_97_2 = arg_97_2.lobby_host:members():members_map()
		local var_97_3 = true
		local var_97_4 = arg_97_0:game_server_reservers()

		for iter_97_0 = 1, #var_97_4 do
			local var_97_5 = var_97_4[iter_97_0]

			if not var_97_2[var_97_5] then
				local var_97_6 = var_97_1:party_id(var_97_5)

				if var_97_6 and var_97_6 ~= 0 then
					local var_97_7 = PEER_ID_TO_CHANNEL[var_97_5]

					if var_97_7 then
						printf("Sending rpc_join_reserved_game_server to %s", var_97_5)
						RPC.rpc_join_reserved_game_server(var_97_7)
					end

					var_97_3 = false
				end
			end
		end

		var_97_0 = var_97_3
		arg_97_0._join_signaling_timer = arg_97_1 + 2
	end

	return var_97_0
end

function VersusMechanism.get_current_set(arg_98_0)
	return arg_98_0._win_conditions:get_current_set()
end

function VersusMechanism.get_current_spawn_group(arg_99_0)
	return arg_99_0:get_current_set()
end

function VersusMechanism.get_map_start_section(arg_100_0)
	return arg_100_0:get_current_set()
end

function VersusMechanism.is_last_set(arg_101_0)
	return arg_101_0:get_current_set() == arg_101_0._num_sets
end

function VersusMechanism.match_ended_early(arg_102_0)
	local var_102_0 = arg_102_0._game_round_ended_reason

	return var_102_0 == "party_one_won_early" or var_102_0 == "party_two_won_early", var_102_0
end

function VersusMechanism.get_game_round_ended_reason(arg_103_0)
	return arg_103_0._game_round_ended_reason, arg_103_0._game_round_ended_reason_data
end

function VersusMechanism.get_objective_settings(arg_104_0)
	local var_104_0 = Managers.level_transition_handler:get_current_level_key()

	return VersusObjectiveSettings[var_104_0] or {}
end

function VersusMechanism.should_start_next_set(arg_105_0)
	return not arg_105_0:is_last_set() or arg_105_0._win_conditions:get_current_round() % 2 == 1
end

function VersusMechanism.num_sets(arg_106_0)
	return arg_106_0._num_sets
end

function VersusMechanism.increment_total_rounds_started(arg_107_0)
	arg_107_0._total_rounds_started = arg_107_0._total_rounds_started + 1
end

function VersusMechanism.total_rounds_started(arg_108_0)
	return arg_108_0._total_rounds_started
end

function VersusMechanism.match_id(arg_109_0)
	return arg_109_0._shared_state:get_match_id()
end

function VersusMechanism.get_players_session_score(arg_110_0, arg_110_1, arg_110_2, arg_110_3)
	return ScoreboardHelper.get_versus_stats(arg_110_1, arg_110_3)
end

function VersusMechanism.sync_players_session_score(arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4)
	for iter_111_0, iter_111_1 in pairs(arg_111_1) do
		arg_111_2[#arg_111_2 + 1] = iter_111_1.peer_id
		arg_111_3[#arg_111_3 + 1] = iter_111_1.local_player_id

		local var_111_0 = iter_111_1.scores
		local var_111_1 = table.keys(var_111_0)

		table.sort(var_111_1)

		for iter_111_2 = 1, #var_111_1 do
			local var_111_2 = var_111_0[var_111_1[iter_111_2]]

			arg_111_4[#arg_111_4 + 1] = var_111_2
		end
	end
end

function VersusMechanism.extract_players_session_score(arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4, arg_112_5, arg_112_6)
	for iter_112_0, iter_112_1 in pairs(arg_112_5) do
		local var_112_0 = iter_112_1.peer_id
		local var_112_1 = iter_112_1.local_player_id

		for iter_112_2 = 1, arg_112_1 do
			if var_112_0 == arg_112_3[iter_112_2] and var_112_1 == arg_112_4[iter_112_2] then
				local var_112_2 = iter_112_1.scores
				local var_112_3 = table.keys(var_112_2)

				table.sort(var_112_3)

				local var_112_4 = (iter_112_2 - 1) * arg_112_2 + 1
				local var_112_5 = 1

				for iter_112_3 = var_112_4, var_112_4 + arg_112_2 - 1 do
					var_112_2[var_112_3[var_112_5]] = arg_112_6[iter_112_3]
					var_112_5 = var_112_5 + 1
				end

				break
			end
		end
	end
end

function VersusMechanism.get_starting_level()
	return var_0_5
end

function VersusMechanism.create_versus_migration_info(arg_114_0, arg_114_1, arg_114_2)
	local var_114_0 = Managers.level_transition_handler
	local var_114_1 = {
		friend_party = Managers.party:client_get_friend_party()
	}
	local var_114_2 = var_0_5
	local var_114_3 = Managers.level_transition_handler
	local var_114_4 = LevelHelper:get_environment_variation_id(var_114_2)
	local var_114_5 = Managers.mechanism:create_level_seed()
	local var_114_6 = var_114_3:get_current_difficulty()
	local var_114_7 = 0

	var_114_1.level_data = {
		level_key = var_114_2,
		environment_variation_id = var_114_4,
		level_seed = var_114_5,
		difficulty = var_114_6
	}

	local var_114_8 = "false"
	local var_114_9 = NetworkLookup.matchmaking_types["n/a"]

	var_114_1.lobby_data = {
		is_private = var_114_8,
		difficulty = var_114_6,
		selected_mission_id = var_114_2,
		mission_id = var_114_2,
		matchmaking_type = var_114_9
	}

	return var_114_1
end

function VersusMechanism.get_server_id(arg_115_0)
	return arg_115_0._server_id
end

function VersusMechanism.set_peer_backend_id(arg_116_0, arg_116_1, arg_116_2)
	arg_116_0._peer_backend_id[arg_116_1] = arg_116_2
end

function VersusMechanism.get_peer_backend_id(arg_117_0, arg_117_1)
	return arg_117_0._peer_backend_id[arg_117_1]
end

function VersusMechanism.load_end_screen_resources(arg_118_0)
	Managers.package:load("resource_packages/levels/dlcs/carousel/versus_dependencies", "end_screen_resource")
end

function VersusMechanism.unload_end_screen_resources(arg_119_0)
	if Managers.package:is_loading("resource_packages/levels/dlcs/carousel/versus_dependencies", "end_screen_resource") or Managers.package:has_loaded("resource_packages/levels/dlcs/carousel/versus_dependencies", "end_screen_resource") then
		Managers.package:unload("resource_packages/levels/dlcs/carousel/versus_dependencies", "end_screen_resource")
	end
end

function VersusMechanism._setup_match(arg_120_0)
	if arg_120_0._shared_state then
		arg_120_0._shared_state:destroy()
	end

	local var_120_0 = Network.peer_id()
	local var_120_1 = Managers.mechanism:dedicated_server_peer_id()
	local var_120_2 = Managers.mechanism:server_peer_id()
	local var_120_3

	if DEDICATED_SERVER then
		var_120_3 = true
	elseif PEER_ID_TO_CHANNEL[var_120_1] then
		var_120_3 = false
	else
		var_120_3 = var_120_0 == var_120_2
		var_120_1 = nil

		if var_120_3 then
			local var_120_4 = Managers.backend:player_id()

			arg_120_0._peer_backend_id[var_120_0] = var_120_4
		end
	end

	printf("[VersusMechanism] Setting up match. Dedicated server id: %s, server id: %s, own id: %s", var_120_1, var_120_2, var_120_0)

	arg_120_0._shared_state = SharedStateVersus:new(var_120_3, arg_120_0._network_handler, var_120_1 or var_120_2, var_120_0)

	arg_120_0._shared_state:register_rpcs(arg_120_0._network_event_delegate)

	if var_120_3 then
		arg_120_0._shared_state:generate_match_id()
	end

	arg_120_0._shared_state:full_sync()

	arg_120_0._num_sets = arg_120_0:get_objective_settings().num_sets or 1

	if var_120_3 then
		local var_120_5 = Managers.state.network.network_server
		local var_120_6 = var_120_5:get_peers()

		for iter_120_0 = 1, #var_120_6 do
			if var_120_5:get_peer_initialized_mechanism(var_120_6[iter_120_0]) == Managers.mechanism:current_mechanism_name() then
				RPC.rpc_versus_setup_match(PEER_ID_TO_CHANNEL[var_120_6[iter_120_0]])
			end
		end
	end
end

function VersusMechanism.rpc_versus_setup_match(arg_121_0)
	arg_121_0:_setup_match()
end

function VersusMechanism.is_peer_fully_synced(arg_122_0, arg_122_1)
	if arg_122_0._shared_state then
		return arg_122_0._shared_state:is_peer_fully_synced(arg_122_1)
	end

	return true
end

function VersusMechanism.set_hero_cosmetics(arg_123_0, arg_123_1, arg_123_2, arg_123_3, arg_123_4, arg_123_5, arg_123_6, arg_123_7, arg_123_8, arg_123_9, arg_123_10)
	arg_123_0._shared_state:set_hero_cosmetics(arg_123_1, arg_123_2, arg_123_3, arg_123_4, arg_123_5, arg_123_6, arg_123_7, arg_123_8, arg_123_9, arg_123_10)
end

function VersusMechanism.get_hero_cosmetics(arg_124_0, arg_124_1, arg_124_2)
	local var_124_0 = arg_124_0._shared_state:get_hero_cosmetics(arg_124_1, arg_124_2)
	local var_124_1 = var_124_0.weapon
	local var_124_2 = var_124_0.weapon_pose
	local var_124_3 = var_124_0.weapon_pose_skin
	local var_124_4 = var_124_0.hero_skin
	local var_124_5 = var_124_0.hat
	local var_124_6 = var_124_0.frame
	local var_124_7 = var_124_0.pactsworn_cosmetics

	return var_124_1, var_124_2, var_124_3, var_124_4, var_124_5, var_124_6, var_124_7
end

function VersusMechanism.player_joined_party(arg_125_0, arg_125_1, arg_125_2, arg_125_3, arg_125_4, arg_125_5)
	if Managers.mechanism:is_server() then
		local var_125_0 = arg_125_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.session)

		if var_125_0.player_joined_party then
			var_125_0:player_joined_party(arg_125_1, arg_125_2, arg_125_3, arg_125_4, arg_125_5)
		end
	end
end

function VersusMechanism.try_reserve_profile_for_peer_by_mechanism(arg_126_0, arg_126_1, arg_126_2, arg_126_3, arg_126_4, arg_126_5)
	if SPProfiles[arg_126_3].affiliation ~= "heroes" then
		return true
	end

	local var_126_0 = arg_126_0:reserved_party_id_by_peer(arg_126_2)

	if arg_126_0._state == "inn" then
		return arg_126_1:try_reserve_profile_for_peer(var_126_0, arg_126_2, arg_126_3, arg_126_4)
	end

	if not arg_126_0._profiles_reservable then
		return true
	end

	if not arg_126_5 then
		local var_126_1, var_126_2 = Managers.mechanism:get_persistent_profile_index_reservation(arg_126_2)

		if var_126_1 ~= 0 and var_126_1 ~= arg_126_3 then
			local var_126_3 = arg_126_1:get_profile_index_reservation(var_126_0, var_126_1)

			if not var_126_3 or var_126_3 == arg_126_2 then
				return arg_126_1:try_reserve_profile_for_peer(var_126_0, arg_126_2, var_126_1, var_126_2), var_126_1, var_126_2
			end
		end
	end

	return arg_126_1:try_reserve_profile_for_peer(var_126_0, arg_126_2, arg_126_3, arg_126_4)
end

function VersusMechanism.reserved_party_id_by_peer(arg_127_0, arg_127_1)
	local var_127_0 = arg_127_0._network_handler.server_peer_id

	return arg_127_0:get_slot_reservation_handler(var_127_0, var_0_0.session):party_id_by_peer(arg_127_1)
end

function VersusMechanism.remote_client_disconnected(arg_128_0, arg_128_1)
	for iter_128_0, iter_128_1 in pairs(arg_128_0._slot_reservation_handlers) do
		for iter_128_2, iter_128_3 in pairs(iter_128_1) do
			if iter_128_3.remote_client_disconnected then
				iter_128_3:remote_client_disconnected(arg_128_1)
			end
		end
	end
end

function VersusMechanism.store_challenge_progression_status(arg_129_0, arg_129_1, arg_129_2)
	arg_129_2 = arg_129_2 or "area_selection_carousel_name"

	local var_129_0 = arg_129_2 or "default"

	if arg_129_1 or not arg_129_0._challenge_progression[var_129_0] then
		arg_129_0._challenge_progression[var_129_0] = Managers.state.achievement:get_challenge_progression(arg_129_2)
	end
end

local var_0_14 = {}

function VersusMechanism.get_stored_challenge_progression_status(arg_130_0, arg_130_1)
	if arg_130_1 then
		return arg_130_0._challenge_progression[arg_130_1]
	end

	table.clear(var_0_14)

	for iter_130_0, iter_130_1 in pairs(arg_130_0._challenge_progression) do
		table.merge(var_0_14, iter_130_1)
	end

	return var_0_14
end

function VersusMechanism.clear_stored_challenge_progression_status(arg_131_0)
	table.clear(arg_131_0._challenge_progression)
end

function VersusMechanism.cache_horde_ability_charge_data(arg_132_0, arg_132_1)
	if not arg_132_0._horde_ability_charges then
		arg_132_0._horde_ability_charges = {}
	end

	for iter_132_0, iter_132_1 in pairs(arg_132_1) do
		if iter_132_1.ability_charge then
			arg_132_0._horde_ability_charges[iter_132_0] = iter_132_1.ability_charge
		end
	end
end

function VersusMechanism._clear_horde_ability_data(arg_133_0, arg_133_1)
	if arg_133_0._horde_ability_charges then
		table.clear(arg_133_0._horde_ability_charges)
	end
end

function VersusMechanism.get_cached_horde_ability_charges(arg_134_0, arg_134_1)
	if arg_134_0._horde_ability_charges and arg_134_0._horde_ability_charges[arg_134_1] then
		local var_134_0 = arg_134_0._horde_ability_charges[arg_134_1]

		arg_134_0._horde_ability_charges[arg_134_1] = nil

		return var_134_0
	end
end

function VersusMechanism.override_loading_screen_music(arg_135_0)
	local var_135_0
	local var_135_1 = var_0_6.music_overrides

	if arg_135_0._win_conditions:get_current_round() > 0 and var_0_6.music_overrides.versus_between_rounds then
		var_135_0 = var_135_1.versus_between_rounds
	else
		var_135_0 = var_135_1[Managers.level_transition_handler:get_current_level_key()]
	end

	return var_135_0
end

function VersusMechanism.on_enter_custom_game_lobby(arg_136_0)
	arg_136_0._custom_game_settings_handler:request_full_sync()
end

function VersusMechanism.set_custom_game_settings_handler_enabled(arg_137_0, arg_137_1)
	if arg_137_0._custom_game_settings_handler then
		arg_137_0._custom_game_settings_handler:set_enabled(arg_137_1)
	end
end

function VersusMechanism.get_custom_game_setting(arg_138_0, arg_138_1)
	local var_138_0 = false
	local var_138_1

	if arg_138_0._custom_game_settings_handler then
		var_138_1, var_138_0 = arg_138_0._custom_game_settings_handler:get_setting(arg_138_1)
	end

	return var_138_1, var_138_0
end

function VersusMechanism.get_custom_game_settings_handler(arg_139_0)
	return arg_139_0._custom_game_settings_handler
end

function VersusMechanism.custom_settings_enabled(arg_140_0)
	if arg_140_0._custom_game_settings_handler then
		return arg_140_0._custom_game_settings_handler:is_enabled()
	end

	return false
end
