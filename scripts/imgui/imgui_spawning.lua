-- chunkname: @scripts/imgui/imgui_spawning.lua

ImguiSpawning = class(ImguiSpawning)

function ImguiSpawning.init(arg_1_0)
	arg_1_0._breed_index = 0
	arg_1_0._breed_names = table.keys(Breeds)

	table.sort(arg_1_0._breed_names)

	arg_1_0._pickup_index = 0
	arg_1_0._pickup_names = table.keys(AllPickups)

	table.sort(arg_1_0._pickup_names)

	arg_1_0._mark_outline_extension = nil
	arg_1_0._mark_outline_id = nil
	arg_1_0._damage = 100
end

function ImguiSpawning.update(arg_2_0)
	if arg_2_0._mark_outline_extension then
		arg_2_0._mark_outline_extension:remove_outline(arg_2_0._mark_outline_id)

		arg_2_0._mark_outline_extension = nil
	end
end

local var_0_0 = "skaven_clan_rat"

local function var_0_1()
	return Breeds[var_0_0]
end

function ImguiSpawning.draw(arg_4_0)
	local var_4_0 = Imgui.begin_window("Spawning")
	local var_4_1 = arg_4_0._pickup_names[arg_4_0._pickup_index]

	if Imgui.button("Spawn Pickup", 100, 20) and var_4_1 then
		local var_4_2 = Application.main_world()
		local var_4_3 = Managers.state.conflict:player_aim_raycast(var_4_2, false, "filter_ray_horde_spawn")

		if var_4_3 then
			Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_with_physics", NetworkLookup.pickup_names[var_4_1], var_4_3, Quaternion.identity(), NetworkLookup.pickup_spawn_types.dropped)
		end
	end

	Imgui.same_line()

	arg_4_0._pickup_index = Imgui.combo("Pickup", arg_4_0._pickup_index, arg_4_0._pickup_names)

	Imgui.separator()

	local var_4_4 = arg_4_0._breed_names[arg_4_0._breed_index]

	if Imgui.button("Spawn Breed", 100, 20) and var_4_4 then
		local var_4_5 = Managers.state.conflict

		var_0_0 = var_4_4
		var_4_5.get_debug_breed = var_0_1

		var_4_5:debug_spawn_breed(0)

		var_4_5.get_debug_breed = nil
	end

	Imgui.same_line()

	arg_4_0._breed_index = Imgui.combo("Breed", arg_4_0._breed_index, arg_4_0._breed_names)
	script_data.disable_ai_perception = Imgui.checkbox("Disable AI perception", script_data.disable_ai_perception or false)

	Imgui.separator()

	if Managers.state and Managers.state.conflict then
		arg_4_0._damage = Imgui.slider_int("Damage", arg_4_0._damage, 1, 1000)

		local var_4_6 = Application.main_world()
		local var_4_7, var_4_8, var_4_9, var_4_10, var_4_11 = Managers.state.conflict:player_aim_raycast(var_4_6, true, "filter_player_ray_projectile")

		Imgui.text("Looking at: " .. (var_4_7 and var_4_7.name or "n/a"))

		if var_4_7 then
			local var_4_12 = Actor.unit(var_4_11)
			local var_4_13 = ALIVE[var_4_12] and ScriptUnit.has_extension(var_4_12, "outline_system")

			if var_4_13 then
				arg_4_0._mark_outline_extension = var_4_13
				arg_4_0._mark_outline_id = var_4_13:add_outline(OutlineSettings.templates.target_ally)
			end
		end

		if (Imgui.button("Inflict damage (or mouse middle)", 100, 20) or Mouse.pressed(Mouse.button_id("middle"))) and var_4_7 then
			local var_4_14 = Actor.unit(var_4_11)

			DamageUtils.debug_deal_damage(var_4_14, arg_4_0._damage)
		end
	end

	Imgui.end_window()

	return var_4_0
end

function ImguiSpawning._clear_outline(arg_5_0)
	return
end

function ImguiSpawning.is_persistent(arg_6_0)
	return true
end
