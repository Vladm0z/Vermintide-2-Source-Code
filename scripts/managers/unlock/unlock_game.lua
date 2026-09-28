-- chunkname: @scripts/managers/unlock/unlock_game.lua

UnlockGame = class(UnlockGame)

UnlockGame.init = function (self, name, app_id, backend_reward_id, always_unlocked_game_app_ids, cosmetic)
	-- function 1
	return
end

UnlockGame.is_legacy_console_dlc = function (self)
	-- function 2
	return false
end

UnlockGame.cb_get_inventory_items_done = function (self, info)
	-- function 3
	return
end

UnlockGame.ready = function (self)
	-- function 4
	return true
end

UnlockGame.has_error = function (self)
	-- function 5
	return
end

UnlockGame.id = function (self)
	-- function 6
	return
end

UnlockGame.backend_reward_id = function (self)
	-- function 7
	return
end

UnlockGame.remove_backend_reward_id = function (self)
	-- function 8
	return
end

UnlockGame.set_status_changed = function (self, value)
	-- function 9
	return
end

UnlockGame.unlocked = function (self)
	-- function 10
	return
end

UnlockGame.installed = function (self)
	-- function 11
	return
end

UnlockGame.is_cosmetic = function (self)
	-- function 12
	return false
end

UnlockGame.requires_restart = function (self)
	-- function 13
	return false
end
