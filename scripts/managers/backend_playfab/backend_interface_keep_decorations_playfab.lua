-- chunkname: @scripts/managers/backend_playfab/backend_interface_keep_decorations_playfab.lua

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceKeepDecorationsPlayFab = class(BackendInterfaceKeepDecorationsPlayFab)

BackendInterfaceKeepDecorationsPlayFab.init = function (self, backend_mirror)
	-- function 1
	self._backend_mirror = backend_mirror
	self._keep_decorations = {}

	local keep_decorations = not not backend_mirror:get_read_only_data("keep_decorations")

	self._keep_decorations = cjson.decode(keep_decorations)

	self:_refresh()

	for slot_name, painting in pairs(self._keep_decorations) do
		if painting ~= "hidden" and painting ~= "hor_none" and not table.contains(self._unlocked_keep_decorations, painting) then
			self._keep_decorations[slot_name] = "hor_none"
		end
	end
end

BackendInterfaceKeepDecorationsPlayFab.dirtify = function (self)
	-- function 2
	self._dirty = true
end

BackendInterfaceKeepDecorationsPlayFab.ready = function (self)
	-- function 3
	return true
end

BackendInterfaceKeepDecorationsPlayFab._refresh = function (self)
	-- function 4
	local mirror = self._backend_mirror
	local unlocked_keep_decorations = mirror:get_unlocked_keep_decorations()

	self._unlocked_keep_decorations = unlocked_keep_decorations

	local new_keep_decoration_ids = ItemHelper.get_new_keep_decoration_ids()

	if new_keep_decoration_ids then
		for keep_decoration_id, _ in pairs(new_keep_decoration_ids) do
			if not unlocked_keep_decorations[keep_decoration_id] then
				ItemHelper.unmark_keep_decoration_as_new(keep_decoration_id)
			end
		end
	end
end

BackendInterfaceKeepDecorationsPlayFab.update = function (self, dt)
	-- function 5
	return
end

BackendInterfaceKeepDecorationsPlayFab.get_decoration = function (self, slot_name)
	-- function 6
	return self._keep_decorations[slot_name]
end

BackendInterfaceKeepDecorationsPlayFab.set_decoration = function (self, slot_name, item_id)
	-- function 7
	self._keep_decorations[slot_name] = item_id
end

BackendInterfaceKeepDecorationsPlayFab.get_keep_decorations_json = function (self)
	-- function 8
	return cjson.encode(self._keep_decorations)
end

BackendInterfaceKeepDecorationsPlayFab.get_unlocked_keep_decorations = function (self)
	-- function 9
	if self._dirty then
		self:_refresh()
	end

	return self._unlocked_keep_decorations
end
