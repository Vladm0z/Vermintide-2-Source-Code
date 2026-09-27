-- chunkname: @scripts/entity_system/systems/animation/aim_system.lua

require("scripts/unit_extensions/generic/generic_unit_aim_extension")

local tbl = {}
local tbl_2 = {
	"GenericUnitAimExtension"
}

AimSystem = class(AimSystem, ExtensionSystemBase)

AimSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	AimSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	self._extensions = {}
	self._frozen_extensions = {}
end

AimSystem.destroy = function (arg_2_0)
	-- function 2
	return
end

AimSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local add_extension = ScriptUnit.add_extension(self.extension_init_context, arg_3_2, arg_3_3, self.NAME, arg_3_4)

	self._extensions[arg_3_2] = add_extension

	return add_extension
end

AimSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._frozen_extensions[arg_4_1] = nil
	self._extensions[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, self.NAME)
end

AimSystem.on_freeze_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = self._extensions[arg_5_1]

	fassert(var_5_0, "Unit was already frozen.")
	var_5_0.template[var_5_0.network_type].leave(var_5_0.unit, var_5_0.data)

	self._frozen_extensions[arg_5_1] = var_5_0
	self._extensions[arg_5_1] = nil

	table.clear(var_5_0.data)
end

AimSystem.freeze = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local _frozen_extensions = self._frozen_extensions

	if not _frozen_extensions[arg_6_1] then
		return
	end

	local var_6_1 = self._extensions[arg_6_1]

	fassert(var_6_1, "Unit to freeze didn't have unfrozen extension")

	self._extensions[arg_6_1] = nil
	_frozen_extensions[arg_6_1] = var_6_1

	table.clear(var_6_1.data)
end

AimSystem.unfreeze = function (self, arg_7_1)
	-- function 7
	local var_7_0 = self._frozen_extensions[arg_7_1]

	fassert(var_7_0, "Unit to unfreeze didn't have frozen extension")

	self._frozen_extensions[arg_7_1] = nil
	self._extensions[arg_7_1] = var_7_0
	var_7_0.enabled = false

	var_7_0.template[var_7_0.network_type].init(var_7_0.unit, var_7_0.data)
end

AimSystem.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	local dt = arg_8_1.dt

	for k, v in pairs(self._extensions) do
		v:update(k, nil, dt, arg_8_1, arg_8_2)
	end
end
