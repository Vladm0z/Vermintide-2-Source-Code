-- chunkname: @scripts/entity_system/systems/objective/objective_item_spawner_system.lua

require("scripts/settings/objective_unit_templates")

ObjectiveItemSpawnerSystem = class(ObjectiveItemSpawnerSystem, ExtensionSystemBase)

ObjectiveItemSpawnerSystem.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	ObjectiveItemSpawnerSystem.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._item_spawners = {}
	self._spawned_items = {}

	local setting = Managers.state.game_mode:setting("static_objective_item_spawners")

	if not setting then
		for k, v in pairs(setting) do
			self._item_spawners[k] = v
		end
	end

	self._spawn_id = ""
	self._unit_template_id = ""
end

ObjectiveItemSpawnerSystem.item_gizmo_spawned = function (self, arg_2_1)
	-- function 2
	local template_by_unit, var_2_1 = self:template_by_unit(arg_2_1)

	fassert(template_by_unit, "[ObjectiveItemSpawnerSystem] All item spawners need a unit template")

	self._item_spawners[var_2_1] = {
		unit = arg_2_1,
		unit_template = template_by_unit
	}
end

ObjectiveItemSpawnerSystem.template_by_unit = function (arg_3_0, arg_3_1)
	-- function 3
	local get_data = Unit.get_data(arg_3_1, "objective_id")
	local get_data_2 = Unit.get_data(arg_3_1, "unit_template")

	get_data = get_data or Unit.get_data(arg_3_1, "versus_objective_id") or Unit.get_data(arg_3_1, "weave_objective_id")
	get_data_2 = get_data_2 or Unit.get_data(arg_3_1, "versus_unit_template") or Unit.get_data(arg_3_1, "weave_unit_template")

	return ObjectiveUnitTemplates[get_data_2], get_data
end

ObjectiveItemSpawnerSystem.spawn_item = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = self._item_spawners[arg_4_1]

	if not var_4_0 then
		local _trigger_spawn, var_4_2 = self:_trigger_spawn(var_4_0, arg_4_1, arg_4_2)

		if not _trigger_spawn then
			self._spawned_items[arg_4_1] = {
				unit = _trigger_spawn,
				game_object_id = var_4_2
			}
		end
	end
end

ObjectiveItemSpawnerSystem._trigger_spawn = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local unit = arg_5_1.unit
	local unit_template = arg_5_1.unit_template
	local local_position

	if not unit then
		local_position = Unit.local_position(unit, 0)

		if not local_position then
			-- Nothing
		end
	end

	local_position = Vector3(0, 0, 0)

	do
		local local_rotation
	end

	::label_5_0::

	if not unit then
		local_rotation = Unit.local_rotation(unit, 0)

		if not local_rotation then
			-- Nothing
		end
	end

	local_rotation = Quaternion(Vector3(0, 0, 0), -1)

	::label_5_1::

	local create_extension_init_data_func = unit_template.create_extension_init_data_func(arg_5_2, arg_5_3, unit)
	local _spawn_unit, var_5_6 = self:_spawn_unit(unit_template, create_extension_init_data_func, local_position, local_rotation)

	return _spawn_unit, var_5_6
end

ObjectiveItemSpawnerSystem._spawn_unit = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local unit_template_name = arg_6_1.unit_template_name
	local unit_name = arg_6_1.unit_name
	local spawn_network_unit, var_6_3 = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, arg_6_2, arg_6_3, arg_6_4)

	return spawn_network_unit, var_6_3
end

ObjectiveItemSpawnerSystem.destroy_objective = function (self, arg_7_1)
	-- function 7
	local var_7_0 = self._spawned_items[arg_7_1]

	if not var_7_0 then
		Managers.state.unit_spawner:mark_for_deletion(var_7_0.unit)
	end
end
