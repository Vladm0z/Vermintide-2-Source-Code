-- chunkname: @scripts/managers/backend_playfab/backend_interface_keep_decorations_playfab.lua

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceKeepDecorationsPlayFab = class(BackendInterfaceKeepDecorationsPlayFab)

BackendInterfaceKeepDecorationsPlayFab.init = function (self, arg_1_1)
	-- function 1
	self._backend_mirror = arg_1_1
	self._keep_decorations = {}

	local get_read_only_data = arg_1_1:get_read_only_data("keep_decorations")

	get_read_only_data = get_read_only_data or "{}"
	self._keep_decorations = cjson.decode(get_read_only_data)

	self:_refresh()

	for k, v in pairs(self._keep_decorations) do
		if not (v == "hidden" or v == "hor_none" or table.contains(self._unlocked_keep_decorations, v)) then
			self._keep_decorations[k] = "hor_none"
		end
	end
end

BackendInterfaceKeepDecorationsPlayFab.dirtify = function (self)
	-- function 2
	self._dirty = true
end

BackendInterfaceKeepDecorationsPlayFab.ready = function (arg_3_0)
	-- function 3
	return true
end

BackendInterfaceKeepDecorationsPlayFab._refresh = function (self)
	-- function 4
	local get_unlocked_keep_decorations = self._backend_mirror:get_unlocked_keep_decorations()

	self._unlocked_keep_decorations = get_unlocked_keep_decorations

	local get_new_keep_decoration_ids = ItemHelper.get_new_keep_decoration_ids()

	if not get_new_keep_decoration_ids then
		for k, v in pairs(get_new_keep_decoration_ids) do
			if not get_unlocked_keep_decorations[k] then
				ItemHelper.unmark_keep_decoration_as_new(k)
			end
		end
	end
end

BackendInterfaceKeepDecorationsPlayFab.update = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

BackendInterfaceKeepDecorationsPlayFab.get_decoration = function (self, arg_6_1)
	-- function 6
	return self._keep_decorations[arg_6_1]
end

BackendInterfaceKeepDecorationsPlayFab.set_decoration = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	arg_7_0._keep_decorations[arg_7_1] = arg_7_2
end

BackendInterfaceKeepDecorationsPlayFab.get_keep_decorations_json = function (self)
	-- function 8
	return cjson.encode(self._keep_decorations)
end

BackendInterfaceKeepDecorationsPlayFab.get_unlocked_keep_decorations = function (self)
	-- function 9
	if not self._dirty then
		self:_refresh()
	end

	return self._unlocked_keep_decorations
end
