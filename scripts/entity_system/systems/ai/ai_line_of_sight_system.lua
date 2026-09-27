-- chunkname: @scripts/entity_system/systems/ai/ai_line_of_sight_system.lua

AILineOfSightSystem = class(AILineOfSightSystem, ExtensionSystemBase)

local tbl = {
	"AILineOfSightExtension"
}

AILineOfSightSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	AILineOfSightSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self._is_server = arg_1_1.is_server
	self._world = arg_1_1.world
	self._physics_world = World.physics_world(self._world)
	self._extensions = {}
	self._frozen_extensions = {}
	self._num_raycasts = 0
end

AILineOfSightSystem.destroy = function (arg_2_0)
	-- function 2
	return
end

AILineOfSightSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	ScriptUnit.add_extension(nil, arg_3_2, arg_3_3, self.NAME, arg_3_4)

	local extension = ScriptUnit.extension(arg_3_2, self.NAME)

	self._extensions[arg_3_2] = extension

	return extension
end

AILineOfSightSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._frozen_extensions[arg_4_1] = nil

	self:_cleanup_extension(arg_4_1, arg_4_2)
	ScriptUnit.remove_extension(arg_4_1, self.NAME)
end

AILineOfSightSystem.on_freeze_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = self._extensions[arg_5_1]

	fassert(var_5_0, "Unit was already frozen.")

	if var_5_0 == nil then
		return
	end

	self._frozen_extensions[arg_5_1] = var_5_0

	self:_cleanup_extension(arg_5_1, arg_5_2)
end

AILineOfSightSystem._cleanup_extension = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _extensions = self._extensions

	if _extensions[arg_6_1] == nil then
		return
	end

	_extensions[arg_6_1] = nil
end

AILineOfSightSystem.freeze = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local _frozen_extensions = self._frozen_extensions

	if not self._frozen_extensions[arg_7_1] then
		return
	end

	local var_7_1 = self._extensions[arg_7_1]

	fassert(var_7_1, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(arg_7_1, arg_7_2)

	_frozen_extensions[arg_7_1] = var_7_1
end

AILineOfSightSystem.unfreeze = function (self, arg_8_1)
	-- function 8
	local var_8_0 = self._frozen_extensions[arg_8_1]

	self._frozen_extensions[arg_8_1] = nil
	self._extensions[arg_8_1] = var_8_0
end

AILineOfSightSystem.hot_join_sync = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

AILineOfSightSystem.extensions_ready = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local var_10_0 = BLACKBOARDS[arg_10_2]

	arg_10_0._extensions[arg_10_2].blackboard = var_10_0
end

AILineOfSightSystem.target_changed = function (arg_11_0, arg_11_1)
	-- function 11
	arg_11_0._extensions[arg_11_1].blackboard.has_line_of_sight = true
end

local flag

flag = not (PLATFORM == Application.WIN32) and 10 and 2

AILineOfSightSystem.update = function (self, arg_12_1, arg_12_2)
	-- function 12
	local dt = arg_12_1.dt
	local _extensions = self._extensions

	while self._num_raycasts <= flag do
		local _current_unit = self._current_unit
		local var_12_3
		local var_12_4

		if _current_unit == nil or not _extensions[_current_unit] then
			var_12_3, var_12_4 = next(_extensions, _current_unit)
		end

		if not var_12_4 then
			local blackboard = var_12_4.blackboard
			local has_line_of_sight, var_12_7 = var_12_4:has_line_of_sight(var_12_3, blackboard)

			self._num_raycasts = self._num_raycasts + var_12_7
			self._current_unit = var_12_3
			blackboard.has_line_of_sight = has_line_of_sight
		else
			self._current_unit = nil

			break
		end
	end

	self._num_raycasts = 0
end
