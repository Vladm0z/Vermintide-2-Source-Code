-- chunkname: @scripts/settings/dlcs/bless/action_wheel_selector.lua

ActionWheelSelector = class(ActionWheelSelector, ActionBase)

local num = 0.125
local num_2 = 0.25
local num_3 = 0.01
local num_4 = 0.125

ActionWheelSelector.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionWheelSelector.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.weapon_unit = arg_1_7
	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
end

ActionWheelSelector.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ActionWheelSelector.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	self.timer_per_seg = arg_2_1.timer_per_seg
	self.num_seg = arg_2_1.num_seg
	self._timer = arg_2_2 + self.timer_per_seg

	local num

	if not self.current_seg then
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

	self.shader_info = arg_2_1.shader_info
end

ActionWheelSelector.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if arg_3_2 > self._timer then
		self.current_seg = self.current_seg + 1

		if self.current_seg > self.num_seg then
			self.current_seg = 1
		end

		self._timer = arg_3_2 + self.timer_per_seg
	end

	self.weapon_extension:set_mode(self.current_seg)

	if not self.shader_info then
		local material_slot = self.shader_info.material_slot
		local variable_name = self.shader_info.variable_name

		Unit.set_scalar_for_material(self.weapon_unit, material_slot, variable_name, self.current_seg - 1)
	end
end

ActionWheelSelector.finish = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	ActionChangeMode.super.finish(arg_4_0, arg_4_1)
end
