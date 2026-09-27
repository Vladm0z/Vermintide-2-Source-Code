-- chunkname: @scripts/settings/spawn_unit_templates_vs.lua

local tbl = {
	troll_puke = {
		spawn_func = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
			-- function 1
			arg_1_2 = QuaternionBox(arg_1_2)
			arg_1_1 = Vector3Box(arg_1_1)

			local function fn()
				-- function 2
				local forward = Quaternion.forward(arg_1_2:unbox())
				local tbl = {}
				local tbl_2 = {
					flow_dir = forward
				}
				local flag

				flag = arg_1_3 ~= 1 or not "vs_bile_troll_vomit_near" or "vs_bile_troll_vomit"
				tbl_2.liquid_template = flag
				tbl_2.source_unit = arg_1_0
				tbl.area_damage_system = tbl_2

				local str = "units/hub_elements/empty"
				local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "liquid_aoe_unit", tbl, arg_1_1:unbox())

				ScriptUnit.extension(spawn_network_unit, "area_damage_system"):ready()
			end

			Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn)
		end
	},
	vortex = {
		spawn_func = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			-- function 3
			local var_3_0 = BLACKBOARDS[arg_3_0]

			if not var_3_0 then
				var_3_0 = {}
				BLACKBOARDS[arg_3_0] = var_3_0
			end

			local world = var_3_0.world

			world = world or Managers.state.conflict._world
			var_3_0.world = world

			local time = Managers.time:time("game")
			local num = 0
			local spawn_vortex = BreedActions.chaos_vortex_sorcerer.spawn_vortex

			var_3_0.action = spawn_vortex

			if not var_3_0.vortex_data then
				local str = "carousel"

				BTChaosSorcererSkulkApproachAction.initialize_vortex_data(nil, var_3_0, str)
			end

			local vortex_data = var_3_0.vortex_data

			vortex_data.vortex_spawn_pos:store(arg_3_1)

			vortex_data.vortex_spawn_radius = 10
			vortex_data.spawn_timer = time + 25

			local vortex_template = vortex_data.vortex_template
			local unbox = vortex_data.vortex_spawn_pos:unbox()
			local vortex_spawn_radius = vortex_data.vortex_spawn_radius
			local min = math.min(vortex_spawn_radius / vortex_template.full_inner_radius, 1)

			if not (arg_3_3 == 0) then
				local inner_decal_unit_name = spawn_vortex.inner_decal_unit_name

				if not inner_decal_unit_name then
					local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.identity(), unbox)
					local max = math.max(vortex_template.min_inner_radius, min * vortex_template.full_inner_radius)

					Matrix4x4.set_scale(from_quaternion_position, Vector3(max, max, max))

					vortex_data.inner_decal_unit = Managers.state.unit_spawner:spawn_network_unit(inner_decal_unit_name, "network_synched_dummy_unit", nil, from_quaternion_position)
				end

				local outer_decal_unit_name = spawn_vortex.outer_decal_unit_name

				if not outer_decal_unit_name then
					local from_quaternion_position_2 = Matrix4x4.from_quaternion_position(Quaternion.identity(), unbox)
					local max_2 = math.max(vortex_template.min_outer_radius, min * vortex_template.full_outer_radius)

					Matrix4x4.set_scale(from_quaternion_position_2, Vector3(max_2, max_2, max_2))

					vortex_data.outer_decal_unit = Managers.state.unit_spawner:spawn_network_unit(outer_decal_unit_name, "network_synched_dummy_unit", nil, from_quaternion_position_2)
				end
			end

			BTChaosSorcererSummoningAction._spawn_vortex(nil, arg_3_0, var_3_0, time, num, arg_3_1, var_3_0.vortex_data)
		end
	},
	vortex_dummy_missile = {
		spawn_func = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			-- function 4
			local var_4_0 = BLACKBOARDS[arg_4_0]

			if not var_4_0 then
				var_4_0 = {}
				BLACKBOARDS[arg_4_0] = var_4_0
			end

			local world = var_4_0.world

			world = world or Managers.state.conflict._world
			var_4_0.world = world

			local vortex_data = var_4_0.vortex_data

			vortex_data = vortex_data or {}
			var_4_0.vortex_data = vortex_data

			local vortex_data_2 = var_4_0.vortex_data

			vortex_data_2.extra_time = 2
			vortex_data_2.max_height = 10
			vortex_data_2.num_dummy_missiles = 0

			local spawn_vortex = BreedActions.chaos_vortex_sorcerer.spawn_vortex
			local unbox

			if not vortex_data_2.summon_position then
				unbox = vortex_data_2.summon_position:unbox()

				if not unbox then
					-- Nothing
				end
			end

			unbox = POSITION_LOOKUP[arg_4_0]

			::label_4_0::

			local forward = Quaternion.forward(arg_4_2)

			return BTChaosSorcererSummoningAction._launch_vortex_dummy_missile(nil, arg_4_0, spawn_vortex, vortex_data_2, arg_4_1, unbox, forward)
		end
	}
}

table.merge_recursive(SpawnUnitTemplates, tbl)
