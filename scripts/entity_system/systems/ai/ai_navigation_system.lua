-- chunkname: @scripts/entity_system/systems/ai/ai_navigation_system.lua

local num = 5
local num_2 = 1
local alive = Unit.alive
local tbl = {
	"AINavigationExtension",
	"PlayerBotNavigation"
}

AINavigationSystem = class(AINavigationSystem, ExtensionSystemBase)

AINavigationSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	AINavigationSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self.unit_extension_data = {}
	self.frozen_unit_extension_data = {}
	self.enabled_units = {}
	self.delayed_units = {}
	self.navbots_to_release = {}
	self.nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self._nav_safe_callbacks = {}
end

AINavigationSystem.destroy = function (arg_2_0)
	-- function 2
	AINavigationSystem.super.destroy(arg_2_0)
end

AINavigationSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local on_add_extension = AINavigationSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	if arg_3_3 == "AINavigationExtension" then
		arg_3_0.unit_extension_data[arg_3_2] = on_add_extension
	end

	return on_add_extension
end

AINavigationSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.frozen_unit_extension_data[arg_4_1] = nil

	self:_cleanup_extension(arg_4_1, arg_4_2)
	AINavigationSystem.super.on_remove_extension(self, arg_4_1, arg_4_2)
end

AINavigationSystem.on_freeze_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = self.unit_extension_data[arg_5_1]

	var_5_0 = var_5_0 or self.delayed_units[arg_5_1]

	fassert(var_5_0, "Unit was already frozen.")

	if var_5_0 == nil then
		return
	end

	self.frozen_unit_extension_data[arg_5_1] = var_5_0

	self:_cleanup_extension(arg_5_1, arg_5_2)
end

AINavigationSystem._cleanup_extension = function (self, arg_6_1, arg_6_2)
	-- function 6
	self.unit_extension_data[arg_6_1] = nil
	self.enabled_units[arg_6_1] = nil

	if self.delayed_unit == arg_6_1 then
		self.delayed_unit = next(self.delayed_units, arg_6_1)
	end

	self.delayed_units[arg_6_1] = nil
end

AINavigationSystem.freeze = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local frozen_unit_extension_data = self.frozen_unit_extension_data

	if not frozen_unit_extension_data[arg_7_1] then
		return
	end

	local var_7_1 = self.unit_extension_data[arg_7_1]

	var_7_1 = var_7_1 or self.delayed_units[arg_7_1]

	fassert(var_7_1, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(arg_7_1, arg_7_2)

	self.unit_extension_data[arg_7_1] = nil
	frozen_unit_extension_data[arg_7_1] = var_7_1

	var_7_1:freeze()
end

AINavigationSystem.unfreeze = function (self, arg_8_1)
	-- function 8
	local var_8_0 = self.frozen_unit_extension_data[arg_8_1]

	fassert(var_8_0, "Unit to unfreeze didn't have frozen extension")

	self.frozen_unit_extension_data[arg_8_1] = nil
	self.unit_extension_data[arg_8_1] = var_8_0

	var_8_0:unfreeze()
end

AINavigationSystem.simulate_dummy_target = function (self, arg_9_1)
	-- function 9
	local player_unit = Managers.player:local_player().player_unit

	if not player_unit then
		return
	end

	local var_9_1 = POSITION_LOOKUP[player_unit]
	local simulate_dummy_target = ConflictUtils.simulate_dummy_target(self.nav_world, var_9_1, arg_9_1)

	if not simulate_dummy_target then
		QuickDrawer:sphere(simulate_dummy_target, 1)

		for k, v in pairs(self.unit_extension_data) do
			v._blackboard.goal_destination = Vector3Box(simulate_dummy_target)

			v:move_to(simulate_dummy_target)
		end
	end
end

AINavigationSystem.update = function (self, arg_10_1, arg_10_2)
	-- function 10
	local dt = arg_10_1.dt

	self:update_extension("PlayerBotNavigation", dt, arg_10_1, arg_10_2)
	self:update_navbots_to_release()
	self:update_enabled()
	self:update_destination(arg_10_2)
	self:update_desired_velocity(arg_10_2, dt)
	self:update_next_smart_object(arg_10_2, dt)

	if not script_data.disable_crowd_dispersion then
		self:update_dispersion()
	end

	local _nav_safe_callbacks = self._nav_safe_callbacks
	local count = #_nav_safe_callbacks

	if count > 0 then
		for i = 1, count do
			_nav_safe_callbacks[i]()
		end

		table.clear(_nav_safe_callbacks)
	end
end

AINavigationSystem.add_safe_navigation_callback = function (arg_11_0, arg_11_1)
	-- function 11
	arg_11_0._nav_safe_callbacks[#arg_11_0._nav_safe_callbacks + 1] = arg_11_1
end

AINavigationSystem.post_update = function (self, arg_12_1, arg_12_2)
	-- function 12
	local dt = arg_12_1.dt

	self:update_position()
end

AINavigationSystem.add_navbot_to_release = function (self, arg_13_1)
	-- function 13
	local var_13_0 = self.unit_extension_data[arg_13_1]

	var_13_0 = var_13_0 or self.delayed_units[arg_13_1]
	self.navbots_to_release[arg_13_1] = var_13_0
end

AINavigationSystem.update_navbots_to_release = function (self)
	-- function 14
	for k, v in pairs(self.navbots_to_release) do
		v:release_bot()

		self.navbots_to_release[k] = nil
		self.enabled_units[k] = nil

		if self.delayed_unit == k then
			self.delayed_unit = next(self.delayed_units, k)
		end

		self.delayed_units[k] = nil
	end
end

AINavigationSystem.update_enabled = function (self)
	-- function 15
	for k, v in pairs(self.unit_extension_data) do
		local flag = v._nav_bot == nil or v._enabled

		self.enabled_units[k] = not flag and v and nil
	end

	for k_2, v_2 in pairs(self.delayed_units) do
		local flag_2 = v_2._nav_bot == nil or v_2._enabled

		self.enabled_units[k_2] = not flag_2 and v_2 and nil
	end
end

AINavigationSystem.update_destination = function (self, arg_16_1)
	-- function 16
	local POSITION_LOOKUP = POSITION_LOOKUP
	local distance_squared = Vector3.distance_squared
	local navigation_group_manager = Managers.state.conflict.navigation_group_manager

	for k, v in pairs(self.enabled_units) do
		local _nav_bot = v._nav_bot
		local flag = false
		local flag_2 = false

		if not _nav_bot then
			flag_2 = GwNavBot.is_following_path(_nav_bot)
			flag = GwNavBot.is_computing_new_path(_nav_bot)
		end

		local _blackboard = v._blackboard

		_blackboard.is_navbot_following_path = flag_2
		v._is_computing_path = flag
		v._is_navbot_following_path = flag_2

		if not (not _nav_bot and flag or not (arg_16_1 > v._wait_timer)) then
			local var_16_7 = POSITION_LOOKUP[k]
			local unbox = v._destination:unbox()
			local unbox_2 = v._wanted_destination:unbox()
			local flag_3 = true

			if not v._has_started_pathfind then
				v._has_started_pathfind = nil

				local flag_4 = distance_squared(var_16_7, unbox) < 0.01

				if not (flag_2 or flag_4) then
					_blackboard.no_path_found = nil
					v._failed_move_attempts = 0

					if not v._nav_channel_disabled_on_fail then
						GwNavBot.set_use_channel(_nav_bot, true)

						v._nav_channel_disabled_on_fail = false
					end
				else
					flag_3 = false
					_blackboard.no_path_found = true
					v._failed_move_attempts = v._failed_move_attempts + 1
					v._wait_timer = arg_16_1 + math.min(num, num_2 * v._failed_move_attempts)

					if not (not v._far_pathing_allowed and self:setup_far_astar(var_16_7, unbox_2, v, _blackboard, _nav_bot)) then
						v._failed_move_attempts = v._failed_move_attempts + 1

						v._wanted_destination:store(unbox)

						_blackboard.target_outside_navmesh = true

						if not RecycleSettings.destroy_no_path_found_time then
							self.delayed_units[k] = v
							self.unit_extension_data[k] = nil
							v.delayed_check_time = arg_16_1 + 1.5

							if not v.delayed_max_time then
								v.delayed_max_time = arg_16_1 + RecycleSettings.destroy_no_path_found_time
							end
						end
					end

					if not _blackboard.breed.use_navigation_path_splines then
						GwNavBot.set_use_channel(_nav_bot, false)

						v._nav_channel_disabled_on_fail = true
					end
				end
			end

			if not _blackboard.far_path and not flag_2 then
				local flag_5 = false

				if v:get_path_node_count() > 0 then
					local get_remaining_distance_from_progress_to_end_of_path = v:get_remaining_distance_from_progress_to_end_of_path()

					flag_5 = not get_remaining_distance_from_progress_to_end_of_path and get_remaining_distance_from_progress_to_end_of_path < 1
				end

				if not flag_5 then
					flag_3 = false

					local unbox_3 = v._backup_destination:unbox()
					local unbox_4 = v._original_backup_destination:unbox()
					local get_group_from_position = navigation_group_manager:get_group_from_position(unbox_3)
					local get_group_from_position_2 = navigation_group_manager:get_group_from_position(unbox_4)
					local current_far_path_index = _blackboard.current_far_path_index
					local num_far_path_nodes = _blackboard.num_far_path_nodes
					local var_16_20

					if not (get_group_from_position ~= get_group_from_position_2 or not (current_far_path_index < num_far_path_nodes - 1)) then
						local far_path = _blackboard.far_path
						local num_3 = current_far_path_index + 1

						var_16_20 = far_path[num_3]:get_group_center():unbox()
						_blackboard.current_far_path_index = num_3
					else
						_blackboard.far_path = nil
						_blackboard.current_far_path_index = nil
						_blackboard.num_far_path_nodes = nil
						var_16_20 = unbox_3
					end

					GwNavBot.compute_new_path(_nav_bot, var_16_20)
					v._wanted_destination:store(var_16_20)
					v._destination:store(var_16_20)

					v._is_computing_path = true
					v._has_started_pathfind = true
					_blackboard.next_smart_object_data.next_smart_object_id = nil
				end
			end

			if not flag_3 then
				local navigation_far_away_distance_sq = _blackboard.breed.navigation_far_away_distance_sq

				navigation_far_away_distance_sq = navigation_far_away_distance_sq or 36

				local var_16_24 = distance_squared(unbox, unbox_2)
				local var_16_25 = distance_squared(var_16_7, unbox_2)
				local flag_6 = navigation_far_away_distance_sq < var_16_25
				local flag_7 = not flag_6 and var_16_24 > 9 and not not flag_6 or var_16_24 > 0.01
				local flag_8 = var_16_25 < 0.01

				if not ((GwNavBot.is_path_recomputation_needed(_nav_bot) or not not flag_8 or not flag_2) and flag_7) then
					GwNavBot.compute_new_path(_nav_bot, unbox_2)
					v._destination:store(unbox_2)

					v._is_computing_path = true
					v._has_started_pathfind = true
					v._wait_timer = 0
					_blackboard.next_smart_object_data.next_smart_object_id = nil
				end
			end
		end
	end

	self:update_delayed_units(arg_16_1)
end

AINavigationSystem.update_delayed_units = function (self, arg_17_1)
	-- function 17
	local delayed_units = self.delayed_units
	local delayed_unit = self.delayed_unit

	if not alive(delayed_unit) then
		local var_17_2 = delayed_units[delayed_unit]

		if arg_17_1 > var_17_2.delayed_check_time then
			self.unit_extension_data[delayed_unit] = var_17_2
			self.delayed_unit = next(delayed_units, delayed_unit)
			delayed_units[delayed_unit] = nil

			local _nav_bot = var_17_2._nav_bot

			if not _nav_bot and not GwNavBot.is_following_path(_nav_bot) then
				var_17_2.delayed_max_time = nil

				return
			end

			if arg_17_1 > var_17_2.delayed_max_time then
				if not RecycleSettings.destroy_no_path_only_behind then
					local conflict = Managers.state.conflict
					local main_path_info = conflict.main_path_info

					if not alive(main_path_info.behind_unit) then
						local var_17_6 = conflict.main_path_player_info[main_path_info.behind_unit]
						local closest_pos_at_main_path, var_17_8, var_17_9, var_17_10, var_17_11 = MainPathUtils.closest_pos_at_main_path(nil, POSITION_LOOKUP[delayed_unit])

						if not (var_17_11 < var_17_6.path_index) then
							Managers.state.conflict:destroy_unit(delayed_unit, var_17_2._blackboard, "main_path_blocked")
						end
					end
				else
					Managers.state.conflict:destroy_unit(delayed_unit, var_17_2._blackboard, "no_path_found")
				end
			end
		end
	end

	if self.delayed_unit == delayed_unit then
		self.delayed_unit = next(delayed_units, delayed_unit)
	end
end

AINavigationSystem.setup_far_astar = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
	if not arg_18_4.far_path then
		arg_18_4.far_path = nil
		arg_18_4.current_far_path_index = nil
		arg_18_4.num_far_path_nodes = nil
	end

	local far_astar, var_18_1, var_18_2, var_18_3 = self:far_astar(arg_18_1, arg_18_2)

	if not far_astar then
		arg_18_3:move_to(var_18_1)
		arg_18_3._backup_destination:store(arg_18_2)
		arg_18_3._original_backup_destination:store(arg_18_2)

		arg_18_4.far_path = var_18_2
		arg_18_4.current_far_path_index = 2
		arg_18_4.num_far_path_nodes = var_18_3

		GwNavBot.compute_new_path(arg_18_5, var_18_1)
		arg_18_3._destination:store(var_18_1)

		arg_18_3._is_computing_path = true
		arg_18_3._has_started_pathfind = true
		arg_18_3._wait_timer = 0
		arg_18_4.next_smart_object_data.next_smart_object_id = nil

		return true
	end
end

AINavigationSystem.far_astar = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	local a_star_cached_between_positions, var_19_1 = Managers.state.conflict.navigation_group_manager:a_star_cached_between_positions(arg_19_1, arg_19_2)

	if not a_star_cached_between_positions then
		return false
	end

	local count = #a_star_cached_between_positions

	if count <= 1 then
		return false
	end

	local unbox = a_star_cached_between_positions[2]:get_group_center():unbox()

	return true, unbox, a_star_cached_between_positions, count
end

local num_3 = 0.0001

AINavigationSystem.update_desired_velocity = function (self, arg_20_1, arg_20_2)
	-- function 20
	local num = 0
	local nav_world = self.nav_world

	for k, v in pairs(self.enabled_units) do
		local _blackboard = v._blackboard
		local var_20_3

		if _blackboard.move_state ~= "idle" then
			var_20_3 = GwNavBot.output_velocity(v._nav_bot)
		else
			var_20_3 = Vector3.zero()
		end

		local var_20_4 = var_20_3
		local var_20_5 = POSITION_LOOKUP[k]
		local unbox = v._wanted_destination:unbox()
		local distance_squared = Vector3.distance_squared(var_20_5, unbox)
		local flag = distance_squared < 0.010000000000000002
		local length_squared = Vector3.length_squared(var_20_3)
		local locomotion_extension = _blackboard.locomotion_extension

		if Vector3.length_squared(locomotion_extension:current_velocity()) == 0 then
			v._interpolating = false
		end

		local _is_computing_path = v._is_computing_path
		local _is_navbot_following_path = v._is_navbot_following_path

		if (not (length_squared < num_3) or not not flag or not _is_computing_path) and _is_navbot_following_path or not v._interpolating then
			v._interpolating = _is_computing_path

			if not _is_computing_path then
				local look = Quaternion.look(Vector3.flat(unbox - var_20_5), Vector3.up())
				local _max_speed = v._max_speed

				if not (not (num < 1) or not (arg_20_1 > v._raycast_timer)) then
					v._raycast_timer = arg_20_1 + 1
					num = num + 1

					local num_2 = var_20_5 + Quaternion.forward(look) * 2

					if not GwNavQueries.raycango(nav_world, var_20_5, num_2, v._traverse_logic) then
						_blackboard.no_path_found = true
						v._interpolating = nil
						_max_speed = 0 or _max_speed
					end
				end

				local num_4 = locomotion_extension:get_rotation_speed() * locomotion_extension:get_rotation_speed_modifier() * arg_20_2

				if distance_squared < 9 then
					num_4 = math.min(1, num_4 * 2)
					_max_speed = _max_speed * 0.5
				end

				local world_rotation = Unit.world_rotation(k, 0)
				local lerp = Quaternion.lerp(world_rotation, look, num_4)

				locomotion_extension:set_wanted_rotation(lerp)

				var_20_4 = Quaternion.forward(lerp) * _max_speed
			end
		end

		var_20_4.z = 0

		local length = Vector3.length(var_20_4)

		v._current_speed = math.min(length, v._max_speed, v._current_speed + arg_20_2 * 3 * v._max_speed)

		local num_5 = Vector3.normalize(var_20_4) * v._current_speed

		locomotion_extension:set_wanted_velocity_flat(num_5)
	end
end

AINavigationSystem.update_next_smart_object = function (self, arg_21_1, arg_21_2)
	-- function 21
	for k, v in pairs(self.enabled_units) do
		local next_smart_object_data = v._blackboard.next_smart_object_data
		local GwNavSmartObjectInterval = GwNavSmartObjectInterval
		local _next_smartobject_interval = v._next_smartobject_interval
		local num = 2

		if not GwNavBot.current_or_next_smartobject_interval(v._nav_bot, _next_smartobject_interval, num) then
			local entrance_position, var_21_5 = GwNavSmartObjectInterval.entrance_position(_next_smartobject_interval)
			local exit_position, var_21_7 = GwNavSmartObjectInterval.exit_position(_next_smartobject_interval)
			local smartobject_id = GwNavSmartObjectInterval.smartobject_id(_next_smartobject_interval)
			local system = Managers.state.entity:system("nav_graph_system")

			if smartobject_id == -1 or not system:get_smart_object_type(smartobject_id) then
				next_smart_object_data.next_smart_object_id = smartobject_id

				next_smart_object_data.entrance_pos:store(entrance_position)
				next_smart_object_data.exit_pos:store(exit_position)

				next_smart_object_data.entrance_is_at_bot_progress_on_path = var_21_5
				next_smart_object_data.exit_is_at_the_end_of_path = var_21_7

				fassert(next_smart_object_data.next_smart_object_id)

				next_smart_object_data.smart_object_type = system:get_smart_object_type(next_smart_object_data.next_smart_object_id)
				next_smart_object_data.smart_object_data = system:get_smart_object_data(next_smart_object_data.next_smart_object_id)

				fassert(LAYER_ID_MAPPING[next_smart_object_data.smart_object_type] ~= nil, "Invalid smart object type %s", next_smart_object_data.smart_object_type)
			end
		else
			next_smart_object_data.next_smart_object_id = nil
		end

		if not next_smart_object_data.next_smart_object_id then
			local distance_squared = Vector3.distance_squared(next_smart_object_data.entrance_pos:unbox(), Unit.local_position(v._unit, 0))

			v._blackboard.is_in_smartobject_range = distance_squared < 1
		end
	end
end

AINavigationSystem.update_dispersion = function (self, arg_22_1, arg_22_2)
	-- function 22
	for k, v in pairs(self.enabled_units) do
		local update_logic_for_crowd_dispersion = GwNavBot.update_logic_for_crowd_dispersion(v._nav_bot)

		if update_logic_for_crowd_dispersion == 1 then
			-- Nothing
		elseif update_logic_for_crowd_dispersion == 2 then
			-- Nothing
		end
	end
end

AINavigationSystem.update_position = function (self, arg_23_1, arg_23_2)
	-- function 23
	for k, v in pairs(self.enabled_units) do
		if not v._nav_bot then
			local local_position = Unit.local_position(v._unit, 0)

			GwNavBot.update_position(v._nav_bot, local_position)
		end
	end
end

AINavigationSystem.update_debug_draw = function (self, arg_24_1)
	-- function 24
	local drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "AINavigationExtension"
	})
	local get = Colors.get("pink")
	local get_2 = Colors.get("purple")
	local var_24_3 = Vector3(0, 0, 0.01)

	for k, v in pairs(self.unit_extension_data) do
		local local_position = Unit.local_position(k, 0)
		local var_24_5 = self.enabled_units[k]
		local flag = not var_24_5 and get and get_2
		local unbox = v._wanted_destination:unbox()
		local unbox_2 = v._destination:unbox()

		drawer:sphere(local_position, 0.1, flag)
		drawer:sphere(unbox, 0.2, flag)
		drawer:vector(local_position, unbox - local_position, flag)

		if Vector3.distance_squared(unbox, unbox_2) > 0.1 then
			drawer:vector(local_position + var_24_3, unbox_2 - local_position, Colors.get("green"))
		end

		if not var_24_5 then
			local velocity = GwNavBot.velocity(v._nav_bot)

			if Vector3.length(velocity) > 0 then
				drawer:vector(local_position + Vector3.up(), Vector3.normalize(velocity), flag)
			end
		end

		local next_smart_object_data = v._blackboard.next_smart_object_data

		if not next_smart_object_data.next_smart_object_id then
			local unbox_3 = next_smart_object_data.entrance_pos:unbox()
			local unbox_4 = next_smart_object_data.exit_pos:unbox()
			local var_24_13 = drawer
			local sphere = drawer.sphere
			local var_24_15 = unbox_3
			local num = 0.3
			local get_3

			if not next_smart_object_data.entrance_is_at_bot_progress_on_path then
				get_3 = Colors.get("pink")

				if not get_3 then
					-- Nothing
				end
			end

			get_3 = Colors.get("red")

			::label_24_0::

			sphere(var_24_13, var_24_15, num, get_3)

			local var_24_18 = drawer
			local sphere_2 = drawer.sphere
			local var_24_20 = unbox_4
			local num_2 = 0.3
			local get_4

			if not next_smart_object_data.exit_is_at_the_end_of_path then
				get_4 = Colors.get("pink")

				if not get_4 then
					-- Nothing
				end
			end

			get_4 = Colors.get("red")

			::label_24_1::

			sphere_2(var_24_18, var_24_20, num_2, get_4)

			local var_24_23 = drawer
			local vector = drawer.vector
			local var_24_25 = unbox_3
			local num_3 = unbox_4 - unbox_3
			local get_5

			if not next_smart_object_data.next_smart_object_id then
				get_5 = Colors.get("pink")

				if not get_5 then
					-- Nothing
				end
			end

			get_5 = Colors.get("red")

			::label_24_2::

			vector(var_24_23, var_24_25, num_3, get_5)
		end
	end

	local debug_unit = script_data.debug_unit
	local var_24_29 = self.unit_extension_data[debug_unit]

	var_24_29 = var_24_29 or self.delayed_units[debug_unit]

	if not alive(debug_unit) and not var_24_29 then
		local _blackboard = var_24_29._blackboard

		if script_data.debug_ai_movement == "text_and_graphics" then
			self:_debug_draw_text(debug_unit, _blackboard, var_24_29, arg_24_1)
		end

		self:_debug_draw_nav_path(drawer, var_24_29)
		self:_debug_draw_far_path(drawer, debug_unit, _blackboard, var_24_29)
	end
end

AINavigationSystem._debug_draw_text = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	Debug.text("AI NAVIGATION DEBUG")
	Debug.text("  enabled = %s", tostring(self.enabled_units[arg_25_1] ~= nil))

	local text = Debug.text
	local str = "  using far-path = %s"
	local flag

	flag = not arg_25_2.far_path and "YES" and "NO"

	text(str, flag)
	Debug.text("  has_reached = %s", tostring(arg_25_3:has_reached_destination()))

	local text_2 = Debug.text
	local str_2 = "  remaining path distance = %.2f"
	local get_remaining_distance_from_progress_to_end_of_path = arg_25_3:get_remaining_distance_from_progress_to_end_of_path()

	get_remaining_distance_from_progress_to_end_of_path = get_remaining_distance_from_progress_to_end_of_path or 0

	text_2(str_2, get_remaining_distance_from_progress_to_end_of_path)
	Debug.text("  dist to dest = %.2f", tostring(arg_25_3:distance_to_destination()))
	Debug.text("  current_speed = %.2f", arg_25_3._current_speed)

	local text_3 = Debug.text
	local str_3 = "  desired_velocity = %s"
	local var_25_8

	if not arg_25_3._nav_bot then
		var_25_8 = tostring(GwNavBot.output_velocity(arg_25_3._nav_bot))

		if not var_25_8 then
			-- Nothing
		end
	end

	var_25_8 = "?"

	::label_25_0::

	text_3(str_3, var_25_8)
	Debug.text("  failed_move_attempts = %d", arg_25_3._failed_move_attempts)
	Debug.text("  no_path_found = %s", tostring(arg_25_2.no_path_found))
	Debug.text("  is_computing_path = %s", tostring(arg_25_3._is_computing_path))
	Debug.text("  is_following_path = %s", tostring(arg_25_3:is_following_path()))
	Debug.text("  interpolating = %s", tostring(arg_25_3._interpolating))

	local text_4 = Debug.text
	local str_4 = "  move_state = %s"
	local tostring = tostring
	local move_state = arg_25_3._blackboard.move_state

	move_state = move_state or "nil"

	text_4(str_4, tostring(move_state))
	Debug.text("  btnode = %s", tostring(arg_25_2.btnode_name))
	Debug.text("  wait_timer = %.1f", math.max(-1, arg_25_3._wait_timer - arg_25_4))
end

AINavigationSystem._debug_draw_nav_path = function (arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	local _nav_bot = arg_26_2._nav_bot

	if _nav_bot == nil then
		return
	end

	if not arg_26_2._is_navbot_following_path then
		return
	end

	local get_path_nodes_count = GwNavBot.get_path_nodes_count(_nav_bot)

	if get_path_nodes_count > 0 then
		local var_26_2
		local get_path_current_node_index = GwNavBot.get_path_current_node_index(_nav_bot)
		local num = Vector3.up() * 0.05

		for i = 0, get_path_nodes_count - 1 do
			local get_path_node_pos = GwNavBot.get_path_node_pos(_nav_bot, i)
			local get

			if get_path_current_node_index == i then
				get = Colors.get("green")

				if not get then
					-- Nothing
				end
			end

			get = Colors.get("powder_blue")

			::label_26_0::

			arg_26_1:sphere(get_path_node_pos + num, 0.1, get)

			if not var_26_2 then
				arg_26_1:line(get_path_node_pos + num, var_26_2 + num, Colors.get("powder_blue"))
			end

			var_26_2 = get_path_node_pos
		end
	end
end

AINavigationSystem._debug_draw_far_path = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local far_path = arg_27_3.far_path

	if not far_path then
		local var_27_1 = POSITION_LOOKUP[arg_27_2]
		local num_far_path_nodes = arg_27_3.num_far_path_nodes
		local current_far_path_index = arg_27_3.current_far_path_index
		local var_27_4

		for i = 1, num_far_path_nodes do
			local unbox = far_path[i]:get_group_center():unbox()
			local flag = not (i < current_far_path_index) or Colors.get("yellow")
			local num = 0.1

			if i < current_far_path_index then
				flag = Colors.get("orange")
			elseif i == current_far_path_index then
				flag = Colors.get("green")
				num = num + math.random() * 0.1
			elseif i < num_far_path_nodes then
				flag = Colors.get("yellow")
			else
				flag = Colors.get("black")
			end

			if not var_27_4 then
				arg_27_1:line(var_27_4, unbox, flag)
			end

			arg_27_1:sphere(unbox, num, flag)

			var_27_4 = unbox
		end

		local unbox_2 = arg_27_4._backup_destination:unbox()

		arg_27_1:sphere(unbox_2, 0.1, Colors.get("yellow"))
		arg_27_1:sphere(unbox_2, 0.2, Colors.get("yellow"))
		arg_27_1:vector(var_27_1, unbox_2 - var_27_1, Colors.get("yellow"))
	end
end

NAVIGATION_RUNNING_IN_THREAD = false

AINavigationSystem.override_nav_funcs = function (arg_28_0)
	-- function 28
	local tbl = {
		"GwNavWorld",
		"GwNavBot",
		"GwNavQueries",
		"GwNavSmartObjectInterval",
		"GwNavTagLayerCostTable",
		"GwNavTraverseLogic",
		"GwNavBoxObstacle",
		"GwNavAStar",
		"GwNavCylinderObstacle",
		"GwNavTagVolume"
	}

	for i = 1, #tbl do
		local var_28_1 = tbl[i]
		local var_28_2 = _G[var_28_1]

		for k, v in pairs(var_28_2) do
			if not (k == "join_async_update" or k == "kick_async_update") then
				var_28_2[k] = function (...)
					-- function 29
					fassert(not NAVIGATION_RUNNING_IN_THREAD, "%s.%s() function was run during navigation running on other thread", var_28_1, k)

					return v(...)
				end
			end
		end
	end
end
