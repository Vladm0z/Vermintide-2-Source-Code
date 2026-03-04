-- chunkname: @scripts/managers/unlock/unlock_dlc_bundle.lua

UnlockDlcBundle = class(UnlockDlcBundle)

UnlockDlcBundle.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	arg_1_0._name = arg_1_1
	arg_1_0._id = arg_1_2
	arg_1_0._backend_reward_id = arg_1_3
	arg_1_0._requires_restart = arg_1_7
	arg_1_0._status_changed = false
	arg_1_0._bundle_contains = arg_1_9 or {}
	arg_1_0._installed = false

	if HAS_STEAM and arg_1_4 then
		local var_1_0 = Steam.app_id()

		if var_1_0 and table.contains(arg_1_4, var_1_0) then
			arg_1_0._always_unlocked_for_app_id = true
			arg_1_0._unlocked = true
			arg_1_0._installed = true
		end
	end

	arg_1_0:update_is_installed()
end

UnlockDlcBundle.is_legacy_console_dlc = function (arg_2_0)
	return false
end

UnlockDlcBundle.ready = function (arg_3_0)
	return true
end

UnlockDlcBundle.has_error = function (arg_4_0)
	return false
end

UnlockDlcBundle.id = function (arg_5_0)
	return arg_5_0._id
end

UnlockDlcBundle.backend_reward_id = function (arg_6_0)
	return arg_6_0._backend_reward_id
end

UnlockDlcBundle.remove_backend_reward_id = function (arg_7_0)
	arg_7_0._backend_reward_id = nil
end

UnlockDlcBundle.unlocked = function (arg_8_0)
	return arg_8_0._unlocked
end

UnlockDlcBundle.installed = function (arg_9_0)
	return arg_9_0._installed
end

UnlockDlcBundle.check_all_children_dlc_owned = function (arg_10_0)
	if arg_10_0._always_unlocked_for_app_id then
		return
	end

	local var_10_0 = true

	for iter_10_0 = 1, #arg_10_0._bundle_contains do
		local var_10_1 = arg_10_0._bundle_contains[iter_10_0]

		if not Managers.unlock:get_dlc(var_10_1):unlocked() then
			var_10_0 = false

			break
		end
	end

	arg_10_0._unlocked = var_10_0
end

UnlockDlcBundle.set_status_changed = function (arg_11_0, arg_11_1)
	arg_11_0._status_changed = arg_11_1
end

UnlockDlcBundle.is_cosmetic = function (arg_12_0)
	return false
end

UnlockDlcBundle.requires_restart = function (arg_13_0)
	return arg_13_0._status_changed and arg_13_0._requires_restart
end

UnlockDlcBundle.update_is_installed = function (arg_14_0)
	if not HAS_STEAM then
		return arg_14_0._installed
	end

	if arg_14_0._always_unlocked_for_app_id then
		return arg_14_0._installed
	end

	local var_14_0 = true

	for iter_14_0 = 1, #arg_14_0._bundle_contains do
		local var_14_1 = arg_14_0._bundle_contains[iter_14_0]
		local var_14_2 = UnlockSettings[1].unlocks[var_14_1]

		if not Steam.is_installed(var_14_2.id) then
			var_14_0 = false

			break
		end
	end

	if arg_14_0._installed ~= var_14_0 then
		arg_14_0._installed = var_14_0

		return var_14_0, true
	end

	return var_14_0
end
