-- chunkname: @scripts/settings/dlcs/bless/action_book_charge.lua

ActionBookCharge = class(ActionBookCharge, ActionMeleeStart)

local set_flow_variable = Unit.set_flow_variable
local flow_event = Unit.flow_event

ActionBookCharge.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionBookCharge.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	self.owner_unit = arg_1_4

	local get_all_weapon_unit, var_1_1 = self.inventory_extension:get_all_weapon_unit()

	self._left_hand_unit = get_all_weapon_unit
	self._right_hand_unit = var_1_1
	self._current_segment = -1
	self._sfx_active = false
	self._charge_sfx = false
end

local function fn(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local var_2_0 = arg_2_1
	local get_action_time_scale = ActionUtils.get_action_time_scale(arg_2_2, arg_2_0)

	if not arg_2_4 then
		var_2_0 = var_2_0 * get_action_time_scale
	else
		var_2_0 = var_2_0 * (1 / get_action_time_scale)
	end

	return var_2_0
end

ActionBookCharge.client_owner_start_action = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	ActionBookCharge.super.client_owner_start_action(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	self.charge = self.weapon_extension:get_custom_data("charge")

	local owner_unit = self.owner_unit
	local extension = ScriptUnit.extension(owner_unit, "buff_system")
	local var_3_2 = fn
	local var_3_3 = arg_3_1
	local charge_speed = arg_3_1.charge_speed

	charge_speed = charge_speed or 0.3
	self.charge_speed = var_3_2(var_3_3, charge_speed, owner_unit, extension, true)

	local var_3_5 = fn
	local var_3_6 = arg_3_1
	local initial_charge_delay = arg_3_1.initial_charge_delay

	initial_charge_delay = initial_charge_delay or 0
	self.initial_charge_delay = var_3_5(var_3_6, initial_charge_delay, owner_unit, extension, false)
	self.start_time = arg_3_2

	self:_update_visual_charge(self.charge)
end

ActionBookCharge.client_owner_post_update = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	ActionBookCharge.super.client_owner_post_update(self, arg_4_1, arg_4_2, arg_4_3)

	if arg_4_2 < self.start_time + self.initial_charge_delay then
		return
	end

	if not (not (self.charge < 1) or self._sfx_active) then
		self._sfx_active = true

		self.first_person_extension:play_hud_sound_event("priest_melee_book_charge")
	end

	self.charge = self.charge + self.charge_speed * arg_4_1

	self.weapon_extension:set_custom_data("charge", self.charge)
	self:_update_visual_charge(self.charge)
end

ActionBookCharge._update_visual_charge = function (self, arg_5_1)
	-- function 5
	if not self._right_hand_unit then
		local clamp = math.clamp(arg_5_1, 0, 1)

		set_flow_variable(self._right_hand_unit, "current_charge", clamp)
		flow_event(self._right_hand_unit, "lua_update_charge")
	end

	local inventory_extension = self.inventory_extension

	if not (not (arg_5_1 >= 1) or self._charge_sfx) then
		self._charge_sfx = true

		self.first_person_extension:play_hud_sound_event("priest_melee_book_charge_end")

		self._sfx_active = false
	elseif not (arg_5_1 < 1) or not self._charge_sfx then
		self._charge_sfx = false
	end
end

ActionBookCharge.finish = function (self, arg_6_1)
	-- function 6
	ActionChangeMode.super.finish(self, arg_6_1)

	if self.charge < 1 then
		self._sfx_active = false

		self.first_person_extension:play_hud_sound_event("priest_melee_book_charge_stop")
	end
end
