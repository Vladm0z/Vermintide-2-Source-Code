-- chunkname: @scripts/managers/unlock/unlock_clan.lua

require("scripts/helpers/steam_helper")

UnlockClan = class(UnlockClan)

UnlockClan.init = function (self, name, clan_id, backend_reward_id, always_unlocked_game_app_ids)
	-- function 1
	self._name = name
	self._id = clan_id
	self._backend_reward_id = backend_reward_id
	self._unlocked = false

	if rawget(_G, "Steam") then
		local clans = SteamHelper.clans()

		if clans[clan_id] then
			self._unlocked = true
		end
	end
end

UnlockClan.ready = function (self)
	-- function 2
	return true
end

UnlockClan.has_error = function (self)
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

UnlockClan.set_status_changed = function (self, value)
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

UnlockClan.is_cosmetic = function (self)
	-- function 10
	return true
end
