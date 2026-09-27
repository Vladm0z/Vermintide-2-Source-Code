-- chunkname: @scripts/managers/unlock/unlock_dlc_bundle.lua

UnlockDlcBundle = class(UnlockDlcBundle)

UnlockDlcBundle.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	-- function 1
	self._name = arg_1_1
	self._id = arg_1_2
	self._backend_reward_id = arg_1_3
	self._requires_restart = arg_1_7
	self._status_changed = false
	self._bundle_contains = arg_1_9 or {}
	self._installed = false

	if not HAS_STEAM and not arg_1_4 then
		local app_id = Steam.app_id()

		if not app_id and not table.contains(arg_1_4, app_id) then
			self._always_unlocked_for_app_id = true
			self._unlocked = true
			self._installed = true
		end
	end

	self:update_is_installed()
end

UnlockDlcBundle.is_legacy_console_dlc = function (arg_2_0)
	-- function 2
	return false
end

UnlockDlcBundle.ready = function (arg_3_0)
	-- function 3
	return true
end

UnlockDlcBundle.has_error = function (arg_4_0)
	-- function 4
	return false
end

UnlockDlcBundle.id = function (self)
	-- function 5
	return self._id
end

UnlockDlcBundle.backend_reward_id = function (self)
	-- function 6
	return self._backend_reward_id
end

UnlockDlcBundle.remove_backend_reward_id = function (self)
	-- function 7
	self._backend_reward_id = nil
end

UnlockDlcBundle.unlocked = function (self)
	-- function 8
	return self._unlocked
end

UnlockDlcBundle.installed = function (self)
	-- function 9
	return self._installed
end

UnlockDlcBundle.check_all_children_dlc_owned = function (self)
	-- function 10
	if not self._always_unlocked_for_app_id then
		return
	end

	local flag = true

	for i = 1, #self._bundle_contains do
		local var_10_1 = self._bundle_contains[i]

		if not Managers.unlock:get_dlc(var_10_1):unlocked() then
			flag = false

			break
		end
	end

	self._unlocked = flag
end

UnlockDlcBundle.set_status_changed = function (self, arg_11_1)
	-- function 11
	self._status_changed = arg_11_1
end

UnlockDlcBundle.is_cosmetic = function (arg_12_0)
	-- function 12
	return false
end

UnlockDlcBundle.requires_restart = function (self)
	-- function 13
	local _status_changed = self._status_changed

	_status_changed = not _status_changed and self._requires_restart

	return _status_changed
end

UnlockDlcBundle.update_is_installed = function (self)
	-- function 14
	if not HAS_STEAM then
		return self._installed
	end

	if not self._always_unlocked_for_app_id then
		return self._installed
	end

	local flag = true

	for i = 1, #self._bundle_contains do
		local var_14_1 = self._bundle_contains[i]
		local var_14_2 = UnlockSettings[1].unlocks[var_14_1]

		if not Steam.is_installed(var_14_2.id) then
			flag = false

			break
		end
	end

	if self._installed ~= flag then
		self._installed = flag

		return flag, true
	end

	return flag
end
