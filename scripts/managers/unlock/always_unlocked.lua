-- chunkname: @scripts/managers/unlock/always_unlocked.lua

AlwaysUnlocked = class(AlwaysUnlocked)

AlwaysUnlocked.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	arg_1_0._name = arg_1_1
	arg_1_0._is_legacy_console_dlc = arg_1_7
	arg_1_0._id = arg_1_2 or "0"
end

AlwaysUnlocked.ready = function (arg_2_0)
	return true
end

AlwaysUnlocked.is_legacy_console_dlc = function (arg_3_0)
	return arg_3_0._is_legacy_console_dlc
end

AlwaysUnlocked.has_error = function (arg_4_0)
	return false
end

AlwaysUnlocked.id = function (arg_5_0)
	return arg_5_0._id
end

AlwaysUnlocked.set_status_changed = function (arg_6_0, arg_6_1)
	return
end

AlwaysUnlocked.backend_reward_id = function (arg_7_0)
	return
end

AlwaysUnlocked.remove_backend_reward_id = function (arg_8_0)
	return
end

AlwaysUnlocked.unlocked = function (arg_9_0)
	return true
end

AlwaysUnlocked.installed = function (arg_10_0)
	return true
end

AlwaysUnlocked.is_cosmetic = function (arg_11_0)
	return true
end

AlwaysUnlocked.requires_restart = function (arg_12_0)
	return false
end
