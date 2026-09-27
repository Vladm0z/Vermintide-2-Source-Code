-- chunkname: @scripts/unit_extensions/default_player_unit/buffs/buff_utils.lua

require("scripts/managers/game_mode/mechanisms/mechanism_overrides")

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local BuffUtils = BuffUtils

BuffUtils = BuffUtils or {}
BuffUtils = BuffUtils

if not script_data then
	local script_data = script_data
	local debug_legendary_traits = script_data.debug_legendary_traits

	debug_legendary_traits = debug_legendary_traits or Development.parameter("debug_legendary_traits")
	script_data.debug_legendary_traits = debug_legendary_traits
end

BuffUtils.apply_buff_tweak_data = function (arg_1_0, arg_1_1)
	-- function 1
	for k, v in pairs(arg_1_0) do
		local var_1_0 = arg_1_1[k]

		if not var_1_0 then
			table.merge(v.buffs[1], var_1_0)
		end
	end
end

BuffUtils.copy_talent_buff_names = function (arg_2_0)
	-- function 2
	for k, v in pairs(arg_2_0) do
		local buffs = v.buffs

		fassert(#buffs == 1, "talent buff has more than one sub buff, add multiple buffs from the talent instead")

		buffs[1].name = k
	end
end

BuffUtils.get_max_stacks = function (arg_3_0, arg_3_1)
	-- function 3
	return BuffUtils.get_buff_template(arg_3_0).buffs[arg_3_1 or 1].max_stacks or nil
end

BuffUtils.remove_stacked_buffs = function (arg_4_0, arg_4_1)
	-- function 4
	local flag = not arg_4_0 and ScriptUnit.has_extension(arg_4_0, "buff_system")

	if not flag then
		return
	end

	for i, v in ipairs(arg_4_1) do
		flag:remove_buff(v)
	end

	table.clear(arg_4_1)
end

BuffUtils.buffs_from_rpc_params = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local buff_templates = NetworkLookup.buff_templates
	local buff_data_types = NetworkLookup.buff_data_types
	local tbl = {}

	for i = 1, arg_5_0 do
		local var_5_3 = arg_5_1[i]
		local var_5_4 = arg_5_2[i]
		local var_5_5 = arg_5_3[i]
		local var_5_6 = buff_templates[var_5_3]
		local var_5_7 = buff_data_types[var_5_4]

		tbl[var_5_6] = {
			[var_5_7] = var_5_5
		}
	end

	return tbl
end

BuffUtils.buffs_to_rpc_params = function (arg_6_0)
	-- function 6
	local buff_templates = NetworkLookup.buff_templates
	local buff_data_types = NetworkLookup.buff_data_types
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local num = 0

	for k, v in pairs(arg_6_0) do
		num = num + 1

		local var_6_6 = buff_templates[k]
		local var_6_7, var_6_8 = next(v)

		tbl_2[num], tbl[num] = buff_data_types[var_6_7 or "n/a"], var_6_6
		tbl_3[num] = var_6_8 or 1
	end

	return {
		num,
		tbl,
		tbl_2,
		tbl_3
	}
end

local node = Unit.node

local function fn(self, arg_7_1)
	-- function 7
	local var_7_0

	if not self.link_node then
		var_7_0 = node(arg_7_1, self.link_node)

		if not var_7_0 then
			-- Nothing
		end
	end

	var_7_0 = 0

	::label_7_0::

	return var_7_0
end

BuffUtils.create_attached_particles = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	if not (not arg_8_0 and arg_8_1) then
		return nil
	end

	local tbl = {
		end_t = arg_8_5
	}

	for i = 1, #arg_8_1 do
		local var_8_1 = arg_8_1[i]

		if not arg_8_3 and var_8_1.first_person and arg_8_3 or not var_8_1.third_person then
			local var_8_2 = arg_8_2

			if not var_8_2 then
				local var_8_3 = fn(var_8_1, var_8_2)
				local pose = var_8_1.pose
				local flag

				flag = not pose and Matrix4x4.from_quaternion_position_scale(Quaternion.from_euler_angles_xyz(pose.rotation[1], pose.rotation[2], pose.rotation[3]), Vector3Aux.unbox(pose.position), Vector3Aux.unbox(pose.scale)) and nil

				local create_particles_linked = ScriptWorld.create_particles_linked(arg_8_0, var_8_1.effect, var_8_2, var_8_3, var_8_1.orphaned_policy, flag)

				if not var_8_1.custom_variables then
					for j = 1, #var_8_1.custom_variables do
						local var_8_7 = var_8_1.custom_variables[j]
						local name = var_8_7.name
						local cached_id = var_8_7.cached_id

						cached_id = cached_id or World.find_particles_variable(arg_8_0, var_8_1.effect, name)
						var_8_7.cached_id = cached_id

						local value = var_8_7.value

						value = value or var_8_7.dynamic_value()

						local local_scale = Unit.local_scale(arg_8_2, 0)
						local divide_elements = Vector3.divide_elements(Vector3Aux.unbox(value), local_scale)

						World.set_particles_variable(arg_8_0, create_particles_linked, var_8_7.cached_id, divide_elements)
					end
				end

				if not var_8_1.material_variables then
					for k = 1, #var_8_1.material_variables do
						local var_8_13 = var_8_1.material_variables[k]
						local cloud_name = var_8_13.cloud_name
						local material_variable = var_8_13.material_variable
						local value_2 = var_8_13.value

						value_2 = value_2 or var_8_13.dynamic_value()

						ScriptWorld.set_material_variable_for_particles(arg_8_0, create_particles_linked, cloud_name, material_variable, value_2)
					end
				end

				if not var_8_1.continuous then
					if var_8_1.destroy_policy == "stop" then
						local stop_fx = tbl.stop_fx

						stop_fx = stop_fx or {}
						tbl.stop_fx = stop_fx
						stop_fx[#stop_fx + 1] = create_particles_linked
					else
						local destroy_fx = tbl.destroy_fx

						destroy_fx = destroy_fx or {}
						tbl.destroy_fx = destroy_fx
						destroy_fx[#destroy_fx + 1] = create_particles_linked
					end
				end

				if not var_8_1.update then
					local update_fx = tbl.update_fx

					update_fx = update_fx or {}
					tbl.update_fx = update_fx
					update_fx[create_particles_linked] = var_8_1.update
				end
			end
		end
	end

	return tbl
end

BuffUtils.update_attached_particles = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local update_fx = arg_9_1.update_fx

	for k, v in pairs(update_fx) do
		v(k, arg_9_0, arg_9_2, arg_9_1.end_t)
	end
end

BuffUtils.destroy_attached_particles = function (arg_10_0, arg_10_1)
	-- function 10
	if not arg_10_1 and not arg_10_0 then
		local destroy_fx = arg_10_1.destroy_fx

		if not destroy_fx then
			for i = 1, #destroy_fx do
				World.destroy_particles(arg_10_0, destroy_fx[i])
			end
		end

		local stop_fx = arg_10_1.stop_fx

		if not stop_fx then
			for j = 1, #stop_fx do
				World.stop_spawning_particles(arg_10_0, stop_fx[j])
			end
		end
	end
end

BuffUtils.create_liquid_forward = function (arg_11_0, arg_11_1)
	-- function 11
	if not ALIVE[arg_11_0] then
		local function fn()
			-- function 12
			local var_12_0 = POSITION_LOOKUP[arg_11_0]

			if not var_12_0 then
				local template = arg_11_1.template
				local local_rotation = Unit.local_rotation(arg_11_0, 0)
				local forward = Quaternion.forward(local_rotation)
				local tbl = {
					area_damage_system = {
						flow_dir = forward,
						liquid_template = template.liquid_template,
						source_unit = arg_11_0
					}
				}
				local str = "units/hub_elements/empty"
				local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "liquid_aoe_unit", tbl, var_12_0)

				ScriptUnit.extension(spawn_network_unit, "area_damage_system"):ready()
			end
		end

		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn)

		local fx_name = arg_11_1.template.fx_name

		if not fx_name then
			local var_11_2 = NetworkLookup.effects[fx_name]
			local num = 0
			local var_11_4 = POSITION_LOOKUP[arg_11_0]
			local identity = Quaternion.identity()

			Managers.state.network:rpc_play_particle_effect(nil, var_11_2, NetworkConstants.invalid_game_object_id, num, var_11_4, identity, false)
		end
	end
end

BuffUtils.get_buff_template = function (arg_13_0, arg_13_1)
	-- function 13
	if not BuffTemplates[arg_13_0] then
		return
	end

	return MechanismOverrides.get(BuffTemplates[arg_13_0], arg_13_1)
end

local BalefireDots = BalefireDots

BalefireDots = BalefireDots or {}
BalefireDots = BalefireDots

local BalefireBurnDotLookup = BalefireBurnDotLookup

BalefireBurnDotLookup = BalefireBurnDotLookup or {}
BalefireBurnDotLookup = BalefireBurnDotLookup

BuffUtils.generate_balefire_burn_variants = function (self)
	-- function 14
	for k, v in pairs(self) do
		local find = string.find(k, "_balefire")

		if not find then
			local var_14_1
			local var_14_2

			for i, v_2 in ipairs(v.buffs) do
				local perks = v_2.perks

				if not perks and not table.find(perks, scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning) then
					if not var_14_1 then
						var_14_1 = k .. "_balefire"
						var_14_2 = table.clone(v)
						BalefireDots[var_14_1] = true
						BalefireBurnDotLookup[k] = var_14_1
						DotTypeLookup[var_14_1] = DotTypeLookup[k]
						self[var_14_1] = var_14_2
					end

					local perks_2 = var_14_2.buffs[i].perks

					table.remove_array_value(perks_2, scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning)
					table.insert_unique(perks_2, scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning_balefire)
				end
			end
		else
			local sub = string.sub(k, 1, find - 1)

			DotTypeLookup[k] = DotTypeLookup[sub]
			BalefireDots[k] = true
		end
	end
end

local InfiniteBurnDotLookup = InfiniteBurnDotLookup

InfiniteBurnDotLookup = InfiniteBurnDotLookup or {}
InfiniteBurnDotLookup = InfiniteBurnDotLookup

BuffUtils.generate_infinite_burn_variants = function (self)
	-- function 15
	for k, v in pairs(self) do
		if not string.find(k, "_infinite") then
			local var_15_0
			local var_15_1

			for i, v_2 in ipairs(v.buffs) do
				local perks = v_2.perks

				if not perks and not table.find(perks, scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning) then
					if not var_15_0 then
						var_15_0 = k .. "_infinite"
						var_15_1 = table.clone(v)
						InfiniteBurnDotLookup[k] = var_15_0
						self[var_15_0] = var_15_1
					end

					v_2 = var_15_1.buffs[i]
					v_2.name = "infinite_burning_dot"
					v_2.duration = nil
					v_2.on_max_stacks_overflow_func = "reapply_infinite_burn"
					v_2.max_stacks = 1

					local max_stacks_func = v_2.max_stacks_func

					if max_stacks_func ~= nil then
						v_2.max_stacks_func = function (...)
							-- function 16
							return math.min(max_stacks_func(...), 1)
						end
					end

					if not v_2.time_between_dot_damages then
						v_2.time_between_dot_damages = v_2.time_between_dot_damages / 2
					end

					break
				end
			end
		end
	end
end
