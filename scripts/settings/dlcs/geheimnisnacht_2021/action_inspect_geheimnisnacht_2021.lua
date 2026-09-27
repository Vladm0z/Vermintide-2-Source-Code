-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/action_inspect_geheimnisnacht_2021.lua

ActionInspectGeheimnisnacht2021 = class(ActionInspectGeheimnisnacht2021, ActionDummy)

local num = 0.05
local num_2 = 0.5
local num_3 = 1.05
local num_4 = 0
local num_5 = 0
local num_6 = 1
local str = "fx/invisible_screen_distortion_extreme"
local num_7 = 0.5
local num_8 = 5
local tbl = {
	bw_necromancer = true,
	wh_priest = true,
	we_thornsister = true,
	es_questingknight = true,
	dr_slayer = true
}

ActionInspectGeheimnisnacht2021.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionInspectGeheimnisnacht2021.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	self._dialogue_input = ScriptUnit.extension_input(arg_1_4, "dialogue_system")
	self._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self._health_extension = ScriptUnit.has_extension(arg_1_4, "health_system")
	self._influence_str = 0
	self._influence_str_max = 0
	self._screen_fx_id = nil
	self._is_immune = tbl[self._career_extension:career_name()]
	self._next_curse_time_t = 0
	self._take_curse_damage = false
	self._buff_system = Managers.state.entity:system("buff_system")
end

ActionInspectGeheimnisnacht2021.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionInspectGeheimnisnacht2021.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self._influence_str = 0
	self._influence_str_max = 0
	self._next_curse_time_t = 0
	self._take_curse_damage = false

	self._first_person_extension:animation_set_variable("influence", self._influence_str)
end

ActionInspectGeheimnisnacht2021.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local _influence_str = self._influence_str

	if not self._is_immune then
		local world_rotation = Unit.world_rotation(self.weapon_unit, 0)
		local current_rotation = self._first_person_extension:current_rotation()
		local forward = Quaternion.forward(world_rotation)
		local forward_2 = Quaternion.forward(current_rotation)
		local dot = Vector3.dot(forward, forward_2)
		local max

		if dot > 0.9 then
			max = math.max(dot * num_3, num_4)

			if not max then
				-- Nothing
			end
		end

		max = 0

		::label_3_0::

		local num_5 = num * arg_3_1

		if max < self._influence_str then
			num_5 = num_2 * arg_3_1
		end

		local num_9 = max * num

		self._influence_str = math.min(math.lerp(self._influence_str, max, num_5), num_6)
	end

	self._first_person_extension:animation_set_variable("influence", self._influence_str)

	self._influence_str_max = math.max(self._influence_str_max, self._influence_str)

	if not (not (_influence_str < 0.3) or not (self._influence_str >= 0.3)) then
		Unit.animation_event(self.first_person_unit, "gehemnisnacht_egg_heartbeat_start")
	end

	if not (not (_influence_str > 0.3) or not (self._influence_str <= 0.3)) then
		Unit.animation_event(self.first_person_unit, "gehemnisnacht_egg_heartbeat_stop")
	end

	if not (not (_influence_str < 0.7) or not (self._influence_str >= 0.7)) then
		Unit.animation_event(self.first_person_unit, "gehemnisnacht_egg_level2")
		self:_create_screen_particles()
		self._first_person_extension:set_weapon_sway_settings({
			recentering_lerp_speed = 250,
			lerp_speed = 3,
			sway_range = 1,
			camera_look_sensitivity = 0.03,
			look_sensitivity = 8
		})
	end

	if not (not (_influence_str > 0.7) or not (self._influence_str <= 0.7)) then
		Unit.animation_event(self.first_person_unit, "gehemnisnacht_egg_level1")
		self._first_person_extension:set_weapon_sway_settings({
			recentering_lerp_speed = 0,
			lerp_speed = 10,
			sway_range = 1,
			camera_look_sensitivity = 1,
			look_sensitivity = 1.5
		})
	end

	if not (not (_influence_str < 0.9) or not (self._influence_str >= 0.9)) then
		Unit.animation_event(self.first_person_unit, "gehemnisnacht_egg_level3")
		self._first_person_extension:set_weapon_sway_settings({
			recentering_lerp_speed = 10,
			lerp_speed = 10,
			sway_range = 1,
			camera_look_sensitivity = 1,
			look_sensitivity = 1.5
		})

		self._take_curse_damage = true
	end

	if not (not self._take_curse_damage and not (arg_3_2 >= self._next_curse_time_t)) then
		self._next_curse_time_t = arg_3_2 + num_7

		self._health_extension:convert_to_temp(num_8)
	end

	if not self._screen_fx_id then
		local viewport_name = Managers.player:owner(self.owner_unit).viewport_name
		local viewport = ScriptWorld.viewport(self.world, viewport_name)
		local camera = ScriptViewport.camera(viewport)
		local res_w = RESOLUTION_LOOKUP.res_w
		local res_h = RESOLUTION_LOOKUP.res_h
		local num_10 = res_w / 2
		local num_11 = res_h / 2
		local world_position = Unit.world_position(self.weapon_unit, 0)
		local world_to_screen = Camera.world_to_screen(camera, world_position)
		local var_3_18 = Vector3((world_to_screen.x - num_10) / num_10, 0, (world_to_screen.y - num_11) / num_11)

		World.move_particles(self.world, self._screen_fx_id, var_3_18)
	end
end

ActionInspectGeheimnisnacht2021.finish = function (self, arg_4_1)
	-- function 4
	ActionInspectGeheimnisnacht2021.super.finish(self, arg_4_1)
	self:_destroy_screen_particles()
end

ActionInspectGeheimnisnacht2021._create_screen_particles = function (self)
	-- function 5
	if not self._screen_fx_id then
		self._screen_fx_id = self._first_person_extension:create_screen_particles(str, Vector3(1, 0, 0))
	end
end

ActionInspectGeheimnisnacht2021._destroy_screen_particles = function (self)
	-- function 6
	if not self._screen_fx_id then
		self._first_person_extension:stop_spawning_screen_particles(self._screen_fx_id)

		self._screen_fx_id = nil
	end
end
