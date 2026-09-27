-- chunkname: @scripts/unit_extensions/level/disrupt_ritual_extension.lua

DisruptRitualExtension = class(DisruptRitualExtension)

local tbl = {
	"rpc_client_disrupt_ritual_update"
}

DisruptRitualExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._network_transmit = arg_1_1.network_transmit
	self._network_event_delegate = arg_1_1.network_transmit.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl))

	self._event_manager = Managers.state.event

	Managers.state.event:register(self, "start_disrupt_ritual", "start_disrupt_ritual")
	Managers.state.event:register(self, "player_party_changed", "player_party_changed")

	self._volume_system = Managers.state.entity:system("volume_system")
	self._tutorial_system = Managers.state.entity:system("tutorial_system")
	self._ritual_system = Managers.state.entity:system("disrupt_ritual_system")
	self._health_extension = ScriptUnit.extension(arg_1_2, "health_system")
	self._level = LevelHelper:current_level(arg_1_1.world)
	self._is_server = arg_1_1.is_server
	self._unit = arg_1_2
	self._next_tick = 0
end

DisruptRitualExtension.start_disrupt_ritual = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	if arg_2_1 ~= self._unit then
		return
	end

	self._active = true
	self._volume_name = arg_2_2

	local get_data = Unit.get_data(self._unit, "health")

	self._max_damage = get_data

	self._health_extension:set_current_damage(self._max_damage)

	self._current_damage = 0

	self._event_manager:trigger("tutorial_event_show_health_bar", self._unit, true)

	if not self._is_server then
		return
	end

	arg_2_3 = arg_2_3 or "any_alive_players_inside"

	if arg_2_3 == "all_alive_players_inside" then
		self._condition_func = self._volume_system.all_alive_human_players_inside
		arg_2_3 = "all_alive_players_inside"
	elseif arg_2_3 == "any_alive_players_inside" then
		self._condition_func = self._volume_system.any_alive_human_players_inside
		arg_2_3 = "players_inside"
	else
		fassert(false, "disrupt ritual has to be of type 'all_alive_players_inside' or 'any_alive_players_inside' ")
	end

	self._tick_length = arg_2_5
	self._num_progression_events = arg_2_4
	self._damage_per_tick = arg_2_6
	self._heal_per_tick = arg_2_7
	self._active = true

	self._volume_system:register_volume(arg_2_2, "trigger_volume", {
		sub_type = arg_2_3
	})

	local tbl = {}

	for i = 0, 100 do
		local get_data_2 = Unit.get_data(self._unit, "checkpoints", i)

		if not get_data_2 then
			break
		end

		if get_data_2 ~= 0 then
			tbl[#tbl + 1] = get_data_2
		end
	end

	self._checkpoints = tbl
	self._num_checkpoints = #tbl

	local tbl_2 = {
		[1] = 0,
		[arg_2_4] = get_data
	}
	local num = get_data / arg_2_4

	for j = 2, arg_2_4 - 1 do
		tbl_2[j] = num * j
	end

	self._progression_event_thresholds = tbl_2
	self._num_progression_events = arg_2_4
end

DisruptRitualExtension.update = function (self, arg_3_1)
	-- function 3
	if not (not self._active and not (arg_3_1 < self._next_tick)) then
		return
	end

	self._next_tick = arg_3_1 + self._tick_length

	local _current_damage = self._current_damage
	local _checkpoints = self._checkpoints
	local _current_checkpoint = self._current_checkpoint

	_current_checkpoint = _current_checkpoint or 0

	local _current_progression_event = self._current_progression_event

	_current_progression_event = _current_progression_event or 0

	if not self._condition_func(self._volume_system, self._volume_name) then
		self:server_apply_damage(_current_damage, _checkpoints, _current_checkpoint, self._num_checkpoints)
	else
		self:server_heal(_current_damage, _checkpoints, _current_checkpoint)
	end

	local _current_damage_2 = self._current_damage

	self._health_extension:set_current_damage(self._max_damage - _current_damage_2)
	self:server_update_progression_status(self._progression_event_thresholds, _current_progression_event, self._num_progression_events, _current_damage_2)
	self:print_damage(_current_damage_2)

	local var_3_5 = self
	local server_send_rpc_update_clients = self.server_send_rpc_update_clients
	local var_3_7 = _current_damage_2
	local _current_checkpoint_2 = self._current_checkpoint

	_current_checkpoint_2 = _current_checkpoint_2 or 0

	server_send_rpc_update_clients(var_3_5, var_3_7, _current_checkpoint_2, self._current_progression_event, self._volume_name)
end

DisruptRitualExtension.server_heal = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if not self._increasing_damage then
		self:fire_flow_event("decreased", "damage")

		self._increasing_damage = false
	end

	local num = 0
	local num_2 = arg_4_1 - self._heal_per_tick

	if arg_4_3 > 0 then
		num = arg_4_2[arg_4_3]
	end

	if num_2 < num then
		return
	end

	self._current_damage = num_2
end

DisruptRitualExtension.server_apply_damage = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not self._increasing_damage then
		self:fire_flow_event("increased", "damage")

		self._increasing_damage = true
	end

	self._current_damage = arg_5_1 + self._damage_per_tick

	if self._current_damage >= self._max_damage then
		self._tutorial_system:flow_callback_show_health_bar(self._unit, false)

		self._active = false
	end

	if arg_5_3 == arg_5_4 then
		return
	end

	local num = arg_5_3 + 1

	if self._current_damage >= arg_5_2[num] then
		self._current_checkpoint = num

		self:fire_flow_event(num, "checkpoint")
		self:print_checkpoint(num)
	end
end

DisruptRitualExtension.server_update_progression_status = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local var_6_0 = arg_6_1[arg_6_2 + 1]
	local var_6_1

	if not var_6_0 then
		var_6_1 = var_6_0 <= arg_6_4
	end

	local var_6_2

	if not var_6_1 then
		var_6_2 = arg_6_2 + 1
	end

	if not var_6_2 then
		return
	end

	self._current_progression_event = var_6_2

	self:fire_flow_event(var_6_2, "progression")
	self:print_progression_event(var_6_2)
end

DisruptRitualExtension.server_send_rpc_update_clients = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	self._network_transmit:send_rpc_clients("rpc_client_disrupt_ritual_update", arg_7_1, arg_7_2, arg_7_3, arg_7_4)
end

DisruptRitualExtension.rpc_client_disrupt_ritual_update = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	if not (not self._active and self._volume_name == arg_8_5) then
		return
	end

	if not (not (arg_8_2 > self._current_damage) or self._increasing_damage) then
		self:fire_flow_event("increased", "damage")

		self._increasing_damage = true
	elseif not (arg_8_2 < self._current_damage) or not self._increasing_damage then
		self:fire_flow_event("decreased", "damage")

		self._increasing_damage = false
	end

	self._current_damage = arg_8_2

	self._health_extension:set_current_damage(self._max_damage - arg_8_2)

	if not (self._current_checkpoint == arg_8_3 or arg_8_3 == 0) then
		self._current_checkpoint = arg_8_3

		self:fire_flow_event(arg_8_3, "checkpoint")
		self:print_checkpoint(arg_8_3)
	end

	if self._current_progression_event ~= arg_8_4 then
		self._current_progression_event = arg_8_4

		self:fire_flow_event(arg_8_4, "progression")
		self:print_progression_event(arg_8_4)
	end

	if arg_8_2 >= self._max_damage then
		self._event_manager:trigger("tutorial_event_show_health_bar", self._unit, false)

		self._active = false
	end
end

DisruptRitualExtension.player_party_changed = function (self)
	-- function 9
	if not self._active then
		Unit.flow_event(self._unit, "show_health_bar")
	end
end

DisruptRitualExtension.fire_flow_event = function (self, arg_10_1, arg_10_2)
	-- function 10
	local str = self._volume_name .. "_" .. arg_10_2 .. "_" .. arg_10_1

	Level.trigger_event(self._level, str)
end

DisruptRitualExtension.print_damage = function (self, arg_11_1)
	-- function 11
	print("Disrupt Ritual ", self._volume_name, " current damage: ", arg_11_1)
end

DisruptRitualExtension.print_progression_event = function (self, arg_12_1)
	-- function 12
	print(self._volume_name, ": Disrupt Ritual progress updated. Current progression event: ", arg_12_1)
end

DisruptRitualExtension.print_checkpoint = function (self, arg_13_1)
	-- function 13
	print(self._volume_name, ": Disrupt Ritual checkpoint updated. Current checkpoint: ", arg_13_1)
end

DisruptRitualExtension.destroy = function (self)
	-- function 14
	self._network_event_delegate:unregister(self)
end
