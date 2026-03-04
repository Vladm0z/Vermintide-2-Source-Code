-- chunkname: @scripts/managers/unlock/unlock_clan.lua

require("scripts/helpers/steam_helper")

UnlockClan = class(UnlockClan)

UnlockClan.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._name = arg_1_1
	arg_1_0._id = arg_1_2
	arg_1_0._backend_reward_id = arg_1_3
	arg_1_0._unlocked = false

	if rawget(_G, "Steam") and SteamHelper.clans()[arg_1_2] then
		arg_1_0._unlocked = true
	end
end

UnlockClan.ready = function (arg_2_0)
	return true
end

UnlockClan.has_error = function (arg_3_0)
	return false
end

UnlockClan.id = function (arg_4_0)
	return arg_4_0._id
end

UnlockClan.backend_reward_id = function (arg_5_0)
	return arg_5_0._backend_reward_id
end

UnlockClan.remove_backend_reward_id = function (arg_6_0)
	arg_6_0._backend_reward_id = nil
end

UnlockClan.set_status_changed = function (arg_7_0, arg_7_1)
	return
end

UnlockClan.unlocked = function (arg_8_0)
	return arg_8_0._unlocked
end

UnlockClan.installed = function (arg_9_0)
	return arg_9_0._unlocked
end

UnlockClan.is_cosmetic = function (arg_10_0)
	return true
end
