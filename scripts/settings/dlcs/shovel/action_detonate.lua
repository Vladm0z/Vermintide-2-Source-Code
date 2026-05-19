-- chunkname: @scripts/settings/dlcs/shovel/action_detonate.lua

ActionDetonate = class(ActionDetonate, ActionBase)

function ActionDetonate.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionDetonate.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0.first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	arg_1_0.owner_buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	arg_1_0.hud_extension = ScriptUnit.has_extension(arg_1_4, "hud_system")
	arg_1_0.owner_unit = arg_1_4

	if arg_1_0.first_person_extension then
		arg_1_0.first_person_unit = arg_1_0.first_person_extension:get_first_person_unit()
	end

	arg_1_0._rumble_effect_id = false
	arg_1_0.unit_id = Managers.state.network.unit_storage:go_id(arg_1_4)
end

function ActionDetonate.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionDetonate.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = arg_2_1.detonate_delay_start
	local var_2_2 = arg_2_1.detonation_order
	local var_2_3 = Managers.state.entity:system("projectile_system")
	local var_2_4 = var_2_3:get_indexed_projectile_count(var_2_0)
	local var_2_5
	local var_2_6
	local var_2_7
	local var_2_8

	if var_2_2 == "front_first" then
		var_2_5 = var_2_4
		var_2_6 = math.max(var_2_4 - arg_2_1.num_to_detonate, 1)
		var_2_8 = -1
	else
		var_2_5 = 1
		var_2_6 = math.min(arg_2_1.num_to_detonate, var_2_4)
		var_2_8 = 1
	end

	local var_2_9 = false

	for iter_2_0 = var_2_5, var_2_6, var_2_8 do
		local var_2_10 = var_2_3:get_and_delete_indexed_projectile(var_2_0, iter_2_0, true)
		local var_2_11 = ScriptUnit.has_extension(var_2_10, "projectile_system")

		if var_2_11 then
			var_2_11:queue_delayed_external_event("detonate", arg_2_2 + var_2_1, true)

			var_2_1 = var_2_1 + arg_2_1.detonate_delay_increment
			var_2_9 = true
		end
	end

	if var_2_9 and arg_2_0.first_person_extension then
		arg_2_0.first_person_extension:animation_event("shake_minimal")
	end
end

function ActionDetonate.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

function ActionDetonate.finish(arg_4_0, arg_4_1)
	ActionDetonate.super.finish(arg_4_0, arg_4_1)
end

function ActionDetonate.destroy(arg_5_0)
	return
end
