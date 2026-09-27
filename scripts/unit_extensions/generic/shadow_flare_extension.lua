-- chunkname: @scripts/unit_extensions/generic/shadow_flare_extension.lua

ShadowFlareExtension = class(ShadowFlareExtension)

ShadowFlareExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.owner_unit_id = arg_1_3.owner_unit_id

	local glow_time = arg_1_3.glow_time

	glow_time = glow_time or 10
	self.glow_time = glow_time

	local delete_time = arg_1_3.delete_time

	delete_time = delete_time or 3
	self.delete_time = delete_time
	self.initial_position = arg_1_3.initial_position
	self._timer = 0
	self._delete_timer = 0
	self._flare_done = false

	local unit = Managers.state.unit_storage:unit(self.owner_unit_id)

	self._player = Managers.player:owner(unit)
end

ShadowFlareExtension.flare_active = function (self)
	-- function 2
	return not self._flare_done
end

ShadowFlareExtension.set_flare_done = function (self)
	-- function 3
	self._flare_done = true
end

ShadowFlareExtension.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._player.remote then
		return
	end

	local glow_time = self.glow_time
	local _timer = self._timer

	if _timer < 1 then
		local clamp = math.clamp(_timer + arg_4_2 / glow_time, 0, 1)

		if clamp == 1 then
			local network = Managers.state.network
			local unit_game_object_id = network:unit_game_object_id(arg_4_1)

			if not self._player.is_server then
				network.network_transmit:send_rpc_clients("rpc_shadow_flare_done", unit_game_object_id)
			else
				network.network_transmit:send_rpc_server("rpc_shadow_flare_done", unit_game_object_id)
			end

			self:set_flare_done()
		end

		self._timer = clamp
	end

	if not self._flare_done then
		self:delete_with_delay(arg_4_1, arg_4_2)
	end
end

ShadowFlareExtension.delete_with_delay = function (self, arg_5_1, arg_5_2)
	-- function 5
	local delete_time = self.delete_time
	local _delete_timer = self._delete_timer

	if _delete_timer < 1 then
		_delete_timer = math.clamp(_delete_timer + arg_5_2 / delete_time, 0, 1)

		if _delete_timer == 1 then
			Managers.state.unit_spawner:mark_for_deletion(arg_5_1)
		end
	end

	self._delete_timer = _delete_timer
end
