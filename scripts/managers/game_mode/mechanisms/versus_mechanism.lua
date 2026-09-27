-- chunkname: @scripts/managers/game_mode/mechanisms/versus_mechanism.lua

require("scripts/managers/irc/irc_manager")
require("scripts/managers/game_mode/mechanisms/versus_game_server_slot_reservation_handler")
require("scripts/managers/game_mode/mechanisms/player_hosted_slot_reservation_handler")
require("scripts/managers/game_mode/mechanisms/shared_state_versus")
require("scripts/managers/game_mode/mechanisms/game_mode_custom_settings_handler")

local scripts_managers_game_mode_mechanisms_reservation_handler_types = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

VersusMechanism = class(VersusMechanism)
VersusMechanism.name = "Versus"

local tbl = {
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
local tbl_2 = {
	"rpc_versus_setup_match",
	"rpc_sync_vs_custom_game_slot_data",
	"rpc_move_slot_reservation_handler",
	"rpc_request_slot_reservation_sync"
}
local num = 1
local str = "VersusMechanism"
local str_2 = "carousel_hub"
local carousel = DLCSettings.carousel

local function fn(self)
	-- function 1
	local mission_id = self.mission_id
	local preferred_level_keys = self.preferred_level_keys
	local difficulty = self.difficulty
	local quick_game = self.quick_game
	local private_game = self.private_game
	local player_hosted = self.player_hosted
	local dedicated_servers_win = self.dedicated_servers_win
	local dedicated_servers_aws = self.dedicated_servers_aws
	local join_method = self.join_method
	local matchmaking_type = self.matchmaking_type
	local mechanism = self.mechanism

	print("............................................................................................................")
	print("............................................................................................................")

	local printf = printf
	local str = "GAME START SETTINGS -> Mission: %s | Difficulty: %s | Find Player Hosted: %s | Find Dedicated Servers - WIN: %s | Find Dedicated Servers - AWS: %s | Quick Game: %s | Private Game: %s | Matchmaking Type: %s | Join Method: %s"
	local flag = not mission_id and mission_id and "Not specified"
	local var_1_14 = difficulty
	local flag_2

	flag_2 = not player_hosted and "yes" and "no"

	local flag_3

	flag_3 = not dedicated_servers_win and "yes" and "no"

	local flag_4

	flag_4 = not dedicated_servers_aws and "yes" and "no"

	local flag_5

	flag_5 = not quick_game and "yes" and "no"

	local flag_6

	flag_6 = not private_game and "yes" and "no"

	printf(str, flag, var_1_14, flag_2, flag_3, flag_4, flag_5, flag_6, matchmaking_type or "Not specified", join_method)
	print("............................................................................................................")
	print("............................................................................................................")
end

local tbl_3 = {
	default = function (self)
		-- function 2
		fn(self)

		local tbl = {
			mission_id = self.mission_id,
			preferred_level_keys = self.preferred_level_keys,
			difficulty = self.difficulty,
			quick_game = self.quick_game,
			player_hosted = self.player_hosted,
			use_dedicated_win_servers = self.dedicated_servers_win,
			use_dedicated_aws_servers = self.dedicated_servers_aws,
			join_method = self.join_method,
			matchmaking_type = self.matchmaking_type,
			mechanism = self.mechanism,
			vote_type = self.request_type
		}
		local str = "carousel_settings_vote"

		Managers.state.voting:request_vote(str, tbl, Network.peer_id())
	end,
	versus_custom = function (self)
		-- function 3
		fn(self)

		local tbl = {
			mission_id = self.mission_id,
			any_level = self.any_level,
			difficulty = self.difficulty,
			private_game = self.private_game,
			quick_game = self.quick_game,
			player_hosted = self.player_hosted,
			use_dedicated_win_servers = self.dedicated_servers_win,
			use_dedicated_aws_servers = self.dedicated_servers_aws,
			join_method = self.join_method,
			matchmaking_type = self.matchmaking_type,
			mechanism = self.mechanism,
			vote_type = self.request_type
		}
		local str = "carousel_player_hosted_settings_vote"

		Managers.state.voting:request_vote(str, tbl, Network.peer_id())
	end
}

VersusMechanism.init = function (self, arg_4_1)
	-- function 4
	self._hero_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)

	fassert(PROFILES_BY_AFFILIATION.dark_pact, "You are missing dark-pact player profiles. See vs_profiles.lua")

	self._dark_pact_profiles = table.clone(PROFILES_BY_AFFILIATION.dark_pact)
	self._spectator_profiles = table.clone(PROFILES_BY_AFFILIATION.spectators)
	self._message_targets_initiated = false
	self._challenge_progression = {}
	self._slot_reservation_handlers = {}

	self:register_chats()
	self:_reset(arg_4_1, true)

	if not DEDICATED_SERVER then
		self._custom_game_settings_handler = GameModeCustomSettingsHandler:new("versus")
	end
end

VersusMechanism.register_rpcs = function (self, arg_5_1)
	-- function 5
	self:unregister_rpcs()

	self._network_event_delegate = arg_5_1

	arg_5_1:register(self, unpack(tbl_2))

	if not self._shared_state then
		self._shared_state:register_rpcs(self._network_event_delegate)
	end

	if not DEDICATED_SERVER then
		self._custom_game_settings_handler:register_rpcs(arg_5_1)
	end
end

VersusMechanism.unregister_rpcs = function (self)
	-- function 6
	if not self._network_event_delegate then
		if not DEDICATED_SERVER then
			self._custom_game_settings_handler:unregister_rpcs(self._network_event_delegate)
		end

		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
	end

	if not self._shared_state then
		self._shared_state:unregister_rpcs()
	end
end

VersusMechanism._reset = function (self, arg_7_1, arg_7_2)
	-- function 7
	self._settings = arg_7_1
	self._level_override_key = nil
	self._total_rounds_started = 0
	self._profiles_reservable = false

	self:_clear_horde_ability_data()

	local flag = self._state ~= "inn"

	if not self._shared_state then
		self._shared_state:destroy()

		self._shared_state = nil
	end

	if not flag then
		self:set_current_state("inn")

		if not arg_7_2 then
			Managers.mechanism:reset_party_data(false)
		end

		if not (not DEDICATED_SERVER and Development.parameter("network_log_spew") or Development.parameter("network_log_messages") or Development.parameter("network_log_messages")) then
			Network.log("info")
		end

		self._local_match = false
		self._private_lobby = true
		self._using_dedicated_servers = true
		self._using_dedicated_aws_servers = true
		self._using_player_hosted = true
		self._num_sets = 1
		self._force_start_dedicated_server = false
		self._join_signaling_timer = 0
		self._queue_tickets = {}
	end

	if not arg_7_2 then
		if not (not DEDICATED_SERVER and Development.parameter("network_log_spew") or Development.parameter("network_log_messages") or Development.parameter("network_log_messages")) then
			Network.log("warnings")
		end

		local network_server = Managers.mechanism:network_server()

		if not network_server then
			for i, v in ipairs(network_server:get_peers()) do
				Managers.party:assign_peer_to_party(v, num)
			end
		end
	end

	if not flag then
		self._win_conditions = VersusWinConditions:new(self)
	end

	self._peer_backend_id = {}
end

VersusMechanism.setup_mechanism_parties = function (self, arg_8_1)
	-- function 8
	self:_create_party_info()
end

VersusMechanism.make_profiles_reservable = function (self)
	-- function 9
	self._profiles_reservable = true
end

VersusMechanism.profiles_reservable = function (self)
	-- function 10
	return self._profiles_reservable
end

VersusMechanism.network_handler_set = function (self, arg_11_1)
	-- function 11
	self._network_handler = arg_11_1

	if not arg_11_1 then
		return
	end

	local server_peer_id = arg_11_1.server_peer_id
	local my_peer_id = arg_11_1.my_peer_id

	for k in pairs(self._slot_reservation_handlers) do
		if not (k == server_peer_id or k == my_peer_id) then
			self:destroy_slot_reservation_handler(k)
		end
	end

	if not self:get_slot_reservation_handler(server_peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.session) then
		local var_11_2
		local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
		local flag = not get_current_level_keys and LevelSettings[get_current_level_keys]

		if not (not flag and not flag.hub_level and DEDICATED_SERVER) then
			var_11_2 = {
				heroes = MechanismSettings.versus.party_data.heroes
			}
		else
			var_11_2 = MechanismSettings.versus.party_data
		end

		self:create_slot_reservation_handler(server_peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.session, var_11_2)
	end
end

VersusMechanism.network_context_created = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	if not self._shared_state then
		local var_12_0 = LevelSettings[Managers.level_transition_handler:get_current_level_key()]

		if not (not arg_12_4 and self._shared_state:get_match_ended() or var_12_0.hub_level) then
			self._shared_state:network_context_created(arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
		else
			self._shared_state:destroy()

			self._shared_state = nil
		end
	end

	local get_slot_reservation_handler = self:get_slot_reservation_handler(arg_12_3, scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

	if not get_slot_reservation_handler and not get_slot_reservation_handler.network_context_created then
		get_slot_reservation_handler:network_context_created(arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	end

	self._lobby = arg_12_1

	if not arg_12_4 and not self._pending_set_lobby_max_members then
		self:_update_lobby_max_members()
	else
		self._pending_set_lobby_max_members = nil
	end
end

VersusMechanism.network_context_destroyed = function (self)
	-- function 13
	self:_reset(self._settings)
end

VersusMechanism.destroy = function (self)
	-- function 14
	local _dark_pact_packages = self._dark_pact_packages

	if not _dark_pact_packages then
		local package = Managers.package

		for k, v in pairs(_dark_pact_packages) do
			package:unload(k, str)
		end
	end

	if not DEDICATED_SERVER then
		self._custom_game_settings_handler:destroy()
	end

	for k_2, v_2 in pairs(self._slot_reservation_handlers) do
		for k_3, v_3 in pairs(v_2) do
			v_3:destroy()
		end
	end

	self._slot_reservation_handlers = nil

	self:unregister_chats()
	self:_unload_sound_bank()
end

VersusMechanism._create_party_info = function (self)
	-- function 15
	self._num_reserved_slots = 0
	self._num_total_slots = 0
	self._member_info_by_party = {}

	local _member_info_by_party = self._member_info_by_party
	local parties = Managers.party:parties()

	for i = 1, #parties do
		local slots = parties[i].slots
		local tbl = {}
		local tbl_2 = {}

		for j = 1, #slots do
			tbl_2[j] = "?"
			tbl[j] = "?"
		end

		_member_info_by_party[i] = {
			members = tbl,
			states = tbl_2
		}
	end
end

VersusMechanism.reset_party_info = function (self)
	-- function 16
	local _member_info_by_party = self._member_info_by_party

	for i = 1, #_member_info_by_party do
		local var_16_1 = _member_info_by_party[i]

		table.clear(var_16_1.members)
		table.clear(var_16_1.states)
	end
end

VersusMechanism.max_instance_members = function (self, arg_17_1)
	-- function 17
	if not arg_17_1 then
		local max_party_members

		if not DEDICATED_SERVER then
			max_party_members = Managers.mechanism:max_party_members()

			if not max_party_members then
				-- Nothing
			end
		end

		max_party_members = Managers.party:max_party_members({
			heroes = MechanismSettings.versus.party_data.heroes
		})

		::label_17_0::

		return max_party_members
	end

	local get_match_owner = self._network_handler:get_match_handler():get_match_owner()

	if not DEDICATED_SERVER then
		return self:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.session):num_slots_total()
	elseif self._local_match or not self._is_hosting_custom_game then
		local get_slot_reservation_handler = self:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game)

		get_slot_reservation_handler = get_slot_reservation_handler or self:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

		return get_slot_reservation_handler:num_slots_total()
	else
		return Managers.mechanism:max_party_members()
	end
end

VersusMechanism.set_is_hosting_versus_custom_game = function (self, arg_18_1)
	-- function 18
	assert(arg_18_1 ~= self._is_hosting_custom_game, "[VersusMechanism] Already hosting a versus custom game")

	self._is_hosting_custom_game = arg_18_1

	local mechanism = Managers.mechanism
	local game_mode = Managers.state.game_mode
	local flag = not game_mode and game_mode:game_mode()
	local var_18_3
	local peer_id = Network.peer_id()

	if not arg_18_1 then
		Managers.party:server_init_friend_parties(true)
		self:create_slot_reservation_handler(peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game, MechanismSettings.versus.party_data)

		var_18_3 = "custom_game_lobby"
	else
		self:set_custom_game_settings_handler_enabled(false)
		Managers.party:server_clear_friend_parties()

		if not self:get_slot_reservation_handler(peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game) then
			self:destroy_slot_reservation_handler(peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game)
		else
			self:destroy_slot_reservation_handler(peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

			local tbl = {
				heroes = MechanismSettings.versus.party_data.heroes
			}

			self:create_slot_reservation_handler(peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.session, tbl)
		end

		var_18_3 = "party_lobby"
	end

	if not mechanism:is_server() and not flag then
		flag:change_game_mode_state(var_18_3)
	end
end

VersusMechanism.can_join_custom_lobby = function (arg_19_0)
	-- function 19
	local game_mode = Managers.state.game_mode

	return (not game_mode and game_mode:game_mode_key()) == "inn_vs"
end

VersusMechanism.is_hosting_versus_custom_game = function (self)
	-- function 20
	return self._is_hosting_custom_game
end

VersusMechanism.sync_mechanism_data = function (self, arg_21_1, arg_21_2)
	-- function 21
	local var_21_0 = PEER_ID_TO_CHANNEL[arg_21_1]

	if not self._local_match then
		RPC.rpc_carousel_set_local_match(var_21_0, self._local_match)
	end

	if not self._private_lobby then
		RPC.rpc_carousel_set_private_lobby(var_21_0, self._private_lobby)
	end

	RPC.rpc_dedicated_or_player_hosted_search(var_21_0, self._using_dedicated_servers, self._using_dedicated_aws_servers, self._using_player_hosted)

	if not self._win_conditions then
		self._win_conditions:hot_join_sync(arg_21_1)
	end

	if not arg_21_2 then
		return
	end

	if not self._shared_state then
		RPC.rpc_versus_setup_match(var_21_0)
	end
end

VersusMechanism._load_sound_bank = function (self)
	-- function 22
	if not self._sound_bank_loaded then
		local str = "resource_packages/dlcs/ingame_sounds_carousel"

		print("Loading carousel mode sound bank resource package %s", str)
		Managers.package:load(str, "versus", nil, true)

		self._sound_bank_loaded = true
	end
end

VersusMechanism._unload_sound_bank = function (self)
	-- function 23
	if not self._sound_bank_loaded then
		local str = "resource_packages/dlcs/ingame_sounds_carousel"

		print("Unloading carousel sound bank resource package %s", str)
		Managers.package:unload(str, "versus")

		self._sound_bank_loaded = false
	end
end

VersusMechanism._load_dark_pact_profiles = function (self)
	-- function 24
	local tbl = {}

	local function fn(self, arg_25_1)
		-- function 25
		for i = 1, #arg_25_1 do
			self[arg_25_1[i]] = true
		end
	end

	local keys = table.keys(table.filter(Cosmetics, function (self)
		-- function 26
		return self.dark_pact
	end))

	for i = 1, #keys do
		local var_24_3 = keys[i]
		local var_24_4 = ItemMasterList[var_24_3]
		local flag = true
		local retrieve_skin_packages = CosmeticsUtils.retrieve_skin_packages(var_24_3, flag)

		if not retrieve_skin_packages then
			fn(tbl, retrieve_skin_packages)
		end

		local retrieve_skin_packages_2 = CosmeticsUtils.retrieve_skin_packages(var_24_3, not flag)

		if not retrieve_skin_packages_2 then
			fn(tbl, retrieve_skin_packages_2)
		end

		local linked_weapon = var_24_4.linked_weapon
		local flag_2 = not linked_weapon and ItemMasterList[linked_weapon]

		if not flag_2 then
			local temporary_template = flag_2.temporary_template

			temporary_template = temporary_template or flag_2.template

			local get_weapon_template = WeaponUtils.get_weapon_template(temporary_template)
			local get_item_units = BackendUtils.get_item_units(flag_2)
			local var_24_13 = flag_2.can_wield[1]
			local get_weapon_packages = WeaponUtils.get_weapon_packages(get_weapon_template, get_item_units, flag, var_24_13)

			if not get_weapon_packages then
				fn(tbl, get_weapon_packages)
			end
		end
	end

	tbl["units/weapons/player/wpn_packmaster_claw_combo/wpn_packmaster_claw_combo"] = true
	tbl["units/weapons/player/wpn_packmaster_claw_combo/wpn_packmaster_claw_combo_3p"] = true

	local package = Managers.package

	for k, v in pairs(tbl) do
		local var_24_16
		local flag_3 = true
		local flag_4 = false

		package:load(k, str, var_24_16, flag_3, flag_4)
	end

	self._dark_pact_packages = tbl
end

VersusMechanism.is_packages_loaded = function (self)
	-- function 27
	local _dark_pact_packages = self._dark_pact_packages

	if _dark_pact_packages == nil then
		return false
	end

	local package = Managers.package

	for k, v in pairs(_dark_pact_packages) do
		if not package:has_loaded(k, str) then
			return false
		end
	end

	return true
end

VersusMechanism.load_packages = function (self)
	-- function 28
	self:_load_sound_bank()

	if not self._dark_pact_packages then
		return
	end

	self:_load_dark_pact_profiles()
end

VersusMechanism.server_decide_side_order = function (self)
	-- function 29
	if not self._settings.disadvantaged_team_starts then
		return
	end

	local flag = self:get_current_set() == 0
	local var_29_1

	if not flag then
		var_29_1 = math.random(1, 2)
	elseif self._state == "round_2" then
		local tbl = {}

		for i = 1, 2 do
			tbl[i] = self._win_conditions:get_total_score(i)
		end

		if tbl[1] ~= tbl[2] then
			var_29_1 = table.max(tbl)
		else
			var_29_1 = math.random(1, 2)
		end
	elseif not flag then
		var_29_1 = Managers.party:get_party(1).name ~= "heroes" or not 2 or 1
	end

	if not self:custom_settings_enabled() then
		local get_custom_game_setting = self:get_custom_game_setting("starting_as_heroes")

		if not (not flag and get_custom_game_setting == "random") then
			var_29_1 = get_custom_game_setting
		end
	end

	self:set_side_order_state(var_29_1)
end

VersusMechanism.set_side_order_state = function (self, arg_30_1)
	-- function 30
	self._network_handler:set_side_order_state(arg_30_1)
end

VersusMechanism._build_side_compositions = function (self, arg_31_1)
	-- function 31
	local _update_sides, var_31_1 = self:_update_sides(arg_31_1)
	local num = 3
	local party = Managers.party

	return {
		{
			name = "heroes",
			show_damage_feedback = false,
			relations = {
				enemy = {
					"dark_pact"
				}
			},
			party = Managers.party:get_party(_update_sides),
			add_these_settings = {
				using_grims_and_tomes = true,
				show_damage_feedback = false,
				using_enemy_recycler = true,
				available_profiles = self._hero_profiles
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
				available_profiles = self._dark_pact_profiles
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
			party = party:get_party(num),
			add_these_settings = {
				using_grims_and_tomes = false,
				show_damage_feedback = true,
				available_profiles = self._spectator_profiles
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

VersusMechanism._update_sides = function (self, arg_32_1)
	-- function 32
	local var_32_0
	local var_32_1

	if arg_32_1 == "inn" then
		var_32_0 = 1
		var_32_1 = 2
	elseif not self._settings.disadvantaged_team_starts then
		local get_side_order_state = self._network_handler:get_side_order_state()

		if not get_side_order_state then
			var_32_0 = get_side_order_state
			var_32_1 = get_side_order_state ~= 1 or not 2 or 1
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

	self._heroes_id = var_32_0
	self._dark_pact_id = var_32_1

	self:_set_party_side_data(var_32_0, "heroes")
	self:_set_party_side_data(var_32_1, "dark_pact")

	return var_32_0, var_32_1
end

VersusMechanism._set_party_side_data = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	local party = Managers.party
	local parties_by_name = party:parties_by_name()
	local get_party = party:get_party(arg_33_1)

	get_party.name = arg_33_2
	parties_by_name[arg_33_2] = get_party
end

VersusMechanism.progress_state = function (self)
	-- function 34
	local _state = self._state

	if not self:match_ended_early() then
		if not DEDICATED_SERVER then
			self._force_start_dedicated_server = false
		end

		return self._state
	end

	if _state == "inn" then
		self:set_current_state("round_1")
	elseif _state == "round_1" then
		self:set_current_state("round_2")
	elseif _state == "round_2" then
		if not self:is_last_set() then
			self:set_current_state("round_1")

			return self._state
		end

		if not DEDICATED_SERVER then
			self._force_start_dedicated_server = false
		end
	else
		ferror("VersusMechanism: unknown state %s", _state)
	end

	return self._state
end

VersusMechanism.debug_load_level = function (arg_35_0, arg_35_1, arg_35_2)
	-- function 35
	local var_35_0 = LevelSettings[arg_35_1]
	local level_transition_handler = Managers.level_transition_handler

	level_transition_handler:set_next_level(arg_35_1, arg_35_2)
	level_transition_handler:promote_next_level_data()
	Managers.mechanism:progress_state()
end

VersusMechanism.set_current_state = function (self, arg_36_1)
	-- function 36
	if not DEDICATED_SERVER then
		local cprintf = cprintf
		local str = "[Mechanism] State Changed from '%s' to '%s'"
		local _state = self._state

		_state = _state or "None"

		cprintf(str, _state, arg_36_1)
	end

	self._state = arg_36_1
end

VersusMechanism.generate_level_seed = function (arg_37_0)
	-- function 37
	return Managers.mechanism:get_level_seed()
end

VersusMechanism.get_end_of_level_rewards_arguments = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6)
	-- function 38
	local get_stat = arg_38_3:get_stat(arg_38_4, "kills_total")

	return {
		kill_count = get_stat
	}
end

VersusMechanism.get_hub_level_key = function (arg_39_0)
	-- function 39
	return str_2
end

VersusMechanism.get_prior_state = function (arg_40_0)
	-- function 40
	return nil
end

VersusMechanism.is_final_round = function (self)
	-- function 41
	local is_final_round = self._win_conditions:is_final_round()
	local parameter = Development.parameter("versus_quick_match_end")

	if not (parameter or is_final_round) then
		-- Nothing
	end

	::label_41_0::

	if not self._shared_state then
		parameter = self._shared_state:get_party_won_early()

		if not parameter then
			-- Nothing
		end
	end

	parameter = self:match_ended_early()

	::label_41_1::

	return parameter
end

VersusMechanism.get_level_end_view = function (arg_42_0)
	-- function 42
	return "LevelEndViewVersus"
end

local tbl_4 = {
	party_one_won = true,
	party_two_won_early = true,
	party_two_won = true,
	round_end = true,
	party_one_won_early = true,
	draw = true
}

VersusMechanism.is_venture_over = function (self)
	-- function 43
	local _game_round_ended_reason = self._game_round_ended_reason
	local var_43_1 = tbl_4[_game_round_ended_reason]
	local flag = self._state == "round_2" or _game_round_ended_reason == "party_one_won_early" or _game_round_ended_reason == "party_two_won_early"

	return not var_43_1 and flag
end

local tbl_5 = {
	party_one_won = true,
	party_two_won_early = true,
	party_one_won_early = true,
	party_two_won = true,
	draw = true
}

VersusMechanism.game_round_ended = function (self, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	-- function 44
	self._game_round_ended_reason = arg_44_3
	self._game_round_ended_reason_data = arg_44_4

	local var_44_0 = tbl_5[arg_44_3]
	local _state = self._state
	local var_44_2
	local var_44_3
	local var_44_4

	self._level_override_key = nil

	local level_transition_handler = Managers.level_transition_handler

	if _state == "inn" then
		var_44_2 = level_transition_handler:get_next_level_key()
		var_44_4 = level_transition_handler:get_next_environment_variation_id()
	elseif not var_44_0 and arg_44_3 == "party_one_won_early" then
		self._shared_state:on_party_won_early()

		var_44_2 = str_2
		var_44_4 = LevelHelper:get_environment_variation_id(var_44_2)
		var_44_3 = Managers.mechanism:create_level_seed()

		self._shared_state:on_match_ended()
	elseif _state == "round_1" then
		var_44_2 = level_transition_handler:get_current_level_key()
		var_44_4 = level_transition_handler:get_current_environment_variation_id()
	elseif _state == "round_2" then
		if not self:is_last_set() then
			var_44_2 = level_transition_handler:get_current_level_key()
			var_44_4 = level_transition_handler:get_current_environment_variation_id()
		else
			var_44_2 = str_2
			var_44_4 = LevelHelper:get_environment_variation_id(var_44_2)
			var_44_3 = Managers.mechanism:create_level_seed()

			Managers.backend:get_interface("versus"):cancel_matchmaking()
		end
	else
		ferror("Bad state in mechanism versus: %s", tostring(_state))
	end

	if not (arg_44_3 == "round_end" or arg_44_3 == "party_one_won" or arg_44_3 == "party_two_won" or arg_44_3 == "draw" or arg_44_3 == "party_one_won_early" or arg_44_3 ~= "party_two_won_early") then
		var_44_3 = var_44_3 or level_transition_handler:get_current_level_seed()

		level_transition_handler:set_next_level(var_44_2, var_44_4, var_44_3)
	elseif arg_44_3 == "start_game" then
		level_transition_handler:promote_next_level_data()
	elseif arg_44_3 == "reload" then
		local network = Managers.state.network

		for k, v in pairs(self._slot_reservation_handlers) do
			local peers = v:peers()

			for k_2, v_2 in pairs(peers) do
				if not PEER_ID_TO_CHANNEL[v_2] then
					network.network_server:kick_peer(v_2)
				end
			end
		end

		local game_server = Managers.game_server

		if not game_server then
			local matchmaking = Managers.matchmaking

			if not (not matchmaking and matchmaking:on_dedicated_server()) then
				game_server:set_leader_peer_id(nil)
			end

			game_server:restart()
		end
	else
		ferror("Unknown reason (%s)", arg_44_3)
	end
end

VersusMechanism._get_next_game_mode_key = function (self)
	-- function 45
	local var_45_0
	local _state = self._state

	if _state == "inn" then
		if not LevelSettings[Managers.level_transition_handler:get_current_level_keys()].hub_level then
			var_45_0 = "inn_vs"
		else
			var_45_0 = "versus"
		end
	elseif _state == "round_1" then
		var_45_0 = "versus"
	elseif _state == "round_2" then
		var_45_0 = "versus"
	else
		ferror("Bad state in mechanism versus: %s", tostring(_state))
	end

	return var_45_0
end

VersusMechanism.start_next_round = function (self)
	-- function 46
	self._game_round_ended_reason = nil
	self._game_round_ended_reason_data = nil
	self._join_signaling_timer = 0

	local _state = self._state
	local _get_next_game_mode_key = self:_get_next_game_mode_key()
	local var_46_2

	if not Managers.mechanism:is_server() then
		local get_next_level_key = Managers.level_transition_handler:get_next_level_key()

		var_46_2 = (DEDICATED_SERVER or get_next_level_key ~= str_2) and _state == "inn"
	end

	if not var_46_2 then
		self:_reset(self._settings)
	end

	local _build_side_compositions = self:_build_side_compositions(_state)

	return _get_next_game_mode_key, _build_side_compositions
end

VersusMechanism.request_vote = function (arg_47_0, arg_47_1)
	-- function 47
	local var_47_0 = tbl_3[arg_47_1.request_type]

	var_47_0 = var_47_0 or tbl_3.default

	if not var_47_0 then
		var_47_0(arg_47_1)
	end
end

VersusMechanism.preferred_slot_id = function (self, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	if arg_48_1 == 0 then
		return nil
	end

	if self._state == "inn" then
		return nil
	end

	local get_party = Managers.party:get_party(arg_48_1)
	local update_wanted_hero_character = self:update_wanted_hero_character(arg_48_2, arg_48_3, arg_48_1)
	local var_48_2
	local profile_synchronizer = Managers.mechanism:profile_synchronizer()

	if not profile_synchronizer then
		for i = 1, get_party.num_slots do
			if not (get_party.slots[i].is_player or update_wanted_hero_character ~= profile_synchronizer:get_bot_profile(arg_48_1, i)) then
				var_48_2 = i

				break
			end
		end
	end

	if not var_48_2 then
		printf("[VersusMechanism] Looked for party slot for peer %s:%s with profile %s, and found slot with matching bot data", arg_48_2, arg_48_3, update_wanted_hero_character)

		return var_48_2
	end

	return nil
end

VersusMechanism._get_fallback_hero_profile = function (self, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	-- function 49
	local _find_available_hero_profiles = self:_find_available_hero_profiles(arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	local var_49_1 = _find_available_hero_profiles[math.random(1, #_find_available_hero_profiles)]
	local get_random_enabled_non_dlc_career_index_by_profile = PlayerUtils.get_random_enabled_non_dlc_career_index_by_profile(var_49_1)

	return var_49_1, get_random_enabled_non_dlc_career_index_by_profile
end

local tbl_6 = {}

VersusMechanism._find_available_hero_profiles = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	-- function 50
	local heroes = PROFILES_BY_AFFILIATION.heroes

	table.clear(tbl_6)

	for i, v in ipairs(heroes) do
		local index = PROFILES_BY_NAME[v].index

		if not Managers.mechanism:profile_available_for_peer(arg_50_1, arg_50_2, index) then
			tbl_6[#tbl_6 + 1] = index
		end
	end

	return tbl_6
end

VersusMechanism.update_wanted_hero_character = function (self, arg_51_1, arg_51_2, arg_51_3)
	-- function 51
	local get_player_status = Managers.party:get_player_status(arg_51_1, arg_51_2)
	local get_persistent_profile_index_reservation, var_51_2 = Managers.mechanism:get_persistent_profile_index_reservation(arg_51_1)
	local parse_hero_profile_availability, var_51_4, var_51_5 = self:parse_hero_profile_availability(get_persistent_profile_index_reservation, arg_51_3, arg_51_1, arg_51_2)
	local str = "saved"

	if not (get_persistent_profile_index_reservation == 0 or parse_hero_profile_availability == get_persistent_profile_index_reservation) then
		printf("[VersusMechanism] Saved profile %s no longer available: %s, %s", get_persistent_profile_index_reservation, var_51_4, var_51_5)
	end

	if not parse_hero_profile_availability then
		parse_hero_profile_availability, var_51_2 = Managers.mechanism:network_server():peer_wanted_profile(arg_51_1, arg_51_2)
		parse_hero_profile_availability = self:parse_hero_profile_availability(parse_hero_profile_availability, arg_51_3, arg_51_1, arg_51_2)
		str = "wanted"
	end

	if not parse_hero_profile_availability then
		parse_hero_profile_availability = get_player_status.profile_index or get_player_status.preferred_profile_index
		var_51_2 = get_player_status.career_index or get_player_status.preferred_career_index
		parse_hero_profile_availability = self:parse_hero_profile_availability(parse_hero_profile_availability, arg_51_3, arg_51_1, arg_51_2)
		str = "status_fallback"
	end

	if parse_hero_profile_availability or not get_player_status.slot_id then
		local profile_synchronizer = Managers.mechanism:profile_synchronizer()

		if not profile_synchronizer then
			parse_hero_profile_availability, var_51_2 = profile_synchronizer:get_bot_profile(arg_51_3, get_player_status.slot_id)
		end

		if not parse_hero_profile_availability and not var_51_2 and parse_hero_profile_availability == 0 and var_51_2 == 0 or not SPProfiles[parse_hero_profile_availability].careers[var_51_2].required_dlc then
			parse_hero_profile_availability, var_51_2 = nil
		end

		parse_hero_profile_availability = self:parse_hero_profile_availability(parse_hero_profile_availability, arg_51_3, arg_51_1, arg_51_2)
		str = "bot_fallback"
	end

	if not parse_hero_profile_availability then
		local flag = true

		parse_hero_profile_availability, var_51_2 = self:_get_fallback_hero_profile(arg_51_3, arg_51_1, arg_51_2, flag)
		str = "available_fallback"
	end

	assert(not parse_hero_profile_availability and var_51_2, "[VersusMechanism] A profile could not be found in party")

	if str == "saved" or not self._profiles_reservable then
		printf("[VersusMechanism] update profile, reason: %s, %d, %d ", str, parse_hero_profile_availability, var_51_2)

		if not Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(arg_51_1, parse_hero_profile_availability, var_51_2, true) then
			Crashify.print_exception("VersusMechanism", "updated hero character %s for peer %s in party %s, but the profile could not be reserved.", parse_hero_profile_availability, arg_51_1, arg_51_3)
		end
	end

	return parse_hero_profile_availability, var_51_2, str
end

VersusMechanism.parse_hero_profile_availability = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
	-- function 52
	if not (not arg_52_1 and arg_52_1 ~= 0) then
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

VersusMechanism.uses_random_directors = function (arg_53_0)
	-- function 53
	return true
end

VersusMechanism.get_state = function (self)
	-- function 54
	return self._state
end

VersusMechanism.set_local_match = function (self, arg_55_1)
	-- function 55
	self._local_match = arg_55_1

	local mechanism = Managers.mechanism

	if not mechanism:is_server() then
		mechanism:send_rpc_clients("rpc_carousel_set_local_match", arg_55_1)
	end

	mechanism:reset_party_data(false)
end

VersusMechanism.set_private_lobby = function (self, arg_56_1)
	-- function 56
	self._private_lobby = arg_56_1

	local mechanism = Managers.mechanism

	if not mechanism:is_server() then
		mechanism:send_rpc_clients("rpc_carousel_set_private_lobby", arg_56_1)
	end
end

VersusMechanism.set_dedicated_or_player_hosted_search = function (self, arg_57_1, arg_57_2, arg_57_3)
	-- function 57
	self._using_dedicated_servers = arg_57_1
	self._using_dedicated_aws_servers = arg_57_2
	self._using_player_hosted = arg_57_3

	local mechanism = Managers.mechanism

	if not mechanism:is_server() then
		mechanism:send_rpc_clients("rpc_dedicated_or_player_hosted_search", arg_57_1, arg_57_2, arg_57_3)
	end
end

VersusMechanism.is_local_match = function (self)
	-- function 58
	return self._local_match
end

VersusMechanism.is_private_lobby = function (self)
	-- function 59
	return self._private_lobby
end

VersusMechanism.using_dedicated_servers = function (self)
	-- function 60
	return self._using_dedicated_servers, self._using_dedicated_aws_servers
end

VersusMechanism.using_player_hosted = function (self)
	-- function 61
	return self._using_player_hosted
end

local function fn_2(self)
	-- function 62
	local server_peer_id = self.server_peer_id

	return (Managers.player:player_from_peer_id(server_peer_id))
end

VersusMechanism.get_chat_channel = function (self, arg_63_1, arg_63_2)
	-- function 63
	if not self._message_targets_initiated then
		return
	end

	if not arg_63_2 then
		return 1, tbl.all.message_target
	end

	local var_63_0

	if not self._network_handler and not fn_2(self._network_handler) then
		var_63_0 = self:reserved_party_id_by_peer(arg_63_1)
	else
		local var_63_1
		local get_party_from_player_id

		get_party_from_player_id, var_63_0 = Managers.party:get_party_from_player_id(arg_63_1, 1)
	end

	if var_63_0 == 1 then
		return 2, tbl.team.message_target
	elseif var_63_0 == 2 then
		return 3, tbl.team.message_target
	else
		return 1, tbl.all.message_target
	end
end

local tbl_7 = {}

VersusMechanism._get_chat_members = function (self, arg_64_1)
	-- function 64
	table.clear(tbl_7)

	local get_match_handler = self._network_handler:get_match_handler()
	local get_slot_reservation_handler = self:get_slot_reservation_handler(get_match_handler:get_match_owner(), scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game)

	get_slot_reservation_handler = get_slot_reservation_handler or self:get_slot_reservation_handler(get_match_handler:get_match_owner(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

	if not get_slot_reservation_handler and not self._network_handler and not fn_2(self._network_handler) then
		local peers_by_party = get_slot_reservation_handler:peers_by_party(arg_64_1)

		table.append(tbl_7, peers_by_party)
	else
		local occupied_slots = Managers.party:get_party(arg_64_1).occupied_slots

		for i = 1, #occupied_slots do
			local var_64_4 = occupied_slots[i]

			if not var_64_4.is_player then
				tbl_7[#tbl_7 + 1] = var_64_4.peer_id
			end
		end
	end

	return tbl_7
end

VersusMechanism.register_chats = function (self)
	-- function 65
	if not (self._message_targets_initiated or Managers.chat) then
		return
	end

	Managers.chat:register_channel(2, callback(self, "_get_chat_members", 1))
	Managers.chat:register_channel(3, callback(self, "_get_chat_members", 2))

	for k, v in pairs(tbl) do
		Managers.chat:add_message_target(v.message_target, v.message_target_type, v.message_target_key)
	end

	self._message_targets_initiated = true
end

VersusMechanism.unregister_chats = function (self)
	-- function 66
	if not (not self._message_targets_initiated and Managers.chat) then
		return
	end

	Managers.chat:unregister_channel(2)
	Managers.chat:unregister_channel(3)

	for k, v in pairs(tbl) do
		Managers.chat:remove_message_target(v.message_target)
	end

	self._message_targets_initiated = false
end

VersusMechanism.try_reserve_game_server_slots = function (self, arg_67_1, arg_67_2, arg_67_3)
	-- function 67
	assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

	local try_reserve_slots = self:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session):try_reserve_slots(arg_67_1, arg_67_2, arg_67_3)

	if not try_reserve_slots then
		print("[VersusMechanism] Rejected game server reservation because the server is full")
	elseif self._state == "inn" then
		local game_mode = Managers.state.game_mode

		if not game_mode then
			print("[VersusMechanism] Rejected game server reservation because the server has not finished setting up.")

			return false
		end

		if not DEDICATED_SERVER then
			local game_mode_2 = game_mode:game_mode()

			if not game_mode_2 and not game_mode_2.update_auto_force_start_conditions then
				game_mode_2:update_auto_force_start_conditions(arg_67_2)
			end
		end
	end

	return try_reserve_slots
end

VersusMechanism.move_slot_reservation_handler = function (self, arg_68_1, arg_68_2, arg_68_3)
	-- function 68
	local var_68_0 = self._slot_reservation_handlers[arg_68_1]

	if not var_68_0[arg_68_3] then
		var_68_0[arg_68_3]:destroy()
	end

	var_68_0[arg_68_3] = var_68_0[arg_68_2]
	var_68_0[arg_68_2] = nil

	if arg_68_1 == Network.peer_id() then
		self:_update_lobby_max_members()
	end

	var_68_0[arg_68_3]:set_reservation_handler_type(arg_68_3)

	local var_68_1 = NetworkLookup.reservation_handler_types[arg_68_2]
	local var_68_2 = NetworkLookup.reservation_handler_types[arg_68_3]

	self._network_handler:get_match_handler():send_rpc_down("rpc_move_slot_reservation_handler", arg_68_1, var_68_1, var_68_2)
end

VersusMechanism.create_slot_reservation_handler = function (self, arg_69_1, arg_69_2, arg_69_3)
	-- function 69
	local var_69_0 = self._slot_reservation_handlers[arg_69_1]

	var_69_0 = var_69_0 or {}
	self._slot_reservation_handlers[arg_69_1] = var_69_0

	assert(not var_69_0[arg_69_2], "[VersusMechanism] Overriding existing slot reservation handler of peer %s and type %s", arg_69_1, arg_69_2)

	if not DEDICATED_SERVER then
		self._slot_reservation_handlers[arg_69_1][arg_69_2] = VersusGameServerSlotReservationHandler:new(arg_69_3, arg_69_1, arg_69_2)
	else
		self._slot_reservation_handlers[arg_69_1][arg_69_2] = PlayerHostedSlotReservationHandler:new(arg_69_3, arg_69_1, arg_69_2)
	end

	if arg_69_1 == Network.peer_id() then
		self:_update_lobby_max_members()
	end

	return self._slot_reservation_handlers[arg_69_1][arg_69_2]
end

VersusMechanism._update_lobby_max_members = function (self)
	-- function 70
	LobbySetup.update_network_options_max_members()

	local _lobby = self._lobby

	if not _lobby then
		if not _lobby.set_max_members then
			_lobby:set_max_members(self:max_instance_members(_lobby))
		end
	else
		self._pending_set_lobby_max_members = true
	end
end

VersusMechanism.get_slot_reservation_handler = function (self, arg_71_1, arg_71_2)
	-- function 71
	local var_71_0 = self._slot_reservation_handlers[arg_71_1]

	return not var_71_0 and var_71_0[arg_71_2]
end

VersusMechanism.get_all_reservation_handlers_by_owner = function (self, arg_72_1)
	-- function 72
	return self._slot_reservation_handlers[arg_72_1]
end

VersusMechanism.destroy_slot_reservation_handler = function (self, arg_73_1, arg_73_2)
	-- function 73
	local var_73_0 = self._slot_reservation_handlers[arg_73_1]

	for k, v in pairs(var_73_0) do
		if not (k == arg_73_2 or arg_73_2 ~= nil) then
			v:destroy()

			var_73_0[k] = nil
		end
	end

	if arg_73_2 == nil then
		self._slot_reservation_handlers[arg_73_1] = nil
	end
end

VersusMechanism.num_dedicated_reserved_slots_changed = function (self, arg_74_1, arg_74_2, arg_74_3)
	-- function 74
	print("num_dedicated_reserved_slots_changed", arg_74_1, arg_74_2)

	self._num_reserved_slots = arg_74_1
	self._num_total_slots = arg_74_2
end

VersusMechanism.reset_dedicated_slots_count = function (self)
	-- function 75
	self._num_reserved_slots = 0
	self._num_total_slots = 0

	local _member_info_by_party = self._member_info_by_party

	for i = 1, #_member_info_by_party do
		local var_75_1 = _member_info_by_party[i]

		for j = 1, #var_75_1.members do
			var_75_1.states[j] = "unreserved"
			var_75_1.members[j] = ""
		end
	end

	self._server_id = nil
end

VersusMechanism.get_dedicated_slot_info = function (self)
	-- function 76
	return self._num_reserved_slots, self._num_total_slots, self._member_info_by_party, self._server_id
end

VersusMechanism.rpc_sync_vs_custom_game_slot_data = function (self, arg_77_1, arg_77_2, arg_77_3, arg_77_4, arg_77_5, arg_77_6, arg_77_7)
	-- function 77
	local var_77_0 = NetworkLookup.reservation_handler_types[arg_77_3]
	local get_slot_reservation_handler = self:get_slot_reservation_handler(arg_77_2, var_77_0)

	get_slot_reservation_handler = get_slot_reservation_handler or self:create_slot_reservation_handler(arg_77_2, var_77_0)

	printf("[VersusMechanism] 'rpc_sync_vs_custom_game_slot_data' received from peer %s", CHANNEL_TO_PEER_ID[arg_77_1])
	get_slot_reservation_handler:update_slots(arg_77_4, arg_77_5, arg_77_6, arg_77_7)
end

VersusMechanism.rpc_move_slot_reservation_handler = function (self, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
	-- function 78
	local var_78_0 = NetworkLookup.reservation_handler_types[arg_78_3]
	local var_78_1 = NetworkLookup.reservation_handler_types[arg_78_4]

	self:move_slot_reservation_handler(arg_78_2, var_78_0, var_78_1)
end

VersusMechanism.rpc_request_slot_reservation_sync = function (self, arg_79_1)
	-- function 79
	local var_79_0 = CHANNEL_TO_PEER_ID[arg_79_1]

	for k, v in pairs(self._slot_reservation_handlers) do
		for k_2, v_2 in pairs(v) do
			if not v_2.slot_reservation_sync_requested then
				v_2:slot_reservation_sync_requested(var_79_0)
			end
		end
	end
end

VersusMechanism.dedicated_party_slot_status_changed = function (self, arg_80_1, arg_80_2, arg_80_3, arg_80_4)
	-- function 80
	self._server_id = arg_80_1

	local var_80_0 = self._member_info_by_party[arg_80_2]

	if not var_80_0 then
		self:_create_party_info()

		var_80_0 = self._member_info_by_party[arg_80_2]
	end

	if not var_80_0 then
		return
	end

	local members = var_80_0.members
	local states = var_80_0.states

	for i = 1, #arg_80_3 do
		members[i] = arg_80_3[i]

		local var_80_3 = arg_80_4[i]

		if var_80_3 == 1 then
			states[i] = "unreserved"
		elseif var_80_3 == 2 then
			states[i] = "client"
		elseif var_80_3 == 3 then
			states[i] = "group_leader_client"
		end
	end
end

VersusMechanism.game_server_slot_reservation_expired = function (self, arg_81_1)
	-- function 81
	local flag = true
	local flag_2 = false

	self:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session):unreserve_slot(arg_81_1, flag_2, flag)
end

VersusMechanism.force_start_dedicated_server = function (self)
	-- function 82
	if not DEDICATED_SERVER then
		print("dedicated: got force start from a lobby host")

		self._force_start_dedicated_server = true
	else
		local dedicated_server_peer_id = Managers.mechanism:dedicated_server_peer_id()
		local var_82_1 = PEER_ID_TO_CHANNEL[dedicated_server_peer_id]

		if not var_82_1 then
			print("Host sending request to dedicated server, to force start the game")
			RPC.rpc_force_start_dedicated_server(var_82_1)
		else
			print("Host trying to tell dedicated to force start server, but no dedicated peer id was found")
		end
	end
end

VersusMechanism.switch_level_dedicated_server = function (self, arg_83_1, arg_83_2)
	-- function 83
	local num = 0

	if not arg_83_1 then
		num = NetworkLookup.level_keys[arg_83_1]
	end

	self._level_override_key = arg_83_1

	print("set level override key:", arg_83_1)

	if not DEDICATED_SERVER then
		self:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session):send_rpc_to_all_reserving_clients("rpc_switch_level_dedicated_server", num)
	else
		local dedicated_server_peer_id = Managers.mechanism:dedicated_server_peer_id()

		if not (not dedicated_server_peer_id and arg_83_2) then
			local var_83_2 = PEER_ID_TO_CHANNEL[dedicated_server_peer_id]

			RPC.rpc_switch_level_dedicated_server(var_83_2, num)
		end
	end
end

VersusMechanism.handle_ingame_enter = function (self, arg_84_1)
	-- function 84
	local var_84_0 = LevelSettings[Managers.level_transition_handler:get_current_level_key()]

	if self._shared_state or var_84_0.hub_level or not Managers.mechanism:is_server() then
		self:_setup_match()
	end
end

VersusMechanism.get_level_override_key = function (self)
	-- function 85
	return self._level_override_key
end

VersusMechanism.should_game_server_start_game = function (self)
	-- function 86
	if not self._force_start_dedicated_server then
		return true
	end

	assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

	return self:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session):is_fully_reserved()
end

VersusMechanism.game_server_reservers = function (self)
	-- function 87
	assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

	return self:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session):reservers()
end

VersusMechanism.is_all_reserved_peers_joined = function (self, arg_88_1)
	-- function 88
	assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

	return self:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session):is_all_reserved_peers_joined(arg_88_1)
end

VersusMechanism.handle_party_assignment_for_joining_peer = function (arg_89_0, arg_89_1, arg_89_2)
	-- function 89
	local game_mode = Managers.state.game_mode
	local flag = not game_mode and game_mode:game_mode()

	fassert(flag, "No game mode exists")

	local party = Managers.party
	local reserved_party_id_by_peer = Managers.mechanism:reserved_party_id_by_peer(arg_89_1)

	if not reserved_party_id_by_peer then
		Crashify.print_exception("[VersusMechanism]", "Peer %s has not been assigned to a party before entering the game.", arg_89_1)

		reserved_party_id_by_peer = Managers.mechanism:reserved_party_id_by_peer(arg_89_1)

		fassert(reserved_party_id_by_peer, "[VersusMechanism] Peer %s could not be provided a party.", arg_89_1)
	end

	local get_party_from_player_id, var_89_5 = party:get_party_from_player_id(arg_89_1, arg_89_2)
	local var_89_6

	if not (var_89_5 == reserved_party_id_by_peer or party:is_party_full(reserved_party_id_by_peer)) then
		var_89_6 = reserved_party_id_by_peer
	else
		local flag_2 = true
		local flag_3 = true
		local get_least_filled_party, var_89_10 = party:get_least_filled_party(flag_2, flag_3)

		Crashify.print_exception("[VersusMechanism]", "Joining peer %s was not able to join their reserved party %s. Attempting to join %s instead", arg_89_1)

		var_89_6 = var_89_10
	end

	return var_89_6
end

VersusMechanism.should_run_tutorial = function (arg_90_0)
	-- function 90
	return false, nil
end

VersusMechanism.win_conditions = function (self)
	-- function 91
	return self._win_conditions
end

VersusMechanism.entered_mechanism_due_to_switch = function (arg_92_0)
	-- function 92
	Managers.chat:set_chat_enabled(true)
end

VersusMechanism.left_mechanism_due_to_switch = function (arg_93_0)
	-- function 93
	Managers.chat:set_chat_enabled(false)
end

VersusMechanism.should_play_level_introduction = function (self)
	-- function 94
	local var_94_0 = GameModeSettings.versus.show_level_introduction[self._state]

	return var_94_0 == nil or var_94_0
end

VersusMechanism.get_custom_lobby_sort = function (arg_95_0)
	-- function 95
	return function (self, arg_96_1)
		-- function 96
		local server_info = self.server_info
		local server_info_2 = arg_96_1.server_info
		local num_players = server_info.num_players
		local num_players_2 = server_info_2.num_players

		if num_players == num_players_2 then
			local ping = server_info.ping
			local ping_2 = server_info_2.ping

			if math.abs(ping - ping_2) <= 40 then
				local id = server_info.id

				id = id or "ffffffffffffffff"

				local id_2 = server_info_2.id

				id_2 = id_2 or "ffffffffffffffff"

				return PlayerUtils.peer_id_compare(id, id_2)
			end

			return ping < ping_2
		end

		return num_players_2 < num_players
	end
end

VersusMechanism.signal_reservers_to_join = function (self, arg_97_1, arg_97_2)
	-- function 97
	local flag = false

	assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler")

	local get_slot_reservation_handler = self:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

	if arg_97_1 > self._join_signaling_timer then
		local members_map = arg_97_2.lobby_host:members():members_map()
		local flag_2 = true
		local game_server_reservers = self:game_server_reservers()

		for i = 1, #game_server_reservers do
			local var_97_5 = game_server_reservers[i]

			if not members_map[var_97_5] then
				local party_id = get_slot_reservation_handler:party_id(var_97_5)

				if not (not party_id and party_id == 0) then
					local var_97_7 = PEER_ID_TO_CHANNEL[var_97_5]

					if not var_97_7 then
						printf("Sending rpc_join_reserved_game_server to %s", var_97_5)
						RPC.rpc_join_reserved_game_server(var_97_7)
					end

					flag_2 = false
				end
			end
		end

		flag = flag_2
		self._join_signaling_timer = arg_97_1 + 2
	end

	return flag
end

VersusMechanism.get_current_set = function (self)
	-- function 98
	return self._win_conditions:get_current_set()
end

VersusMechanism.get_current_spawn_group = function (self)
	-- function 99
	return self:get_current_set()
end

VersusMechanism.get_map_start_section = function (self)
	-- function 100
	return self:get_current_set()
end

VersusMechanism.is_last_set = function (self)
	-- function 101
	return self:get_current_set() == self._num_sets
end

VersusMechanism.match_ended_early = function (self)
	-- function 102
	local _game_round_ended_reason = self._game_round_ended_reason

	return _game_round_ended_reason == "party_one_won_early" or _game_round_ended_reason == "party_two_won_early", _game_round_ended_reason
end

VersusMechanism.get_game_round_ended_reason = function (self)
	-- function 103
	return self._game_round_ended_reason, self._game_round_ended_reason_data
end

VersusMechanism.get_objective_settings = function (arg_104_0)
	-- function 104
	local get_current_level_key = Managers.level_transition_handler:get_current_level_key()
	local var_104_1 = VersusObjectiveSettings[get_current_level_key]

	var_104_1 = var_104_1 or {}

	return var_104_1
end

VersusMechanism.should_start_next_set = function (self)
	-- function 105
	return not self:is_last_set() and self._win_conditions:get_current_round() % 2 == 1
end

VersusMechanism.num_sets = function (self)
	-- function 106
	return self._num_sets
end

VersusMechanism.increment_total_rounds_started = function (self)
	-- function 107
	self._total_rounds_started = self._total_rounds_started + 1
end

VersusMechanism.total_rounds_started = function (self)
	-- function 108
	return self._total_rounds_started
end

VersusMechanism.match_id = function (self)
	-- function 109
	return self._shared_state:get_match_id()
end

VersusMechanism.get_players_session_score = function (arg_110_0, arg_110_1, arg_110_2, arg_110_3)
	-- function 110
	return ScoreboardHelper.get_versus_stats(arg_110_1, arg_110_3)
end

VersusMechanism.sync_players_session_score = function (arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4)
	-- function 111
	for k, v in pairs(arg_111_1) do
		arg_111_2[#arg_111_2 + 1] = v.peer_id
		arg_111_3[#arg_111_3 + 1] = v.local_player_id

		local scores = v.scores
		local keys = table.keys(scores)

		table.sort(keys)

		for k_2 = 1, #keys do
			local var_111_2 = scores[keys[k_2]]

			arg_111_4[#arg_111_4 + 1] = var_111_2
		end
	end
end

VersusMechanism.extract_players_session_score = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4, arg_112_5, arg_112_6)
	-- function 112
	for k, v in pairs(arg_112_5) do
		local peer_id = v.peer_id
		local local_player_id = v.local_player_id

		for k_2 = 1, arg_112_1 do
			if not (peer_id ~= arg_112_3[k_2] or local_player_id ~= arg_112_4[k_2]) then
				local scores = v.scores
				local keys = table.keys(scores)

				table.sort(keys)

				local num = (k_2 - 1) * arg_112_2 + 1
				local num_2 = 1

				for l = num, num + arg_112_2 - 1 do
					scores[keys[num_2]] = arg_112_6[l]
					num_2 = num_2 + 1
				end

				break
			end
		end
	end
end

VersusMechanism.get_starting_level = function ()
	-- function 113
	return str_2
end

VersusMechanism.create_versus_migration_info = function (arg_114_0, arg_114_1, arg_114_2)
	-- function 114
	local level_transition_handler = Managers.level_transition_handler
	local tbl = {
		friend_party = Managers.party:client_get_friend_party()
	}
	local var_114_2 = str_2
	local level_transition_handler_2 = Managers.level_transition_handler
	local get_environment_variation_id = LevelHelper:get_environment_variation_id(var_114_2)
	local create_level_seed = Managers.mechanism:create_level_seed()
	local get_current_difficulty = level_transition_handler_2:get_current_difficulty()
	local num = 0

	tbl.level_data = {
		level_key = var_114_2,
		environment_variation_id = get_environment_variation_id,
		level_seed = create_level_seed,
		difficulty = get_current_difficulty
	}

	local str = "false"
	local var_114_9 = NetworkLookup.matchmaking_types["n/a"]

	tbl.lobby_data = {
		is_private = str,
		difficulty = get_current_difficulty,
		selected_mission_id = var_114_2,
		mission_id = var_114_2,
		matchmaking_type = var_114_9
	}

	return tbl
end

VersusMechanism.get_server_id = function (self)
	-- function 115
	return self._server_id
end

VersusMechanism.set_peer_backend_id = function (arg_116_0, arg_116_1, arg_116_2)
	-- function 116
	arg_116_0._peer_backend_id[arg_116_1] = arg_116_2
end

VersusMechanism.get_peer_backend_id = function (self, arg_117_1)
	-- function 117
	return self._peer_backend_id[arg_117_1]
end

VersusMechanism.load_end_screen_resources = function (arg_118_0)
	-- function 118
	Managers.package:load("resource_packages/levels/dlcs/carousel/versus_dependencies", "end_screen_resource")
end

VersusMechanism.unload_end_screen_resources = function (arg_119_0)
	-- function 119
	if Managers.package:is_loading("resource_packages/levels/dlcs/carousel/versus_dependencies", "end_screen_resource") or not Managers.package:has_loaded("resource_packages/levels/dlcs/carousel/versus_dependencies", "end_screen_resource") then
		Managers.package:unload("resource_packages/levels/dlcs/carousel/versus_dependencies", "end_screen_resource")
	end
end

VersusMechanism._setup_match = function (self)
	-- function 120
	if not self._shared_state then
		self._shared_state:destroy()
	end

	local peer_id = Network.peer_id()
	local dedicated_server_peer_id = Managers.mechanism:dedicated_server_peer_id()
	local server_peer_id = Managers.mechanism:server_peer_id()
	local var_120_3

	if not DEDICATED_SERVER then
		var_120_3 = true
	elseif not PEER_ID_TO_CHANNEL[dedicated_server_peer_id] then
		var_120_3 = false
	else
		var_120_3 = peer_id == server_peer_id
		dedicated_server_peer_id = nil

		if not var_120_3 then
			local player_id = Managers.backend:player_id()

			self._peer_backend_id[peer_id] = player_id
		end
	end

	printf("[VersusMechanism] Setting up match. Dedicated server id: %s, server id: %s, own id: %s", dedicated_server_peer_id, server_peer_id, peer_id)

	self._shared_state = SharedStateVersus:new(var_120_3, self._network_handler, dedicated_server_peer_id or server_peer_id, peer_id)

	self._shared_state:register_rpcs(self._network_event_delegate)

	if not var_120_3 then
		self._shared_state:generate_match_id()
	end

	self._shared_state:full_sync()

	local num_sets = self:get_objective_settings().num_sets

	num_sets = num_sets or 1
	self._num_sets = num_sets

	if not var_120_3 then
		local network_server = Managers.state.network.network_server
		local get_peers = network_server:get_peers()

		for i = 1, #get_peers do
			if network_server:get_peer_initialized_mechanism(get_peers[i]) == Managers.mechanism:current_mechanism_name() then
				RPC.rpc_versus_setup_match(PEER_ID_TO_CHANNEL[get_peers[i]])
			end
		end
	end
end

VersusMechanism.rpc_versus_setup_match = function (self)
	-- function 121
	self:_setup_match()
end

VersusMechanism.is_peer_fully_synced = function (self, arg_122_1)
	-- function 122
	if not self._shared_state then
		return self._shared_state:is_peer_fully_synced(arg_122_1)
	end

	return true
end

VersusMechanism.set_hero_cosmetics = function (self, arg_123_1, arg_123_2, arg_123_3, arg_123_4, arg_123_5, arg_123_6, arg_123_7, arg_123_8, arg_123_9, arg_123_10)
	-- function 123
	self._shared_state:set_hero_cosmetics(arg_123_1, arg_123_2, arg_123_3, arg_123_4, arg_123_5, arg_123_6, arg_123_7, arg_123_8, arg_123_9, arg_123_10)
end

VersusMechanism.get_hero_cosmetics = function (self, arg_124_1, arg_124_2)
	-- function 124
	local get_hero_cosmetics = self._shared_state:get_hero_cosmetics(arg_124_1, arg_124_2)
	local weapon = get_hero_cosmetics.weapon
	local weapon_pose = get_hero_cosmetics.weapon_pose
	local weapon_pose_skin = get_hero_cosmetics.weapon_pose_skin
	local hero_skin = get_hero_cosmetics.hero_skin
	local hat = get_hero_cosmetics.hat
	local frame = get_hero_cosmetics.frame
	local pactsworn_cosmetics = get_hero_cosmetics.pactsworn_cosmetics

	return weapon, weapon_pose, weapon_pose_skin, hero_skin, hat, frame, pactsworn_cosmetics
end

VersusMechanism.player_joined_party = function (self, arg_125_1, arg_125_2, arg_125_3, arg_125_4, arg_125_5)
	-- function 125
	if not Managers.mechanism:is_server() then
		local get_slot_reservation_handler = self:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

		if not get_slot_reservation_handler.player_joined_party then
			get_slot_reservation_handler:player_joined_party(arg_125_1, arg_125_2, arg_125_3, arg_125_4, arg_125_5)
		end
	end
end

VersusMechanism.try_reserve_profile_for_peer_by_mechanism = function (self, arg_126_1, arg_126_2, arg_126_3, arg_126_4, arg_126_5)
	-- function 126
	if SPProfiles[arg_126_3].affiliation ~= "heroes" then
		return true
	end

	local reserved_party_id_by_peer = self:reserved_party_id_by_peer(arg_126_2)

	if self._state == "inn" then
		return arg_126_1:try_reserve_profile_for_peer(reserved_party_id_by_peer, arg_126_2, arg_126_3, arg_126_4)
	end

	if not self._profiles_reservable then
		return true
	end

	if not arg_126_5 then
		local get_persistent_profile_index_reservation, var_126_2 = Managers.mechanism:get_persistent_profile_index_reservation(arg_126_2)

		if not (get_persistent_profile_index_reservation == 0 or get_persistent_profile_index_reservation == arg_126_3) then
			local get_profile_index_reservation = arg_126_1:get_profile_index_reservation(reserved_party_id_by_peer, get_persistent_profile_index_reservation)

			if not (not get_profile_index_reservation and get_profile_index_reservation ~= arg_126_2) then
				return arg_126_1:try_reserve_profile_for_peer(reserved_party_id_by_peer, arg_126_2, get_persistent_profile_index_reservation, var_126_2), get_persistent_profile_index_reservation, var_126_2
			end
		end
	end

	return arg_126_1:try_reserve_profile_for_peer(reserved_party_id_by_peer, arg_126_2, arg_126_3, arg_126_4)
end

VersusMechanism.reserved_party_id_by_peer = function (self, arg_127_1)
	-- function 127
	local server_peer_id = self._network_handler.server_peer_id

	return self:get_slot_reservation_handler(server_peer_id, scripts_managers_game_mode_mechanisms_reservation_handler_types.session):party_id_by_peer(arg_127_1)
end

VersusMechanism.remote_client_disconnected = function (self, arg_128_1)
	-- function 128
	for k, v in pairs(self._slot_reservation_handlers) do
		for k_2, v_2 in pairs(v) do
			if not v_2.remote_client_disconnected then
				v_2:remote_client_disconnected(arg_128_1)
			end
		end
	end
end

VersusMechanism.store_challenge_progression_status = function (self, arg_129_1, arg_129_2)
	-- function 129
	arg_129_2 = arg_129_2 or "area_selection_carousel_name"

	local flag = arg_129_2 or "default"

	if not (arg_129_1 or self._challenge_progression[flag]) then
		self._challenge_progression[flag] = Managers.state.achievement:get_challenge_progression(arg_129_2)
	end
end

local tbl_8 = {}

VersusMechanism.get_stored_challenge_progression_status = function (self, arg_130_1)
	-- function 130
	if not arg_130_1 then
		return self._challenge_progression[arg_130_1]
	end

	table.clear(tbl_8)

	for k, v in pairs(self._challenge_progression) do
		table.merge(tbl_8, v)
	end

	return tbl_8
end

VersusMechanism.clear_stored_challenge_progression_status = function (self)
	-- function 131
	table.clear(self._challenge_progression)
end

VersusMechanism.cache_horde_ability_charge_data = function (self, arg_132_1)
	-- function 132
	if not self._horde_ability_charges then
		self._horde_ability_charges = {}
	end

	for k, v in pairs(arg_132_1) do
		if not v.ability_charge then
			self._horde_ability_charges[k] = v.ability_charge
		end
	end
end

VersusMechanism._clear_horde_ability_data = function (self, arg_133_1)
	-- function 133
	if not self._horde_ability_charges then
		table.clear(self._horde_ability_charges)
	end
end

VersusMechanism.get_cached_horde_ability_charges = function (self, arg_134_1)
	-- function 134
	if not self._horde_ability_charges and not self._horde_ability_charges[arg_134_1] then
		local var_134_0 = self._horde_ability_charges[arg_134_1]

		self._horde_ability_charges[arg_134_1] = nil

		return var_134_0
	end
end

VersusMechanism.override_loading_screen_music = function (self)
	-- function 135
	local var_135_0
	local music_overrides = carousel.music_overrides

	if not (self._win_conditions:get_current_round() > 0) or not carousel.music_overrides.versus_between_rounds then
		var_135_0 = music_overrides.versus_between_rounds
	else
		var_135_0 = music_overrides[Managers.level_transition_handler:get_current_level_key()]
	end

	return var_135_0
end

VersusMechanism.on_enter_custom_game_lobby = function (self)
	-- function 136
	self._custom_game_settings_handler:request_full_sync()
end

VersusMechanism.set_custom_game_settings_handler_enabled = function (self, arg_137_1)
	-- function 137
	if not self._custom_game_settings_handler then
		self._custom_game_settings_handler:set_enabled(arg_137_1)
	end
end

VersusMechanism.get_custom_game_setting = function (self, arg_138_1)
	-- function 138
	local flag = false
	local var_138_1

	if not self._custom_game_settings_handler then
		var_138_1, flag = self._custom_game_settings_handler:get_setting(arg_138_1)
	end

	return var_138_1, flag
end

VersusMechanism.get_custom_game_settings_handler = function (self)
	-- function 139
	return self._custom_game_settings_handler
end

VersusMechanism.custom_settings_enabled = function (self)
	-- function 140
	if not self._custom_game_settings_handler then
		return self._custom_game_settings_handler:is_enabled()
	end

	return false
end
