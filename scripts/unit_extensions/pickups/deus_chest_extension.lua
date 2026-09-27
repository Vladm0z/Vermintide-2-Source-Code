-- chunkname: @scripts/unit_extensions/pickups/deus_chest_extension.lua

require("scripts/managers/game_mode/mechanisms/deus_weapon_generation")
require("scripts/settings/dlcs/morris/rarity_settings")
require("scripts/utils/hash_utils")

local tbl = {
	"rpc_deus_chest_looted"
}
local num = 1
local num_2 = 10
local num_3 = 12
local tbl_2 = {
	default = {
		swap_melee = {
			"melee"
		},
		swap_ranged = {
			"ranged"
		}
	},
	dr_slayer = {
		swap_melee = {
			"melee"
		},
		swap_ranged = {
			"melee",
			"ranged"
		}
	},
	es_questingknight = {
		swap_melee = {
			"melee"
		},
		swap_ranged = {
			"melee"
		}
	},
	wh_priest = {
		swap_melee = {
			"melee"
		},
		swap_ranged = {
			"melee"
		}
	}
}
local tbl_3 = {}
local RaritySettings = RaritySettings

for k, v in pairs(RaritySettings) do
	tbl_3[k] = "lua_update_" .. k
end

DeusChestExtension = class(DeusChestExtension, PickupUnitExtension)

DeusChestExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	DeusChestExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._is_server = Managers.player.is_server
	self._profile_index = 0
	self._career_index = 0
	self._animation_state = nil
	self._sound_state = nil
	self._sound_state_interact = nil
	self._wwise_world = Managers.world:wwise_world(self.world)

	self:register_rpcs(arg_1_1.network_transmit.network_event_delegate)
end

DeusChestExtension.game_object_initialized = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not self._is_server then
		local _chest_type_override = self._chest_type_override

		_chest_type_override = _chest_type_override or self._deus_run_controller:get_deus_weapon_chest_type()

		self:_set_server_chest_type(_chest_type_override)
	end
end

DeusChestExtension.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	fassert(self._deus_run_controller, "deus pickup unit can only be used in a deus run")

	self._telemetry_data = {
		altar_type = "n/a",
		activated = false,
		currency_when_found = -1,
		level_count = self._deus_run_controller:get_completed_level_count() + 1,
		run_id = self._deus_run_controller:get_run_id()
	}
end

DeusChestExtension.destroy = function (self)
	-- function 4
	if self._telemetry_data.currency_when_found ~= -1 then
		Managers.telemetry_events:deus_altar_passed(self._telemetry_data)
	end

	self:unregister_rpcs()
end

DeusChestExtension.register_rpcs = function (self, arg_5_1)
	-- function 5
	arg_5_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_5_1
end

DeusChestExtension.unregister_rpcs = function (self)
	-- function 6
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

DeusChestExtension.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local local_player = Managers.player:local_player()
	local player_unit = local_player.player_unit

	if not (not self._inventory_extension and self._player_unit == player_unit) then
		self._inventory_extension = ScriptUnit.has_extension(player_unit, "inventory_system")
		self._player = local_player
		self._player_unit = player_unit
	end

	if not (not player_unit and ALIVE[player_unit]) then
		return
	end

	local _go_id = self._go_id

	_go_id = _go_id or Managers.state.unit_storage:go_id(self.unit)

	local _deus_run_controller = self._deus_run_controller
	local get_own_peer_id = _deus_run_controller:get_own_peer_id()
	local get_player_profile, var_7_6 = _deus_run_controller:get_player_profile(get_own_peer_id, num)

	if not (not _go_id and get_player_profile ~= self._profile_index or var_7_6 == self._career_index) then
		local _get_server_chest_type = self:_get_server_chest_type()

		if not _get_server_chest_type then
			local get_current_node = self._deus_run_controller:get_current_node()
			local fnv32_hash = HashUtils.fnv32_hash(_go_id .. "_" .. get_current_node.weapon_pickup_seed)
			local _setup_rarity = self:_setup_rarity(fnv32_hash, _get_server_chest_type)

			Unit.flow_event(self.unit, "lua_update_" .. _get_server_chest_type)

			if _get_server_chest_type == DEUS_CHEST_TYPES.power_up then
				self:_generate_stored_power_up(fnv32_hash)
				Unit.set_data(self.unit, "interaction_data", "hud_description", "deus_weapon_chest_power_up_hud_desc")
				Unit.set_data(self.unit, "interaction_data", "hud_action", "deus_weapon_chest_power_up_action")
			elseif _get_server_chest_type == DEUS_CHEST_TYPES.upgrade then
				Unit.set_data(self.unit, "interaction_data", "hud_description", "deus_weapon_chest_upgrade_hud_desc")
				Unit.set_data(self.unit, "interaction_data", "hud_action", "deus_weapon_chest_upgrade_action")
			else
				local var_7_11 = SPProfiles[get_player_profile]
				local flag = not var_7_11 and var_7_11.careers[var_7_6].name
				local var_7_13 = tbl_2[flag]

				var_7_13 = var_7_13 or tbl_2.default

				local var_7_14 = var_7_13[_get_server_chest_type]

				self:_generate_stored_weapon(var_7_14, _setup_rarity, _go_id, get_player_profile, var_7_6)

				local var_7_15

				if _get_server_chest_type == DEUS_CHEST_TYPES.swap_melee then
					var_7_15 = "melee"
				elseif _get_server_chest_type == DEUS_CHEST_TYPES.swap_ranged then
					var_7_15 = "ranged"
				end

				Unit.set_data(self.unit, "interaction_data", "hud_description", "deus_weapon_chest_swap_" .. var_7_15 .. "_hud_desc")
				Unit.set_data(self.unit, "interaction_data", "hud_action", "deus_weapon_chest_swap_" .. var_7_15 .. "_action")
			end

			local game = Managers.state.network:game()
			local game_object_field = GameSession.game_object_field(game, _go_id, "collected_by_peers")
			local get_own_peer_id_2 = _deus_run_controller:get_own_peer_id()
			local _is_purchased = self._is_purchased
			local flag_2 = (self._stored_purchase or _get_server_chest_type == DEUS_CHEST_TYPES.upgrade) and table.contains(game_object_field, get_own_peer_id_2)

			if not (_is_purchased == flag_2 or flag_2 ~= true) then
				self._is_purchased = flag_2
				self._animation_state = "looted"

				Unit.flow_event(self.unit, "lua_update_collected")
			end

			self._profile_index = get_player_profile
			self._career_index = var_7_6
			self._go_id = _go_id
			self._chest_type = _get_server_chest_type
		end
	end

	self:update_upgrade_chest_color()
	self:_update_chest_interaction_time()

	if self._animation_state ~= "looted" then
		self:_update_chest_animation_and_sound_state(arg_7_1)
	end

	self:_update_telemetry(arg_7_1)
end

DeusChestExtension._update_chest_interaction_time = function (self)
	-- function 8
	local flag

	flag = not self:can_be_unlocked() and 0.5 and 0

	if flag ~= self._interaction_length then
		Unit.set_data(self.unit, "interaction_data", "interaction_length", flag)

		self._interaction_length = flag
	end
end

DeusChestExtension.update_upgrade_chest_color = function (self)
	-- function 9
	if self._chest_type ~= DEUS_CHEST_TYPES.upgrade then
		return
	end

	local _rarity = self._rarity

	if not _rarity then
		return
	end

	if not self._is_purchased then
		return
	end

	local _get_wielded_weapon = self:_get_wielded_weapon()

	if not _get_wielded_weapon then
		return
	end

	local order = RaritySettings[_get_wielded_weapon.rarity].order
	local order_2 = RaritySettings[_rarity].order
	local var_9_4
	local flag

	flag = not (order_2 <= order) or not "lua_interact_disabled" or tbl_3[_rarity]

	if not (not self._prev_update_upgrade_chest_color_event and self._prev_update_upgrade_chest_color_event == flag) then
		Unit.flow_event(self.unit, flag)

		self._prev_update_upgrade_chest_color_event = flag
	end
end

DeusChestExtension.can_interact = function (self)
	-- function 10
	if not self._is_purchased then
		return false
	end

	local _player_unit = self._player_unit
	local _inventory_extension = self._inventory_extension

	if not (not _player_unit and not ALIVE[_player_unit] and _inventory_extension) then
		return false
	end

	if not _inventory_extension:resyncing_loadout() then
		return false
	end

	return true
end

DeusChestExtension.get_interact_hud_description = function (self)
	-- function 11
	if not self._is_purchased then
		return "deus_weapon_chest_already_picked_up_hud_desc"
	else
		return "deus_weapon_chest_hud_desc"
	end
end

DeusChestExtension.get_purchase_cost = function (self)
	-- function 12
	local _chest_type = self._chest_type

	if _chest_type == DEUS_CHEST_TYPES.upgrade then
		local rarity = self:_get_wielded_weapon().rarity

		return DeusCostSettings.deus_chest[_chest_type][rarity][self._rarity]
	elseif _chest_type == DEUS_CHEST_TYPES.swap_melee then
		local rarity_2 = self._deus_run_controller:get_own_loadout().rarity

		return DeusCostSettings.deus_chest[_chest_type][rarity_2][self._rarity]
	elseif _chest_type == DEUS_CHEST_TYPES.swap_ranged then
		local get_own_loadout, var_12_4 = self._deus_run_controller:get_own_loadout()
		local rarity_3 = var_12_4.rarity

		return DeusCostSettings.deus_chest[_chest_type][rarity_3][self._rarity]
	elseif _chest_type == DEUS_CHEST_TYPES.power_up then
		return DeusCostSettings.deus_chest.power_up
	end

	return math.huge
end

DeusChestExtension.purchase = function (self)
	-- function 13
	local get_purchase_cost = self:get_purchase_cost()

	self._deus_run_controller:purchase_chest(self._rarity, self._chest_type, get_purchase_cost)

	self._is_purchased = true

	Unit.flow_event(self.unit, "lua_update_collected")

	self._animation_state = "looted"

	if not self._is_server then
		local go_id = Managers.state.unit_storage:go_id(self.unit)

		Managers.state.network.network_transmit:send_rpc_server("rpc_deus_chest_looted", go_id)
	end
end

DeusChestExtension._get_wielded_weapon = function (self)
	-- function 14
	local _inventory_extension = self._inventory_extension

	if not _inventory_extension then
		return
	end

	local get_own_loadout, var_14_2 = self._deus_run_controller:get_own_loadout()
	local flag

	flag = _inventory_extension:get_wielded_slot_name() ~= "slot_melee" or not "slot_melee" or "slot_ranged"

	return flag ~= "slot_melee" or not get_own_loadout or var_14_2, flag
end

DeusChestExtension.on_interact = function (self)
	-- function 15
	if self._chest_type == DEUS_CHEST_TYPES.upgrade then
		local _get_wielded_weapon, var_15_1 = self:_get_wielded_weapon()

		if not (not _get_wielded_weapon and _get_wielded_weapon == self._previous_wielded_weapon) then
			self:_generate_upgraded_weapon(_get_wielded_weapon, var_15_1, self._rarity, self._go_id, self._profile_index, self._career_index)

			self._previous_wielded_weapon = _get_wielded_weapon
		end
	end
end

DeusChestExtension._setup_rarity = function (self, arg_16_1, arg_16_2)
	-- function 16
	if arg_16_2 == DEUS_CHEST_TYPES.power_up then
		return nil
	else
		local get_current_node = self._deus_run_controller:get_current_node()
		local get_run_difficulty = self._deus_run_controller:get_run_difficulty()
		local run_progress = get_current_node.run_progress

		self._rarity = DeusWeaponGeneration.get_random_rarity(get_run_difficulty, run_progress, arg_16_1)

		Unit.flow_event(self.unit, "lua_update_" .. self._rarity)

		return self._rarity
	end
end

DeusChestExtension.get_rarity = function (self)
	-- function 17
	if self._chest_type == DEUS_CHEST_TYPES.power_up then
		return self._stored_purchase.rarity
	else
		return self._rarity
	end
end

DeusChestExtension.get_stored_purchase = function (self)
	-- function 18
	if self._chest_type == DEUS_CHEST_TYPES.power_up then
		local _deus_run_controller = self._deus_run_controller
		local get_own_peer_id = _deus_run_controller:get_own_peer_id()

		if not self._stored_purchase then
			local name = self._stored_purchase.name

			if not _deus_run_controller:reached_max_power_ups(get_own_peer_id, name) then
				local _go_id = self._go_id

				_go_id = _go_id or Managers.state.unit_storage:go_id(self.unit)

				local get_current_node = self._deus_run_controller:get_current_node()
				local fnv32_hash = HashUtils.fnv32_hash(_go_id .. "_" .. get_current_node.weapon_pickup_seed)

				self:_generate_stored_power_up(fnv32_hash)
			end
		end
	end

	return self._stored_purchase
end

DeusChestExtension.get_chest_type = function (self)
	-- function 19
	return self._chest_type
end

DeusChestExtension._generate_stored_power_up = function (self, arg_20_1)
	-- function 20
	self._stored_purchase = self._deus_run_controller:generate_random_power_ups(DeusPowerUpSettings.weapon_chest_choice_amount, DeusPowerUpAvailabilityTypes.weapon_chest, arg_20_1)[1]
end

DeusChestExtension._generate_stored_weapon = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	local _deus_run_controller = self._deus_run_controller
	local get_current_node = _deus_run_controller:get_current_node()
	local run_progress = get_current_node.run_progress
	local get_run_difficulty = _deus_run_controller:get_run_difficulty()
	local get_weapon_pool = _deus_run_controller:get_weapon_pool()
	local fnv32_hash = HashUtils.fnv32_hash(string.format("%s_%s_%s_%s_%s", arg_21_4, arg_21_5, get_current_node.weapon_pickup_seed, arg_21_3, 1))
	local flag

	flag = not table.contains(arg_21_1, "melee") and 1 and 0

	local flag_2

	flag_2 = not table.contains(arg_21_1, "ranged") and 1 and 0

	local generate_weapon = DeusWeaponGeneration.generate_weapon(get_run_difficulty, run_progress, arg_21_2, fnv32_hash, get_weapon_pool, flag, flag_2)

	_deus_run_controller:remove_weapon_from_pool(arg_21_2, generate_weapon.deus_item_key)

	local get_interface = Managers.backend:get_interface("deus")

	get_interface:grant_deus_weapon(generate_weapon)
	get_interface:refresh_deus_weapons_in_items_backend()

	self._stored_purchase = generate_weapon
end

DeusChestExtension._generate_upgraded_weapon = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	-- function 22
	local _deus_run_controller = self._deus_run_controller
	local get_current_node = _deus_run_controller:get_current_node()
	local run_progress = get_current_node.run_progress
	local get_run_difficulty = _deus_run_controller:get_run_difficulty()
	local fnv32_hash = HashUtils.fnv32_hash(string.format("%s_%s_%s_%s_%s", arg_22_5, arg_22_6, get_current_node.weapon_pickup_seed, arg_22_4, 1))
	local upgrade_item = DeusWeaponGeneration.upgrade_item(arg_22_1, get_run_difficulty, run_progress, arg_22_3, fnv32_hash)

	upgrade_item.preferred_slot_name = arg_22_2

	local get_interface = Managers.backend:get_interface("deus")

	get_interface:grant_deus_weapon(upgrade_item)
	get_interface:refresh_deus_weapons_in_items_backend()

	self._stored_purchase = upgrade_item

	Unit.set_data(self.unit, "interaction_data", "hud_description", "deus_weapon_chest_upgrade_hud_desc")
	Unit.set_data(self.unit, "interaction_data", "hud_action", "deus_weapon_chest_upgrade_action")
end

DeusChestExtension._get_server_chest_type = function (self)
	-- function 23
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(self.unit)

	if not (not game and go_id) then
		return nil
	end

	local game_object_field = GameSession.game_object_field(game, go_id, "server_chest_type")
	local var_23_3

	if game_object_field ~= 0 then
		var_23_3 = NetworkLookup.deus_chest_types[game_object_field]

		if not var_23_3 then
			-- Nothing
		end
	end

	var_23_3 = nil

	::label_23_0::

	return var_23_3
end

DeusChestExtension._set_server_chest_type = function (self, arg_24_1)
	-- function 24
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(self.unit)

	fassert(not game and go_id, "setting state without network setup done")

	local var_24_2 = NetworkLookup.deus_chest_types[arg_24_1]

	GameSession.set_game_object_field(game, go_id, "server_chest_type", var_24_2)
end

local tbl_4 = {
	unlock_chest = "hud_morris_weapon_chest_unlock",
	unlock_power_up = "morris_reliquarys_get_boon",
	close_chest_ui = "hud_morris_weapon_chest_close",
	button_hover = "hud_morris_hover",
	exchange_weapon = "hud_morris_weapon_chest_change_weapon",
	open_chest_ui = "hud_morris_weapon_chest_open",
	unlock_chest_rarity_sounds = {
		common = "play_hud_rewards_tier1",
		plentiful = "play_hud_rewards_tier1",
		exotic = "play_hud_rewards_tier3",
		rare = "play_hud_rewards_tier2",
		unique = "play_hud_rewards_tier4"
	}
}

DeusChestExtension.can_be_unlocked = function (self)
	-- function 25
	if not self:can_interact() then
		return false
	end

	if not (self._stored_purchase or self._chest_type == DEUS_CHEST_TYPES.upgrade) then
		return false
	end

	local get_own_peer_id = self._deus_run_controller:get_own_peer_id()
	local get_player_soft_currency = self._deus_run_controller:get_player_soft_currency(get_own_peer_id)
	local get_purchase_cost = self:get_purchase_cost()

	get_purchase_cost = get_purchase_cost or math.huge

	local unlock_all_deus_chests = script_data.unlock_all_deus_chests

	unlock_all_deus_chests = unlock_all_deus_chests or get_purchase_cost <= get_player_soft_currency

	local _chest_type = self._chest_type

	if _chest_type == DEUS_CHEST_TYPES.upgrade then
		local _get_wielded_weapon = self:_get_wielded_weapon()

		if not _get_wielded_weapon then
			local var_25_6 = RaritySettings

			if var_25_6[_get_wielded_weapon.rarity].order >= var_25_6[self._rarity].order then
				unlock_all_deus_chests = false
			end
		end
	end

	if not unlock_all_deus_chests then
		return false
	end

	local flag = true

	if _chest_type ~= DEUS_CHEST_TYPES.power_up then
		flag = Managers.state.network.profile_synchronizer:others_actually_ingame()
	end

	if not flag then
		return false
	end

	return true
end

DeusChestExtension.open_chest = function (self)
	-- function 26
	local _deus_run_controller = self._deus_run_controller

	self._telemetry_data.currency_when_found = _deus_run_controller:get_player_soft_currency(_deus_run_controller:get_own_peer_id())
	self._telemetry_data.activated = true

	if self._chest_type == DEUS_CHEST_TYPES.power_up then
		local _stored_purchase = self._stored_purchase

		_deus_run_controller:add_power_ups({
			_stored_purchase
		}, num, true)
		self:_play_sound(tbl_4.unlock_power_up)
		self:_post_chest_unlock(self._stored_purchase)
	else
		if not self._stored_purchase then
			local _get_wielded_weapon, var_26_3 = self:_get_wielded_weapon()

			self:_generate_upgraded_weapon(_get_wielded_weapon, var_26_3, self._rarity, self._go_id, self._profile_index, self._career_index)

			self._previous_wielded_weapon = _get_wielded_weapon
		end

		local get_rarity = self:get_rarity()
		local var_26_5 = tbl_4.unlock_chest_rarity_sounds[get_rarity]

		if not var_26_5 then
			self:_play_sound(var_26_5)
		end

		if not (self._chest_type == DEUS_CHEST_TYPES.swap_ranged or self._chest_type ~= DEUS_CHEST_TYPES.swap_melee) then
			ScriptUnit.extension_input(self._player_unit, "dialogue_system"):trigger_networked_dialogue_event("deus_using_a_weapon_shrine")
		end

		self:_post_chest_unlock(self._stored_purchase)
		self:_equip_weapon(_deus_run_controller, self._stored_purchase)
		self:_play_sound(tbl_4.exchange_weapon)
	end
end

DeusChestExtension._equip_weapon = function (self, arg_27_1, arg_27_2)
	-- function 27
	print("[DeusChestExtension] equipped:")
	table.dump(arg_27_2, "deus_weapon")

	local backend_id = arg_27_2.backend_id
	local _inventory_extension = self._inventory_extension
	local _profile_index = self._profile_index
	local var_27_3 = SPProfiles[_profile_index]
	local _career_index = self._career_index
	local var_27_5 = var_27_3.careers[_career_index]
	local name = var_27_5.name
	local var_27_7
	local _chest_type = self._chest_type
	local flag

	flag = (_chest_type ~= DEUS_CHEST_TYPES.swap_melee or not "slot_melee" or _chest_type ~= DEUS_CHEST_TYPES.swap_ranged) and (not "slot_ranged" or self:_get_best_slot_name(arg_27_2, _chest_type, var_27_5, _inventory_extension))

	BackendUtils.set_loadout_item(backend_id, name, flag)
	_inventory_extension:create_equipment_in_slot(flag, backend_id, 1)
	arg_27_1:save_loadout(arg_27_2, flag)
end

DeusChestExtension._get_best_slot_name = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local var_28_0
	local slot_type = arg_28_1.data.slot_type
	local slots_by_slot_index = InventorySettings.slots_by_slot_index

	for k, v in pairs(slots_by_slot_index) do
		if slot_type == v.type then
			var_28_0 = v.name
		end
	end

	local var_28_3
	local equipment = arg_28_4:equipment()
	local backend_id = equipment.wielded.backend_id

	for k_2, v_2 in pairs(equipment.slots) do
		if v_2.item_data.backend_id == backend_id then
			var_28_3 = v_2.id

			break
		end
	end

	if arg_28_2 == DEUS_CHEST_TYPES.upgrade then
		return arg_28_1.preferred_slot_name
	else
		local var_28_6 = arg_28_3.item_slot_types_by_slot_name[var_28_3]

		return not (not var_28_6 and table.contains(var_28_6, slot_type)) and var_28_3 and var_28_0, slot_type
	end
end

DeusChestExtension._post_chest_unlock = function (self, arg_29_1)
	-- function 29
	self:_play_sound(tbl_4.unlock_chest)
	self:purchase()

	local local_player = Managers.player:local_player()

	Managers.state.event:trigger("player_pickup_deus_weapon_chest", local_player)

	if not (not arg_29_1 and self._chest_type == DEUS_CHEST_TYPES.power_up) then
		Managers.state.event:trigger("present_rewards", {
			{
				type = "deus_item_tooltip",
				backend_id = arg_29_1.backend_id
			}
		})
	end

	StatisticsUtil.register_open_shrine(self._chest_type)
end

DeusChestExtension._play_sound = function (self, arg_30_1)
	-- function 30
	WwiseWorld.trigger_event(self._wwise_world, arg_30_1)
end

DeusChestExtension._update_chest_animation_and_sound_state = function (self, arg_31_1)
	-- function 31
	local _player_unit = self._player_unit
	local var_31_1 = POSITION_LOOKUP[_player_unit]
	local var_31_2 = POSITION_LOOKUP[arg_31_1]
	local distance_squared = Vector3.distance_squared(var_31_1, var_31_2)
	local flag = ScriptUnit.extension(_player_unit, "interactor_system"):interactable_unit() == arg_31_1
	local _animation_state = self._animation_state
	local _sound_state = self._sound_state
	local _sound_state_interact = self._sound_state_interact

	if not (self._stored_purchase or self._chest_type == DEUS_CHEST_TYPES.upgrade) then
		_animation_state = "player_far"
		_sound_state = "sound_player_far"
		_sound_state_interact = "interact_false"
	elseif not flag then
		_animation_state = "player_interacting"
		_sound_state_interact = "interact_true"
	elseif distance_squared < num_2 * num_2 then
		_animation_state = "player_near"
		_sound_state = "sound_player_near"
		_sound_state_interact = "interact_false"
	elseif distance_squared > num_3 * num_3 then
		_animation_state = "player_far"
		_sound_state = "sound_player_far"
		_sound_state_interact = "interact_false"
	end

	if _animation_state ~= self._animation_state then
		self._animation_state = _animation_state

		Unit.flow_event(arg_31_1, _animation_state)
	end

	if _sound_state ~= self._sound_state then
		Unit.flow_event(arg_31_1, _sound_state)

		self._sound_state = _sound_state
	end

	if _sound_state_interact ~= self._sound_state_interact then
		Unit.flow_event(arg_31_1, _sound_state_interact)

		self._sound_state_interact = _sound_state_interact
	end
end

DeusChestExtension._update_telemetry = function (self, arg_32_1)
	-- function 32
	local _player_unit = self._player_unit
	local var_32_1 = POSITION_LOOKUP[_player_unit]

	if not var_32_1 then
		return
	end

	local _telemetry_data = self._telemetry_data

	if _telemetry_data.altar_type == "n/a" then
		local _get_server_chest_type = self:_get_server_chest_type()

		_get_server_chest_type = _get_server_chest_type or "n/a"
		_telemetry_data.altar_type = _get_server_chest_type
	end

	if _telemetry_data.currency_when_found == -1 then
		local var_32_4 = POSITION_LOOKUP[arg_32_1]

		if Vector3.distance_squared(var_32_1, var_32_4) < 625 then
			local _deus_run_controller = self._deus_run_controller
			local get_own_peer_id = _deus_run_controller:get_own_peer_id()

			_telemetry_data.currency_when_found = _deus_run_controller:get_player_soft_currency(get_own_peer_id)
		end
	end
end

DeusChestExtension.rpc_deus_chest_looted = function (self, arg_33_1, arg_33_2)
	-- function 33
	local go_id = Managers.state.unit_storage:go_id(self.unit)

	if arg_33_2 ~= go_id then
		return
	end

	local game = Managers.state.network:game()

	fassert(not game and go_id, "setting state without network setup done")

	local game_object_field = GameSession.game_object_field(game, go_id, "collected_by_peers")
	local var_33_3 = CHANNEL_TO_PEER_ID[arg_33_1]

	table.insert(game_object_field, var_33_3)
	GameSession.set_game_object_field(game, go_id, "collected_by_peers", game_object_field)
end
