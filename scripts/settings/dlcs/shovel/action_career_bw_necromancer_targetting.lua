-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_targetting.lua

require("scripts/unit_extensions/weapons/area_damage/liquid/damage_wave_templates")

local necromancer_curse_wave = DamageWaveTemplates.templates.necromancer_curse_wave

ActionCareerBWNecromancerTargetting = class(ActionCareerBWNecromancerTargetting, ActionBase)

local num = 1
local num_2 = 2
local num_3 = 0.5
local num_4 = 2.5
local num_5 = 0.25

ActionCareerBWNecromancerTargetting.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerBWNecromancerTargetting.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._ai_navigation_system = Managers.state.entity:system("ai_navigation_system")
	self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	self._weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self._local_player = Managers.player:owner(arg_1_4).local_player
	self._owner_unit = arg_1_4
	self._has_valid_position = false
	self._last_valid_cast_direction = Vector3Box()
	self._last_valid_cast_position = Vector3Box()
	self._decal_unit = nil
	self._decal_unit_name = "units/decals/decal_arrow_kerillian"

	self._nav_callback = function ()
		-- function 2
		local time = Managers.time:time("game")

		self:_update_targetting(time)
	end
end

ActionCareerBWNecromancerTargetting.client_owner_start_action = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_5 = arg_3_5 or {}

	ActionCareerBWNecromancerTargetting.super.client_owner_start_action(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	self._round_career_ability = self._talent_extension:has_talent("sienna_necromancer_6_3")
	self._has_valid_position = false

	self._weapon_extension:set_mode(false)

	if not (not self._local_player and self._round_career_ability) then
		local _decal_unit_name = self._decal_unit_name

		self._decal_unit = Managers.state.unit_spawner:spawn_local_unit(_decal_unit_name)
	end

	self._ai_navigation_system:add_safe_navigation_callback(self._nav_callback)
	self._first_person_extension:play_hud_sound_event("Play_career_necro_ability_withering_wave_target", nil, false)
end

ActionCareerBWNecromancerTargetting.client_owner_post_update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	self._ai_navigation_system:add_safe_navigation_callback(self._nav_callback)
end

ActionCareerBWNecromancerTargetting._get_first_person_position_direction = function (self)
	-- function 5
	local _first_person_extension = self._first_person_extension
	local current_position = _first_person_extension:current_position()
	local current_rotation = _first_person_extension:current_rotation()
	local rad = math.rad(45)
	local rad_2 = math.rad(12.5)
	local yaw = Quaternion.yaw(current_rotation)
	local clamp = math.clamp(Quaternion.pitch(current_rotation), -rad, rad_2)
	local var_5_7 = Quaternion(Vector3.up(), yaw)
	local var_5_8 = Quaternion(Vector3.right(), clamp)
	local multiply = Quaternion.multiply(var_5_7, var_5_8)
	local forward = Quaternion.forward(multiply)

	return current_position, forward
end

ActionCareerBWNecromancerTargetting._update_targetting = function (self, arg_6_1)
	-- function 6
	local num_2 = 1
	local num_3 = 2
	local _nav_world = self._nav_world
	local _get_first_person_position_direction, var_6_4 = self:_get_first_person_position_direction()
	local normalize = Vector3.normalize(Vector3.flat(var_6_4))

	if not self._decal_unit then
		local look = Quaternion.look(normalize, Vector3.up())

		Unit.set_local_position(self._decal_unit, 0, POSITION_LOOKUP[self._owner_unit])
		Unit.set_local_rotation(self._decal_unit, 0, look)
	end

	if not self._round_career_ability then
		local var_6_7 = POSITION_LOOKUP[self.owner_unit]
		local pos_on_mesh = LocomotionUtils.pos_on_mesh(_nav_world, var_6_7, num_2, num_3)

		if not pos_on_mesh then
			self._has_valid_position = false

			return
		end

		self._has_valid_position = true

		self._weapon_extension:set_mode(true)
		self._last_valid_cast_position:store(pos_on_mesh)
		self._last_valid_cast_direction:store(normalize)
	else
		local num_4 = POSITION_LOOKUP[self.owner_unit] + normalize * num
		local pos_on_mesh_2 = LocomotionUtils.pos_on_mesh(_nav_world, num_4, num_2, num_3)

		if not pos_on_mesh_2 then
			self._has_valid_position = false

			return
		end

		local num_5 = (necromancer_curse_wave.max_speed + necromancer_curse_wave.start_speed * 0.5) * necromancer_curse_wave.time_of_life * 0.5

		self._has_valid_position = true

		self._weapon_extension:set_mode(true)
		self._last_valid_cast_position:store(pos_on_mesh_2)
		self._last_valid_cast_direction:store(normalize)
	end
end

ActionCareerBWNecromancerTargetting.finish = function (self, arg_7_1)
	-- function 7
	if not self._decal_unit then
		Managers.state.unit_spawner:mark_for_deletion(self._decal_unit)

		self._decal_unit = nil
	end

	if arg_7_1 ~= "new_interupting_action" or not self._has_valid_position then
		self._weapon_extension:set_mode(true)

		return {
			position = self._last_valid_cast_position,
			direction = self._last_valid_cast_direction
		}
	else
		self._inventory_extension:wield_previous_non_level_slot()
	end

	return nil
end
