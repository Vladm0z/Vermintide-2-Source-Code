-- chunkname: @scripts/entity_system/systems/ai/ai_line_of_sight_system.lua

AILineOfSightSystem = class(AILineOfSightSystem, ExtensionSystemBase)

local var_0_0 = {
	"AILineOfSightExtension"
}

AILineOfSightSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	AILineOfSightSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._world = arg_1_1.world
	arg_1_0._physics_world = World.physics_world(arg_1_0._world)
	arg_1_0._extensions = {}
	arg_1_0._frozen_extensions = {}
	arg_1_0._num_raycasts = 0
end

AILineOfSightSystem.destroy = function (arg_2_0)
	return
end

AILineOfSightSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	ScriptUnit.add_extension(nil, arg_3_2, arg_3_3, arg_3_0.NAME, arg_3_4)

	local var_3_0 = ScriptUnit.extension(arg_3_2, arg_3_0.NAME)

	arg_3_0._extensions[arg_3_2] = var_3_0

	return var_3_0
end

AILineOfSightSystem.on_remove_extension = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._frozen_extensions[arg_4_1] = nil

	arg_4_0:_cleanup_extension(arg_4_1, arg_4_2)
	ScriptUnit.remove_extension(arg_4_1, arg_4_0.NAME)
end

AILineOfSightSystem.on_freeze_extension = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._extensions[arg_5_1]

	fassert(var_5_0, "Unit was already frozen.")

	if var_5_0 == nil then
		return
	end

	arg_5_0._frozen_extensions[arg_5_1] = var_5_0

	arg_5_0:_cleanup_extension(arg_5_1, arg_5_2)
end

AILineOfSightSystem._cleanup_extension = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._extensions

	if var_6_0[arg_6_1] == nil then
		return
	end

	var_6_0[arg_6_1] = nil
end

AILineOfSightSystem.freeze = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0._frozen_extensions

	if arg_7_0._frozen_extensions[arg_7_1] then
		return
	end

	local var_7_1 = arg_7_0._extensions[arg_7_1]

	fassert(var_7_1, "Unit to freeze didn't have unfrozen extension")
	arg_7_0:_cleanup_extension(arg_7_1, arg_7_2)

	var_7_0[arg_7_1] = var_7_1
end

AILineOfSightSystem.unfreeze = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._frozen_extensions[arg_8_1]

	arg_8_0._frozen_extensions[arg_8_1] = nil
	arg_8_0._extensions[arg_8_1] = var_8_0
end

AILineOfSightSystem.hot_join_sync = function (arg_9_0, arg_9_1, arg_9_2)
	return
end

AILineOfSightSystem.extensions_ready = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = BLACKBOARDS[arg_10_2]

	arg_10_0._extensions[arg_10_2].blackboard = var_10_0
end

AILineOfSightSystem.target_changed = function (arg_11_0, arg_11_1)
	arg_11_0._extensions[arg_11_1].blackboard.has_line_of_sight = true
end

local var_0_1 = PLATFORM == Application.WIN32 and 10 or 2

AILineOfSightSystem.update = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_1.dt
	local var_12_1 = arg_12_0._extensions

	while arg_12_0._num_raycasts <= var_0_1 do
		local var_12_2 = arg_12_0._current_unit
		local var_12_3
		local var_12_4

		if var_12_2 == nil or var_12_1[var_12_2] then
			var_12_3, var_12_4 = next(var_12_1, var_12_2)
		end

		if var_12_4 then
			local var_12_5 = var_12_4.blackboard
			local var_12_6, var_12_7 = var_12_4:has_line_of_sight(var_12_3, var_12_5)

			arg_12_0._num_raycasts = arg_12_0._num_raycasts + var_12_7
			arg_12_0._current_unit = var_12_3
			var_12_5.has_line_of_sight = var_12_6
		else
			arg_12_0._current_unit = nil

			break
		end
	end

	arg_12_0._num_raycasts = 0
end
