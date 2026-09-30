-- chunkname: @scripts/managers/unlock/always_unlocked.lua

AlwaysUnlocked = class(AlwaysUnlocked)

AlwaysUnlocked.init = function (self, name, app_id, backend_reward_id, cosmetic, fallback_id, requires_restart, is_legacy_console_dlc)
	-- function 1
	self._name = name
	self._is_legacy_console_dlc = is_legacy_console_dlc
	self._id = app_id or "0"
end

AlwaysUnlocked.ready = function (self)
	-- function 2
	return true
end

AlwaysUnlocked.is_legacy_console_dlc = function (self)
	-- function 3
	return self._is_legacy_console_dlc
end

AlwaysUnlocked.has_error = function (self)
	-- function 4
	return false
end

AlwaysUnlocked.id = function (self)
	-- function 5
	return self._id
end

AlwaysUnlocked.set_status_changed = function (self, value)
	-- function 6
	return
end

AlwaysUnlocked.backend_reward_id = function (self)
	-- function 7
	return
end

AlwaysUnlocked.remove_backend_reward_id = function (self)
	-- function 8
	return
end

AlwaysUnlocked.unlocked = function (self)
	-- function 9
	return true
end

AlwaysUnlocked.installed = function (self)
	-- function 10
	return true
end

AlwaysUnlocked.is_cosmetic = function (self)
	-- function 11
	return true
end

AlwaysUnlocked.requires_restart = function (self)
	-- function 12
	return false
end
