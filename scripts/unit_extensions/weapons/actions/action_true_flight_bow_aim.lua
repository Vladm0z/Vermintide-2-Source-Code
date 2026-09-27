-- chunkname: @scripts/unit_extensions/weapons/actions/action_true_flight_bow_aim.lua

require("scripts/unit_extensions/weapons/projectiles/true_flight_templates")
require("scripts/unit_extensions/weapons/projectiles/true_flight_utility")

ActionTrueFlightBowAim = class(ActionTrueFlightBowAim, ActionBase)

local unit = Actor.unit
local node = Actor.node
local actor = Unit.actor
local has_node = Unit.has_node
local node_2 = Unit.node
local get_data = Unit.get_data
local world_position = Unit.world_position
local distance_squared = Vector3.distance_squared
local length = Vector3.length
local dot = Vector3.dot
local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4

ActionTrueFlightBowAim.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionTrueFlightBowAim.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(self.weapon_unit, "spread_system") then
		self.spread_extension = ScriptUnit.extension(self.weapon_unit, "spread_system")
	end

	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	self._weapon_extension = ScriptUnit.extension(self.weapon_unit, "weapon_system")
end

ActionTrueFlightBowAim.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	ActionTrueFlightBowAim.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3)

	self._marked_target = {}
	self.current_action = arg_2_1
	self.aim_timer = 0
	self.aim_sticky_timer = 0
	self._is_sticky_target = false
	self._current_target_priority = -1

	local target

	if not arg_2_3 then
		target = arg_2_3.target

		if not target then
			-- Nothing
		end
	end

	target = nil

	::label_2_0::

	self.target = target

	local targets

	if not arg_2_3 then
		targets = arg_2_3.targets

		if not targets then
			-- Nothing
		end
	end

	targets = {}

	::label_2_1::

	self.targets = targets

	local target_2

	if not arg_2_3 then
		target_2 = arg_2_3.target

		if not target_2 then
			-- Nothing
		end
	end

	target_2 = nil

	::label_2_2::

	self.aimed_target = target_2

	self:_mark_target(self.target)

	self.time_to_shoot = arg_2_2

	local owner_unit = self.owner_unit

	self.side = Managers.state.side.side_by_unit[owner_unit]

	local side = self.side

	side = not side and self.side.enemy_broadphase_categories
	self.target_broadphase_categories = side

	local extension = ScriptUnit.extension(owner_unit, "buff_system")
	local ignored_breeds = arg_2_1.ignored_breeds

	ignored_breeds = ignored_breeds or {}
	self._ignored_breeds = ignored_breeds

	local var_2_7 = extension
	local apply_buffs_to_value = extension.apply_buffs_to_value
	local charge_time = arg_2_1.charge_time

	charge_time = charge_time or 0
	self.charge_time = apply_buffs_to_value(var_2_7, charge_time, "reduced_ranged_charge_time")
	self.overcharge_timer = 0
	self.zoom_condition_function = arg_2_1.zoom_condition_function
	self.prioritized_breeds = arg_2_1.prioritized_breeds
	self.played_aim_sound = false

	local aim_sound_delay = arg_2_1.aim_sound_delay

	aim_sound_delay = aim_sound_delay or 0
	self.aim_sound_time = arg_2_2 + aim_sound_delay

	local aim_zoom_delay = arg_2_1.aim_zoom_delay

	aim_zoom_delay = aim_zoom_delay or 0
	self.aim_zoom_time = arg_2_2 + aim_zoom_delay

	local loaded_projectile_settings = arg_2_1.loaded_projectile_settings

	if not loaded_projectile_settings then
		ScriptUnit.extension(self.owner_unit, "inventory_system"):set_loaded_projectile_override(loaded_projectile_settings)
	end

	self.charge_ready_sound_event = self.current_action.charge_ready_sound_event

	self:_start_charge_sound()

	local spread_template_override = arg_2_1.spread_template_override

	if not spread_template_override then
		self.spread_extension:override_spread_template(spread_template_override)
	end
end

ActionTrueFlightBowAim._start_charge_sound = function (self)
	-- function 3
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local owner_player = self.owner_player
	local flag = not owner_player and owner_player.bot_player
	local flag_2 = not owner_player and not owner_player.remote
	local wwise_world = self.wwise_world

	if not (not flag_2 and flag) then
		local start_charge_sound, var_3_7 = ActionUtils.start_charge_sound(wwise_world, self.weapon_unit, owner_unit, current_action)

		self.charging_sound_id = start_charge_sound
		self.wwise_source_id = var_3_7
	end

	ActionUtils.play_husk_sound_event(wwise_world, current_action.charge_sound_husk_name, owner_unit, flag)
end

ActionTrueFlightBowAim._stop_charge_sound = function (self)
	-- function 4
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local owner_player = self.owner_player
	local flag = not owner_player and owner_player.bot_player
	local flag_2 = not owner_player and not owner_player.remote
	local wwise_world = self.wwise_world

	if not (not flag_2 and flag) then
		ActionUtils.stop_charge_sound(wwise_world, self.charging_sound_id, self.wwise_source_id, current_action)

		self.charging_sound_id = nil
		self.wwise_source_id = nil
	end

	ActionUtils.play_husk_sound_event(wwise_world, current_action.charge_sound_husk_stop_event, owner_unit, flag)
end

local function fn(arg_5_0)
	-- function 5
	local has_extension = ScriptUnit.has_extension(arg_5_0, "status_system")

	return not has_extension and has_extension:is_invisible()
end

local tbl = {}

ActionTrueFlightBowAim.client_owner_post_update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local time_to_shoot = self.time_to_shoot
	local target = self.target
	local owner = Managers.player:owner(owner_unit)
	local flag = not owner and owner.bot_player

	if not current_action.overcharge_interval then
		self.overcharge_timer = self.overcharge_timer + arg_6_1

		if self.overcharge_timer >= current_action.overcharge_interval then
			if not self.overcharge_extension then
				local var_6_6 = PlayerUnitStatusSettings.overcharge_values[current_action.overcharge_type]

				self.overcharge_extension:add_charge(var_6_6)
			end

			self.overcharge_timer = 0
		end
	end

	if not self.zoom_condition_function and not self.zoom_condition_function() then
		local extension = ScriptUnit.extension(owner_unit, "status_system")
		local extension_2 = ScriptUnit.extension(owner_unit, "input_system")
		local extension_3 = ScriptUnit.extension(owner_unit, "buff_system")

		if not (extension:is_zooming() or not (arg_6_2 >= self.aim_zoom_time)) then
			extension:set_zooming(true, current_action.default_zoom)
		end

		if not extension_3:has_buff_type("increased_zoom") and not extension:is_zooming() and not extension_2:get("action_three") then
			extension:switch_variable_zoom(current_action.buffed_zoom_thresholds)
		elseif not current_action.zoom_thresholds and not extension:is_zooming() and not extension_2:get("action_three") then
			extension:switch_variable_zoom(current_action.zoom_thresholds)
		end
	end

	if not (self.played_aim_sound or not (arg_6_2 >= self.aim_sound_time) or flag) then
		local aim_sound_event = current_action.aim_sound_event

		if not aim_sound_event then
			local wwise_world = self.wwise_world

			WwiseWorld.trigger_event(wwise_world, aim_sound_event)
		end

		self.played_aim_sound = true
	end

	if not target and not HEALTH_ALIVE[target] and not fn(target) then
		if not flag then
			self:_mark_target(nil)
		end

		self.target = nil
		self.aimed_target = nil
		target = nil
	end

	local aim_time = current_action.aim_time

	aim_time = aim_time or 0.1

	local aim_sticky_time = current_action.aim_sticky_time

	aim_sticky_time = aim_sticky_time or 0

	if not (not (aim_time <= self.aim_timer) or not target or not (aim_sticky_time <= self.aim_sticky_timer)) then
		local get_data = World.get_data(arg_6_3, "physics_world")
		local get_projectile_start_position_rotation, var_6_16 = self.first_person_extension:get_projectile_start_position_rotation()
		local normalize = Vector3.normalize(Quaternion.forward(var_6_16))
		local var_6_18
		local var_6_19

		if not current_action.aim_obstructed_by_walls then
			var_6_18, var_6_19 = PhysicsWorld.immediate_raycast_actors(get_data, get_projectile_start_position_rotation, normalize, "dynamic_collision_filter", "filter_ray_true_flight_ai_only", "dynamic_collision_filter", "filter_ray_true_flight_hitbox_only", "static_collision_filter", "filter_player_ray_projectile_static_only")
		else
			var_6_18, var_6_19 = PhysicsWorld.immediate_raycast_actors(get_data, get_projectile_start_position_rotation, normalize, "dynamic_collision_filter", "filter_ray_true_flight_ai_only", "dynamic_collision_filter", "filter_ray_true_flight_hitbox_only")
		end

		local flag_2 = true

		if not current_action.can_target_players then
			flag_2 = current_action.can_target_players(self.owner_unit)
		end

		local _ignored_breeds = self._ignored_breeds
		local side = Managers.state.side
		local side_by_unit = side.side_by_unit
		local var_6_24
		local num = -1
		local side_2 = self.side

		if var_6_19 > 0 then
			local prioritized_breeds = self.prioritized_breeds

			prioritized_breeds = prioritized_breeds or tbl

			local ignore_bosses = current_action.ignore_bosses

			for i = 1, var_6_19 do
				repeat
					local var_6_29 = var_6_18[i][num_4]

					if not var_6_29 then
						break
					end

					local var_6_30 = unit(var_6_29)

					if not HEALTH_ALIVE[var_6_30] then
						break
					end

					local var_6_31 = side_by_unit[var_6_30]

					if not (not var_6_31 and side:is_enemy_by_side(side_2, var_6_31)) then
						break
					end

					local var_6_32 = node(var_6_29)
					local unit_breed = AiUtils.unit_breed(var_6_30)

					if not unit_breed and not _ignored_breeds[unit_breed.name] then
						break
					end

					if not (not unit_breed.is_player and flag_2) then
						break
					end

					local var_6_34 = unit_breed.hit_zones_lookup[var_6_32]

					if not (not var_6_34 and var_6_34.name ~= "afro") then
						break
					end

					if unit_breed.no_autoaim or not ignore_bosses or not unit_breed.boss then
						break
					end

					if not fn(var_6_30) then
						break
					end

					local var_6_35 = prioritized_breeds[unit_breed.name]

					var_6_35 = var_6_35 or -1

					if not (not (var_6_35 > 0) or not (num < var_6_35)) then
						var_6_24 = var_6_30
						num = var_6_35

						break
					end

					var_6_24 = var_6_24 or var_6_30
				until true
			end
		end

		if not (not current_action.aim_sticky_target_size and not POSITION_LOOKUP[target] and not self._is_sticky_target and not (num <= self._current_target_priority)) then
			local var_6_36 = distance_squared(POSITION_LOOKUP[target], get_projectile_start_position_rotation)
			local var_6_37

			if not var_6_24 then
				var_6_37 = distance_squared(POSITION_LOOKUP[var_6_24], get_projectile_start_position_rotation)

				if not var_6_37 then
					-- Nothing
				end
			end

			var_6_37 = math.huge

			::label_6_0::

			if var_6_36 < var_6_37 then
				local var_6_38

				if not has_node(target, "j_spine1") then
					var_6_38 = node_2(target, "j_spine1")

					if not var_6_38 then
						-- Nothing
					end
				end

				var_6_38 = 0

				::label_6_1::

				local num_2 = world_position(target, var_6_38) - get_projectile_start_position_rotation
				local var_6_40 = length(num_2)
				local num_3

				if var_6_40 > 0 then
					num_3 = num_2 / var_6_40

					if not num_3 then
						-- Nothing
					end
				end

				num_3 = 0

				::label_6_2::

				local aim_sticky_target_size = current_action.aim_sticky_target_size

				if math.cos(math.atan2(aim_sticky_target_size, var_6_40)) < dot(normalize, num_3) then
					var_6_24 = target
				else
					self._is_sticky_target = false
				end
			end
		end

		if not var_6_24 then
			if self.aimed_target ~= var_6_24 then
				self.aimed_target = var_6_24
				self.aim_timer = 0

				if not (not ALIVE[var_6_24] and target == var_6_24) then
					self.target = var_6_24

					self:_mark_target(var_6_24)

					self.aim_sticky_timer = 0
					self._is_sticky_target = num > 0
					self._current_target_priority = num
				end
			end
		elseif not current_action.target_break_size and not target then
			local var_6_43

			if not has_node(target, "j_spine1") then
				var_6_43 = node_2(target, "j_spine1")

				if not var_6_43 then
					-- Nothing
				end
			end

			var_6_43 = 0

			::label_6_3::

			local var_6_44 = world_position(target, var_6_43)
			local direction_length, var_6_46 = Vector3.direction_length(var_6_44 - get_projectile_start_position_rotation)
			local target_break_size = current_action.target_break_size

			if math.cos(math.atan2(target_break_size, var_6_46)) > dot(normalize, direction_length) then
				self:_mark_target(nil)

				self.target = nil
				self.aimed_target = nil
			end
		end
	end

	self.charge_value = math.min(math.max(arg_6_2 - time_to_shoot, 0) / self.charge_time, 1)

	if not flag then
		local charge_sound_parameter_name = current_action.charge_sound_parameter_name

		if not charge_sound_parameter_name then
			local wwise_world_2 = self.wwise_world
			local wwise_source_id = self.wwise_source_id

			WwiseWorld.set_source_parameter(wwise_world_2, wwise_source_id, charge_sound_parameter_name, self.charge_value)
		end

		if not (not self.charge_ready_sound_event and not (self.charge_value >= 1)) then
			self.first_person_extension:play_hud_sound_event(self.charge_ready_sound_event)

			self.charge_ready_sound_event = nil
		end
	end

	self.aim_timer = self.aim_timer + arg_6_1
	self.aim_sticky_timer = self.aim_sticky_timer + arg_6_1
end

ActionTrueFlightBowAim._get_visible_targets = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local first_person_extension = self.first_person_extension
	local num = 50
	local num_2 = math.pi * 0.2
	local get_projectile_start_position_rotation, var_7_4 = first_person_extension:get_projectile_start_position_rotation()
	local forward = Quaternion.forward(var_7_4)
	local cos = math.cos(num_2)
	local tbl = {}
	local alloc_table = FrameTable.alloc_table()
	local broadphase_query = AiUtils.broadphase_query(get_projectile_start_position_rotation, num, alloc_table, self.target_broadphase_categories)

	if broadphase_query > 0 then
		for i = 1, broadphase_query do
			local var_7_10 = alloc_table[i]

			if not HEALTH_ALIVE[var_7_10] then
				local var_7_11 = get_data(var_7_10, "breed")

				if not (not var_7_11 and var_7_11.no_autoaim) then
					local normalize = Vector3.normalize(POSITION_LOOKUP[var_7_10] - get_projectile_start_position_rotation)

					if not (not (cos < Vector3.dot(forward, normalize)) or var_7_10 == arg_7_1 or fn(var_7_10)) then
						tbl[#tbl + 1] = var_7_10
					end
				end
			end
		end
	else
		tbl = self.targets

		for j = #tbl, 1, -1 do
			if not ALIVE[tbl[j]] and not fn(tbl[j]) then
				table.remove(tbl, j)
			end
		end
	end

	TrueFlightUtility.sort_prioritize_specials(tbl)

	if not (not arg_7_1 and fn(arg_7_1)) then
		table.insert(tbl, 1, arg_7_1)
	end

	return tbl
end

ActionTrueFlightBowAim.finish = function (self, arg_8_1, arg_8_2)
	-- function 8
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local unzoom_condition_function = current_action.unzoom_condition_function

	if not self.spread_extension then
		self.spread_extension:reset_spread_template()
	end

	if not unzoom_condition_function and not unzoom_condition_function(arg_8_1) then
		ScriptUnit.extension(owner_unit, "status_system"):set_zooming(false)
	end

	local unaim_sound_event = current_action.unaim_sound_event

	if not unaim_sound_event then
		local wwise_world = self.wwise_world

		WwiseWorld.trigger_event(wwise_world, unaim_sound_event)
	end

	local tbl = {}

	if not (not current_action.num_projectiles and not (current_action.num_projectiles > 1)) then
		local owner = Managers.player:owner(owner_unit)
		local flag = not owner and owner.bot_player

		tbl.targets = self:_get_visible_targets(self.target, current_action.num_projectiles, flag)
	end

	tbl.target = self.target

	self:_stop_charge_sound()
	self:_mark_target(nil)

	self.targets = nil
	self.target = nil

	ScriptUnit.extension(owner_unit, "inventory_system"):set_loaded_projectile_override(nil)

	return tbl
end

ActionTrueFlightBowAim._mark_target = function (self, arg_9_1)
	-- function 9
	if not self.is_bot then
		return
	end

	if not self.current_action.weapon_mode_target_swap then
		if not arg_9_1 then
			self._weapon_extension:set_mode(true)
		else
			self._weapon_extension:set_mode(false)
		end
	end

	local _marked_target = self._marked_target

	if not _marked_target.outline_extension then
		_marked_target.outline_extension:remove_outline(_marked_target.outline_id)

		_marked_target.outline_extension = nil
		_marked_target.outline_id = nil
	end

	if not arg_9_1 and not ALIVE[arg_9_1] then
		local has_extension = ScriptUnit.has_extension(self.target, "outline_system")

		if not has_extension then
			_marked_target.outline_extension = has_extension
			_marked_target.outline_id = has_extension:add_outline(OutlineSettings.templates.target_enemy)
		end
	end
end
