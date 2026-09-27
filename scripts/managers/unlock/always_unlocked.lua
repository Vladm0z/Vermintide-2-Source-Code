-- chunkname: @scripts/managers/unlock/always_unlocked.lua

AlwaysUnlocked = class(AlwaysUnlocked)

AlwaysUnlocked.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	-- function 1
	self._name = arg_1_1
	self._is_legacy_console_dlc = arg_1_7
	self._id = arg_1_2 or "0"
end

AlwaysUnlocked.ready = function (arg_2_0)
	-- function 2
	return true
end

AlwaysUnlocked.is_legacy_console_dlc = function (self)
	-- function 3
	return self._is_legacy_console_dlc
end

AlwaysUnlocked.has_error = function (arg_4_0)
	-- function 4
	return false
end

AlwaysUnlocked.id = function (self)
	-- function 5
	return self._id
end

AlwaysUnlocked.set_status_changed = function (arg_6_0, arg_6_1)
	-- function 6
	return
end

AlwaysUnlocked.backend_reward_id = function (arg_7_0)
	-- function 7
	return
end

AlwaysUnlocked.remove_backend_reward_id = function (arg_8_0)
	-- function 8
	return
end

AlwaysUnlocked.unlocked = function (arg_9_0)
	-- function 9
	return true
end

AlwaysUnlocked.installed = function (arg_10_0)
	-- function 10
	return true
end

AlwaysUnlocked.is_cosmetic = function (arg_11_0)
	-- function 11
	return true
end

AlwaysUnlocked.requires_restart = function (arg_12_0)
	-- function 12
	return false
end
