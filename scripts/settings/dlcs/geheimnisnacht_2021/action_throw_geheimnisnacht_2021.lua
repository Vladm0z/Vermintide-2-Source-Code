-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/action_throw_geheimnisnacht_2021.lua

ActionThrowGeheimnisnacht2021 = class(ActionThrowGeheimnisnacht2021, ActionBase)

ActionThrowGeheimnisnacht2021.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionThrowGeheimnisnacht2021.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

ActionThrowGeheimnisnacht2021.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2)
	ActionThrowGeheimnisnacht2021.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0.current_action = arg_2_1
	arg_2_0.ammo_extension = ScriptUnit.extension(arg_2_0.weapon_unit, "ammo_system")
end

ActionThrowGeheimnisnacht2021.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

ActionThrowGeheimnisnacht2021.finish = function (arg_4_0, arg_4_1)
	if arg_4_1 ~= "action_complete" then
		return
	end

	local var_4_0 = arg_4_0.current_action.ammo_usage

	arg_4_0.ammo_extension:use_ammo(var_4_0)
end
