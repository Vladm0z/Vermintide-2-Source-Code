-- chunkname: @scripts/entity_system/systems/animation/animation_movement_system.lua

require("scripts/unit_extensions/generic/generic_unit_animation_movement_extension")

local tbl = {
	"rpc_enable_animation_movement_system"
}
local tbl_2 = {
	"GenericUnitAnimationMovementExtension"
}

AnimationMovementSystem = class(AnimationMovementSystem, ExtensionSystemBase)

AnimationMovementSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	AnimationMovementSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	self._extensions = {}
	self._frozen_extensions = {}

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))
end

AnimationMovementSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

AnimationMovementSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local add_extension = ScriptUnit.add_extension(self.extension_init_context, arg_3_2, arg_3_3, self.NAME, arg_3_4)

	self._extensions[arg_3_2] = add_extension

	return add_extension
end

AnimationMovementSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._frozen_extensions[arg_4_1] = nil
	self._extensions[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, self.NAME)
end

AnimationMovementSystem.on_freeze_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = self._extensions[arg_5_1]

	fassert(var_5_0, "Unit was already frozen.")

	if var_5_0 == nil then
		return
	end

	self._frozen_extensions[arg_5_1] = var_5_0
	self._extensions[arg_5_1] = nil

	table.clear(var_5_0.data)
end

AnimationMovementSystem.freeze = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local _frozen_extensions = self._frozen_extensions

	if not self._frozen_extensions[arg_6_1] then
		return
	end

	local var_6_1 = self._extensions[arg_6_1]

	fassert(var_6_1, "Unit to freeze didn't have unfrozen extension")

	self._extensions[arg_6_1] = nil
	_frozen_extensions[arg_6_1] = var_6_1

	table.clear(var_6_1.data)
end

AnimationMovementSystem.unfreeze = function (self, arg_7_1)
	-- function 7
	local var_7_0 = self._frozen_extensions[arg_7_1]

	fassert(var_7_0, "Unit to unfreeze didn't have frozen extension")

	self._frozen_extensions[arg_7_1] = nil
	self._extensions[arg_7_1] = var_7_0
	var_7_0.enabled = false

	var_7_0.template[var_7_0.network_type].init(var_7_0.unit, var_7_0.data)
end

AnimationMovementSystem.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	local dt = arg_8_1.dt

	for k, v in pairs(self._extensions) do
		v:update(k, nil, dt, arg_8_1, arg_8_2)
	end
end

AnimationMovementSystem.rpc_enable_animation_movement_system = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local unit = self.unit_storage:unit(arg_9_2)
	local var_9_1 = self._extensions[unit]

	if not var_9_1 then
		var_9_1:set_enabled(arg_9_3)
	end
end
