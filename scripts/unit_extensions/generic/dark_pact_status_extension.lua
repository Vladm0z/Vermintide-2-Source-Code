-- chunkname: @scripts/unit_extensions/generic/dark_pact_status_extension.lua

require("scripts/entity_system/systems/ghost_mode/ghost_mode_utils")

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

DarkPactStatusExtension = class(DarkPactStatusExtension, GenericStatusExtension)

DarkPactStatusExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	DarkPactStatusExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._profile_index = arg_1_3.profile_id
	self._player = arg_1_3.player
	self._is_pinning_enemy = nil
	self._pinned_enemy_unit = nil
	self._is_packmaster_grabbing = nil
	self._is_packmaster_dragging = nil
	self._unarmed = nil
	self._packmaster_dragged_unit = nil
	self._stagger_type = scripts_utils_stagger_types.none
	self._accumulated_stagger = 0
	self._stagger_count = 0
	self._stagger_direction = Vector3Box(Vector3(0, 0, 0))
	self._stagger_animation_scale = 1
	self._stagger_animation_done = false
	self._stagger_length = 0
	self._stagger_time = 0
	self._stagger_immune_time = nil
	self._heavy_stagger_immune_time = nil
	self._always_stagger_suffered = false

	local breed = arg_1_3.breed

	breed = breed or Unit.get_data(arg_1_2, "breed")
	self._breed = breed
	self._stagger_reset_time = 0
	self._breed_action = nil
	self._is_climbing = false
	self._is_tunneling = false
	self._is_spawning = false
end

DarkPactStatusExtension.extensions_ready = function (arg_2_0)
	-- function 2
	DarkPactStatusExtension.super.extensions_ready(arg_2_0)
end

DarkPactStatusExtension.destroy = function (arg_3_0)
	-- function 3
	DarkPactStatusExtension.super.destroy(arg_3_0)
end

DarkPactStatusExtension.set_pinning_enemy = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not arg_4_1 then
		self._pinned_enemy_unit = arg_4_2
		self._is_pinning_enemy = true
	else
		self._pinned_enemy_unit = nil
		self._is_pinning_enemy = false
	end
end

DarkPactStatusExtension.set_is_packmaster_grabbing = function (self, arg_5_1)
	-- function 5
	self._is_packmaster_grabbing = arg_5_1
end

DarkPactStatusExtension.get_is_packmaster_grabbing = function (self)
	-- function 6
	return self._is_packmaster_grabbing
end

DarkPactStatusExtension.get_is_packmaster_dragging = function (self)
	-- function 7
	return self._is_packmaster_dragging
end

DarkPactStatusExtension.set_is_packmaster_dragging = function (self, arg_8_1)
	-- function 8
	self._is_packmaster_dragging = true
	self._packmaster_dragged_unit = arg_8_1
end

DarkPactStatusExtension.set_packmaster_released = function (self)
	-- function 9
	self._is_packmaster_dragging = false
	self._packmaster_dragged_unit = nil
end

DarkPactStatusExtension.set_unarmed = function (self, arg_10_1)
	-- function 10
	self._unarmed = arg_10_1
end

DarkPactStatusExtension.get_unarmed = function (self)
	-- function 11
	return self._unarmed
end

DarkPactStatusExtension.get_packmaster_dragged_unit = function (self)
	-- function 12
	return self._packmaster_dragged_unit
end

DarkPactStatusExtension.set_ghost_mode = function (self, arg_13_1)
	-- function 13
	self.in_ghost_mode = arg_13_1
end

DarkPactStatusExtension.get_in_ghost_mode = function (self)
	-- function 14
	return self.in_ghost_mode
end

DarkPactStatusExtension.in_view_enemy_party_players = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local network_id = arg_15_2:network_id()
	local local_player_id = arg_15_2:local_player_id()
	local get_party_from_player_id = Managers.party:get_party_from_player_id(network_id, local_player_id)
	local ENEMY_PLAYER_AND_BOT_POSITIONS = Managers.state.side.side_by_party[get_party_from_player_id].ENEMY_PLAYER_AND_BOT_POSITIONS

	return (GhostModeUtils.in_line_of_sight_of_enemies(arg_15_1, ENEMY_PLAYER_AND_BOT_POSITIONS, arg_15_3))
end

DarkPactStatusExtension.update = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	DarkPactStatusExtension.super.update(self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	self:update_stagger_count(arg_16_5)
end

DarkPactStatusExtension.is_staggered = function (self)
	-- function 17
	return self._stagger_type > scripts_utils_stagger_types.none
end

DarkPactStatusExtension.accumulated_stagger = function (self)
	-- function 18
	return self._accumulated_stagger
end

DarkPactStatusExtension.stagger_count = function (self)
	-- function 19
	return self._stagger_count
end

DarkPactStatusExtension.stagger_direction = function (self)
	-- function 20
	return self._stagger_direction
end

DarkPactStatusExtension.stagger_animation_scale = function (self)
	-- function 21
	return self._stagger_animation_scale
end

DarkPactStatusExtension.stagger_time = function (self)
	-- function 22
	return self._stagger_time
end

DarkPactStatusExtension.stagger_immune_time = function (self)
	-- function 23
	return self._stagger_immune_time
end

DarkPactStatusExtension.stagger_type = function (self)
	-- function 24
	return self._stagger_type
end

DarkPactStatusExtension.set_stagger_immune_time = function (self, arg_25_1)
	-- function 25
	self._stagger_immune_time = arg_25_1
end

DarkPactStatusExtension.heavy_stagger_immune_time = function (self)
	-- function 26
	return self._heavy_stagger_immune_time
end

DarkPactStatusExtension.set_heavy_stagger_immune_time = function (self, arg_27_1)
	-- function 27
	self._heavy_stagger_immune_time = arg_27_1
end

DarkPactStatusExtension.set_always_stagger_suffered = function (self, arg_28_1)
	-- function 28
	self._always_stagger_suffered = arg_28_1
end

DarkPactStatusExtension.always_stagger_suffered = function (self)
	-- function 29
	return self._always_stagger_suffered
end

DarkPactStatusExtension.stagger_length = function (self)
	-- function 30
	return self._stagger_length
end

DarkPactStatusExtension.stagger_animation_done = function (self)
	-- function 31
	return self._stagger_animation_done
end

DarkPactStatusExtension.set_stagger_animation_done = function (self, arg_32_1)
	-- function 32
	self._stagger_animation_done = arg_32_1
end

DarkPactStatusExtension.set_stagger_values = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8)
	-- function 33
	local time = Managers.time:time("game")

	self._stagger_type = arg_33_1

	self._stagger_direction:store(arg_33_2)

	self._stagger_length = arg_33_3
	self._accumulated_stagger = arg_33_4

	local num

	if arg_33_5 > 0 then
		num = arg_33_5 + time

		if not num then
			-- Nothing
		end
	end

	num = 0

	::label_33_0::

	self._stagger_time = num
	self._stagger_animation_scale = arg_33_6 or 1
	self._always_stagger_suffered = arg_33_7 or false

	if not (not arg_33_8 and Managers.state.network:game()) then
		return
	end

	local flag = arg_33_5 or 0
	local go_id = Managers.state.unit_storage:go_id(self.unit)

	if not self.is_server then
		local owner = Managers.player:owner(self.unit)

		if not owner then
			local peer_id = owner.peer_id

			Managers.state.network.network_transmit:send_rpc("rpc_set_stagger", peer_id, go_id, arg_33_1, arg_33_2, arg_33_3, arg_33_4, flag, self._stagger_animation_scale, self._always_stagger_suffered)
		end
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_set_stagger", go_id, arg_33_1, arg_33_2, arg_33_3, arg_33_4, flag, self._stagger_animation_scale, self._always_stagger_suffered)
	end
end

local num = 10

DarkPactStatusExtension.increase_stagger_count = function (self)
	-- function 34
	local time = Managers.time:time("main")
	local get_data = Unit.get_data(self.unit, "breed")
	local _stagger_count = self._stagger_count
	local stagger_count_reset_time = get_data.stagger_count_reset_time

	stagger_count_reset_time = stagger_count_reset_time or num
	self._stagger_count = _stagger_count + 1
	self._stagger_reset_time = time + stagger_count_reset_time
end

DarkPactStatusExtension.update_stagger_count = function (self, arg_35_1)
	-- function 35
	if not (not (arg_35_1 > self._stagger_reset_time) or not (self._stagger_count > 0)) then
		self._stagger_count = 0
	end
end

DarkPactStatusExtension.set_breed_action = function (self, arg_36_1, arg_36_2)
	-- function 36
	self._breed_action = BreedActions[arg_36_1][arg_36_2]
end

DarkPactStatusExtension.breed_action = function (self)
	-- function 37
	return self._breed_action
end

DarkPactStatusExtension.set_is_climbing = function (self, arg_38_1)
	-- function 38
	self._is_climbing = arg_38_1
end

DarkPactStatusExtension.is_climbing = function (self)
	-- function 39
	local _about_to_climb = self._about_to_climb

	_about_to_climb = _about_to_climb or self._is_climbing

	return _about_to_climb
end

DarkPactStatusExtension.should_climb = function (self)
	-- function 40
	return self._about_to_climb
end

DarkPactStatusExtension.set_should_climb = function (self, arg_41_1)
	-- function 41
	self._about_to_climb = arg_41_1
end

DarkPactStatusExtension.should_tunnel = function (self)
	-- function 42
	return self._is_tunneling
end

DarkPactStatusExtension.set_should_tunnel = function (self, arg_43_1)
	-- function 43
	self._is_tunneling = arg_43_1
end

DarkPactStatusExtension.should_spawn = function (self)
	-- function 44
	return self._is_spawning
end

DarkPactStatusExtension.set_should_spawn = function (self, arg_45_1)
	-- function 45
	self._is_spawning = arg_45_1
end

return "DarkPactStatusExtension"
