-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/action_throw_geheimnisnacht_2021.lua

ActionThrowGeheimnisnacht2021 = class(ActionThrowGeheimnisnacht2021, ActionBase)

ActionThrowGeheimnisnacht2021.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionThrowGeheimnisnacht2021.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

ActionThrowGeheimnisnacht2021.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionThrowGeheimnisnacht2021.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self.current_action = arg_2_1
	self.ammo_extension = ScriptUnit.extension(self.weapon_unit, "ammo_system")
end

ActionThrowGeheimnisnacht2021.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return
end

ActionThrowGeheimnisnacht2021.finish = function (self, arg_4_1)
	-- function 4
	if arg_4_1 ~= "action_complete" then
		return
	end

	local ammo_usage = self.current_action.ammo_usage

	self.ammo_extension:use_ammo(ammo_usage)
end
