-- chunkname: @scripts/unit_extensions/weaves/weave_kill_enemies_extension.lua

WeaveKillEnemiesExtension = class(WeaveKillEnemiesExtension, BaseObjectiveExtension)
WeaveKillEnemiesExtension.NAME = "WeaveKillEnemiesExtension"

local tbl = {
	hardest = 0.7,
	hard = 0.9,
	harder = 0.8,
	cataclysm_2 = 0.5,
	cataclysm = 0.6,
	cataclysm_3 = 0.4,
	normal = 1
}

WeaveKillEnemiesExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	WeaveKillEnemiesExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._on_start_func = arg_1_3.on_start_func
	self._on_progress_func = arg_1_3.on_progress_func
	self._on_complete_func = arg_1_3.on_complete_func
	self._num_killed = 0

	local amount = arg_1_3.amount

	amount = amount or 0
	self._kills_required = amount

	local base_score_per_kill = arg_1_3.base_score_per_kill

	base_score_per_kill = base_score_per_kill or WeaveSettings.base_score_per_kill
	self._base_score_per_kill = base_score_per_kill

	local breed_score_multipliers = arg_1_3.breed_score_multipliers

	breed_score_multipliers = breed_score_multipliers or {}
	self._breed_score_multipliers = breed_score_multipliers

	local score_multiplier = arg_1_3.score_multiplier

	score_multiplier = score_multiplier or 1

	local get_difficulty = Managers.state.difficulty:get_difficulty()

	if type(score_multiplier) == "table" then
		score_multiplier = score_multiplier[get_difficulty] or tbl[get_difficulty] or 1
	end

	self._weave_manager = Managers.weave
	self._score_multiplier = score_multiplier
	self._breeds_allowed = arg_1_3.breeds_allowed
	self._races_allowed = arg_1_3.races_allowed
	self._hit_zones_allowed = arg_1_3.hit_zones_allowed
	self._attacks_allowed = arg_1_3.attacks_allowed
	self._damage_types_allowed = arg_1_3.damage_types_allowed

	if not arg_1_1.is_server then
		return
	end

	if self._kills_required > 0 then
		self._method = "num_kills"
	else
		self._method = "score"

		if type(self._breed_score_multipliers) == "number" then
			self._breed_score_multipliers = {
				default = self._breed_score_multipliers
			}
		else
			local enemies_score_multipliers = WeaveSettings.enemies_score_multipliers
			local _breed_score_multipliers = self._breed_score_multipliers

			for k, v in pairs(enemies_score_multipliers) do
				if not _breed_score_multipliers[k] then
					_breed_score_multipliers[k] = v
				end
			end
		end
	end

	if not (not self._breeds_allowed and #self._breeds_allowed ~= 0) then
		self._breeds_allowed = nil
	end

	if not (not self._races_allowed and #self._races_allowed ~= 0) then
		self._races_allowed = nil
	end

	if not (not self._hit_zones_allowed and #self._hit_zones_allowed ~= 0) then
		self._hit_zones_allowed = nil
	end

	if not (not self._attacks_allowed and #self._attacks_allowed ~= 0) then
		self._attacks_allowed = nil
	end

	if not (not self._damage_types_allowed and #self._damage_types_allowed ~= 0) then
		self._damage_types_allowed = nil
	end
end

WeaveKillEnemiesExtension.initial_sync_data = function (self, arg_2_1)
	-- function 2
	arg_2_1.value = self:get_percentage_done()
end

WeaveKillEnemiesExtension._set_objective_data = function (arg_3_0, arg_3_1)
	-- function 3
	return
end

WeaveKillEnemiesExtension._activate = function (self)
	-- function 4
	local has_extension = ScriptUnit.has_extension(self._unit, "tutorial_system")

	if not has_extension then
		has_extension:set_active(true)
	end
end

WeaveKillEnemiesExtension._deactivate = function (arg_5_0)
	-- function 5
	return
end

WeaveKillEnemiesExtension._server_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

WeaveKillEnemiesExtension._client_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

WeaveKillEnemiesExtension.is_done = function (self)
	-- function 8
	if self._method == "score" then
		return false
	end

	return self._num_killed >= self._kills_required
end

WeaveKillEnemiesExtension.get_percentage_done = function (self)
	-- function 9
	if self._method == "score" then
		return 0
	end

	if self._kills_required == 0 then
		return 1
	end

	return math.clamp(self._num_killed / self._kills_required, 0, 1)
end

WeaveKillEnemiesExtension.on_ai_killed = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local _hit_zones_allowed = self._hit_zones_allowed

	if not _hit_zones_allowed and not arg_10_4 then
		local var_10_1 = arg_10_4[DamageDataIndex.HIT_ZONE]

		if not table.contains(_hit_zones_allowed, var_10_1) then
			return
		end
	end

	local _damage_types_allowed = self._damage_types_allowed

	if not _damage_types_allowed and not arg_10_4 then
		local var_10_3 = arg_10_4[DamageDataIndex.DAMAGE_TYPE]

		if not table.contains(_damage_types_allowed, var_10_3) then
			return
		end
	end

	local _attacks_allowed = self._attacks_allowed

	if not _attacks_allowed and not arg_10_4 then
		local var_10_5 = arg_10_4[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_10_6 = rawget(ItemMasterList, var_10_5)

		if not var_10_6 then
			local slot_type = var_10_6.slot_type

			if not table.contains(_attacks_allowed, slot_type) then
				return
			end
		else
			return
		end
	end

	local _breeds_allowed = self._breeds_allowed
	local flag = false
	local name = arg_10_3.breed.name

	if not _breeds_allowed and not table.contains(_breeds_allowed, name) then
		flag = true
	end

	local _races_allowed = self._races_allowed

	if flag or not _races_allowed then
		local race = arg_10_3.breed.race

		if not table.contains(_races_allowed, race) then
			flag = true
		end
	end

	if not ((_breeds_allowed or not _races_allowed) and flag) then
		return
	end

	self._num_killed = self._num_killed + 1

	if self._num_killed ~= 1 or not self._on_start_func then
		self._on_start_func(self._unit)

		self._on_start_func = nil
	end

	if not self._on_progress_func then
		self._on_progress_func(self._unit, self._num_killed, self._kills_required)
	end

	if self._method == "score" then
		local var_10_13 = WeaveSettings.roaming_multiplier[PLATFORM]
		local get_data = Unit.get_data(arg_10_1, "spawn_type")

		get_data = get_data or "unknown"

		local _breed_score_multipliers = self._breed_score_multipliers
		local var_10_16 = _breed_score_multipliers[name]

		var_10_16 = var_10_16 or _breed_score_multipliers.default

		local num

		if get_data == "roam" then
			num = self._score_multiplier * var_10_13

			if not num then
				-- Nothing
			end
		end

		num = self._score_multiplier

		::label_10_0::

		local num_2 = num * var_10_16

		if not arg_10_3.despawned then
			Managers.weave:increase_bar_score(num_2)
			print("Spawn type: " .. get_data, "Score: " .. num_2, "Score Multiplier: ", num)
		end

		Unit.set_data(arg_10_1, "spawn_type", nil)
	end

	if not self._is_server then
		self:server_set_value(self:get_percentage_done())
	end
end
