-- chunkname: @scripts/entity_system/systems/objective/objective_item_spawner_system.lua

require("scripts/settings/objective_unit_templates")

ObjectiveItemSpawnerSystem = class(ObjectiveItemSpawnerSystem, ExtensionSystemBase)

ObjectiveItemSpawnerSystem.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	ObjectiveItemSpawnerSystem.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._item_spawners = {}
	arg_1_0._spawned_items = {}

	local var_1_0 = Managers.state.game_mode:setting("static_objective_item_spawners")

	if var_1_0 then
		for iter_1_0, iter_1_1 in pairs(var_1_0) do
			arg_1_0._item_spawners[iter_1_0] = iter_1_1
		end
	end

	arg_1_0._spawn_id = ""
	arg_1_0._unit_template_id = ""
end

ObjectiveItemSpawnerSystem.item_gizmo_spawned = function (arg_2_0, arg_2_1)
	local var_2_0, var_2_1 = arg_2_0:template_by_unit(arg_2_1)

	fassert(var_2_0, "[ObjectiveItemSpawnerSystem] All item spawners need a unit template")

	arg_2_0._item_spawners[var_2_1] = {
		unit = arg_2_1,
		unit_template = var_2_0
	}
end

ObjectiveItemSpawnerSystem.template_by_unit = function (arg_3_0, arg_3_1)
	local var_3_0 = Unit.get_data(arg_3_1, "objective_id")
	local var_3_1 = Unit.get_data(arg_3_1, "unit_template")

	var_3_0 = var_3_0 or Unit.get_data(arg_3_1, "versus_objective_id") or Unit.get_data(arg_3_1, "weave_objective_id")
	var_3_1 = var_3_1 or Unit.get_data(arg_3_1, "versus_unit_template") or Unit.get_data(arg_3_1, "weave_unit_template")

	return ObjectiveUnitTemplates[var_3_1], var_3_0
end

ObjectiveItemSpawnerSystem.spawn_item = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0._item_spawners[arg_4_1]

	if var_4_0 then
		local var_4_1, var_4_2 = arg_4_0:_trigger_spawn(var_4_0, arg_4_1, arg_4_2)

		if var_4_1 then
			arg_4_0._spawned_items[arg_4_1] = {
				unit = var_4_1,
				game_object_id = var_4_2
			}
		end
	end
end

ObjectiveItemSpawnerSystem._trigger_spawn = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_1.unit
	local var_5_1 = arg_5_1.unit_template
	local var_5_2 = var_5_0 and Unit.local_position(var_5_0, 0) or Vector3(0, 0, 0)
	local var_5_3 = var_5_0 and Unit.local_rotation(var_5_0, 0) or Quaternion(Vector3(0, 0, 0), -1)
	local var_5_4 = var_5_1.create_extension_init_data_func(arg_5_2, arg_5_3, var_5_0)
	local var_5_5, var_5_6 = arg_5_0:_spawn_unit(var_5_1, var_5_4, var_5_2, var_5_3)

	return var_5_5, var_5_6
end

ObjectiveItemSpawnerSystem._spawn_unit = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_1.unit_template_name
	local var_6_1 = arg_6_1.unit_name
	local var_6_2, var_6_3 = Managers.state.unit_spawner:spawn_network_unit(var_6_1, var_6_0, arg_6_2, arg_6_3, arg_6_4)

	return var_6_2, var_6_3
end

ObjectiveItemSpawnerSystem.destroy_objective = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._spawned_items[arg_7_1]

	if var_7_0 then
		Managers.state.unit_spawner:mark_for_deletion(var_7_0.unit)
	end
end
