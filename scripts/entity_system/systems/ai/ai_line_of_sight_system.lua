-- chunkname: @scripts/entity_system/systems/ai/ai_line_of_sight_system.lua

AILineOfSightSystem = class(AILineOfSightSystem, ExtensionSystemBase)

local extensions = {
	"AILineOfSightExtension"
}

AILineOfSightSystem.init = function (self, context, system_name)
	-- function 1
	AILineOfSightSystem.super.init(self, context, system_name, extensions)

	self._is_server = context.is_server
	self._world = context.world
	self._physics_world = World.physics_world(self._world)
	self._extensions = {}
	self._frozen_extensions = {}
	self._num_raycasts = 0
end

AILineOfSightSystem.destroy = function (self)
	-- function 2
	return
end

AILineOfSightSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data)
	-- function 3
	ScriptUnit.add_extension(nil, unit, extension_name, self.NAME, extension_init_data)

	local extension = ScriptUnit.extension(unit, self.NAME)

	self._extensions[unit] = extension

	return extension
end

AILineOfSightSystem.on_remove_extension = function (self, unit, extension_name)
	-- function 4
	self._frozen_extensions[unit] = nil

	self:_cleanup_extension(unit, extension_name)
	ScriptUnit.remove_extension(unit, self.NAME)
end

AILineOfSightSystem.on_freeze_extension = function (self, unit, extension_name)
	-- function 5
	local extension = self._extensions[unit]

	fassert(extension, "Unit was already frozen.")

	if extension == nil then
		return
	end

	self._frozen_extensions[unit] = extension

	self:_cleanup_extension(unit, extension_name)
end

AILineOfSightSystem._cleanup_extension = function (self, unit, extension_name)
	-- function 6
	local extensions = self._extensions

	if extensions[unit] == nil then
		return
	end

	extensions[unit] = nil
end

AILineOfSightSystem.freeze = function (self, unit, extension_name, reason)
	-- function 7
	local frozen_extensions = self._frozen_extensions

	if self._frozen_extensions[unit] then
		return
	end

	local extension = self._extensions[unit]

	fassert(extension, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(unit, extension_name)

	frozen_extensions[unit] = extension
end

AILineOfSightSystem.unfreeze = function (self, unit)
	-- function 8
	local extension = self._frozen_extensions[unit]

	self._frozen_extensions[unit] = nil
	self._extensions[unit] = extension
end

AILineOfSightSystem.hot_join_sync = function (self, peer_id, player)
	-- function 9
	return
end

AILineOfSightSystem.extensions_ready = function (self, world, unit, extension_name)
	-- function 10
	local bb = BLACKBOARDS[unit]

	self._extensions[unit].blackboard = bb
end

AILineOfSightSystem.target_changed = function (self, unit)
	-- function 11
	self._extensions[unit].blackboard.has_line_of_sight = true
end

local is_win32 = PLATFORM == Application.WIN32
local num

if is_win32 then
	num = 10

	goto label_0_0
end

num = 2

local MAX_RAYCASTS = num

::label_0_0::

AILineOfSightSystem.update = function (self, context, t)
	-- function 12
	local dt = context.dt
	local unit_extensions = self._extensions

	while self._num_raycasts <= MAX_RAYCASTS do
		local current_unit = self._current_unit
		local unit, extension

		if current_unit == nil or unit_extensions[current_unit] then
			unit, extension = next(unit_extensions, current_unit)
		end

		if extension then
			local blackboard = extension.blackboard
			local success, num_raycasts = extension:has_line_of_sight(unit, blackboard)

			self._num_raycasts = self._num_raycasts + num_raycasts
			self._current_unit = unit
			blackboard.has_line_of_sight = success
		else
			self._current_unit = nil

			break
		end
	end

	self._num_raycasts = 0
end
