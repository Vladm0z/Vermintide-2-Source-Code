-- chunkname: @scripts/settings/dlcs/bless/action_wheel_selector.lua

ActionWheelSelector = class(ActionWheelSelector, ActionBase)

local STOP_LERP_TIME = 0.125
local STOP_LERP_TIME_CONTROLLER = 0.25
local START_LERP_TIME = 0.01
local START_LERP_TIME_CONTROLLER = 0.125

ActionWheelSelector.init = function (self, world, item_name, is_server, owner_unit, damage_unit, first_person_unit, weapon_unit, weapon_system)
	-- function 1
	ActionWheelSelector.super.init(self, world, item_name, is_server, owner_unit, damage_unit, first_person_unit, weapon_unit, weapon_system)

	self.weapon_unit = weapon_unit
	self.weapon_extension = ScriptUnit.extension(weapon_unit, "weapon_system")
end

ActionWheelSelector.client_owner_start_action = function (self, new_action, t, chain_action_data, power_level, action_init_data)
	-- function 2
	ActionWheelSelector.super.client_owner_start_action(self, new_action, t, chain_action_data, power_level, action_init_data)

	self.timer_per_seg = new_action.timer_per_seg
	self.num_seg = new_action.num_seg
	self._timer = t + self.timer_per_seg

	local num

	if self.current_seg then
		num = self.current_seg + 1

		if not num then
			-- Nothing
		end
	end

	num = 1

	::label_2_0::

	self.current_seg = num

	if self.current_seg > self.num_seg then
		self.current_seg = 1
	end

	self.shader_info = new_action.shader_info
end

ActionWheelSelector.client_owner_post_update = function (self, dt, t, world, can_damage)
	-- function 3
	if t > self._timer then
		self.current_seg = self.current_seg + 1

		if self.current_seg > self.num_seg then
			self.current_seg = 1
		end

		self._timer = t + self.timer_per_seg
	end

	self.weapon_extension:set_mode(self.current_seg)

	if self.shader_info then
		local material_slot = self.shader_info.material_slot
		local variable_name = self.shader_info.variable_name

		Unit.set_scalar_for_material(self.weapon_unit, material_slot, variable_name, self.current_seg - 1)
	end
end

ActionWheelSelector.finish = function (self, reason, data)
	-- function 4
	ActionChangeMode.super.finish(self, reason)
end
