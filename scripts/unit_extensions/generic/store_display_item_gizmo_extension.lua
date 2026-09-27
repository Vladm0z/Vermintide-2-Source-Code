-- chunkname: @scripts/unit_extensions/generic/store_display_item_gizmo_extension.lua

StoreDisplayItemGizmoExtension = class(StoreDisplayItemGizmoExtension)

StoreDisplayItemGizmoExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._gizmo_unit = arg_1_2
	self._world = arg_1_1.world

	local get_data = Unit.get_data(arg_1_2, "store_display_key")
	local store_display_items = Managers.backend:get_interface("peddler"):store_display_items()
	local flag = not store_display_items and store_display_items[get_data]

	if not flag then
		self:spawn_prop(flag)
	elseif not Unit.get_data(arg_1_2, "hide_if_empty") then
		Unit.set_unit_visibility(arg_1_2, false)
		Unit.disable_physics(arg_1_2)
	end
end

StoreDisplayItemGizmoExtension.cb_display_item_loaded = function (self)
	-- function 2
	local _gizmo_unit = self._gizmo_unit
	local str = "ap_hat"
	local num = 0

	if not Unit.has_node(_gizmo_unit, str) then
		num = Unit.node(_gizmo_unit, str)
	end

	local _world = self._world
	local world_pose = Unit.world_pose(_gizmo_unit, num)
	local spawn_unit = World.spawn_unit(_world, self._display_unit_name, world_pose)

	self._display_unit = spawn_unit

	World.link_unit(_world, spawn_unit, _gizmo_unit, num)
end

StoreDisplayItemGizmoExtension.spawn_prop = function (self, arg_3_1)
	-- function 3
	local var_3_0 = ItemMasterList[arg_3_1]

	if not var_3_0 then
		local unit = var_3_0.unit

		if not unit then
			unit = var_3_0.left_hand_unit or var_3_0.right_hand_unit
			unit = not unit and unit .. "_3p"
		end

		print("[StoreDisplayItemGizmoExtension] spawn prop", arg_3_1, unit)

		if not unit then
			self._display_unit_name = unit

			local var_3_2 = callback(self, "cb_display_item_loaded", unit)

			Managers.package:load(unit, "StoreDisplayItemGizmoExtension", var_3_2, true, true)
		end
	else
		print("[StoreDisplayItemGizmoExtension] can't find master_item_id", arg_3_1)
	end
end

StoreDisplayItemGizmoExtension.destroy = function (self)
	-- function 4
	if not Unit.alive(self._display_unit) then
		World.destroy_unit(self._world, self._display_unit)
	end

	if not self._display_unit_name then
		Managers.package:unload(self._display_unit_name, "StoreDisplayItemGizmoExtension")
	end
end
