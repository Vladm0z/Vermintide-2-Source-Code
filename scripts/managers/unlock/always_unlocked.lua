-- chunkname: @scripts/managers/unlock/always_unlocked.lua

AlwaysUnlocked = class(AlwaysUnlocked)

function AlwaysUnlocked.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	arg_1_0._name = arg_1_1
	arg_1_0._is_legacy_console_dlc = arg_1_7
	arg_1_0._id = arg_1_2 or "0"
end

function AlwaysUnlocked.ready(arg_2_0)
	return true
end

function AlwaysUnlocked.is_legacy_console_dlc(arg_3_0)
	return arg_3_0._is_legacy_console_dlc
end

function AlwaysUnlocked.has_error(arg_4_0)
	return false
end

function AlwaysUnlocked.id(arg_5_0)
	return arg_5_0._id
end

function AlwaysUnlocked.set_status_changed(arg_6_0, arg_6_1)
	return
end

function AlwaysUnlocked.backend_reward_id(arg_7_0)
	return
end

function AlwaysUnlocked.remove_backend_reward_id(arg_8_0)
	return
end

function AlwaysUnlocked.unlocked(arg_9_0)
	return true
end

function AlwaysUnlocked.installed(arg_10_0)
	return true
end

function AlwaysUnlocked.is_cosmetic(arg_11_0)
	return true
end

function AlwaysUnlocked.requires_restart(arg_12_0)
	return false
end
