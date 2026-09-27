-- chunkname: @scripts/entity_system/systems/versus/versus_horde_ability_system.lua

require("scripts/unit_extensions/default_player_unit/versus_horde_ability_extension")
require("scripts/unit_extensions/default_player_unit/versus_horde_ability_husk_extension")

local var_0_0 = local_require("scripts/settings/versus_horde_ability_settings")

VersusHordeAbilitySystem = class(VersusHordeAbilitySystem, ExtensionSystemBase)

local tbl = {
	"rpc_activate_dark_pact_horde_ability",
	"rpc_client_outline_own_horde_units",
	"rpc_horde_ability_activated"
}
local tbl_2 = {
	"VersusHordeAbilityExtension",
	"VersusHordeAbilityHuskExtension"
}

VersusHordeAbilitySystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	VersusHordeAbilitySystem.super.init(self, arg_1_1, arg_1_2, tbl_2)
	self:register_rpcs(arg_1_1.network_event_delegate)

	if not self.is_server then
		self._server_player_data = {}
		self._next_batch_sync = 0
		self._event_manager = Managers.state.event
		self._conflict_director = Managers.state.conflict
		self._mechanism = Managers.mechanism:game_mechanism()
		self._win_conditions = self._mechanism:win_conditions()

		self._event_manager:register(self, "new_player_unit", "on_player_unit_spawned")
		self._event_manager:register(self, "gm_event_round_started", "on_round_started")
		self._event_manager:register(self, "on_player_joined_party", "on_player_joined_party")
		self._event_manager:register(self, "on_player_left_party", "on_player_left_party")

		self._num_players_by_party = {
			0,
			0
		}

		if not self._mechanism:custom_settings_enabled() then
			self._custom_settings_modifier = self._mechanism:get_custom_game_setting("horde_ability_recharge_rate_percent") / 100
		end
	end

	self._extensions = {}
	self.unit_storage = arg_1_1.unit_storage
end

VersusHordeAbilitySystem.destroy = function (self)
	-- function 2
	if not self.is_server then
		self._event_manager:unregister("new_player_unit", self)
		self._event_manager:unregister("gm_event_round_started", self)
		self._event_manager:unregister("on_player_joined_party", self)
		self._event_manager:unregister("on_player_left_party", self)

		if not var_0_0.save_charges_between_rounds then
			self._mechanism:cache_horde_ability_charge_data(self._server_player_data)
		end
	end

	self:unregister_rpcs()
end

VersusHordeAbilitySystem.register_rpcs = function (self, arg_3_1)
	-- function 3
	self._network_event_delegate = arg_3_1

	arg_3_1:register(self, unpack(tbl))
end

VersusHordeAbilitySystem.unregister_rpcs = function (self)
	-- function 4
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
	end
end

VersusHordeAbilitySystem.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self.is_server then
		self:_server_update_ability_charges(arg_5_1.dt)
		self:_server_batch_sync_client_horde_units(arg_5_2)
	end

	for k, v in pairs(self._extensions) do
		v:update(arg_5_2)
	end
end

VersusHordeAbilitySystem.on_remove_extension = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	arg_6_0._extensions[arg_6_1] = nil

	VersusHordeAbilitySystem.super.on_remove_extension(arg_6_0, arg_6_1, arg_6_2)
end

VersusHordeAbilitySystem.on_add_extension = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local on_add_extension = VersusHordeAbilitySystem.super.on_add_extension(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)

	arg_7_0._extensions[arg_7_2] = on_add_extension

	return on_add_extension
end

VersusHordeAbilitySystem.cooldown = function (arg_8_0)
	-- function 8
	return var_0_0.cooldown
end

VersusHordeAbilitySystem.on_round_started = function (self)
	-- function 9
	self._round_started = true
end

VersusHordeAbilitySystem.is_activation_allowed = function (self, arg_10_1)
	-- function 10
	local enable_activation_in_ghost_mode = var_0_0.enable_activation_in_ghost_mode

	enable_activation_in_ghost_mode = enable_activation_in_ghost_mode or not arg_10_1

	return not enable_activation_in_ghost_mode and self._round_started
end

VersusHordeAbilitySystem.activate_dark_pact_horde_ability = function (self)
	-- function 11
	if not self.is_server then
		local network_id = Managers.player:local_player():network_id()

		self:server_spawn_horde(network_id)
	else
		self.network_transmit:send_rpc_server("rpc_activate_dark_pact_horde_ability")
	end
end

VersusHordeAbilitySystem.rpc_client_outline_own_horde_units = function (self, arg_12_1, arg_12_2)
	-- function 12
	for i = 1, #arg_12_2 do
		local unit = self.unit_storage:unit(arg_12_2[i])

		if not unit then
			ScriptUnit.extension(unit, "outline_system"):add_outline(OutlineSettingsVS.templates.horde_ability)
		end
	end
end

VersusHordeAbilitySystem.server_register_horde_unit = function (self, arg_13_1, arg_13_2)
	-- function 13
	local var_13_0 = self._server_player_data[arg_13_2]

	var_13_0.ability_horde_units_to_sync[#var_13_0.ability_horde_units_to_sync + 1] = arg_13_1
end

VersusHordeAbilitySystem._server_update_ability_charges = function (self, arg_14_1)
	-- function 14
	local cooldown = var_0_0.cooldown
	local var_14_1

	for k, v in pairs(self._server_player_data) do
		if not v.ability_charge then
			local _recharge_modifier = self:_recharge_modifier(k)
			local cooldown_2 = _recharge_modifier.cooldown
			local _custom_settings_modifier = self._custom_settings_modifier

			_custom_settings_modifier = _custom_settings_modifier or 1

			local flag

			flag = self._round_started or not 0 or arg_14_1 * cooldown_2 * _custom_settings_modifier

			if not script_data.short_ability_cooldowns then
				flag = flag * 100
			end

			v.ability_charge = math.clamp(v.ability_charge + flag, 0, cooldown)

			if not v.extension then
				local boost = _recharge_modifier.boost

				v.extension:server_set_ability_charge(math.floor(v.ability_charge), cooldown_2, boost)
			end
		end
	end
end

VersusHordeAbilitySystem.server_spawn_horde = function (self, arg_15_1)
	-- function 15
	local conflict = Managers.state.conflict
	local side_id = Managers.state.side:get_side_from_name("dark_pact").side_id
	local var_15_2 = self._server_player_data[arg_15_1]

	if var_0_0.cooldown > var_15_2.ability_charge then
		return
	end

	local get_composition = self:get_composition()
	local tbl = {
		override_composition_type = get_composition
	}
	local tbl_2 = {
		horde_ability_caller_peer_id = arg_15_1
	}
	local var_15_6

	if not var_15_2.extension then
		var_15_6 = POSITION_LOOKUP[var_15_2.extension:unit()]

		if not var_15_6 then
			-- Nothing
		end
	end

	var_15_6 = nil

	::label_15_0::

	conflict.horde_spawner:execute_ambush_horde(tbl, side_id, false, var_15_6, tbl_2)

	var_15_2.ability_charge = 0

	local player = Managers.player:player(arg_15_1, 1)

	if not player then
		local player_unit = player.player_unit

		if not ALIVE[player_unit] then
			ScriptUnit.extension_input(player_unit, "dialogue_system"):trigger_dialogue_event("vs_ability_horde")
		end

		Managers.state.network.network_transmit:send_rpc_all("rpc_horde_ability_activated", arg_15_1)
	end
end

VersusHordeAbilitySystem.server_register_peer = function (self, arg_16_1)
	-- function 16
	local save_charges_between_rounds = var_0_0.save_charges_between_rounds

	save_charges_between_rounds = not save_charges_between_rounds and self._mechanism:get_cached_horde_ability_charges(arg_16_1)

	if not self._server_player_data[arg_16_1] then
		self._server_player_data[arg_16_1] = {
			ability_charge = save_charges_between_rounds or 0,
			ability_horde_units_to_sync = {}
		}
	end
end

VersusHordeAbilitySystem.server_ability_recharge_boost = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	if not (not arg_17_5 and var_0_0.recharge_boosts_on_downed_units) then
		return
	end

	local var_17_0 = self._server_player_data[arg_17_1]

	if not var_17_0 then
		return
	end

	local actions = var_0_0.recharge_boosts.actions
	local damage_sources = var_0_0.recharge_boosts.damage_sources
	local var_17_3 = actions[arg_17_2]

	if not var_17_3 then
		var_17_3 = damage_sources[arg_17_3]
		var_17_3 = var_17_3 or damage_sources[arg_17_4]
	end

	if not var_17_3 then
		local num = var_17_3 * self:_recharge_modifier(arg_17_1).boost
		local num_2 = var_0_0.cooldown / 100 * num

		var_17_0.ability_charge = var_17_0.ability_charge + num_2
	end
end

VersusHordeAbilitySystem.on_player_unit_spawned = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	if not self._extensions[arg_18_2] then
		return
	end

	local peer_id = arg_18_1.peer_id
	local var_18_1 = self._server_player_data[peer_id]

	var_18_1 = var_18_1 or {}

	local ability_charge

	if not var_18_1 then
		ability_charge = var_18_1.ability_charge

		if not ability_charge then
			-- Nothing
		end
	end

	ability_charge = self._mechanism:get_cached_horde_ability_charges(peer_id)
	ability_charge = ability_charge or 0

	::label_18_0::

	var_18_1.player_unit = arg_18_2
	var_18_1.extension = self._extensions[arg_18_2]
	var_18_1.ability_charge = ability_charge
	self._server_player_data[peer_id] = var_18_1
end

VersusHordeAbilitySystem.rpc_activate_dark_pact_horde_ability = function (self, arg_19_1)
	-- function 19
	local var_19_0 = CHANNEL_TO_PEER_ID[arg_19_1]

	self:server_spawn_horde(var_19_0)
end

VersusHordeAbilitySystem._server_batch_sync_client_horde_units = function (self, arg_20_1)
	-- function 20
	if arg_20_1 < self._next_batch_sync then
		return
	end

	self._next_batch_sync = arg_20_1 + var_0_0.horde_units_batch_sync_interval

	for k, v in pairs(self._server_player_data) do
		local ability_horde_units_to_sync = v.ability_horde_units_to_sync

		if not (not ability_horde_units_to_sync and table.is_empty(ability_horde_units_to_sync)) then
			local new_array = Script.new_array(var_0_0.max_num_horde_units_per_player)

			for k_2 = 1, #ability_horde_units_to_sync do
				new_array[k_2] = ability_horde_units_to_sync[k_2]
			end

			table.clear(ability_horde_units_to_sync)

			if not PEER_ID_TO_CHANNEL[k] then
				self.network_transmit:send_rpc("rpc_client_outline_own_horde_units", k, new_array)
			end
		end
	end
end

VersusHordeAbilitySystem.get_composition = function (self)
	-- function 21
	local factions = ConflictDirectors[self._conflict_director.current_conflict_settings].factions
	local compositions_per_faction = var_0_0.compositions_per_faction
	local skaven = compositions_per_faction.skaven

	if not (not factions and table.is_empty(factions)) then
		local count = #factions
		local random = math.random(1, count)

		for i = 0, count - 1 do
			local var_21_5 = factions[math.index_wrapper(random + i, count)]

			if not compositions_per_faction[var_21_5] then
				skaven = compositions_per_faction[var_21_5]

				break
			end
		end
	end

	return skaven
end

VersusHordeAbilitySystem.on_player_joined_party = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	if not arg_22_5 then
		return
	end

	if not self._num_players_by_party[arg_22_3] then
		self._num_players_by_party[arg_22_3] = self._num_players_by_party[arg_22_3] + 1
	end
end

VersusHordeAbilitySystem.on_player_left_party = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	if not self._num_players_by_party[arg_23_3] then
		self._num_players_by_party[arg_23_3] = self._num_players_by_party[arg_23_3] - 1
	end
end

VersusHordeAbilitySystem._recharge_modifier = function (self)
	-- function 24
	self._pactsworn_party_id = Managers.state.side:get_side_from_name("dark_pact").party.party_id
	self._hero_party_id = Managers.state.side:get_side_from_name("heroes").party.party_id

	local party_id = Managers.state.side:get_side_from_name("dark_pact").party.party_id
	local party_id_2 = Managers.state.side:get_side_from_name("heroes").party.party_id
	local clamp = math.clamp(self._num_players_by_party[party_id_2] - self._num_players_by_party[party_id], 0, 3)
	local var_24_3 = var_0_0.team_size_difference_recharge_modifier[clamp]
	local get_total_score = self._win_conditions:get_total_score(party_id)
	local get_total_score_2 = self._win_conditions:get_total_score(party_id_2)
	local num = 10
	local num_2 = get_total_score - get_total_score_2
	local sign = math.sign(num_2)
	local num_3 = math.floor(math.abs(num_2 / num)) * num * sign
	local max_score_difference_modifier = var_0_0.max_score_difference_modifier
	local var_24_11 = var_0_0.score_difference_recharge_modifier[num_3]

	var_24_11 = var_24_11 or var_0_0.score_difference_recharge_modifier[max_score_difference_modifier * sign]

	local var_24_12 = var_0_0.team_size_difference_recharge_modifier[3]
	local tbl = {
		cooldown = math.min(var_24_11.cooldown_mod * var_24_3, var_24_12),
		boost = math.min(var_24_11.boost_mod * var_24_3, var_24_12)
	}

	if self._mechanism:get_current_set() == 1 then
		tbl = {
			cooldown = var_24_3,
			boost = var_24_3
		}
	end

	return tbl or 1
end

VersusHordeAbilitySystem.settings = function (arg_25_0)
	-- function 25
	return var_0_0
end

VersusHordeAbilitySystem.rpc_horde_ability_activated = function (arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	if not Managers.chat and not Managers.chat:has_channel(1) then
		local player = Managers.player:player(arg_26_2, 1)
		local flag = not player and player:name()

		if not flag then
			Managers.chat:add_local_system_message(1, string.format(Localize("vs_chat_message_horde_ability"), flag), true)
		end
	end
end
