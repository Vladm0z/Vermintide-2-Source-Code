-- chunkname: @scripts/unit_extensions/weapons/actions/action_catch.lua

ActionCatch = class(ActionCatch, ActionBase)

ActionCatch.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCatch.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

ActionCatch.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ActionCatch.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	local var_2_0 = arg_2_0.owner_unit

	arg_2_0._inventory_extension = ScriptUnit.extension(var_2_0, "inventory_system")

	local var_2_1 = ActionUtils.get_action_time_scale(var_2_0, arg_2_1)

	arg_2_0._catch_time = arg_2_2 + (arg_2_1.catch_time or 0) * (1 / var_2_1)
	arg_2_0._state = "waiting_to_catch"
	arg_2_0._should_not_remove = arg_2_1.should_not_remove

	if not arg_2_0._should_not_remove then
		arg_2_0:_remove_pickup()
	end
end

ActionCatch.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_0._state == "waiting_to_catch" and arg_3_2 >= arg_3_0._catch_time then
		arg_3_0:_add_ammo()

		arg_3_0._state = "caught"
	end
end

ActionCatch._remove_pickup = function (arg_4_0)
	if arg_4_0._inventory_extension then
		local var_4_0 = false
		local var_4_1 = Network.peer_id()
		local var_4_2 = 1
		local var_4_3 = Managers.state.entity:system("pickup_system"):get_and_delete_limited_owned_pickup_with_index(var_4_1, var_4_2)

		if var_4_3 and Unit.alive(var_4_3) then
			var_4_0 = true

			Unit.flow_event(var_4_3, "lua_recall")
		end

		if not var_4_0 then
			local var_4_4 = Managers.state.entity:system("projectile_system"):get_and_delete_indexed_projectile(arg_4_0.owner_unit, var_4_2)

			if var_4_4 and Unit.alive(var_4_4) then
				Unit.flow_event(var_4_4, "lua_recall")
			end
		end
	end
end

ActionCatch._add_ammo = function (arg_5_0)
	local var_5_0 = arg_5_0._inventory_extension
	local var_5_1
	local var_5_2 = var_5_0:equipment().slots.slot_ranged

	if var_5_2 then
		local var_5_3 = var_5_2.left_unit_1p
		local var_5_4 = var_5_3 and ScriptUnit.has_extension(var_5_3, "ammo_system")

		if var_5_4 then
			var_5_1 = var_5_4
		end

		local var_5_5 = var_5_2.right_unit_1p
		local var_5_6 = var_5_5 and ScriptUnit.has_extension(var_5_5, "ammo_system")

		if var_5_6 then
			var_5_1 = var_5_6
		end
	end

	if var_5_1 then
		if var_5_1:total_remaining_ammo() == 0 then
			Unit.animation_event(arg_5_0.first_person_unit, "to_ammo")
		end

		local var_5_7 = 1

		var_5_1:add_ammo(var_5_7)

		if var_5_1:current_ammo() == 0 then
			local var_5_8 = false

			var_5_1:start_reload(var_5_8)
		end
	end
end

ActionCatch.finish = function (arg_6_0, arg_6_1)
	return
end
