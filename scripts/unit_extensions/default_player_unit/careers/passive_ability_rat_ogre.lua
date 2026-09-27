-- chunkname: @scripts/unit_extensions/default_player_unit/careers/passive_ability_rat_ogre.lua

PassiveAbilityRatOgre = class(PassiveAbilityRatOgre)

local tbl = {
	"rpc_start_leap",
	"rpc_stop_leap"
}

PassiveAbilityRatOgre.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._unit = arg_1_2
	self._is_server = arg_1_1.is_server

	local player = arg_1_3.player

	player = not player and arg_1_3.player.remote
	self._is_remote_player = player
	self._jump_from_pos = Vector3Box(0, 0, 0)
	self._jump_to_pos = Vector3Box(0, 0, 0)
	self._update_anim_variables = false
	self._network_event_delegate = Managers.state.network.network_transmit.network_event_delegate
	self._network_transmit = Managers.state.network.network_transmit

	self:register_rpcs(self._network_event_delegate)

	self._anim_value = 0
end

PassiveAbilityRatOgre.register_rpcs = function (self, arg_2_1)
	-- function 2
	self._network_event_delegate = arg_2_1

	arg_2_1:register(self, unpack(tbl))
end

PassiveAbilityRatOgre.unregister_rpcs = function (self)
	-- function 3
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
	end
end

PassiveAbilityRatOgre.extensions_ready = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._career_extension = ScriptUnit.extension(arg_4_2, "career_system")

	if not self._is_remote_player then
		self._first_person_extension = ScriptUnit.has_extension(arg_4_2, "first_person_system")
	end
end

PassiveAbilityRatOgre.destroy = function (self)
	-- function 5
	self:unregister_rpcs()
end

PassiveAbilityRatOgre.rpc_start_leap = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if Managers.state.unit_storage:unit(arg_6_2) ~= self._unit then
		return
	end

	if not self._is_server then
		if not DEDICATED_SERVER then
			self:set_leap_data(arg_6_3, arg_6_4)
		end

		local var_6_0 = CHANNEL_TO_PEER_ID[arg_6_1]

		self._network_transmit:send_rpc_clients_except("rpc_start_leap", var_6_0, arg_6_2, arg_6_3, arg_6_4)
	else
		self:set_leap_data(arg_6_3, arg_6_4)
	end
end

PassiveAbilityRatOgre.rpc_stop_leap = function (self, arg_7_1, arg_7_2)
	-- function 7
	if Managers.state.unit_storage:unit(arg_7_2) ~= self._unit then
		return
	end

	if not self._is_server then
		if not DEDICATED_SERVER then
			self:stop()
		end

		local var_7_0 = CHANNEL_TO_PEER_ID[arg_7_1]

		self._network_transmit:send_rpc_clients_except("rpc_stop_leap", var_7_0, arg_7_2)
	else
		self:stop()
	end
end

PassiveAbilityRatOgre.start_leap = function (self, arg_8_1, arg_8_2)
	-- function 8
	local go_id = Managers.state.unit_storage:go_id(self._unit)

	if not (self._is_server or self._is_remote_player) then
		self._network_transmit:send_rpc_server("rpc_start_leap", go_id, arg_8_1, arg_8_2)
		self:set_leap_data(arg_8_1, arg_8_2)
	elseif not (not self._is_server and DEDICATED_SERVER) then
		self._network_transmit:send_rpc_clients("rpc_start_leap", go_id, arg_8_1, arg_8_2)
		self:set_leap_data(arg_8_1, arg_8_2)
	elseif not self._is_server then
		self._network_transmit:send_rpc_clients("rpc_start_leap", go_id, arg_8_1, arg_8_2)
	end
end

PassiveAbilityRatOgre.set_leap_data = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not DEDICATED_SERVER then
		Vector3Box.store(self._jump_from_pos, arg_9_1)
		Vector3Box.store(self._jump_to_pos, arg_9_2)

		self._update_anim_variables = true

		local _unit = self._unit

		if not self._is_remote_player then
			self._first_person_extension:play_animation_event("attack_jump_air")
		end

		Unit.animation_event(_unit, "attack_jump_air")
	end
end

PassiveAbilityRatOgre.stop_leap = function (self)
	-- function 10
	local go_id = Managers.state.unit_storage:go_id(self._unit)

	if not go_id then
		return
	end

	if not (self._is_server or self._is_remote_player) then
		self._network_transmit:send_rpc_server("rpc_stop_leap", go_id)
		self:stop()
	elseif not (not self._is_server and DEDICATED_SERVER) then
		self._network_transmit:send_rpc_clients("rpc_stop_leap", go_id)
		self:stop()
	elseif not self._is_server then
		self._network_transmit:send_rpc_clients("rpc_stop_leap", go_id)
	end
end

PassiveAbilityRatOgre.stop = function (self)
	-- function 11
	self._update_anim_variables = false

	local _unit = self._unit

	if not Unit.alive(_unit) then
		return
	end

	if not (not self._anim_value and not (self._anim_value > 0.2)) then
		if not self._is_remote_player then
			self._first_person_extension:play_animation_event("attack_jump_land")
		end

		Unit.animation_event(_unit, "attack_jump_land")
	else
		if not self._is_remote_player then
			self._first_person_extension:play_animation_event("cancel_priming")
		end

		Unit.animation_event(_unit, "cancel_priming")
	end
end

PassiveAbilityRatOgre.update = function (self, arg_12_1, arg_12_2)
	-- function 12
	if not self._update_anim_variables then
		local _unit = self._unit

		if not Unit.alive(_unit) then
			self._update_anim_variables = false

			return
		end

		local var_12_1 = POSITION_LOOKUP[_unit]
		local unbox = self._jump_from_pos:unbox()
		local unbox_2 = self._jump_to_pos:unbox()
		local num = Vector3.length(var_12_1 - unbox) / Vector3.length(unbox_2 - unbox)

		self._anim_value = math.clamp(num * 2, 0, 2)

		local str = "jump_rotation"
		local animation_find_variable = Unit.animation_find_variable(_unit, str)

		if not self._is_remote_player then
			Unit.animation_set_variable(_unit, animation_find_variable, self._anim_value)
		else
			Unit.animation_set_variable(_unit, animation_find_variable, self._anim_value)
			self._first_person_extension:animation_set_variable(str, self._anim_value)
		end
	end
end
