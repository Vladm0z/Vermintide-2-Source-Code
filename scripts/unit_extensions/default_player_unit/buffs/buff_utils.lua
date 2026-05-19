-- chunkname: @scripts/unit_extensions/default_player_unit/buffs/buff_utils.lua

require("scripts/managers/game_mode/mechanisms/mechanism_overrides")

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

BuffUtils = BuffUtils or {}

if script_data then
	script_data.debug_legendary_traits = script_data.debug_legendary_traits or Development.parameter("debug_legendary_traits")
end

function BuffUtils.apply_buff_tweak_data(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		local var_1_0 = arg_1_1[iter_1_0]

		if var_1_0 then
			table.merge(iter_1_1.buffs[1], var_1_0)
		end
	end
end

function BuffUtils.copy_talent_buff_names(arg_2_0)
	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		local var_2_0 = iter_2_1.buffs

		fassert(#var_2_0 == 1, "talent buff has more than one sub buff, add multiple buffs from the talent instead")

		var_2_0[1].name = iter_2_0
	end
end

function BuffUtils.get_max_stacks(arg_3_0, arg_3_1)
	return BuffUtils.get_buff_template(arg_3_0).buffs[arg_3_1 or 1].max_stacks or nil
end

function BuffUtils.remove_stacked_buffs(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0 and ScriptUnit.has_extension(arg_4_0, "buff_system")

	if not var_4_0 then
		return
	end

	for iter_4_0, iter_4_1 in ipairs(arg_4_1) do
		var_4_0:remove_buff(iter_4_1)
	end

	table.clear(arg_4_1)
end

function BuffUtils.buffs_from_rpc_params(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = NetworkLookup.buff_templates
	local var_5_1 = NetworkLookup.buff_data_types
	local var_5_2 = {}

	for iter_5_0 = 1, arg_5_0 do
		local var_5_3 = arg_5_1[iter_5_0]
		local var_5_4 = arg_5_2[iter_5_0]
		local var_5_5 = arg_5_3[iter_5_0]
		local var_5_6 = var_5_0[var_5_3]
		local var_5_7 = var_5_1[var_5_4]

		var_5_2[var_5_6] = {
			[var_5_7] = var_5_5
		}
	end

	return var_5_2
end

function BuffUtils.buffs_to_rpc_params(arg_6_0)
	local var_6_0 = NetworkLookup.buff_templates
	local var_6_1 = NetworkLookup.buff_data_types
	local var_6_2 = {}
	local var_6_3 = {}
	local var_6_4 = {}
	local var_6_5 = 0

	for iter_6_0, iter_6_1 in pairs(arg_6_0) do
		var_6_5 = var_6_5 + 1

		local var_6_6 = var_6_0[iter_6_0]
		local var_6_7, var_6_8 = next(iter_6_1)

		var_6_3[var_6_5], var_6_2[var_6_5] = var_6_1[var_6_7 or "n/a"], var_6_6
		var_6_4[var_6_5] = var_6_8 or 1
	end

	return {
		var_6_5,
		var_6_2,
		var_6_3,
		var_6_4
	}
end

local var_0_1 = Unit.node

local function var_0_2(arg_7_0, arg_7_1)
	return arg_7_0.link_node and var_0_1(arg_7_1, arg_7_0.link_node) or 0
end

function BuffUtils.create_attached_particles(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	if not arg_8_0 or not arg_8_1 then
		return nil
	end

	local var_8_0 = {
		end_t = arg_8_5
	}

	for iter_8_0 = 1, #arg_8_1 do
		local var_8_1 = arg_8_1[iter_8_0]

		if arg_8_3 and var_8_1.first_person or not arg_8_3 and var_8_1.third_person then
			local var_8_2 = arg_8_2

			if var_8_2 then
				local var_8_3 = var_0_2(var_8_1, var_8_2)
				local var_8_4 = var_8_1.pose
				local var_8_5

				var_8_5 = var_8_4 and Matrix4x4.from_quaternion_position_scale(Quaternion.from_euler_angles_xyz(var_8_4.rotation[1], var_8_4.rotation[2], var_8_4.rotation[3]), Vector3Aux.unbox(var_8_4.position), Vector3Aux.unbox(var_8_4.scale)) or nil

				local var_8_6 = ScriptWorld.create_particles_linked(arg_8_0, var_8_1.effect, var_8_2, var_8_3, var_8_1.orphaned_policy, var_8_5)

				if var_8_1.custom_variables then
					for iter_8_1 = 1, #var_8_1.custom_variables do
						local var_8_7 = var_8_1.custom_variables[iter_8_1]
						local var_8_8 = var_8_7.name

						var_8_7.cached_id = var_8_7.cached_id or World.find_particles_variable(arg_8_0, var_8_1.effect, var_8_8)

						local var_8_9 = var_8_7.value or var_8_7.dynamic_value()
						local var_8_10 = Unit.local_scale(arg_8_2, 0)
						local var_8_11 = Vector3.divide_elements(Vector3Aux.unbox(var_8_9), var_8_10)

						World.set_particles_variable(arg_8_0, var_8_6, var_8_7.cached_id, var_8_11)
					end
				end

				if var_8_1.material_variables then
					for iter_8_2 = 1, #var_8_1.material_variables do
						local var_8_12 = var_8_1.material_variables[iter_8_2]
						local var_8_13 = var_8_12.cloud_name
						local var_8_14 = var_8_12.material_variable
						local var_8_15 = var_8_12.value or var_8_12.dynamic_value()

						ScriptWorld.set_material_variable_for_particles(arg_8_0, var_8_6, var_8_13, var_8_14, var_8_15)
					end
				end

				if var_8_1.continuous then
					if var_8_1.destroy_policy == "stop" then
						local var_8_16 = var_8_0.stop_fx or {}

						var_8_0.stop_fx = var_8_16
						var_8_16[#var_8_16 + 1] = var_8_6
					else
						local var_8_17 = var_8_0.destroy_fx or {}

						var_8_0.destroy_fx = var_8_17
						var_8_17[#var_8_17 + 1] = var_8_6
					end
				end

				if var_8_1.update then
					local var_8_18 = var_8_0.update_fx or {}

					var_8_0.update_fx = var_8_18
					var_8_18[var_8_6] = var_8_1.update
				end
			end
		end
	end

	return var_8_0
end

function BuffUtils.update_attached_particles(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1.update_fx

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		iter_9_1(iter_9_0, arg_9_0, arg_9_2, arg_9_1.end_t)
	end
end

function BuffUtils.destroy_attached_particles(arg_10_0, arg_10_1)
	if arg_10_1 and arg_10_0 then
		local var_10_0 = arg_10_1.destroy_fx

		if var_10_0 then
			for iter_10_0 = 1, #var_10_0 do
				World.destroy_particles(arg_10_0, var_10_0[iter_10_0])
			end
		end

		local var_10_1 = arg_10_1.stop_fx

		if var_10_1 then
			for iter_10_1 = 1, #var_10_1 do
				World.stop_spawning_particles(arg_10_0, var_10_1[iter_10_1])
			end
		end
	end
end

function BuffUtils.create_liquid_forward(arg_11_0, arg_11_1)
	if ALIVE[arg_11_0] then
		local function var_11_0()
			local var_12_0 = POSITION_LOOKUP[arg_11_0]

			if var_12_0 then
				local var_12_1 = arg_11_1.template
				local var_12_2 = Unit.local_rotation(arg_11_0, 0)
				local var_12_3 = Quaternion.forward(var_12_2)
				local var_12_4 = {
					area_damage_system = {
						flow_dir = var_12_3,
						liquid_template = var_12_1.liquid_template,
						source_unit = arg_11_0
					}
				}
				local var_12_5 = "units/hub_elements/empty"
				local var_12_6 = Managers.state.unit_spawner:spawn_network_unit(var_12_5, "liquid_aoe_unit", var_12_4, var_12_0)

				ScriptUnit.extension(var_12_6, "area_damage_system"):ready()
			end
		end

		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_11_0)

		local var_11_1 = arg_11_1.template.fx_name

		if var_11_1 then
			local var_11_2 = NetworkLookup.effects[var_11_1]
			local var_11_3 = 0
			local var_11_4 = POSITION_LOOKUP[arg_11_0]
			local var_11_5 = Quaternion.identity()

			Managers.state.network:rpc_play_particle_effect(nil, var_11_2, NetworkConstants.invalid_game_object_id, var_11_3, var_11_4, var_11_5, false)
		end
	end
end

function BuffUtils.get_buff_template(arg_13_0, arg_13_1)
	if not BuffTemplates[arg_13_0] then
		return
	end

	return MechanismOverrides.get(BuffTemplates[arg_13_0], arg_13_1)
end

BalefireDots = BalefireDots or {}
BalefireBurnDotLookup = BalefireBurnDotLookup or {}

function BuffUtils.generate_balefire_burn_variants(arg_14_0)
	for iter_14_0, iter_14_1 in pairs(arg_14_0) do
		local var_14_0 = string.find(iter_14_0, "_balefire")

		if not var_14_0 then
			local var_14_1
			local var_14_2

			for iter_14_2, iter_14_3 in ipairs(iter_14_1.buffs) do
				local var_14_3 = iter_14_3.perks

				if var_14_3 and table.find(var_14_3, var_0_0.burning) then
					if not var_14_1 then
						var_14_1 = iter_14_0 .. "_balefire"
						var_14_2 = table.clone(iter_14_1)
						BalefireDots[var_14_1] = true
						BalefireBurnDotLookup[iter_14_0] = var_14_1
						DotTypeLookup[var_14_1] = DotTypeLookup[iter_14_0]
						arg_14_0[var_14_1] = var_14_2
					end

					local var_14_4 = var_14_2.buffs[iter_14_2].perks

					table.remove_array_value(var_14_4, var_0_0.burning)
					table.insert_unique(var_14_4, var_0_0.burning_balefire)
				end
			end
		else
			local var_14_5 = string.sub(iter_14_0, 1, var_14_0 - 1)

			DotTypeLookup[iter_14_0] = DotTypeLookup[var_14_5]
			BalefireDots[iter_14_0] = true
		end
	end
end

InfiniteBurnDotLookup = InfiniteBurnDotLookup or {}

function BuffUtils.generate_infinite_burn_variants(arg_15_0)
	for iter_15_0, iter_15_1 in pairs(arg_15_0) do
		if not string.find(iter_15_0, "_infinite") then
			local var_15_0
			local var_15_1

			for iter_15_2, iter_15_3 in ipairs(iter_15_1.buffs) do
				local var_15_2 = iter_15_3.perks

				if var_15_2 and table.find(var_15_2, var_0_0.burning) then
					if not var_15_0 then
						var_15_0 = iter_15_0 .. "_infinite"
						var_15_1 = table.clone(iter_15_1)
						InfiniteBurnDotLookup[iter_15_0] = var_15_0
						arg_15_0[var_15_0] = var_15_1
					end

					iter_15_3 = var_15_1.buffs[iter_15_2]
					iter_15_3.name = "infinite_burning_dot"
					iter_15_3.duration = nil
					iter_15_3.on_max_stacks_overflow_func = "reapply_infinite_burn"
					iter_15_3.max_stacks = 1

					local var_15_3 = iter_15_3.max_stacks_func

					if var_15_3 ~= nil then
						function iter_15_3.max_stacks_func(...)
							return math.min(var_15_3(...), 1)
						end
					end

					if iter_15_3.time_between_dot_damages then
						iter_15_3.time_between_dot_damages = iter_15_3.time_between_dot_damages / 2
					end

					break
				end
			end
		end
	end
end
