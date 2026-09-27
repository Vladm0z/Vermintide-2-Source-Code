-- chunkname: @scripts/unit_extensions/weapons/actions/action_catch.lua

ActionCatch = class(ActionCatch, ActionBase)

ActionCatch.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCatch.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

ActionCatch.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ActionCatch.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	local owner_unit = self.owner_unit

	self._inventory_extension = ScriptUnit.extension(owner_unit, "inventory_system")

	local get_action_time_scale = ActionUtils.get_action_time_scale(owner_unit, arg_2_1)
	local catch_time = arg_2_1.catch_time

	catch_time = catch_time or 0
	self._catch_time = arg_2_2 + catch_time * (1 / get_action_time_scale)
	self._state = "waiting_to_catch"
	self._should_not_remove = arg_2_1.should_not_remove

	if not self._should_not_remove then
		self:_remove_pickup()
	end
end

ActionCatch.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if not (self._state ~= "waiting_to_catch" or not (arg_3_2 >= self._catch_time)) then
		self:_add_ammo()

		self._state = "caught"
	end
end

ActionCatch._remove_pickup = function (self)
	-- function 4
	if not self._inventory_extension then
		local flag = false
		local peer_id = Network.peer_id()
		local num = 1
		local get_and_delete_limited_owned_pickup_with_index = Managers.state.entity:system("pickup_system"):get_and_delete_limited_owned_pickup_with_index(peer_id, num)

		if not get_and_delete_limited_owned_pickup_with_index and not Unit.alive(get_and_delete_limited_owned_pickup_with_index) then
			flag = true

			Unit.flow_event(get_and_delete_limited_owned_pickup_with_index, "lua_recall")
		end

		if not flag then
			local get_and_delete_indexed_projectile = Managers.state.entity:system("projectile_system"):get_and_delete_indexed_projectile(self.owner_unit, num)

			if not get_and_delete_indexed_projectile and not Unit.alive(get_and_delete_indexed_projectile) then
				Unit.flow_event(get_and_delete_indexed_projectile, "lua_recall")
			end
		end
	end
end

ActionCatch._add_ammo = function (self)
	-- function 5
	local _inventory_extension = self._inventory_extension
	local var_5_1
	local slot_ranged = _inventory_extension:equipment().slots.slot_ranged

	if not slot_ranged then
		local left_unit_1p = slot_ranged.left_unit_1p
		local flag = not left_unit_1p and ScriptUnit.has_extension(left_unit_1p, "ammo_system")

		if not flag then
			var_5_1 = flag
		end

		local right_unit_1p = slot_ranged.right_unit_1p
		local flag_2 = not right_unit_1p and ScriptUnit.has_extension(right_unit_1p, "ammo_system")

		if not flag_2 then
			var_5_1 = flag_2
		end
	end

	if not var_5_1 then
		if var_5_1:total_remaining_ammo() == 0 then
			Unit.animation_event(self.first_person_unit, "to_ammo")
		end

		local num = 1

		var_5_1:add_ammo(num)

		if var_5_1:current_ammo() == 0 then
			local flag_3 = false

			var_5_1:start_reload(flag_3)
		end
	end
end

ActionCatch.finish = function (arg_6_0, arg_6_1)
	-- function 6
	return
end
