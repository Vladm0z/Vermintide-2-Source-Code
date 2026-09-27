-- chunkname: @scripts/settings/dlcs/shovel/action_detonate.lua

ActionDetonate = class(ActionDetonate, ActionBase)

ActionDetonate.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionDetonate.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self.first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	self.owner_buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	self.hud_extension = ScriptUnit.has_extension(arg_1_4, "hud_system")
	self.owner_unit = arg_1_4

	if not self.first_person_extension then
		self.first_person_unit = self.first_person_extension:get_first_person_unit()
	end

	self._rumble_effect_id = false
	self.unit_id = Managers.state.network.unit_storage:go_id(arg_1_4)
end

ActionDetonate.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionDetonate.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local owner_unit = self.owner_unit
	local detonate_delay_start = arg_2_1.detonate_delay_start
	local detonation_order = arg_2_1.detonation_order
	local system = Managers.state.entity:system("projectile_system")
	local get_indexed_projectile_count = system:get_indexed_projectile_count(owner_unit)
	local var_2_5
	local var_2_6
	local var_2_7
	local num

	if detonation_order == "front_first" then
		var_2_5 = get_indexed_projectile_count
		var_2_6 = math.max(get_indexed_projectile_count - arg_2_1.num_to_detonate, 1)
		num = -1
	else
		var_2_5 = 1
		var_2_6 = math.min(arg_2_1.num_to_detonate, get_indexed_projectile_count)
		num = 1
	end

	local flag = false

	for i = var_2_5, var_2_6, num do
		local get_and_delete_indexed_projectile = system:get_and_delete_indexed_projectile(owner_unit, i, true)
		local has_extension = ScriptUnit.has_extension(get_and_delete_indexed_projectile, "projectile_system")

		if not has_extension then
			has_extension:queue_delayed_external_event("detonate", arg_2_2 + detonate_delay_start, true)

			detonate_delay_start = detonate_delay_start + arg_2_1.detonate_delay_increment
			flag = true
		end
	end

	if not flag and not self.first_person_extension then
		self.first_person_extension:animation_event("shake_minimal")
	end
end

ActionDetonate.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return
end

ActionDetonate.finish = function (arg_4_0, arg_4_1)
	-- function 4
	ActionDetonate.super.finish(arg_4_0, arg_4_1)
end

ActionDetonate.destroy = function (arg_5_0)
	-- function 5
	return
end
