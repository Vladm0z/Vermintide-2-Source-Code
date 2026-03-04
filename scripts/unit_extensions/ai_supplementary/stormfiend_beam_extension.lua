-- chunkname: @scripts/unit_extensions/ai_supplementary/stormfiend_beam_extension.lua

StormfiendBeamExtension = class(StormfiendBeamExtension)

local var_0_0 = POSITION_LOOKUP
local var_0_1 = {
	attack_right = "fx_right_muzzle",
	attack_left = "fx_left_muzzle"
}
local var_0_2 = table.mirror_array_inplace(var_0_1)

StormfiendBeamExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.state = "no_state"
	arg_1_0.particle_name = "fx/chr_warp_fire_flamethrower_01"
	arg_1_0.beam_forward_offset = 8
	arg_1_0.beam_up_offset = 8
	arg_1_0.muzzle_nodes = {}
	arg_1_0.particle_ids = {}
end

StormfiendBeamExtension.destroy = function (arg_2_0)
	for iter_2_0, iter_2_1 in pairs(var_0_2) do
		arg_2_0:_remove_beam(iter_2_1)
	end
end

StormfiendBeamExtension._remove_beam = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.world

	if arg_3_0.particle_ids[arg_3_1] then
		World.stop_spawning_particles(var_3_0, arg_3_0.particle_ids[arg_3_1])

		arg_3_0.particle_ids[arg_3_1] = nil
		arg_3_0.muzzle_nodes[arg_3_1] = nil
	end
end

StormfiendBeamExtension.set_beam = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = var_0_2[arg_4_1]

	if not arg_4_2 and arg_4_0.particle_ids[var_4_0] then
		arg_4_0:_remove_beam(var_4_0)
	elseif arg_4_2 and not arg_4_0.particle_ids[var_4_0] then
		arg_4_0:_create_beam(var_4_0)
	end
end

StormfiendBeamExtension._create_beam = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.unit

	if ALIVE[var_5_0] then
		local var_5_1 = Unit.node(var_5_0, arg_5_1)

		arg_5_0.muzzle_nodes[arg_5_1] = var_5_1

		local var_5_2 = arg_5_0.world
		local var_5_3 = World.create_particles(var_5_2, arg_5_0.particle_name, Vector3.zero(), Quaternion.identity())
		local var_5_4 = Unit.local_rotation(var_5_0, var_5_1)
		local var_5_5 = Quaternion.look(Vector3.right() + Vector3.up() * 0.2 * (arg_5_1 == "fx_left_muzzle" and 1 or 0))
		local var_5_6 = Matrix4x4.from_quaternion(Quaternion.multiply(var_5_4, var_5_5))

		World.link_particles(var_5_2, var_5_3, var_5_0, var_5_1, var_5_6, "stop")

		arg_5_0.particle_life_time = Vector3Box(1, 0, 0)
		arg_5_0.particle_ids[arg_5_1] = var_5_3
	end
end

StormfiendBeamExtension.get_target_position = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.state.network:game()
	local var_6_1 = Managers.state.unit_storage:go_id(arg_6_1)
	local var_6_2 = GameSession.game_object_field(var_6_0, var_6_1, "aim_target")

	if var_6_2 then
		local var_6_3 = Unit.world_position(arg_6_1, arg_6_2)

		var_6_2[3] = var_6_3[3]

		return var_6_2 + Vector3.normalize(var_6_2 - var_6_3) * arg_6_0.beam_forward_offset + Vector3.up() * arg_6_0.beam_up_offset
	end

	return false
end

StormfiendBeamExtension.update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_0.world

	if not ALIVE[arg_7_1] then
		return
	end

	for iter_7_0, iter_7_1 in pairs(arg_7_0.muzzle_nodes) do
		local var_7_1 = arg_7_0:get_target_position(arg_7_1, iter_7_1)

		if var_7_1 then
			local var_7_2 = Unit.world_position(arg_7_1, iter_7_1)
			local var_7_3 = var_7_1 - var_7_2
			local var_7_4 = Vector3.length(var_7_3)
			local var_7_5 = Vector3(var_7_2.x, var_7_2.y, var_7_2.z + 0.1)
			local var_7_6 = Vector3.normalize(var_7_3)
			local var_7_7 = arg_7_0.particle_ids[iter_7_0]

			if var_7_7 then
				local var_7_8 = World.find_particles_variable(var_7_0, arg_7_0.particle_name, "firepoint_1")

				World.set_particles_variable(var_7_0, var_7_7, var_7_8, var_7_5 + var_7_6 * 0.1)

				local var_7_9 = World.find_particles_variable(var_7_0, arg_7_0.particle_name, "firepoint_2")

				World.set_particles_variable(var_7_0, var_7_7, var_7_9, var_7_1)

				local var_7_10 = World.find_particles_variable(var_7_0, arg_7_0.particle_name, "firelife_1")
				local var_7_11

				var_7_11.x, var_7_11 = var_7_4 / 4, arg_7_0.particle_life_time:unbox()

				World.set_particles_variable(var_7_0, var_7_7, var_7_10, var_7_11)
			end
		end
	end
end
