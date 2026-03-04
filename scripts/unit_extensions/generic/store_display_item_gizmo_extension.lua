-- chunkname: @scripts/unit_extensions/generic/store_display_item_gizmo_extension.lua

StoreDisplayItemGizmoExtension = class(StoreDisplayItemGizmoExtension)

StoreDisplayItemGizmoExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._gizmo_unit = arg_1_2
	arg_1_0._world = arg_1_1.world

	local var_1_0 = Unit.get_data(arg_1_2, "store_display_key")
	local var_1_1 = Managers.backend:get_interface("peddler"):store_display_items()
	local var_1_2 = var_1_1 and var_1_1[var_1_0]

	if var_1_2 then
		arg_1_0:spawn_prop(var_1_2)
	elseif Unit.get_data(arg_1_2, "hide_if_empty") then
		Unit.set_unit_visibility(arg_1_2, false)
		Unit.disable_physics(arg_1_2)
	end
end

StoreDisplayItemGizmoExtension.cb_display_item_loaded = function (arg_2_0)
	local var_2_0 = arg_2_0._gizmo_unit
	local var_2_1 = "ap_hat"
	local var_2_2 = 0

	if Unit.has_node(var_2_0, var_2_1) then
		var_2_2 = Unit.node(var_2_0, var_2_1)
	end

	local var_2_3 = arg_2_0._world
	local var_2_4 = Unit.world_pose(var_2_0, var_2_2)
	local var_2_5 = World.spawn_unit(var_2_3, arg_2_0._display_unit_name, var_2_4)

	arg_2_0._display_unit = var_2_5

	World.link_unit(var_2_3, var_2_5, var_2_0, var_2_2)
end

StoreDisplayItemGizmoExtension.spawn_prop = function (arg_3_0, arg_3_1)
	local var_3_0 = ItemMasterList[arg_3_1]

	if var_3_0 then
		local var_3_1 = var_3_0.unit

		if not var_3_1 then
			var_3_1 = var_3_0.left_hand_unit or var_3_0.right_hand_unit
			var_3_1 = var_3_1 and var_3_1 .. "_3p"
		end

		print("[StoreDisplayItemGizmoExtension] spawn prop", arg_3_1, var_3_1)

		if var_3_1 then
			arg_3_0._display_unit_name = var_3_1

			local var_3_2 = callback(arg_3_0, "cb_display_item_loaded", var_3_1)

			Managers.package:load(var_3_1, "StoreDisplayItemGizmoExtension", var_3_2, true, true)
		end
	else
		print("[StoreDisplayItemGizmoExtension] can't find master_item_id", arg_3_1)
	end
end

StoreDisplayItemGizmoExtension.destroy = function (arg_4_0)
	if Unit.alive(arg_4_0._display_unit) then
		World.destroy_unit(arg_4_0._world, arg_4_0._display_unit)
	end

	if arg_4_0._display_unit_name then
		Managers.package:unload(arg_4_0._display_unit_name, "StoreDisplayItemGizmoExtension")
	end
end
