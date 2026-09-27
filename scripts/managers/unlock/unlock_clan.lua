-- chunkname: @scripts/managers/unlock/unlock_clan.lua

require("scripts/helpers/steam_helper")

UnlockClan = class(UnlockClan)

UnlockClan.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._name = arg_1_1
	self._id = arg_1_2
	self._backend_reward_id = arg_1_3
	self._unlocked = false

	if not rawget(_G, "Steam") and not SteamHelper.clans()[arg_1_2] then
		self._unlocked = true
	end
end

UnlockClan.ready = function (arg_2_0)
	-- function 2
	return true
end

UnlockClan.has_error = function (arg_3_0)
	-- function 3
	return false
end

UnlockClan.id = function (self)
	-- function 4
	return self._id
end

UnlockClan.backend_reward_id = function (self)
	-- function 5
	return self._backend_reward_id
end

UnlockClan.remove_backend_reward_id = function (self)
	-- function 6
	self._backend_reward_id = nil
end

UnlockClan.set_status_changed = function (arg_7_0, arg_7_1)
	-- function 7
	return
end

UnlockClan.unlocked = function (self)
	-- function 8
	return self._unlocked
end

UnlockClan.installed = function (self)
	-- function 9
	return self._unlocked
end

UnlockClan.is_cosmetic = function (arg_10_0)
	-- function 10
	return true
end
