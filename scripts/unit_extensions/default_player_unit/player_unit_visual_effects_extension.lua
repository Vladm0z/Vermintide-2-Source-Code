-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_visual_effects_extension.lua

PlayerUnitVisualEffectsExtension = class(PlayerUnitVisualEffectsExtension)

local set_flow_variable = Unit.set_flow_variable
local flow_event = Unit.flow_event

PlayerUnitVisualEffectsExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.network_manager = Managers.state.network
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.overcharge_threshold_changed = true
end

PlayerUnitVisualEffectsExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.inventory_extension = ScriptUnit.extension(arg_2_2, "inventory_system")
	self.overcharge_extension = ScriptUnit.extension(arg_2_2, "overcharge_system")

	local extension = ScriptUnit.extension(arg_2_2, "first_person_system")
	local get_first_person_unit = extension:get_first_person_unit()
	local get_first_person_mesh_unit = extension:get_first_person_mesh_unit()

	self.first_person_extension = extension
	self.first_person_unit = get_first_person_unit
	self.first_person_mesh_unit = get_first_person_mesh_unit

	local extension_2 = ScriptUnit.extension(arg_2_2, "cosmetic_system")

	self.cosmetic_extension = extension_2
	self.third_person_mesh_unit = extension_2:get_third_person_mesh_unit()
end

PlayerUnitVisualEffectsExtension.destroy = function (arg_3_0)
	-- function 3
	return
end

PlayerUnitVisualEffectsExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	self:_update_overcharge_thresholds()
	self:_set_overcharge_flow_values()
	self:_set_weapons_energy_drainable()
end

PlayerUnitVisualEffectsExtension._update_overcharge_thresholds = function (self)
	-- function 5
	local current_overcharge_status, var_5_1, var_5_2 = self.overcharge_extension:current_overcharge_status()

	if not (not self.above_overcharge_threshold and not (current_overcharge_status < var_5_1)) then
		self.above_overcharge_threshold = false
		self.overcharge_threshold_changed = true
	elseif not (self.above_overcharge_threshold or not (var_5_1 <= current_overcharge_status)) then
		self.above_overcharge_threshold = true
		self.overcharge_threshold_changed = true
	else
		self.overcharge_threshold_changed = false
	end
end

PlayerUnitVisualEffectsExtension._set_overcharge_flow_values = function (self)
	-- function 6
	local get_anim_blend_overcharge = self.overcharge_extension:get_anim_blend_overcharge()

	self:_set_character_overcharge(get_anim_blend_overcharge)
	self:_set_weapons_overcharge(get_anim_blend_overcharge)

	if not self.overcharge_threshold_changed then
		self:_set_character_overcharge_threshold()
		self:_set_weapons_overcharge_threshold()

		self.overcharge_threshold_changed = false
	end
end

PlayerUnitVisualEffectsExtension._set_character_overcharge = function (self, arg_7_1)
	-- function 7
	local unit = self.unit
	local third_person_mesh_unit = self.third_person_mesh_unit
	local first_person_unit = self.first_person_unit
	local first_person_mesh_unit = self.first_person_mesh_unit

	if not unit and not Unit.alive(unit) then
		set_flow_variable(unit, "current_overcharge", arg_7_1)
		flow_event(unit, "lua_update_overcharge")
	end

	if not third_person_mesh_unit and not Unit.alive(third_person_mesh_unit) then
		set_flow_variable(third_person_mesh_unit, "current_overcharge", arg_7_1)
		flow_event(third_person_mesh_unit, "lua_update_overcharge")
	end

	if not first_person_unit and not Unit.alive(first_person_unit) then
		set_flow_variable(first_person_unit, "current_overcharge", arg_7_1)
		flow_event(first_person_unit, "lua_update_overcharge")
	end

	if not first_person_mesh_unit and not Unit.alive(first_person_mesh_unit) then
		set_flow_variable(first_person_mesh_unit, "current_overcharge", arg_7_1)
		flow_event(first_person_mesh_unit, "lua_update_overcharge")
	end
end

PlayerUnitVisualEffectsExtension._set_weapons_energy_drainable = function (self)
	-- function 8
	local get_wielded_slot_data = self.inventory_extension:get_wielded_slot_data()
	local unit = self.unit
	local flag = not unit and ScriptUnit.has_extension(unit, "energy_system")

	if not get_wielded_slot_data and not flag then
		local is_drainable = flag:is_drainable()
		local left_unit_1p = get_wielded_slot_data.left_unit_1p
		local left_ammo_unit_1p = get_wielded_slot_data.left_ammo_unit_1p
		local right_unit_1p = get_wielded_slot_data.right_unit_1p
		local right_ammo_unit_1p = get_wielded_slot_data.right_ammo_unit_1p

		if not left_unit_1p and not Unit.alive(left_unit_1p) then
			set_flow_variable(left_unit_1p, "is_energy_drainable", is_drainable)
		end

		if not left_ammo_unit_1p and not Unit.alive(left_ammo_unit_1p) then
			set_flow_variable(left_ammo_unit_1p, "is_energy_drainable", is_drainable)
		end

		if not right_unit_1p and not Unit.alive(right_unit_1p) then
			set_flow_variable(right_unit_1p, "is_energy_drainable", is_drainable)
		end

		if not right_ammo_unit_1p and not Unit.alive(right_ammo_unit_1p) then
			set_flow_variable(right_ammo_unit_1p, "is_energy_drainable", is_drainable)
		end

		local left_unit_3p = get_wielded_slot_data.left_unit_3p
		local left_ammo_unit_3p = get_wielded_slot_data.left_ammo_unit_3p
		local right_unit_3p = get_wielded_slot_data.right_unit_3p
		local right_ammo_unit_3p = get_wielded_slot_data.right_ammo_unit_3p

		if not left_unit_3p and not Unit.alive(left_unit_3p) then
			set_flow_variable(left_unit_3p, "is_energy_drainable", is_drainable)
		end

		if not left_ammo_unit_3p and not Unit.alive(left_ammo_unit_3p) then
			set_flow_variable(left_ammo_unit_3p, "is_energy_drainable", is_drainable)
		end

		if not right_unit_3p and not Unit.alive(right_unit_3p) then
			set_flow_variable(right_unit_3p, "is_energy_drainable", is_drainable)
		end

		if not right_ammo_unit_3p and not Unit.alive(right_ammo_unit_3p) then
			set_flow_variable(right_ammo_unit_3p, "is_energy_drainable", is_drainable)
		end
	end
end

PlayerUnitVisualEffectsExtension._set_character_overcharge_threshold = function (self)
	-- function 9
	local unit = self.unit
	local third_person_mesh_unit = self.third_person_mesh_unit
	local first_person_unit = self.first_person_unit
	local first_person_mesh_unit = self.first_person_mesh_unit
	local str = "below_overcharge_threshold"

	if not self.above_overcharge_threshold then
		str = "above_overcharge_threshold"
	end

	if not unit and not Unit.alive(unit) then
		flow_event(unit, str)
	end

	if not third_person_mesh_unit and not Unit.alive(third_person_mesh_unit) then
		flow_event(third_person_mesh_unit, str)
	end

	if not first_person_unit and not Unit.alive(first_person_unit) then
		flow_event(first_person_unit, str)
	end

	if not first_person_mesh_unit and not Unit.alive(first_person_mesh_unit) then
		flow_event(first_person_mesh_unit, str)
	end
end

PlayerUnitVisualEffectsExtension._set_weapons_overcharge = function (self, arg_10_1)
	-- function 10
	local get_wielded_slot_data = self.inventory_extension:get_wielded_slot_data()

	if not get_wielded_slot_data then
		local left_unit_1p = get_wielded_slot_data.left_unit_1p
		local right_unit_1p = get_wielded_slot_data.right_unit_1p

		if not left_unit_1p and not Unit.alive(left_unit_1p) then
			set_flow_variable(left_unit_1p, "current_overcharge", arg_10_1)
			flow_event(left_unit_1p, "lua_update_overcharge")
		end

		if not right_unit_1p and not Unit.alive(right_unit_1p) then
			set_flow_variable(right_unit_1p, "current_overcharge", arg_10_1)
			flow_event(right_unit_1p, "lua_update_overcharge")
		end

		local left_unit_3p = get_wielded_slot_data.left_unit_3p
		local right_unit_3p = get_wielded_slot_data.right_unit_3p

		if not left_unit_3p and not Unit.alive(left_unit_3p) then
			set_flow_variable(left_unit_3p, "current_overcharge", arg_10_1)
			flow_event(left_unit_3p, "lua_update_overcharge")
		end

		if not right_unit_3p and not Unit.alive(right_unit_3p) then
			set_flow_variable(right_unit_3p, "current_overcharge", arg_10_1)
			flow_event(right_unit_3p, "lua_update_overcharge")
		end
	end
end

PlayerUnitVisualEffectsExtension._set_weapons_overcharge_threshold = function (self)
	-- function 11
	local get_slot_data = self.inventory_extension:get_slot_data("slot_ranged")

	if not get_slot_data then
		local str = "below_overcharge_threshold"

		if not self.above_overcharge_threshold then
			str = "above_overcharge_threshold"
		end

		local left_unit_1p = get_slot_data.left_unit_1p
		local right_unit_1p = get_slot_data.right_unit_1p

		if not left_unit_1p and not Unit.alive(left_unit_1p) then
			flow_event(left_unit_1p, str)
		end

		if not right_unit_1p and not Unit.alive(right_unit_1p) then
			flow_event(right_unit_1p, str)
		end

		local left_unit_3p = get_slot_data.left_unit_3p
		local right_unit_3p = get_slot_data.right_unit_3p

		if not left_unit_3p and not Unit.alive(left_unit_3p) then
			flow_event(left_unit_3p, str)
		end

		if not right_unit_3p and not Unit.alive(right_unit_3p) then
			flow_event(right_unit_3p, str)
		end
	end
end
