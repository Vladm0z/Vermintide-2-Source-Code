-- chunkname: @scripts/unit_extensions/ai_supplementary/stormfiend_beam_extension.lua

StormfiendBeamExtension = class(StormfiendBeamExtension)

local POSITION_LOOKUP = POSITION_LOOKUP
local tbl = {
	attack_right = "fx_right_muzzle",
	attack_left = "fx_left_muzzle"
}
local mirror_array_inplace = table.mirror_array_inplace(tbl)

StormfiendBeamExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.is_server = Managers.player.is_server
	self.state = "no_state"
	self.particle_name = "fx/chr_warp_fire_flamethrower_01"
	self.beam_forward_offset = 8
	self.beam_up_offset = 8
	self.muzzle_nodes = {}
	self.particle_ids = {}
end

StormfiendBeamExtension.destroy = function (self)
	-- function 2
	for k, v in pairs(mirror_array_inplace) do
		self:_remove_beam(v)
	end
end

StormfiendBeamExtension._remove_beam = function (self, arg_3_1)
	-- function 3
	local world = self.world

	if not self.particle_ids[arg_3_1] then
		World.stop_spawning_particles(world, self.particle_ids[arg_3_1])

		self.particle_ids[arg_3_1] = nil
		self.muzzle_nodes[arg_3_1] = nil
	end
end

StormfiendBeamExtension.set_beam = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = mirror_array_inplace[arg_4_1]

	if arg_4_2 or not self.particle_ids[var_4_0] then
		self:_remove_beam(var_4_0)
	elseif not (not arg_4_2 and self.particle_ids[var_4_0]) then
		self:_create_beam(var_4_0)
	end
end

StormfiendBeamExtension._create_beam = function (self, arg_5_1)
	-- function 5
	local unit = self.unit

	if not ALIVE[unit] then
		local node = Unit.node(unit, arg_5_1)

		self.muzzle_nodes[arg_5_1] = node

		local world = self.world
		local create_particles = World.create_particles(world, self.particle_name, Vector3.zero(), Quaternion.identity())
		local local_rotation = Unit.local_rotation(unit, node)
		local look = Quaternion.look
		local right = Vector3.right()
		local num = Vector3.up() * 0.2
		local flag

		flag = arg_5_1 ~= "fx_left_muzzle" or not 1 or 0

		local var_5_9 = look(right + num * flag)
		local from_quaternion = Matrix4x4.from_quaternion(Quaternion.multiply(local_rotation, var_5_9))

		World.link_particles(world, create_particles, unit, node, from_quaternion, "stop")

		self.particle_life_time = Vector3Box(1, 0, 0)
		self.particle_ids[arg_5_1] = create_particles
	end
end

StormfiendBeamExtension.get_target_position = function (self, arg_6_1, arg_6_2)
	-- function 6
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(arg_6_1)
	local game_object_field = GameSession.game_object_field(game, go_id, "aim_target")

	if not game_object_field then
		local world_position = Unit.world_position(arg_6_1, arg_6_2)

		game_object_field[3] = world_position[3]

		return game_object_field + Vector3.normalize(game_object_field - world_position) * self.beam_forward_offset + Vector3.up() * self.beam_up_offset
	end

	return false
end

StormfiendBeamExtension.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local world = self.world

	if not ALIVE[arg_7_1] then
		return
	end

	for k, v in pairs(self.muzzle_nodes) do
		local get_target_position = self:get_target_position(arg_7_1, v)

		if not get_target_position then
			local world_position = Unit.world_position(arg_7_1, v)
			local num = get_target_position - world_position
			local length = Vector3.length(num)
			local var_7_5 = Vector3(world_position.x, world_position.y, world_position.z + 0.1)
			local normalize = Vector3.normalize(num)
			local var_7_7 = self.particle_ids[k]

			if not var_7_7 then
				local find_particles_variable = World.find_particles_variable(world, self.particle_name, "firepoint_1")

				World.set_particles_variable(world, var_7_7, find_particles_variable, var_7_5 + normalize * 0.1)

				local find_particles_variable_2 = World.find_particles_variable(world, self.particle_name, "firepoint_2")

				World.set_particles_variable(world, var_7_7, find_particles_variable_2, get_target_position)

				local find_particles_variable_3 = World.find_particles_variable(world, self.particle_name, "firelife_1")
				local unbox

				unbox.x, unbox = length / 4, self.particle_life_time:unbox()

				World.set_particles_variable(world, var_7_7, find_particles_variable_3, unbox)
			end
		end
	end
end
