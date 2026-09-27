-- chunkname: @scripts/managers/blood/blood_manager.lua

require("scripts/managers/blood/blood_settings")

BloodManager = class(BloodManager)

local num = 64
local num_2 = 15

BloodManager.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._weapon_blood = {}
	self._blood_effect_data = {}
	self._blood_active = true

	self:_create_blood_ball_buffer()

	local num = 5

	self._blood_system = EngineOptimizedExtensions.blood_init_system(self._blood_system, self._world, "blood_ball", num)

	self:_init_settings()
end

BloodManager.destroy = function (self)
	-- function 2
	self:clear_weapon_blood()
	EngineOptimizedExtensions.blood_destroy_system(self._blood_system)
end

BloodManager.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self._blood_active then
		local time = World.time(self._world)

		self:_update_weapon_blood(arg_3_1, time)
		self:_update_blood_ball_buffer()
	end

	self:_update_blood_effects()
	EngineOptimizedExtensions.blood_update(self._blood_system)
end

BloodManager.update_blood_enabled = function (self, arg_4_1)
	-- function 4
	if arg_4_1 or not self._blood_active then
		self:clear_weapon_blood()
		self:clear_blood_decals()
	end

	self._blood_active = arg_4_1
	BloodSettings.enemy_blood.enabled = arg_4_1
	BloodSettings.blood_decals.enabled = arg_4_1
	BloodSettings.weapon_blood.enabled = arg_4_1
	BloodSettings.hit_effects.enabled = arg_4_1
end

BloodManager.get_blood_enabled = function (self)
	-- function 5
	return self._blood_active
end

BloodManager.update_num_blood_decals = function (arg_6_0, arg_6_1)
	-- function 6
	BloodSettings.blood_decals.num_decals = arg_6_1
end

BloodManager.update_screen_blood_enabled = function (arg_7_0, arg_7_1)
	-- function 7
	BloodSettings.screen_space.enabled = arg_7_1
end

BloodManager.update_dismemberment_enabled = function (arg_8_0, arg_8_1)
	-- function 8
	BloodSettings.dismemberment.enabled = arg_8_1
end

BloodManager.update_ragdoll_enabled = function (arg_9_0, arg_9_1)
	-- function 9
	BloodSettings.ragdoll_push.enabled = arg_9_1
end

BloodManager._init_settings = function (self)
	-- function 10
	local user_setting = Application.user_setting("blood_enabled")

	user_setting = user_setting or user_setting == nil

	self:update_blood_enabled(user_setting)

	local user_setting_2 = Application.user_setting("num_blood_decals")

	user_setting_2 = user_setting_2 or BloodSettings.blood_decals.num_decals

	self:update_num_blood_decals(user_setting_2)

	local user_setting_3 = Application.user_setting("screen_blood_enabled")

	user_setting_3 = user_setting_3 or user_setting_3 == nil

	self:update_screen_blood_enabled(user_setting_3)

	local user_setting_4 = Application.user_setting("dismemberment_enabled")

	user_setting_4 = user_setting_4 or user_setting_4 == nil

	self:update_dismemberment_enabled(user_setting_4)

	local user_setting_5 = Application.user_setting("ragdoll_enabled")

	user_setting_5 = user_setting_5 or user_setting_5 == nil

	self:update_ragdoll_enabled(user_setting_5)
end

BloodManager._update_weapon_blood = function (self, arg_11_1, arg_11_2)
	-- function 11
	for k, v in pairs(self._weapon_blood) do
		for k_2, v_2 in pairs(v) do
			v[k_2] = math.clamp(v_2 - BloodSettings.weapon_blood.dissolve_rate * arg_11_1, 0, BloodSettings.weapon_blood.max_value)

			self:_set_weapon_blood_intensity(k, k_2, v[k_2])
		end
	end
end

BloodManager.clear_blood_decals = function (arg_12_0)
	-- function 12
	Managers.state.decal:clear_all_of_type("blood_decals")
end

BloodManager.clear_unit_decals = function (arg_13_0, arg_13_1)
	-- function 13
	Unit.set_vector4_for_materials(arg_13_1, "hit_position", Color(0, 0, 0, 0))
end

BloodManager._update_blood_effects = function (self)
	-- function 14
	for k, v in pairs(self._blood_effect_data) do
		if not (HEALTH_ALIVE[k] or v.done) then
			for i, v_2 in ipairs(v) do
				if not v_2.effect_id then
					World.destroy_particles(self._world, v_2.effect_id)
				end
			end

			self._blood_effect_data[k].done = true
		end
	end
end

BloodManager._set_weapon_blood_intensity = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	if not Unit.alive(arg_15_2) then
		Unit.set_scalar_for_materials(arg_15_2, "blood_intensity", arg_15_3)
	else
		arg_15_0._weapon_blood[arg_15_1][arg_15_2] = nil
	end
end

BloodManager.clear_weapon_blood = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not arg_16_1 and not self._weapon_blood[arg_16_1] then
		local var_16_0 = self._weapon_blood[arg_16_1]

		if not arg_16_2 and not var_16_0[arg_16_2] then
			self:_set_weapon_blood_intensity(arg_16_1, arg_16_2, 0)

			self._weapon_blood[arg_16_1][arg_16_2] = nil
		elseif not arg_16_2 then
			for k, v in pairs(var_16_0) do
				self:_set_weapon_blood_intensity(arg_16_1, k, 0)
			end

			self._weapon_blood[arg_16_1] = nil
		end
	else
		for k_2, v_2 in pairs(self._weapon_blood) do
			for k_3, v_3 in pairs(v_2) do
				self._weapon_blood[k_2][k_3] = nil

				self:_set_weapon_blood_intensity(k_2, k_3, 0)
			end
		end

		self._weapon_blood = {}
	end
end

BloodManager._update_blood_ball_buffer = function (self)
	-- function 17
	local _blood_ball_ring_buffer = self._blood_ball_ring_buffer
	local size = _blood_ball_ring_buffer.size

	if size == 0 then
		return
	end

	local buffer = _blood_ball_ring_buffer.buffer
	local read_index = _blood_ball_ring_buffer.read_index
	local max_size = _blood_ball_ring_buffer.max_size
	local min = math.min(num_2, size)

	for i = 1, min do
		local var_17_6 = buffer[read_index]

		self:_spawn_blood_ball(var_17_6)

		read_index = read_index % max_size + 1
		size = size - 1
	end

	_blood_ball_ring_buffer.size = size
	_blood_ball_ring_buffer.read_index = read_index
end

BloodManager._create_blood_ball_buffer = function (self)
	-- function 18
	local var_18_0 = num

	self._blood_ball_ring_buffer = {
		write_index = 1,
		read_index = 1,
		size = 0,
		buffer = Script.new_array(var_18_0),
		max_size = var_18_0
	}

	for i = 1, var_18_0 do
		self._blood_ball_ring_buffer.buffer[i] = {
			velocity = 0,
			position = Vector3Box(),
			direction = Vector3Box()
		}
	end
end

BloodManager._spawn_blood_ball = function (self, arg_19_1)
	-- function 19
	local unbox = arg_19_1.position:unbox()
	local unbox_2 = arg_19_1.direction:unbox()
	local look = Quaternion.look(unbox_2, Vector3.up())
	local velocity = arg_19_1.velocity

	EngineOptimizedExtensions.blood_spawn_blood_ball(self._blood_system, "units/decals/blood_ball", unbox, look, unbox_2, velocity)
end

BloodManager.despawn_blood_ball = function (self, arg_20_1)
	-- function 20
	EngineOptimizedExtensions.blood_despawn_blood_ball(self._blood_system, arg_20_1)
end

BloodManager._add_blood_ball_data_to_buffer = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local _blood_ball_ring_buffer = self._blood_ball_ring_buffer
	local buffer = _blood_ball_ring_buffer.buffer
	local read_index = _blood_ball_ring_buffer.read_index
	local write_index = _blood_ball_ring_buffer.write_index
	local size = _blood_ball_ring_buffer.size
	local max_size = _blood_ball_ring_buffer.max_size

	if max_size < size + 1 then
		local var_21_6 = buffer[read_index]

		self:_spawn_blood_ball(var_21_6)

		_blood_ball_ring_buffer.size = size - 1
		_blood_ball_ring_buffer.read_index = read_index % max_size + 1
	end

	local var_21_7 = BloodSettings.blood_ball.damage_type_velocities[arg_21_3]
	local default = BloodSettings.blood_ball.damage_type_velocities.default
	local var_21_9 = buffer[write_index]

	var_21_9.position:store(arg_21_1)
	var_21_9.direction:store(arg_21_2)

	var_21_9.velocity = var_21_7 or default
	_blood_ball_ring_buffer.size = size + 1
	_blood_ball_ring_buffer.write_index = write_index % max_size + 1
end

BloodManager.add_blood_ball = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	if not BloodSettings.blood_decals.enabled then
		local get_data = Unit.get_data(arg_22_4, "breed")

		if not ((not (BloodSettings.blood_decals.num_decals > 0) or not Vector3.is_valid(arg_22_1)) and get_data.no_blood) then
			self:_add_blood_ball_data_to_buffer(arg_22_1, arg_22_2, arg_22_3)
		end

		local extension = ScriptUnit.extension(arg_22_4, "health_system")

		if not get_data.blood_effect_name then
			self:_spawn_effects(arg_22_4, get_data, extension)
		end

		if not get_data.blood_intensity then
			self:_update_blood_intensity(arg_22_4, get_data, extension)
		end
	end
end

BloodManager._get_blood_effect_data = function (self, arg_23_1, arg_23_2)
	-- function 23
	if not self._blood_effect_data[arg_23_1] then
		self._blood_effect_data[arg_23_1] = table.clone(arg_23_2)
	end

	return self._blood_effect_data[arg_23_1]
end

BloodManager._spawn_effects = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local blood_effect_name = arg_24_2.blood_effect_name
	local blood_effect_nodes = arg_24_2.blood_effect_nodes
	local _get_blood_effect_data = self:_get_blood_effect_data(arg_24_1, blood_effect_nodes)

	if not _get_blood_effect_data.done then
		return
	end

	local num = 1 - arg_24_3:current_health_percent()
	local num_2 = 1 / (#_get_blood_effect_data + 1)
	local var_24_5 = num_2

	for i, v in ipairs(_get_blood_effect_data) do
		if var_24_5 < num then
			if not v.triggered then
				local create_particles = World.create_particles(self._world, blood_effect_name, Vector3(0, 0, 0))

				_get_blood_effect_data[i].effect_id = create_particles

				local node = Unit.node(arg_24_1, v.node)
				local from_quaternion = Matrix4x4.from_quaternion(Unit.local_rotation(arg_24_1, node))

				World.link_particles(self._world, create_particles, arg_24_1, node, from_quaternion, "destroy")

				_get_blood_effect_data[i].triggered = true
			end
		else
			break
		end

		var_24_5 = var_24_5 + num_2
	end
end

BloodManager._update_blood_intensity = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local blood_intensity = arg_25_2.blood_intensity
	local num_meshes = Unit.num_meshes(arg_25_1)
	local num = 1 - arg_25_3:current_health_percent()

	for i = 0, num_meshes - 1 do
		local mesh = Unit.mesh(arg_25_1, i)

		for k, v in pairs(blood_intensity) do
			if not Mesh.has_material(mesh, k) then
				local material = Mesh.material(mesh, k)

				Material.set_scalar(material, v, num)
			end
		end
	end
end

BloodManager.add_weapon_blood = function (self, arg_26_1, arg_26_2)
	-- function 26
	if not BloodSettings.weapon_blood.enabled and not self:_is_player(arg_26_1) and not self:_is_melee_weapon(arg_26_1) then
		local equipment = ScriptUnit.extension(arg_26_1, "inventory_system"):equipment()
		local right_hand_wielded_unit = equipment.right_hand_wielded_unit
		local right_hand_wielded_unit_3p = equipment.right_hand_wielded_unit_3p
		local left_hand_wielded_unit = equipment.left_hand_wielded_unit
		local left_hand_wielded_unit_3p = equipment.left_hand_wielded_unit_3p
		local var_26_5 = BloodSettings.weapon_blood[arg_26_2]

		var_26_5 = var_26_5 or BloodSettings.weapon_blood.default

		local _weapon_blood = self._weapon_blood
		local var_26_7 = self._weapon_blood[arg_26_1]

		var_26_7 = var_26_7 or {}
		_weapon_blood[arg_26_1] = var_26_7

		if not right_hand_wielded_unit then
			local var_26_8 = self._weapon_blood[arg_26_1]
			local max = math.max
			local var_26_10 = self._weapon_blood[arg_26_1][right_hand_wielded_unit]

			var_26_10 = var_26_10 or 0
			var_26_8[right_hand_wielded_unit] = max(var_26_10 + var_26_5, BloodSettings.weapon_blood.starting_value)
		end

		if not right_hand_wielded_unit_3p then
			local var_26_11 = self._weapon_blood[arg_26_1]
			local max_2 = math.max
			local var_26_13 = self._weapon_blood[arg_26_1][right_hand_wielded_unit_3p]

			var_26_13 = var_26_13 or 0
			var_26_11[right_hand_wielded_unit_3p] = max_2(var_26_13 + var_26_5, BloodSettings.weapon_blood.starting_value)
		end

		if not left_hand_wielded_unit then
			local var_26_14 = self._weapon_blood[arg_26_1]
			local max_3 = math.max
			local var_26_16 = self._weapon_blood[arg_26_1][left_hand_wielded_unit]

			var_26_16 = var_26_16 or 0
			var_26_14[left_hand_wielded_unit] = max_3(var_26_16 + var_26_5, BloodSettings.weapon_blood.starting_value)
		end

		if not left_hand_wielded_unit_3p then
			local var_26_17 = self._weapon_blood[arg_26_1]
			local max_4 = math.max
			local var_26_19 = self._weapon_blood[arg_26_1][right_hand_wielded_unit_3p]

			var_26_19 = var_26_19 or 0
			var_26_17[left_hand_wielded_unit_3p] = max_4(var_26_19 + var_26_5, BloodSettings.weapon_blood.starting_value)
		end
	end
end

BloodManager.add_enemy_blood = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	if not BloodSettings.enemy_blood.enabled and not HEALTH_ALIVE[arg_27_2] then
		local local_position = Unit.local_position(arg_27_2, 0)
		local box, var_27_2 = Unit.box(arg_27_2)
		local num = var_27_2[3] * 0.5
		local num_2 = math.max(var_27_2[1], var_27_2[2]) * 0.5
		local num_3 = local_position + Vector3(0, 0, num)
		local num_4 = num_3 + Vector3.normalize(arg_27_1 - num_3) * num_2
		local local_pose = Unit.local_pose(arg_27_2, 0)
		local inverse = Matrix4x4.inverse(local_pose)
		local normalize = Vector3.normalize(arg_27_1 - num_3)
		local cross = Vector3.cross(normalize, Vector3.up())
		local transform = Matrix4x4.transform(inverse, num_4)
		local normalize_2 = Vector3.normalize(Matrix4x4.transform_without_translation(inverse, normalize))
		local normalize_3 = Vector3.normalize(Matrix4x4.transform_without_translation(inverse, cross))
		local var_27_14 = Color(transform[1], transform[2], transform[3], 1)
		local var_27_15 = Color(normalize_2[1], normalize_2[2], normalize_2[3], 0)
		local var_27_16 = Color(normalize_3[1], normalize_3[2], normalize_3[3], 0)

		Unit.set_vector4_for_materials(arg_27_2, "hit_position", var_27_14)
		Unit.set_vector4_for_materials(arg_27_2, "hit_normal", var_27_15)
		Unit.set_vector4_for_materials(arg_27_2, "hit_tangent", var_27_16)
	end
end

BloodManager.play_screen_space_blood = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	-- function 28
	if not BloodSettings.screen_space.enabled then
		World.create_particles(self._world, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	end
end

BloodManager._is_melee_weapon = function (arg_29_0, arg_29_1)
	-- function 29
	local has_extension = ScriptUnit.has_extension(arg_29_1, "inventory_system")

	if not has_extension then
		return false
	end

	local equipment = has_extension:equipment()

	if not equipment.wielded then
		return false
	end

	return equipment.wielded.slot_type == "melee"
end

BloodManager._is_player = function (arg_30_0, arg_30_1)
	-- function 30
	local players = Managers.player:players()

	for k, v in pairs(players) do
		if v.player_unit == arg_30_1 then
			return v
		end
	end

	return false
end
