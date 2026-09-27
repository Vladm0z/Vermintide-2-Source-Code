-- chunkname: @scripts/entity_system/systems/damage/hit_reaction_system.lua

HitReactionSystem = class(HitReactionSystem, ExtensionSystemBase)

local tbl = {
	"GenericHitReactionExtension"
}

HitReactionSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	HitReactionSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self.unit_extensions = {}
	self.frozen_unit_extensions = {}
end

HitReactionSystem.destroy = function (arg_2_0)
	-- function 2
	return
end

HitReactionSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local add_extension = ScriptUnit.add_extension(self.extension_init_context, arg_3_2, arg_3_3, self.NAME, arg_3_4)

	self.unit_extensions[arg_3_2] = add_extension

	return add_extension
end

HitReactionSystem.extensions_ready = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	return
end

HitReactionSystem.on_remove_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	self.frozen_unit_extensions[arg_5_1] = nil

	self:_cleanup_extension(arg_5_1, arg_5_2)
	ScriptUnit.remove_extension(arg_5_1, self.NAME)
end

HitReactionSystem.on_freeze_extension = function (self, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = self.unit_extensions[arg_6_1]

	fassert(var_6_0, "Unit was already frozen.")

	if var_6_0 == nil then
		return
	end

	self.frozen_unit_extensions[arg_6_1] = var_6_0

	self:_cleanup_extension(arg_6_1, arg_6_2)
end

HitReactionSystem._cleanup_extension = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	arg_7_0.unit_extensions[arg_7_1] = nil
end

HitReactionSystem.freeze = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	fassert(self.frozen_unit_extensions[arg_8_1] == nil, "Tried to freeze an already frozen unit.")

	local var_8_0 = self.unit_extensions[arg_8_1]

	fassert(var_8_0, "Unit to freeze didn't have unfrozen extension")

	self.unit_extensions[arg_8_1] = nil
	self.frozen_unit_extensions[arg_8_1] = var_8_0
end

HitReactionSystem.unfreeze = function (self, arg_9_1)
	-- function 9
	local var_9_0 = self.frozen_unit_extensions[arg_9_1]

	fassert(var_9_0, "Unit to unfreeze didn't have frozen extension")

	self.frozen_unit_extensions[arg_9_1] = nil
	self.unit_extensions[arg_9_1] = var_9_0

	var_9_0:unfreeze()
end

HitReactionSystem.hot_join_sync = function (arg_10_0, arg_10_1)
	-- function 10
	return
end

HitReactionSystem.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	local dt = arg_11_1.dt

	for k, v in pairs(self.unit_extensions) do
		v:update(k, nil, dt, arg_11_1, arg_11_2)
	end
end
