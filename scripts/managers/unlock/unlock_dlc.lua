-- chunkname: @scripts/managers/unlock/unlock_dlc.lua

UnlockDlc = class(UnlockDlc)

function UnlockDlc.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	arg_1_0._name = arg_1_1
	arg_1_0._id = arg_1_2
	arg_1_0._backend_reward_id = arg_1_3
	arg_1_0._installed = false
	arg_1_0._owned = false
	arg_1_0._cosmetic = arg_1_5
	arg_1_0._requires_restart = arg_1_7
	arg_1_0._status_changed = false

	if HAS_STEAM and arg_1_4 then
		local var_1_0 = Steam.app_id()

		if var_1_0 and table.contains(arg_1_4, var_1_0) then
			arg_1_0._always_unlocked_for_app_id = true
			arg_1_0._installed = true
		end
	end

	arg_1_0:update_is_installed()
end

function UnlockDlc.is_legacy_console_dlc(arg_2_0)
	return false
end

function UnlockDlc.ready(arg_3_0)
	return true
end

function UnlockDlc.has_error(arg_4_0)
	return false
end

function UnlockDlc.id(arg_5_0)
	return arg_5_0._id
end

function UnlockDlc.backend_reward_id(arg_6_0)
	return arg_6_0._backend_reward_id
end

function UnlockDlc.remove_backend_reward_id(arg_7_0)
	arg_7_0._backend_reward_id = nil
end

function UnlockDlc.unlocked(arg_8_0)
	return arg_8_0._installed and arg_8_0._owned
end

function UnlockDlc.installed(arg_9_0)
	return arg_9_0._installed
end

function UnlockDlc.set_owned(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_2 == nil or arg_10_2 then
		arg_10_0._status_changed = arg_10_0._status_changed or arg_10_1 ~= arg_10_0._owned
	end

	arg_10_0._owned = arg_10_1
end

function UnlockDlc.set_status_changed(arg_11_0, arg_11_1)
	arg_11_0._status_changed = arg_11_1
end

function UnlockDlc.update_is_installed(arg_12_0)
	if not HAS_STEAM then
		return arg_12_0._installed
	end

	if arg_12_0._always_unlocked_for_app_id then
		return arg_12_0._installed
	end

	local var_12_0 = Steam.is_installed(arg_12_0._id)

	if arg_12_0._installed ~= var_12_0 then
		arg_12_0._installed = var_12_0

		return var_12_0, true
	end

	return var_12_0
end

function UnlockDlc.is_cosmetic(arg_13_0)
	return arg_13_0._cosmetic
end

function UnlockDlc.requires_restart(arg_14_0)
	return arg_14_0._status_changed and arg_14_0._requires_restart
end
