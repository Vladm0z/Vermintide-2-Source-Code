-- chunkname: @scripts/unit_extensions/weapons/actions/action_bullet_spray.lua

ActionBulletSpray = class(ActionBulletSpray, ActionBase)

local num = -1
local num_2 = math.abs(num) + 5
local num_3 = 3.5
local num_4 = 2
local num_5 = 10
local tbl = {
	"j_leftshoulder",
	"j_rightshoulder",
	"j_spine1"
}
local count = #tbl

ActionBulletSpray.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionBulletSpray.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self.buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self.targets = {}
end

ActionBulletSpray.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionBulletSpray.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local owner_unit = self.owner_unit
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1, arg_2_2)

	self.power_level = arg_2_4
	self.current_action = arg_2_1
	self._target_index = 1
	self.state = "waiting_to_shoot"
	self._check_buffs = true

	if not arg_2_1.use_ammo_at_time then
		self.use_ammo_time = arg_2_2 + arg_2_1.use_ammo_at_time
		self.used_ammo = false
	end

	local sqrt = math.sqrt(num_2 * num_2 + num_3 * num_3)

	self.CONE_COS_ALPHA = num_2 / sqrt

	local overcharge_type = arg_2_1.overcharge_type

	if not overcharge_type then
		local var_2_4 = PlayerUnitStatusSettings.overcharge_values[overcharge_type]

		if not is_critical_strike and not self.buff_extension:has_buff_perk("no_overcharge_crit") then
			var_2_4 = 0
		end

		self.overcharge_extension:add_charge(var_2_4)
	end

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self:_handle_critical_strike(is_critical_strike, self.buff_extension, has_extension, nil, "on_critical_shot", nil)

	self._is_critical_strike = is_critical_strike
end

ActionBulletSpray.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local current_action = self.current_action

	if not (not self.use_ammo_time and self.used_ammo or not (arg_3_2 >= self.use_ammo_time)) then
		self.used_ammo = true

		local ammo_extension = self.ammo_extension

		if not ammo_extension then
			ammo_extension:use_ammo(current_action.ammo_usage)
		end
	end

	if self.state == "waiting_to_shoot" then
		self:_select_targets(arg_3_3, true)

		if not Managers.player:owner(self.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "handgun_fire"
			})
		end

		local fire_sound_event = current_action.fire_sound_event

		if not fire_sound_event then
			local fire_sound_on_husk = current_action.fire_sound_on_husk

			ScriptUnit.extension(self.owner_unit, "first_person_system"):play_hud_sound_event(fire_sound_event, nil, fire_sound_on_husk)
		end

		self.state = "shooting"
	end

	if self.state == "shooting" then
		local first_person_unit = self.first_person_unit
		local var_3_5 = POSITION_LOOKUP[first_person_unit]
		local targets = self.targets
		local _target_index = self._target_index
		local var_3_8 = targets[_target_index]

		if not Unit.alive(var_3_8) then
			local get_data = Unit.get_data(var_3_8, "breed")
			local str = "j_spine"

			if not get_data then
				local random = math.random(1, count)

				for i = 1, count do
					local index_wrapper = math.index_wrapper(random + i - 1, count)
					local var_3_13 = tbl[index_wrapper]

					if not Unit.has_node(var_3_8, var_3_13) then
						str = var_3_13

						break
					end
				end
			end

			local world_position = Unit.world_position(var_3_8, Unit.node(var_3_8, str))
			local normalize = Vector3.normalize(world_position - var_3_5)
			local raycast_to_target = self:raycast_to_target(arg_3_3, var_3_5, normalize, var_3_8)
			local var_3_17

			if not current_action.area_damage then
				var_3_17 = var_3_8
			end

			if not raycast_to_target then
				local _check_buffs = self._check_buffs

				if not DamageUtils.process_projectile_hit(arg_3_3, self.item_name, self.owner_unit, self.is_server, raycast_to_target, current_action, normalize, _check_buffs, var_3_17, nil, self._is_critical_strike, self.power_level).buffs_checked then
					_check_buffs = not _check_buffs and false
				end

				self._check_buffs = _check_buffs
			end

			local weapon_unit = self.weapon_unit
			local var_3_20

			if not raycast_to_target then
				var_3_20 = raycast_to_target[#raycast_to_target][1]

				if not var_3_20 then
					-- Nothing
				end
			end

			var_3_20 = var_3_5 + normalize * 100

			::label_3_0::

			Unit.set_flow_variable(weapon_unit, "hit_position", var_3_20)
			Unit.set_flow_variable(weapon_unit, "trail_life", Vector3.length(var_3_20 - var_3_5) * 0.1)
			Unit.flow_event(weapon_unit, "lua_bullet_trail")
			Unit.flow_event(weapon_unit, "lua_bullet_trail_set")
		end

		self._target_index = _target_index + 1

		if self._target_index > #targets then
			self:_proc_spell_used(self.buff_extension)

			self.state = "shot"
		end
	end
end

ActionBulletSpray.finish = function (self, arg_4_1)
	-- function 4
	self:_clear_targets()

	local ammo_extension = self.ammo_extension
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local reload_when_out_of_ammo_condition_func = current_action.reload_when_out_of_ammo_condition_func
	local flag

	flag = reload_when_out_of_ammo_condition_func or not true or reload_when_out_of_ammo_condition_func(owner_unit, arg_4_1)

	if not ammo_extension and not current_action.reload_when_out_of_ammo and not flag and ammo_extension:ammo_count() ~= 0 or not ammo_extension:can_reload() then
		local flag_2 = true

		ammo_extension:start_reload(flag_2)
	end

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end

	if not (self.state == "waiting_to_shoot" or self.state == "shot") then
		self:_proc_spell_used(self.buff_extension)
	end
end

ActionBulletSpray._clear_targets = function (self)
	-- function 5
	table.clear(self.targets)
end

local unit = Actor.unit
local distance_squared = Vector3.distance_squared
local local_position = Unit.local_position

ActionBulletSpray._select_targets = function (self, arg_6_1, arg_6_2)
	-- function 6
	local get_data = World.get_data(arg_6_1, "physics_world")
	local first_person_unit = self.first_person_unit
	local var_6_2 = POSITION_LOOKUP[first_person_unit]
	local world_rotation = Unit.world_rotation(first_person_unit, 0)
	local normalize = Vector3.normalize(Quaternion.forward(world_rotation))
	local flag = not Managers.state.difficulty:get_difficulty_settings().friendly_fire_ranged

	if not self.current_action.fire_at_gaze_setting and not ScriptUnit.has_extension(self.owner_unit, "eyetracking_system") then
		local extension = ScriptUnit.extension(self.owner_unit, "eyetracking_system")

		if not extension:get_is_feature_enabled("tobii_fire_at_gaze") then
			normalize = extension:gaze_forward()
		end
	end

	local num_4 = var_6_2 + normalize * num + normalize * num_3
	local num_6 = var_6_2 + normalize * num + normalize * (num_2 - num_3)

	PhysicsWorld.prepare_actors_for_overlap(get_data, num_4, num_2 * num_2)

	local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(get_data, num_4, num_6, num_3, 100, "collision_filter", "filter_character_trigger", "report_initial_overlap")

	table.sort(linear_sphere_sweep, function (self, arg_7_1)
		-- function 7
		local var_7_0 = unit(self.actor)
		local var_7_1 = unit(arg_7_1.actor)
		local var_7_2 = local_position(var_7_0, 0)
		local var_7_3 = local_position(var_7_1, 0)

		return distance_squared(var_6_2, var_7_2) < distance_squared(var_6_2, var_7_3)
	end)

	if not linear_sphere_sweep then
		local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[self.owner_unit].PLAYER_AND_BOT_UNITS
		local count = #linear_sphere_sweep
		local targets = self.targets
		local temp_count, var_6_14, var_6_15 = Script.temp_count()
		local tbl = {}
		local num_7 = 0

		for i = 1, count do
			local var_6_18 = linear_sphere_sweep[i]
			local actor = var_6_18.actor
			local unit_2 = Actor.unit(actor)
			local position = var_6_18.position

			if not tbl[unit_2] then
				local get_data_2 = Unit.get_data(unit_2, "breed")

				if not (not table.contains(PLAYER_AND_BOT_UNITS, unit_2) and flag) then
					if not self:_is_infront_player(var_6_2, normalize, position) and not self:_check_within_cone(var_6_2, normalize, unit_2, true) then
						targets[#targets + 1] = unit_2
						tbl[unit_2] = true
					end
				elseif not get_data_2 and not self:_is_infront_player(var_6_2, normalize, position) and not self:_check_within_cone(var_6_2, normalize, unit_2) then
					targets[#targets + 1] = unit_2
					tbl[unit_2] = true

					if not HEALTH_ALIVE[unit_2] then
						num_7 = num_7 + 1
					end
				end

				if num_7 >= num_5 then
					break
				end
			end
		end

		Script.set_temp_count(temp_count, var_6_14, var_6_15)
	end
end

ActionBulletSpray._check_within_cone = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local CONE_COS_ALPHA = self.CONE_COS_ALPHA

	if not arg_8_4 then
		local sqrt = math.sqrt(num_2 * num_2 + num_4 * num_4)

		CONE_COS_ALPHA = num_2 / sqrt
	end

	local world_position = Unit.world_position(arg_8_3, Unit.node(arg_8_3, "j_neck"))
	local normalize = Vector3.normalize(world_position - arg_8_1)

	if CONE_COS_ALPHA <= Vector3.dot(arg_8_2, normalize) then
		return true
	end

	return false
end

ActionBulletSpray._is_infront_player = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local normalize = Vector3.normalize(arg_9_3 - arg_9_1)

	if Vector3.dot(normalize, arg_9_2) > 0 then
		return true
	end
end

ActionBulletSpray.raycast_to_target = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local get_data = World.get_data(arg_10_1, "physics_world")
	local str = "filter_player_ray_projectile"

	return (PhysicsWorld.immediate_raycast(get_data, arg_10_2, arg_10_3, "all", "collision_filter", str))
end
