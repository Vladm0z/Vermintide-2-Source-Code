-- chunkname: @scripts/unit_extensions/weapons/actions/action_one_time_consumable.lua

ActionOneTimeConsumable = class(ActionOneTimeConsumable, ActionBase)

function ActionOneTimeConsumable.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionOneTimeConsumable.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0._ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
end

function ActionOneTimeConsumable.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
	ActionOneTimeConsumable.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0.current_action = arg_2_1
end

function ActionOneTimeConsumable.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

function ActionOneTimeConsumable.finish(arg_4_0, arg_4_1)
	if arg_4_1 ~= "action_complete" and arg_4_1 ~= "hungover" then
		return
	end

	local var_4_0 = arg_4_0.owner_unit
	local var_4_1 = arg_4_0.current_action
	local var_4_2 = var_4_1.buff_template

	if var_4_2 then
		local var_4_3 = arg_4_0.network_manager
		local var_4_4 = NetworkLookup.buff_templates[var_4_2]
		local var_4_5 = var_4_3:unit_game_object_id(var_4_0)

		if arg_4_0.is_server then
			arg_4_0._buff_extension:add_buff(var_4_2)
			var_4_3.network_transmit:send_rpc_clients("rpc_add_buff", var_4_5, var_4_4, var_4_5, 0, false)
		else
			var_4_3.network_transmit:send_rpc_server("rpc_add_buff", var_4_5, var_4_4, var_4_5, 0, true)
		end
	end

	local var_4_6 = arg_4_0._ammo_extension

	if var_4_6 then
		local var_4_7 = var_4_1.ammo_usage

		var_4_6:use_ammo(var_4_7)
	end
end
