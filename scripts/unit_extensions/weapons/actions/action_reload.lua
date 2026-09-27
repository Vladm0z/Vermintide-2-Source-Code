-- chunkname: @scripts/unit_extensions/weapons/actions/action_reload.lua

ActionReload = class(ActionReload, ActionBase)

ActionReload.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	self.weapon_system = arg_1_8
	self.owner_unit = arg_1_4
	self.first_person_unit = arg_1_6
	self.weapon_unit = arg_1_7
	self.world = arg_1_1
	self.item_name = arg_1_2
	self.wwise_world = Managers.world:wwise_world(arg_1_1)
	self.is_server = arg_1_3
end

ActionReload.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionReload.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local owner_unit = self.owner_unit
	local extension = ScriptUnit.extension(owner_unit, "inventory_system")
	local var_2_2
	local equipment = extension:equipment()

	if equipment.right_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.right_hand_wielded_unit, "ammo_system") then
		var_2_2 = ScriptUnit.extension(equipment.right_hand_wielded_unit, "ammo_system")
	elseif equipment.left_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.left_hand_wielded_unit, "ammo_system") then
		var_2_2 = ScriptUnit.extension(equipment.left_hand_wielded_unit, "ammo_system")
	end

	local flag = true

	var_2_2:start_reload(flag)
end

ActionReload.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return
end

ActionReload.finish = function (arg_4_0, arg_4_1)
	-- function 4
	return
end
