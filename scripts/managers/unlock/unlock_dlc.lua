-- chunkname: @scripts/managers/unlock/unlock_dlc.lua

UnlockDlc = class(UnlockDlc)

UnlockDlc.init = function (self, name, app_id, backend_reward_id, always_unlocked_game_app_ids, cosmetic, fallback_id, requires_restart)
	-- function 1
	self._name = name
	self._id = app_id
	self._backend_reward_id = backend_reward_id
	self._installed = false
	self._owned = false
	self._cosmetic = cosmetic
	self._requires_restart = requires_restart
	self._status_changed = false

	if HAS_STEAM and always_unlocked_game_app_ids then
		local steam_app_id = Steam.app_id()

		if steam_app_id and table.contains(always_unlocked_game_app_ids, steam_app_id) then
			self._always_unlocked_for_app_id = true
			self._installed = true
		end
	end

	self:update_is_installed()
end

UnlockDlc.is_legacy_console_dlc = function (self)
	-- function 2
	return false
end

UnlockDlc.ready = function (self)
	-- function 3
	return true
end

UnlockDlc.has_error = function (self)
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
	return self._installed
end

UnlockDlc.installed = function (self)
	-- function 9
	return self._installed
end

UnlockDlc.set_owned = function (self, value, set_status_change)
	-- function 10
	if set_status_change == nil or set_status_change then
		self._status_changed = self._status_changed
	end

	self._owned = value
end

UnlockDlc.set_status_changed = function (self, value)
	-- function 11
	self._status_changed = value
end

UnlockDlc.update_is_installed = function (self)
	-- function 12
	if not HAS_STEAM then
		return self._installed
	end

	if self._always_unlocked_for_app_id then
		return self._installed
	end

	local installed = Steam.is_installed(self._id)

	if self._installed ~= installed then
		self._installed = installed

		return installed, true
	end

	return installed
end

UnlockDlc.is_cosmetic = function (self)
	-- function 13
	return self._cosmetic
end

UnlockDlc.requires_restart = function (self)
	-- function 14
	return self._status_changed
end
