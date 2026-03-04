-- chunkname: @scripts/entity_system/systems/damage/hit_reaction_system.lua

HitReactionSystem = class(HitReactionSystem, ExtensionSystemBase)

local var_0_0 = {
	"GenericHitReactionExtension"
}

HitReactionSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	HitReactionSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0.unit_extensions = {}
	arg_1_0.frozen_unit_extensions = {}
end

HitReactionSystem.destroy = function (arg_2_0)
	return
end

HitReactionSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = ScriptUnit.add_extension(arg_3_0.extension_init_context, arg_3_2, arg_3_3, arg_3_0.NAME, arg_3_4)

	arg_3_0.unit_extensions[arg_3_2] = var_3_0

	return var_3_0
end

HitReactionSystem.extensions_ready = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	return
end

HitReactionSystem.on_remove_extension = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.frozen_unit_extensions[arg_5_1] = nil

	arg_5_0:_cleanup_extension(arg_5_1, arg_5_2)
	ScriptUnit.remove_extension(arg_5_1, arg_5_0.NAME)
end

HitReactionSystem.on_freeze_extension = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.unit_extensions[arg_6_1]

	fassert(var_6_0, "Unit was already frozen.")

	if var_6_0 == nil then
		return
	end

	arg_6_0.frozen_unit_extensions[arg_6_1] = var_6_0

	arg_6_0:_cleanup_extension(arg_6_1, arg_6_2)
end

HitReactionSystem._cleanup_extension = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.unit_extensions[arg_7_1] = nil
end

HitReactionSystem.freeze = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	fassert(arg_8_0.frozen_unit_extensions[arg_8_1] == nil, "Tried to freeze an already frozen unit.")

	local var_8_0 = arg_8_0.unit_extensions[arg_8_1]

	fassert(var_8_0, "Unit to freeze didn't have unfrozen extension")

	arg_8_0.unit_extensions[arg_8_1] = nil
	arg_8_0.frozen_unit_extensions[arg_8_1] = var_8_0
end

HitReactionSystem.unfreeze = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.frozen_unit_extensions[arg_9_1]

	fassert(var_9_0, "Unit to unfreeze didn't have frozen extension")

	arg_9_0.frozen_unit_extensions[arg_9_1] = nil
	arg_9_0.unit_extensions[arg_9_1] = var_9_0

	var_9_0:unfreeze()
end

HitReactionSystem.hot_join_sync = function (arg_10_0, arg_10_1)
	return
end

HitReactionSystem.update = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_1.dt

	for iter_11_0, iter_11_1 in pairs(arg_11_0.unit_extensions) do
		iter_11_1:update(iter_11_0, nil, var_11_0, arg_11_1, arg_11_2)
	end
end
