-- chunkname: @scripts/ui/views/deus_menu/deus_run_stats_view.lua

require("scripts/ui/views/deus_menu/deus_run_stats_ui")

DeusRunStatsView = class(DeusRunStatsView)

local num = 1

DeusRunStatsView.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._ingame_hud = arg_1_1
	self._is_server = arg_1_2.is_server
	self._deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	local str = "deus_run_stats_view"
	local input_manager = arg_1_2.input_manager

	self._input_manager = input_manager
	self._input_service_name = str

	input_manager:create_input_service(str, "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service(str, "keyboard")
	input_manager:map_device_to_service(str, "gamepad")
	input_manager:map_device_to_service(str, "mouse")

	self._ui = DeusRunStatsUi:new(arg_1_2, self)
end

DeusRunStatsView.on_enter = function (self)
	-- function 2
	self._input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, self._input_service_name, "DeusRunStatsView")
end

DeusRunStatsView.on_exit = function (self)
	-- function 3
	self._input_manager:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, self._input_service_name, "DeusRunStatsView")
end

DeusRunStatsView.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._ui:update(arg_4_1, arg_4_2)
	self:_handle_input(arg_4_1, arg_4_2)
end

DeusRunStatsView.input_service = function (self)
	-- function 5
	return self._input_manager:get_service(self._input_service_name)
end

DeusRunStatsView.is_ui_active = function (self)
	-- function 6
	return self._ui:active()
end

DeusRunStatsView._handle_input = function (self, arg_7_1, arg_7_2)
	-- function 7
	local get_service = self._input_manager:get_service(self._input_service_name)
	local get = get_service:get("hotkey_deus_inventory", false)
	local is_device_active = Managers.input:is_device_active("gamepad")
	local active = self._ui:active()

	if not active then
		if not get_service:get("right_press") then
			self._ui:lock(true)
		end

		if not self._ui:force_update_power_ups() then
			self:_update_dynamic_values()
		end
	elseif not (active == get or get ~= true) then
		self:_update_dynamic_values()
		self:_update_inventory()

		local flag = Managers.player:local_player().player_unit == nil

		if flag or not is_device_active then
			self._ui:lock(true, flag)
		end
	end

	local locked = self._ui:locked()

	locked = not locked and not not Managers.ui:end_screen_active() or not self:_is_in_deus_map_view()

	self._ui:set_active(locked or get)
end

DeusRunStatsView.destroy = function (self)
	-- function 8
	self._ui:destroy()
end

DeusRunStatsView._update_dynamic_values = function (self)
	-- function 9
	local _deus_run_controller = self._deus_run_controller
	local get_blessings = _deus_run_controller:get_blessings()
	local keys = table.keys(DeusBlessingSettings)
	local get_own_peer_id = _deus_run_controller:get_own_peer_id()
	local get_player_power_ups = _deus_run_controller:get_player_power_ups(get_own_peer_id, num)
	local get_party_power_ups = _deus_run_controller:get_party_power_ups()
	local get_player_profile, var_9_7 = _deus_run_controller:get_player_profile(get_own_peer_id, num)
	local tbl = {
		blessings = get_blessings,
		power_ups = get_player_power_ups,
		party_power_ups = get_party_power_ups,
		profile_index = get_player_profile,
		career_index = var_9_7
	}

	self._ui:update_dynamic_values(tbl)
end

DeusRunStatsView._update_inventory = function (self)
	-- function 10
	local _deus_run_controller = self._deus_run_controller
	local get_own_loadout, var_10_2 = _deus_run_controller:get_own_loadout()
	local get_own_peer_id = _deus_run_controller:get_own_peer_id()
	local get_player_consumable_healthkit_slot = _deus_run_controller:get_player_consumable_healthkit_slot(get_own_peer_id, num)
	local get_player_consumable_potion_slot = _deus_run_controller:get_player_consumable_potion_slot(get_own_peer_id, num)
	local var_10_6 = rawget(ItemMasterList, get_player_consumable_potion_slot)

	if not var_10_6 and not var_10_6.hide_in_frame_ui then
		local get_player_additional_items = _deus_run_controller:get_player_additional_items(get_own_peer_id, num)
		local slot_potion = get_player_additional_items.slot_potion

		slot_potion = not slot_potion and get_player_additional_items.slot_potion.items

		if not slot_potion then
			for i = 1, #slot_potion do
				local var_10_9 = slot_potion[i]

				if not var_10_9.hide_in_frame_ui then
					get_player_consumable_potion_slot = var_10_9.key

					break
				end
			end
		end
	end

	local get_player_consumable_grenade_slot = _deus_run_controller:get_player_consumable_grenade_slot(get_own_peer_id, num)

	if not (self._melee ~= get_own_loadout or self._ranged ~= var_10_2 or self._potion_slot ~= get_player_consumable_potion_slot or self._grenade_slot ~= get_player_consumable_grenade_slot or self._healing_slot == get_player_consumable_healthkit_slot) then
		self._ui:set_loadout(get_own_loadout, var_10_2, get_player_consumable_healthkit_slot, get_player_consumable_potion_slot, get_player_consumable_grenade_slot)

		self._melee = get_own_loadout
		self._ranged = var_10_2
		self._potion_slot = get_player_consumable_potion_slot
		self._grenade_slot = get_player_consumable_grenade_slot
		self._healing_slot = get_player_consumable_healthkit_slot
	end
end

DeusRunStatsView._is_in_deus_map_view = function (arg_11_0)
	-- function 11
	if Managers.mechanism:current_mechanism_name() ~= "deus" then
		return false
	end

	return Managers.mechanism:get_state() == "map_deus"
end
