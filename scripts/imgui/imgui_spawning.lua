-- chunkname: @scripts/imgui/imgui_spawning.lua

ImguiSpawning = class(ImguiSpawning)

ImguiSpawning.init = function (self)
	-- function 1
	self._breed_index = 0
	self._breed_names = table.keys(Breeds)

	table.sort(self._breed_names)

	self._pickup_index = 0
	self._pickup_names = table.keys(AllPickups)

	table.sort(self._pickup_names)

	self._mark_outline_extension = nil
	self._mark_outline_id = nil
	self._damage = 100
end

ImguiSpawning.update = function (self)
	-- function 2
	if not self._mark_outline_extension then
		self._mark_outline_extension:remove_outline(self._mark_outline_id)

		self._mark_outline_extension = nil
	end
end

local str = "skaven_clan_rat"

local function fn()
	-- function 3
	return Breeds[str]
end

ImguiSpawning.draw = function (self)
	-- function 4
	local begin_window = Imgui.begin_window("Spawning")
	local var_4_1 = self._pickup_names[self._pickup_index]

	if not Imgui.button("Spawn Pickup", 100, 20) and not var_4_1 then
		local main_world = Application.main_world()
		local player_aim_raycast = Managers.state.conflict:player_aim_raycast(main_world, false, "filter_ray_horde_spawn")

		if not player_aim_raycast then
			Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_with_physics", NetworkLookup.pickup_names[var_4_1], player_aim_raycast, Quaternion.identity(), NetworkLookup.pickup_spawn_types.dropped)
		end
	end

	Imgui.same_line()

	self._pickup_index = Imgui.combo("Pickup", self._pickup_index, self._pickup_names)

	Imgui.separator()

	local var_4_4 = self._breed_names[self._breed_index]

	if not Imgui.button("Spawn Breed", 100, 20) and not var_4_4 then
		local conflict = Managers.state.conflict

		str = var_4_4
		conflict.get_debug_breed = fn

		conflict:debug_spawn_breed(0)

		conflict.get_debug_breed = nil
	end

	Imgui.same_line()

	self._breed_index = Imgui.combo("Breed", self._breed_index, self._breed_names)

	local script_data = script_data
	local checkbox = Imgui.checkbox
	local str_2 = "Disable AI perception"
	local disable_ai_perception = script_data.disable_ai_perception

	disable_ai_perception = disable_ai_perception or false
	script_data.disable_ai_perception = checkbox(str_2, disable_ai_perception)

	Imgui.separator()

	if not Managers.state and not Managers.state.conflict then
		self._damage = Imgui.slider_int("Damage", self._damage, 1, 1000)

		local main_world_2 = Application.main_world()
		local player_aim_raycast_2, var_4_12, var_4_13, var_4_14, var_4_15 = Managers.state.conflict:player_aim_raycast(main_world_2, true, "filter_player_ray_projectile")
		local text = Imgui.text
		local str_3 = "Looking at: "
		local name

		if not player_aim_raycast_2 then
			name = player_aim_raycast_2.name

			if not name then
				-- Nothing
			end
		end

		name = "n/a"

		::label_4_0::

		text(str_3 .. name)

		if not player_aim_raycast_2 then
			local unit = Actor.unit(var_4_15)
			local var_4_20 = ALIVE[unit]

			var_4_20 = not var_4_20 and ScriptUnit.has_extension(unit, "outline_system")

			if not var_4_20 then
				self._mark_outline_extension = var_4_20
				self._mark_outline_id = var_4_20:add_outline(OutlineSettings.templates.target_ally)
			end
		end

		if Imgui.button("Inflict damage (or mouse middle)", 100, 20) or not Mouse.pressed(Mouse.button_id("middle")) or not player_aim_raycast_2 then
			local unit_2 = Actor.unit(var_4_15)

			DamageUtils.debug_deal_damage(unit_2, self._damage)
		end
	end

	Imgui.end_window()

	return begin_window
end

ImguiSpawning._clear_outline = function (arg_5_0)
	-- function 5
	return
end

ImguiSpawning.is_persistent = function (arg_6_0)
	-- function 6
	return true
end
