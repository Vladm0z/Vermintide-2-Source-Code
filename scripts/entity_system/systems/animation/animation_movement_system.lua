-- chunkname: @scripts/entity_system/systems/animation/animation_movement_system.lua

require("scripts/unit_extensions/generic/generic_unit_animation_movement_extension")

local var_0_0 = {
	"rpc_enable_animation_movement_system"
}
local var_0_1 = {
	"GenericUnitAnimationMovementExtension"
}

AnimationMovementSystem = class(AnimationMovementSystem, ExtensionSystemBase)

function AnimationMovementSystem.init(arg_1_0, arg_1_1, arg_1_2)
	AnimationMovementSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	arg_1_0._extensions = {}
	arg_1_0._frozen_extensions = {}

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))
end

function AnimationMovementSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

function AnimationMovementSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = ScriptUnit.add_extension(arg_3_0.extension_init_context, arg_3_2, arg_3_3, arg_3_0.NAME, arg_3_4)

	arg_3_0._extensions[arg_3_2] = var_3_0

	return var_3_0
end

function AnimationMovementSystem.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._frozen_extensions[arg_4_1] = nil
	arg_4_0._extensions[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, arg_4_0.NAME)
end

function AnimationMovementSystem.on_freeze_extension(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._extensions[arg_5_1]

	fassert(var_5_0, "Unit was already frozen.")

	if var_5_0 == nil then
		return
	end

	arg_5_0._frozen_extensions[arg_5_1] = var_5_0
	arg_5_0._extensions[arg_5_1] = nil

	table.clear(var_5_0.data)
end

function AnimationMovementSystem.freeze(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0._frozen_extensions

	if arg_6_0._frozen_extensions[arg_6_1] then
		return
	end

	local var_6_1 = arg_6_0._extensions[arg_6_1]

	fassert(var_6_1, "Unit to freeze didn't have unfrozen extension")

	arg_6_0._extensions[arg_6_1] = nil
	var_6_0[arg_6_1] = var_6_1

	table.clear(var_6_1.data)
end

function AnimationMovementSystem.unfreeze(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._frozen_extensions[arg_7_1]

	fassert(var_7_0, "Unit to unfreeze didn't have frozen extension")

	arg_7_0._frozen_extensions[arg_7_1] = nil
	arg_7_0._extensions[arg_7_1] = var_7_0
	var_7_0.enabled = false

	var_7_0.template[var_7_0.network_type].init(var_7_0.unit, var_7_0.data)
end

function AnimationMovementSystem.update(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1.dt

	for iter_8_0, iter_8_1 in pairs(arg_8_0._extensions) do
		iter_8_1:update(iter_8_0, nil, var_8_0, arg_8_1, arg_8_2)
	end
end

function AnimationMovementSystem.rpc_enable_animation_movement_system(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0.unit_storage:unit(arg_9_2)
	local var_9_1 = arg_9_0._extensions[var_9_0]

	if var_9_1 then
		var_9_1:set_enabled(arg_9_3)
	end
end
