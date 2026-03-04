-- chunkname: @scripts/managers/unlock/unlock_clan.lua

require("scripts/helpers/steam_helper")

UnlockClan = class(UnlockClan)

function UnlockClan.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._name = arg_1_1
	arg_1_0._id = arg_1_2
	arg_1_0._backend_reward_id = arg_1_3
	arg_1_0._unlocked = false

	if rawget(_G, "Steam") and SteamHelper.clans()[arg_1_2] then
		arg_1_0._unlocked = true
	end
end

function UnlockClan.ready(arg_2_0)
	return true
end

function UnlockClan.has_error(arg_3_0)
	return false
end

function UnlockClan.id(arg_4_0)
	return arg_4_0._id
end

function UnlockClan.backend_reward_id(arg_5_0)
	return arg_5_0._backend_reward_id
end

function UnlockClan.remove_backend_reward_id(arg_6_0)
	arg_6_0._backend_reward_id = nil
end

function UnlockClan.set_status_changed(arg_7_0, arg_7_1)
	return
end

function UnlockClan.unlocked(arg_8_0)
	return arg_8_0._unlocked
end

function UnlockClan.installed(arg_9_0)
	return arg_9_0._unlocked
end

function UnlockClan.is_cosmetic(arg_10_0)
	return true
end
