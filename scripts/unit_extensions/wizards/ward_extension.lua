-- chunkname: @scripts/unit_extensions/wizards/ward_extension.lua

WardExtension = class(WardExtension)

local num = 49
local num_2 = 8
local var_0_2 = num_2
local num_3 = 0.5
local num_4 = 14
local num_5 = 196
local skaven_clan_rat = Breeds.skaven_clan_rat
local str = "horde_rat_defend_destructible"
local str_2 = "destructible_defenders"
local str_3 = "ward"
local var_0_10 = QuaternionBox(Quaternion.identity())
local tbl = {
	idle = 0,
	aggressive = 1
}
local tbl_2 = {
	"rpc_client_ward_hot_join_sync"
}

WardExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._player_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase
	self._network_transmit = arg_1_1.network_transmit
	self._network_event_delegate = arg_1_1.network_transmit.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl_2))

	self._defenders = {}
	self._nearby_enemies = {}
	self._next_check = 0
	self._num_spawned = 0
	self._spawned = false
	self._state = tbl.idle
	self._ward_pos = Vector3Box(Unit.local_position(arg_1_2, 0))
	self._is_server = arg_1_1.is_server
	self._event_manager = Managers.state.event

	Managers.state.event:register(self, "spawn_defenders", "spawn_defenders")
	Managers.state.event:register(self, "player_party_changed", "player_party_changed")
end

WardExtension.destroy = function (self)
	-- function 2
	if tbl ~= tbl.aggressive then
		self:set_defenders_aggressive()
	end

	self._network_event_delegate:unregister(self)
	Managers.state.event:unregister("spawn_defenders", self)
	Managers.state.event:trigger("tutorial_event_remove_health_bar", self._unit)
	Managers.state.event:unregister("player_party_changed", self)
end

WardExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not self._spawned then
		self:toggle_health_bar_by_proximity(arg_3_1)
	end

	if not (self._is_server or self._state ~= tbl.aggressive) then
		return
	end

	local unbox = self._ward_pos:unbox()

	if arg_3_5 > self._next_check then
		self._closest_player = self:get_closest_player(unbox)
		self._next_check = arg_3_5 + num_3
	end

	if not self._closest_player and not unbox then
		self:update_state(unbox, self._closest_player)
	end
end

local tbl_3 = {}

WardExtension.get_closest_player = function (self, arg_4_1)
	-- function 4
	local query = Broadphase.query(self._player_broadphase, arg_4_1, num_4, tbl_3)

	if query == 0 then
		return
	end

	if query == 1 then
		return tbl_3[1]
	end

	local huge = math.huge
	local var_4_2
	local var_4_3
	local var_4_4

	for i = 1, query do
		local var_4_5 = tbl_3[i]
		local var_4_6 = POSITION_LOOKUP[var_4_5]
		local distance_squared = Vector3.distance_squared(arg_4_1, var_4_6)

		if distance_squared < huge then
			var_4_2 = var_4_5
			huge = distance_squared
		end
	end

	return var_4_2
end

WardExtension.update_state = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not arg_5_1 then
		return
	end

	local var_5_0 = POSITION_LOOKUP[arg_5_2]

	if not var_5_0 then
		return
	end

	if Vector3.distance_squared(arg_5_1, var_5_0) < num then
		self:set_defenders_aggressive(arg_5_2)

		self._state = tbl.aggressive

		return
	end

	self._state = tbl.idle
end

WardExtension.set_defenders_aggressive = function (self, arg_6_1)
	-- function 6
	local get_ai_group = Managers.state.entity:system("ai_group_system"):get_ai_group(self._defender_group_id)

	if not get_ai_group then
		AIGroupTemplates.destructible_defenders.set_group_aggressive(get_ai_group, arg_6_1)
	end
end

WardExtension.spawn_defenders = function (self, arg_7_1)
	-- function 7
	self._spawned = true

	if not self._is_server then
		return
	end

	arg_7_1 = arg_7_1 or num_2
	self._defender_group_id = Managers.state.entity:system("ai_group_system"):generate_group_id()

	local tbl = {
		behavior = str,
		ward_pos = self._ward_pos,
		spawned_func = function (arg_8_0, arg_8_1, arg_8_2)
			-- function 8
			local var_8_0 = BLACKBOARDS[arg_8_0]

			var_8_0.defend = true
			var_8_0.defend_get_in_position = true
			var_8_0.destructible_pos = arg_8_2.ward_pos
		end
	}
	local tbl_2 = {
		id = self._defender_group_id,
		size = arg_7_1,
		template = str_2
	}

	for i = 1, arg_7_1 do
		Managers.state.conflict:spawn_queued_unit(skaven_clan_rat, self._ward_pos, var_0_10, str_3, nil, nil, tbl, tbl_2)
	end
end

WardExtension.toggle_health_bar_by_proximity = function (self, arg_9_1)
	-- function 9
	local _local_player_unit_unit = self._local_player_unit_unit

	if not _local_player_unit_unit then
		self._local_player_unit_unit = Managers.player:local_player().player_unit
	end

	if not Unit.alive(_local_player_unit_unit) then
		if not self._health_bar_on then
			self._health_bar_on = false

			self._event_manager:trigger("tutorial_event_show_health_bar", arg_9_1, false)
		end

		return
	end

	local unbox = self._ward_pos:unbox()
	local world_position = Unit.world_position(_local_player_unit_unit, 0)
	local flag = num_5 > Vector3.distance_squared(unbox, world_position)

	if not (not flag and self._health_bar_on) then
		self._health_bar_on = true

		self._event_manager:trigger("tutorial_event_show_health_bar", arg_9_1, true)
	elseif flag or not self._health_bar_on then
		self._health_bar_on = false

		self._event_manager:trigger("tutorial_event_show_health_bar", arg_9_1, false)
	end
end

WardExtension.player_party_changed = function (self)
	-- function 10
	if not self._is_server and not self._spawned then
		self._network_transmit:send_rpc_clients("rpc_client_ward_hot_join_sync", self._spawned)
	end
end

WardExtension.rpc_client_ward_hot_join_sync = function (self, arg_11_1)
	-- function 11
	self._spawned = arg_11_1
end
