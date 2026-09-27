-- chunkname: @scripts/unit_extensions/weapons/spread/weapon_spread_extension.lua

require("scripts/unit_extensions/weapons/spread/spread_templates")

WeaponSpreadExtension = class(WeaponSpreadExtension)

WeaponSpreadExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.owner_unit = arg_1_3.owner_unit

	local item_name = arg_1_3.item_name

	self.item_name = item_name

	local var_1_1 = ItemMasterList[item_name]
	local get_item_template = BackendUtils.get_item_template(var_1_1)

	self.default_spread_template_name = get_item_template.default_spread_template

	local spread_lerp_speed_pitch = get_item_template.spread_lerp_speed_pitch

	if not spread_lerp_speed_pitch then
		spread_lerp_speed_pitch = get_item_template.spread_lerp_speed
		spread_lerp_speed_pitch = spread_lerp_speed_pitch or 4
	end

	self.spread_lerp_speed_pitch = spread_lerp_speed_pitch

	local spread_lerp_speed_yaw = get_item_template.spread_lerp_speed_yaw

	if not spread_lerp_speed_yaw then
		spread_lerp_speed_yaw = get_item_template.spread_lerp_speed
		spread_lerp_speed_yaw = spread_lerp_speed_yaw or 4
	end

	self.spread_lerp_speed_yaw = spread_lerp_speed_yaw

	local spread_lerp_speed_pitch_zoom = get_item_template.spread_lerp_speed_pitch_zoom

	if not spread_lerp_speed_pitch_zoom then
		spread_lerp_speed_pitch_zoom = get_item_template.spread_lerp_speed_zoom

		if not spread_lerp_speed_pitch_zoom then
			spread_lerp_speed_pitch_zoom = get_item_template.spread_lerp_speed
			spread_lerp_speed_pitch_zoom = spread_lerp_speed_pitch_zoom or 4
		end
	end

	self.spread_lerp_speed_pitch_zoom = spread_lerp_speed_pitch_zoom

	local spread_lerp_speed_yaw_zoom = get_item_template.spread_lerp_speed_yaw_zoom

	if not spread_lerp_speed_yaw_zoom then
		spread_lerp_speed_yaw_zoom = get_item_template.spread_lerp_speed_zoom

		if not spread_lerp_speed_yaw_zoom then
			spread_lerp_speed_yaw_zoom = get_item_template.spread_lerp_speed
			spread_lerp_speed_yaw_zoom = spread_lerp_speed_yaw_zoom or 4
		end
	end

	self.spread_lerp_speed_yaw_zoom = spread_lerp_speed_yaw_zoom
	self.spread_settings = SpreadTemplates[self.default_spread_template_name]
	self.current_state = "still"
	self.current_yaw = 0
	self.current_pitch = 0
	self.shooting = false
	self.hit_aftermath = false
	self.hit_timer = 0
end

WeaponSpreadExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	local owner_unit = self.owner_unit

	self.owner_health_extension = ScriptUnit.extension(owner_unit, "health_system")
	self.owner_status_extension = ScriptUnit.extension(owner_unit, "status_system")
	self.owner_buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
	self.owner_locomotion_extension = ScriptUnit.extension(owner_unit, "locomotion_system")
end

WeaponSpreadExtension.destroy = function (arg_3_0)
	-- function 3
	return
end

local tbl = {
	temporary_health_degen = true,
	buff_shared_medpack_temp_health = true,
	buff_shared_medpack = true,
	buff = true,
	warpfire_ground = true,
	life_tap = true,
	health_degen = true,
	vomit_ground = true,
	wounded_dot = true,
	heal = true,
	life_drain = true
}

WeaponSpreadExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local current_pitch = self.current_pitch
	local current_yaw = self.current_yaw
	local current_state = self.current_state
	local var_4_3 = self.spread_settings.continuous[current_state]
	local owner_buff_extension = self.owner_buff_extension
	local apply_buffs_to_value = owner_buff_extension:apply_buffs_to_value(var_4_3.max_pitch, "reduced_spread")
	local apply_buffs_to_value_2 = owner_buff_extension:apply_buffs_to_value(var_4_3.max_yaw, "reduced_spread")
	local owner_status_extension = self.owner_status_extension
	local owner_locomotion_extension = self.owner_locomotion_extension
	local is_moving = CharacterStateHelper.is_moving(owner_locomotion_extension)
	local is_crouching = CharacterStateHelper.is_crouching(owner_status_extension)
	local is_zooming = CharacterStateHelper.is_zooming(owner_status_extension)
	local var_4_12
	local spread_lerp_speed_pitch_zoom

	if not is_zooming then
		spread_lerp_speed_pitch_zoom = self.spread_lerp_speed_pitch_zoom

		if not spread_lerp_speed_pitch_zoom then
			-- Nothing
		end
	end

	spread_lerp_speed_pitch_zoom = self.spread_lerp_speed_pitch

	do
		local spread_lerp_speed_yaw_zoom
	end

	::label_4_0::

	if not is_zooming then
		spread_lerp_speed_yaw_zoom = self.spread_lerp_speed_yaw_zoom

		if not spread_lerp_speed_yaw_zoom then
			-- Nothing
		end
	end

	spread_lerp_speed_yaw_zoom = self.spread_lerp_speed_yaw

	::label_4_1::

	if not self.hit_aftermath then
		self.hit_timer = self.hit_timer - arg_4_3

		local random = Math.random(0.5, 1)

		spread_lerp_speed_pitch_zoom = random
		spread_lerp_speed_yaw_zoom = random

		if self.hit_timer <= 0 then
			self.hit_aftermath = false
		end
	end

	local flag

	flag = not is_moving and not is_crouching and not is_zooming and "zoomed_crouch_moving" and "crouch_moving" or not is_zooming and "zoomed_moving" and "moving" or not is_crouching and (not is_zooming and "zoomed_crouch_still" and "crouch_still" or not is_zooming) or "zoomed_still" and "still"

	if not is_moving then
		apply_buffs_to_value = owner_buff_extension:apply_buffs_to_value(apply_buffs_to_value, "reduced_spread_moving")
		apply_buffs_to_value_2 = owner_buff_extension:apply_buffs_to_value(apply_buffs_to_value_2, "reduced_spread_moving")
	end

	local lerp = math.lerp(current_pitch, apply_buffs_to_value, arg_4_3 * spread_lerp_speed_pitch_zoom)
	local lerp_2 = math.lerp(current_yaw, apply_buffs_to_value_2, arg_4_3 * spread_lerp_speed_yaw_zoom)

	if current_state ~= flag then
		self.current_state = flag
	end

	local immediate = self.spread_settings.immediate
	local num = 0
	local num_2 = 0
	local recently_damaged = self.owner_health_extension:recently_damaged()

	if not (not recently_damaged and not tbl[recently_damaged]) then
		local being_hit = immediate.being_hit

		num = owner_buff_extension:apply_buffs_to_value(being_hit.immediate_pitch, "reduced_spread_hit")
		num_2 = owner_buff_extension:apply_buffs_to_value(being_hit.immediate_yaw, "reduced_spread_hit")
		self.hit_aftermath = true
		self.hit_timer = 1.5
	end

	if not self.shooting then
		local shooting = immediate.shooting

		num = owner_buff_extension:apply_buffs_to_value(shooting.immediate_pitch, "reduced_spread_shot")
		num_2 = owner_buff_extension:apply_buffs_to_value(shooting.immediate_yaw, "reduced_spread_shot")
		self.shooting = false
	end

	local num_3 = lerp + num
	local num_4 = lerp_2 + num_2

	self.current_pitch = math.min(num_3, SpreadTemplates.maximum_pitch)
	self.current_yaw = math.min(num_4, SpreadTemplates.maximum_yaw)
end

WeaponSpreadExtension.set_shooting = function (self)
	-- function 5
	self.shooting = true
end

WeaponSpreadExtension.combine_spread_rotations = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local var_6_0 = Quaternion(Vector3.forward(), arg_6_1)
	local var_6_1 = Quaternion(Vector3.right(), arg_6_2)
	local multiply = Quaternion.multiply(arg_6_3, var_6_0)

	return (Quaternion.multiply(multiply, var_6_1))
end

WeaponSpreadExtension.get_max_pitch_rotation = function (self, arg_7_1)
	-- function 7
	local current_pitch = self.current_pitch
	local current_yaw = self.current_yaw
	local num = current_yaw * math.cos(arg_7_1)
	local num_2 = current_pitch * math.sin(arg_7_1)
	local length = Vector3.length(Vector3(num, num_2, 0))

	if length < 1e-05 then
		return 0
	end

	local num_3 = current_pitch * current_yaw / length

	return math.degrees_to_radians(num_3)
end

WeaponSpreadExtension.get_current_pitch_and_yaw = function (self)
	-- function 8
	return self.current_pitch, self.current_yaw
end

WeaponSpreadExtension.override_spread_template = function (self, arg_9_1)
	-- function 9
	self.spread_settings = SpreadTemplates[arg_9_1]

	local current_state = self.current_state
	local var_9_1 = self.spread_settings.continuous[current_state]

	self.current_pitch = var_9_1.max_pitch
	self.current_yaw = var_9_1.max_yaw
end

WeaponSpreadExtension.reset_spread_template = function (self)
	-- function 10
	self.spread_settings = SpreadTemplates[self.default_spread_template_name]
end

WeaponSpreadExtension.get_randomised_spread = function (self, arg_11_1)
	-- function 11
	local num = math.random() * math.pi * 2
	local num_2 = math.random() * self:get_max_pitch_rotation(num)

	return (self:combine_spread_rotations(num, num_2, arg_11_1))
end

WeaponSpreadExtension.get_target_style_spread = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	if not (not arg_12_5 and arg_12_1 ~= 1) then
		return arg_12_3
	end

	local num

	if not arg_12_5 then
		num = arg_12_1 - 1

		if not num then
			-- Nothing
		end
	end

	num = arg_12_1

	do
		local num_2
	end

	::label_12_0::

	if not arg_12_5 then
		num_2 = arg_12_2 - 1

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = arg_12_2

	::label_12_1::

	local flag = arg_12_4 or 1
	local num_3 = flag * (num / num_2)
	local num_4 = flag / num_2
	local num_5 = ((0.85 + 0.3 * math.random()) * num_4 * 2 + num_3 - num_4) * (math.pi * 2)
	local get_max_pitch_rotation = self:get_max_pitch_rotation(num_5)
	local sqrt = math.sqrt(0.25 + 0.5 * math.random())

	if not (flag ~= 2 or not (num <= num_2 / flag)) then
		sqrt = sqrt * ((arg_12_6 or 0.8) / 2)
	else
		sqrt = sqrt * (arg_12_6 or 0.8)
	end

	local num_6 = sqrt * get_max_pitch_rotation

	return (self:combine_spread_rotations(num_5, num_6, arg_12_3))
end
