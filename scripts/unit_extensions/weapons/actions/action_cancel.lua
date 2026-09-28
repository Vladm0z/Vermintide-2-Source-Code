-- chunkname: @scripts/unit_extensions/weapons/actions/action_cancel.lua

ActionCancel = class(ActionCancel, ActionBase)

ActionCancel.init = function (self, world, item_name, is_server, owner_unit, damage_unit, first_person_unit, weapon_unit, weapon_system)
	-- function 1
	ActionCancel.super.init(self, world, item_name, is_server, owner_unit, damage_unit, first_person_unit, weapon_unit, weapon_system)
end

ActionCancel.client_owner_start_action = function (self, new_action, t)
	-- function 2
	ActionCancel.super.client_owner_start_action(self, new_action, t)
end

ActionCancel.client_owner_post_update = function (self, dt, t, world, can_damage)
	-- function 3
	return
end

ActionCancel.finish = function (self, reason)
	-- function 4
	return
end
