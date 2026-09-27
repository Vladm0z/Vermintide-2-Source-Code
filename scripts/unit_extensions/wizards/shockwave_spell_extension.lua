-- chunkname: @scripts/unit_extensions/wizards/shockwave_spell_extension.lua

ShockwaveSpellExtension = class(ShockwaveSpellExtension)

ShockwaveSpellExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._position = Vector3Box(Unit.local_position(arg_1_2, 0))

	local get_data = Unit.get_data(arg_1_2, "wave_distance")

	get_data = get_data or 2
	self._shockwave_radius_min = get_data

	local get_data_2 = Unit.get_data(arg_1_2, "wave_distance")

	get_data_2 = get_data_2 or 30
	self._shockwave_radius_max = get_data_2

	local get_data_3 = Unit.get_data(arg_1_2, "spell_vfx")

	get_data_3 = get_data_3 or "fx/wizard_tower_end_sofia_explosion"
	self._vfx = get_data_3
	self._spell_triggerd = false
	self._world = arg_1_1.world
	self._start_time = 0
	self._time_to_broadphase = 0.15
	self._enemy_damage = 0
	self._players = Managers.player:players()

	Managers.state.event:register(self, "on_failed_guardians_event", "setup_shockwave")
end

local num = 1.5
local tbl = {}
local tbl_2 = {}
local num_2 = 0
local num_3 = 0
local num_4 = 0
local num_5 = 0.25

ShockwaveSpellExtension.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not self._spell_triggerd then
		return
	end

	num_5 = num_5 + arg_2_3

	local flag = num_5 >= self._time_to_broadphase
	local num_2 = (arg_2_5 - self._start_time) / num
	local clamp = math.clamp(num_2, 0, 1)
	local lerp = math.lerp(self._shockwave_radius_min, self._shockwave_radius_max, clamp)
	local unbox = self._position:unbox()

	if clamp >= 1 or not flag then
		num_4 = AiUtils.broadphase_query(unbox, lerp, tbl)
		num_5 = 0
	end

	self:damage_player(unbox, lerp)
	self:damage_enemies(unbox, arg_2_5)

	if not (not (clamp >= 1) or not (num_4 <= 0)) then
		self:reset_shockwave()
	end
end

ShockwaveSpellExtension.damage_enemies = function (self, arg_3_1, arg_3_2)
	-- function 3
	if num_4 > 0 then
		local min = math.min(num_4, 3)

		for i = 1, min do
			local var_3_1 = tbl[i]

			if not (ALIVE[var_3_1] or tbl_2[var_3_1]) then
				local var_3_2 = POSITION_LOOKUP[var_3_1]
				local normalize = Vector3.normalize(var_3_2 - arg_3_1)
				local extension = ScriptUnit.extension(var_3_1, "health_system")

				tbl_2[var_3_1] = true

				local str = "torso"
				local var_3_6
				local _unit = self._unit
				local str_2 = "grenade"

				DamageUtils.add_damage_network(var_3_1, _unit, 240, str, str_2, var_3_2, normalize, var_3_6, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end

		for j = min, 1, -1 do
			table.swap_delete(tbl, j)
		end

		num_4 = #tbl
	end
end

ShockwaveSpellExtension.damage_player = function (self, arg_4_1, arg_4_2)
	-- function 4
	local _players = self._players
	local num = arg_4_2 * arg_4_2
	local num_2 = 1

	for k, v in pairs(_players) do
		local player_unit = v.player_unit

		if not (not ALIVE[player_unit] and tbl_2[player_unit]) then
			local var_4_4 = POSITION_LOOKUP[player_unit]

			if num > Vector3.distance_squared(arg_4_1, var_4_4) then
				local str = "torso"
				local str_2 = "forced"
				local normalize = Vector3.normalize(var_4_4 - arg_4_1)
				local extension = ScriptUnit.extension(player_unit, "health_system")
				local num_3 = extension:current_health() / 2

				extension:add_damage(player_unit, num_3, str, str_2, var_4_4, normalize, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, num_2)

				tbl_2[player_unit] = true

				local num_4 = 10
				local num_5 = (normalize + Vector3.up() * 3) * num_4

				ScriptUnit.extension(player_unit, "locomotion_system"):add_external_velocity(num_5)

				num_2 = num_2 + 1
			end
		end
	end
end

ShockwaveSpellExtension.setup_shockwave = function (self, arg_5_1)
	-- function 5
	self._enemy_damage = arg_5_1.enemy_damage
	self._start_time = Managers.time:time("game")
	self._spell_triggerd = true

	World.create_particles(self._world, self._vfx, self._position:unbox())
end

ShockwaveSpellExtension.reset_shockwave = function (self)
	-- function 6
	self._spell_triggerd = false

	table.clear(tbl_2)
end

ShockwaveSpellExtension.destroy = function (arg_7_0)
	-- function 7
	Managers.state.event:unregister("on_failed_guardians_event", arg_7_0)
end
