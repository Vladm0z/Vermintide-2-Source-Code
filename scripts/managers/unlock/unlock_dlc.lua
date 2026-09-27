-- chunkname: @scripts/managers/unlock/unlock_dlc.lua

UnlockDlc = class(UnlockDlc)

UnlockDlc.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	-- function 1
	self._name = arg_1_1
	self._id = arg_1_2
	self._backend_reward_id = arg_1_3
	self._installed = false
	self._owned = false
	self._cosmetic = arg_1_5
	self._requires_restart = arg_1_7
	self._status_changed = false

	if not HAS_STEAM and not arg_1_4 then
		local app_id = Steam.app_id()

		if not app_id and not table.contains(arg_1_4, app_id) then
			self._always_unlocked_for_app_id = true
			self._installed = true
		end
	end

	self:update_is_installed()
end

UnlockDlc.is_legacy_console_dlc = function (arg_2_0)
	-- function 2
	return false
end

UnlockDlc.ready = function (arg_3_0)
	-- function 3
	return true
end

UnlockDlc.has_error = function (arg_4_0)
	-- function 4
	return false
end

UnlockDlc.id = function (self)
	-- function 5
	return self._id
end

UnlockDlc.backend_reward_id = function (self)
	-- function 6
	return self._backend_reward_id
end

UnlockDlc.remove_backend_reward_id = function (self)
	-- function 7
	self._backend_reward_id = nil
end

UnlockDlc.unlocked = function (self)
	-- function 8
	local _installed = self._installed

	_installed = not _installed and self._owned

	return _installed
end

UnlockDlc.installed = function (self)
	-- function 9
	return self._installed
end

UnlockDlc.set_owned = function (self, arg_10_1, arg_10_2)
	-- function 10
	if arg_10_2 == nil or not arg_10_2 then
		local _status_changed = self._status_changed

		_status_changed = _status_changed or arg_10_1 ~= self._owned
		self._status_changed = _status_changed
	end

	self._owned = arg_10_1
end

UnlockDlc.set_status_changed = function (self, arg_11_1)
	-- function 11
	self._status_changed = arg_11_1
end

UnlockDlc.update_is_installed = function (self)
	-- function 12
	if not HAS_STEAM then
		return self._installed
	end

	if not self._always_unlocked_for_app_id then
		return self._installed
	end

	local is_installed = Steam.is_installed(self._id)

	if self._installed ~= is_installed then
		self._installed = is_installed

		return is_installed, true
	end

	return is_installed
end

UnlockDlc.is_cosmetic = function (self)
	-- function 13
	return self._cosmetic
end

UnlockDlc.requires_restart = function (self)
	-- function 14
	local _status_changed = self._status_changed

	_status_changed = not _status_changed and self._requires_restart

	return _status_changed
end
