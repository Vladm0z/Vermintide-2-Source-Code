-- chunkname: @scripts/game_state/components/level_transition_handler.lua

require("scripts/game_state/components/enemy_package_loader")
require("scripts/game_state/components/transient_package_loader")
require("scripts/game_state/components/pickup_package_loader")
require("scripts/game_state/components/general_synced_package_loader")

local print = print

local function fn(...)
	-- function 1
	if not script_data.level_transition_handler_debug_logging then
		local var_1_0 = sprintf(...)

		print("[LevelTransitionHandler] ", var_1_0)
	end
end

local function fn_2(...)
	-- function 2
	local var_2_0 = sprintf(...)

	print("[LevelTransitionHandler] ", var_2_0)
end

LevelTransitionHandler = class(LevelTransitionHandler)

LevelTransitionHandler.init = function (self)
	-- function 3
	fn("init")

	self.loading_packages = {}
	self._has_loaded_all_packages = nil
	self.loaded_levels = {}
	self._queued_network_flow_states = {}
	self.enemy_package_loader = EnemyPackageLoader:new()
	self.transient_package_loader = TransientPackageLoader:new()
	self.pickup_package_loader = PickupPackageLoader:new()
	self.general_synced_package_loader = GeneralSyncedPackageLoader:new()
	self._network_state = nil

	local var_3_0
	local var_3_1
	local var_3_2
	local var_3_3
	local var_3_4
	local var_3_5
	local var_3_6
	local var_3_7
	local var_3_8
	local var_3_9

	if not DEDICATED_SERVER then
		var_3_3 = "versus"
	end

	local apply_defaults_to_level_data, var_3_11, var_3_12, var_3_13, var_3_14, var_3_15, var_3_16, var_3_17, var_3_18, var_3_19 = self:apply_defaults_to_level_data(var_3_0, var_3_2, var_3_1, var_3_3, var_3_4, var_3_5, var_3_6, var_3_7, var_3_8, var_3_9)
	local tbl = {
		level_transition_type = "load_next_level",
		level_key = apply_defaults_to_level_data,
		mechanism = var_3_13,
		game_mode = var_3_14,
		level_seed = var_3_12,
		environment_variation_id = var_3_11,
		conflict_director = var_3_15,
		locked_director_functions = var_3_16,
		difficulty = var_3_17,
		difficulty_tweak = var_3_18,
		extra_packages = var_3_19
	}

	self._offline_level_data = table.clone(tbl)
	self._offline_level_data.level_session_id = math.random_seed()
	self._default_level_data = tbl
	self._next_level_data = nil
	self._checkpoint_data = nil
	self.hero_specific_packages = {}
end

LevelTransitionHandler.register_network_state = function (self, arg_4_1)
	-- function 4
	self._network_state = arg_4_1

	fn("register_network_state")

	local _offline_level_data = self._offline_level_data

	if not arg_4_1:is_server() then
		arg_4_1:set_level_data(_offline_level_data.level_key, _offline_level_data.environment_variation_id, _offline_level_data.level_seed, _offline_level_data.mechanism, _offline_level_data.game_mode, _offline_level_data.conflict_director, _offline_level_data.locked_director_functions, _offline_level_data.difficulty, _offline_level_data.difficulty_tweak, _offline_level_data.level_session_id, _offline_level_data.level_transition_type, _offline_level_data.extra_packages)
	end

	self._offline_level_data = nil
	self._next_level_data = nil
	self._checkpoint_data = nil
end

LevelTransitionHandler.deregister_network_state = function (self)
	-- function 5
	fn("deregister_network_state")

	self._next_level_data = nil
	self._network_state = nil
	self._offline_level_data = table.clone(self._default_level_data)
	self._offline_level_data.level_session_id = math.random_seed()
	self._currently_loaded_level_session_id = nil
end

LevelTransitionHandler.register_rpcs = function (self, arg_6_1)
	-- function 6
	self.enemy_package_loader:register_rpcs(arg_6_1)
	self.transient_package_loader:register_rpcs(arg_6_1)
end

LevelTransitionHandler.unregister_rpcs = function (self)
	-- function 7
	self.enemy_package_loader:unregister_rpcs()
	self.transient_package_loader:unregister_rpcs()
end

LevelTransitionHandler.reload_level = function (self, arg_8_1, arg_8_2)
	-- function 8
	fassert(not self._network_state and self._network_state:is_server(), "only the server can reload")
	fn_2("reload_level")

	self._checkpoint_data = arg_8_1

	local flag = true
	local str = "reload_level"

	self:_set_next_level(str, self:get_current_level_key(), self:get_current_environment_variation_id(), arg_8_2 or self:get_current_level_seed(), self:get_current_mechanism(), self:get_current_game_mode(), self:get_current_conflict_director(), self:get_current_locked_director_functions(), self:get_current_difficulty(), self:get_current_difficulty_tweak(), table.shallow_copy(self:get_current_extra_packages(), flag))
end

LevelTransitionHandler.get_checkpoint_data = function (self)
	-- function 9
	fassert(not self._network_state and self._network_state:is_server(), "only the server handles checkpoint data")

	return self._checkpoint_data
end

LevelTransitionHandler.get_current_environment_variation_name = function (self)
	-- function 10
	local get_current_environment_variation_id = self:get_current_environment_variation_id()
	local get_current_level_key = self:get_current_level_key()

	if not get_current_environment_variation_id and not get_current_level_key then
		local environment_variations = LevelSettings[get_current_level_key].environment_variations

		return not environment_variations and environment_variations[get_current_environment_variation_id]
	end

	return nil
end

LevelTransitionHandler.update = function (self)
	-- function 11
	local flag = false

	for k, v in pairs(self.loading_packages) do
		flag = true

		if not self:_level_packages_loaded(k) then
			self.loaded_levels[k] = true
			self.loading_packages[k] = nil
		end
	end

	if not flag then
		self._has_loaded_all_packages = false
	elseif not (self._has_loaded_all_packages or flag) then
		fn_2("Level load completed!")

		self._has_loaded_all_packages = true
	end

	self.enemy_package_loader:update()
	self.pickup_package_loader:update()
	self.general_synced_package_loader:update()
	self.transient_package_loader:update()
end

LevelTransitionHandler.promote_next_level_data = function (self)
	-- function 12
	local fassert = fassert
	local is_server

	if not self._network_state then
		is_server = self._network_state:is_server()

		if not is_server then
			-- Nothing
		end
	end

	is_server = not self._network_state

	::label_12_0::

	fassert(is_server, "only server can promote")
	fassert(self._next_level_data, "can't promote without previously calling set_next_level")
	fn_2("promote_next_level_data")

	if not self._network_state then
		self._network_state:set_level_data(self._next_level_data.level_key, self._next_level_data.environment_variation_id, self._next_level_data.level_seed, self._next_level_data.mechanism, self._next_level_data.game_mode, self._next_level_data.conflict_director, self._next_level_data.locked_director_functions, self._next_level_data.difficulty, self._next_level_data.difficulty_tweak, self._next_level_data.level_session_id, self._next_level_data.level_transition_type, self._next_level_data.extra_packages)
	else
		self._offline_level_data = self._next_level_data
	end

	self._next_level_data = nil
end

LevelTransitionHandler.needs_level_load = function (self)
	-- function 13
	return self:get_current_level_session_id() ~= self._currently_loaded_level_session_id
end

LevelTransitionHandler.load_current_level = function (self)
	-- function 14
	local get_current_level_key = self:get_current_level_key()
	local get_current_extra_packages = self:get_current_extra_packages()
	local get_current_environment_variation_id = self:get_current_environment_variation_id()
	local get_current_level_session_id = self:get_current_level_session_id()

	printf("load_current_level, loading %s %s", get_current_level_key, tostring(get_current_environment_variation_id))
	fassert(LevelSettings[get_current_level_key], "The level named %q does not exist in LevelSettings.", tostring(get_current_level_key))

	local _currently_loaded_level_key = self._currently_loaded_level_key
	local _currently_loaded_environment_variation_id = self._currently_loaded_environment_variation_id

	self:_release_extra_packages(_currently_loaded_level_key)

	if not (not _currently_loaded_level_key and get_current_level_key == _currently_loaded_level_key) then
		self:_release_level_resources(_currently_loaded_level_key)
	end

	local flag = not self.loading_packages[get_current_level_key]
	local flag_2 = not self:_level_packages_loaded(get_current_level_key)

	self:_load_extra_packages(get_current_level_key, get_current_extra_packages)

	if _currently_loaded_level_key ~= get_current_level_key or _currently_loaded_environment_variation_id ~= get_current_environment_variation_id or not flag or not flag_2 then
		self:_load_level_packages(get_current_level_key)

		local var_14_8 = LevelSettings[get_current_level_key]
		local packages = var_14_8.packages

		fn("loading level: %q", get_current_level_key)
		fn("loading packages: %s", table.tostring(packages))
		fn("loading extra packages: [%s] %s", get_current_level_key, table.tostring(get_current_extra_packages))

		self.loading_packages[get_current_level_key] = true

		local flag_3 = not _currently_loaded_level_key and LevelSettings[_currently_loaded_level_key]
		local flag_4 = not flag_3 and flag_3.render_settings_overrides

		if not flag_4 then
			fn("Restoring override render_settings for level: %q", get_current_level_key)

			for k, v in pairs(flag_4) do
				local user_setting = Application.user_setting("render_settings", k)

				fn("Restoring: %q = %q", k, user_setting)
				Application.set_render_setting(k, tostring(user_setting))
			end
		end

		local render_settings_overrides = var_14_8.render_settings_overrides

		if not render_settings_overrides then
			fn("Setting render_settings overrides for level: %q", get_current_level_key)

			for k_2, v_2 in pairs(render_settings_overrides) do
				fn("Overriding: %q = %q", k_2, v_2)
				Application.set_render_setting(k_2, tostring(v_2))
			end
		end
	end

	self._currently_loaded_level_key = get_current_level_key
	self._currently_loaded_environment_variation_id = get_current_environment_variation_id
	self._currently_loaded_level_session_id = get_current_level_session_id
	self._has_loaded_all_packages = false
end

LevelTransitionHandler.release_level_resources = function (self)
	-- function 15
	local _currently_loaded_level_key = self._currently_loaded_level_key

	if not _currently_loaded_level_key then
		return
	end

	self:_release_extra_packages(_currently_loaded_level_key)
	self:_release_level_resources(_currently_loaded_level_key)

	self._currently_loaded_level_key = nil
	self._currently_loaded_environment_variation_id = nil
end

LevelTransitionHandler._release_level_resources = function (self, arg_16_1)
	-- function 16
	local var_16_0 = self.loaded_levels[arg_16_1]
	local var_16_1 = self.loading_packages[arg_16_1]

	if LEVEL_EDITOR_TEST or var_16_0 or not var_16_1 then
		self:_unload_level_packages(arg_16_1)

		self.loading_packages[arg_16_1] = nil
		self.loaded_levels[arg_16_1] = false
	end
end

LevelTransitionHandler._load_extra_packages = function (self, arg_17_1, arg_17_2)
	-- function 17
	if not (not arg_17_2 and not (#arg_17_2 > 0)) then
		fassert(self._extra_packages == nil, "Trying to load level before releasing previous one properly. _extra_packages have not been unloaded.")

		self._extra_packages = arg_17_2

		local flag = true
		local var_17_1 = arg_17_1
		local package = Managers.package

		for i = 1, #arg_17_2 do
			local var_17_3 = arg_17_2[i]

			package:load(var_17_3, var_17_1, nil, flag)
		end
	end
end

LevelTransitionHandler._release_extra_packages = function (self, arg_18_1)
	-- function 18
	local _extra_packages = self._extra_packages

	if not _extra_packages then
		fn("unloading extra packages: [%s] %s", arg_18_1, table.tostring(_extra_packages))

		local package = Managers.package

		for i = #_extra_packages, 1, -1 do
			local var_18_2 = _extra_packages[i]

			if package:has_loaded(var_18_2, arg_18_1) or not package:is_loading(var_18_2) then
				package:unload(var_18_2, arg_18_1)
			end
		end

		self._extra_packages = nil
	end
end

LevelTransitionHandler.has_next_level = function (self)
	-- function 19
	fassert(not self._network_state and self._network_state:is_server(), "only the server handles next level logic")

	return self._next_level_data ~= nil
end

LevelTransitionHandler.clear_next_level = function (self)
	-- function 20
	fassert(not self._network_state and self._network_state:is_server(), "only the server handles next level logic")
	fn("clear_next_level")

	self._next_level_data = nil
end

LevelTransitionHandler.set_next_level = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8, arg_21_9, arg_21_10)
	-- function 21
	local str = "load_next_level"

	self:_set_next_level(str, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8, arg_21_9, arg_21_10)
end

LevelTransitionHandler.get_next_level_key = function (self)
	-- function 22
	fassert(not self._network_state and self._network_state:is_server(), "only the server handles next level logic")

	local _next_level_data = self._next_level_data

	_next_level_data = not _next_level_data and self._next_level_data.level_key

	return _next_level_data
end

LevelTransitionHandler.get_next_level_seed = function (self)
	-- function 23
	fassert(not self._network_state and self._network_state:is_server(), "only the server handles next level logic")

	local _next_level_data = self._next_level_data

	_next_level_data = not _next_level_data and self._next_level_data.level_seed

	return _next_level_data
end

LevelTransitionHandler.get_next_game_mode = function (self)
	-- function 24
	fassert(not self._network_state and self._network_state:is_server(), "only the server handles next level logic")

	local _next_level_data = self._next_level_data

	_next_level_data = not _next_level_data and self._next_level_data.game_mode

	return _next_level_data
end

LevelTransitionHandler.get_next_conflict_director = function (self)
	-- function 25
	fassert(not self._network_state and self._network_state:is_server(), "only the server handles next level logic")

	local _next_level_data = self._next_level_data

	_next_level_data = not _next_level_data and self._next_level_data.conflict_director

	return _next_level_data
end

LevelTransitionHandler.get_next_environment_variation_id = function (self)
	-- function 26
	fassert(not self._network_state and self._network_state:is_server(), "only the server handles next level logic")

	local _next_level_data = self._next_level_data

	_next_level_data = not _next_level_data and self._next_level_data.environment_variation_id

	return _next_level_data
end

LevelTransitionHandler.get_next_locked_director_functions = function (self)
	-- function 27
	fassert(not self._network_state and self._network_state:is_server(), "only the server handles next level logic")

	local _next_level_data = self._next_level_data

	_next_level_data = not _next_level_data and self._next_level_data.locked_director_functions

	return _next_level_data
end

LevelTransitionHandler.get_next_difficulty = function (self)
	-- function 28
	fassert(not self._network_state and self._network_state:is_server(), "only the server handles next level logic")

	local _next_level_data = self._next_level_data

	_next_level_data = not _next_level_data and self._next_level_data.difficulty

	return _next_level_data
end

LevelTransitionHandler.get_next_difficulty_tweak = function (self)
	-- function 29
	fassert(not self._network_state and self._network_state:is_server(), "only the server handles next level logic")

	local _next_level_data = self._next_level_data

	_next_level_data = not _next_level_data and self._next_level_data.difficulty_tweak

	return _next_level_data
end

LevelTransitionHandler.get_current_level_key = function (self)
	-- function 30
	local get_level_key

	if not self._network_state then
		get_level_key = self._network_state:get_level_key()

		if not get_level_key then
			-- Nothing
		end
	end

	get_level_key = self._offline_level_data
	get_level_key = not get_level_key and self._offline_level_data.level_key

	::label_30_0::

	return get_level_key
end

LevelTransitionHandler.get_current_level_seed = function (self)
	-- function 31
	local get_level_seed

	if not self._network_state then
		get_level_seed = self._network_state:get_level_seed()

		if not get_level_seed then
			-- Nothing
		end
	end

	get_level_seed = self._offline_level_data.level_seed

	::label_31_0::

	return get_level_seed
end

LevelTransitionHandler.get_current_game_mode = function (self)
	-- function 32
	local get_game_mode

	if not self._network_state then
		get_game_mode = self._network_state:get_game_mode()

		if not get_game_mode then
			-- Nothing
		end
	end

	get_game_mode = self._offline_level_data.game_mode

	::label_32_0::

	return get_game_mode
end

LevelTransitionHandler.get_current_conflict_director = function (self)
	-- function 33
	local get_conflict_director

	if not self._network_state then
		get_conflict_director = self._network_state:get_conflict_director()

		if not get_conflict_director then
			-- Nothing
		end
	end

	get_conflict_director = self._offline_level_data.conflict_director

	::label_33_0::

	return get_conflict_director
end

LevelTransitionHandler.get_current_environment_variation_id = function (self)
	-- function 34
	local get_environment_variation_id

	if not self._network_state then
		get_environment_variation_id = self._network_state:get_environment_variation_id()

		if not get_environment_variation_id then
			-- Nothing
		end
	end

	get_environment_variation_id = self._offline_level_data.environment_variation_id

	::label_34_0::

	return get_environment_variation_id
end

LevelTransitionHandler.get_current_locked_director_functions = function (self)
	-- function 35
	local get_locked_director_functions

	if not self._network_state then
		get_locked_director_functions = self._network_state:get_locked_director_functions()

		if not get_locked_director_functions then
			-- Nothing
		end
	end

	get_locked_director_functions = self._offline_level_data.locked_director_functions

	::label_35_0::

	return get_locked_director_functions
end

LevelTransitionHandler.get_current_difficulty = function (self)
	-- function 36
	local get_difficulty

	if not self._network_state then
		get_difficulty = self._network_state:get_difficulty()

		if not get_difficulty then
			-- Nothing
		end
	end

	get_difficulty = self._offline_level_data.difficulty

	::label_36_0::

	return get_difficulty
end

LevelTransitionHandler.get_current_difficulty_tweak = function (self)
	-- function 37
	local get_difficulty_tweak

	if not self._network_state then
		get_difficulty_tweak = self._network_state:get_difficulty_tweak()

		if not get_difficulty_tweak then
			-- Nothing
		end
	end

	get_difficulty_tweak = self._offline_level_data.difficulty_tweak

	::label_37_0::

	return get_difficulty_tweak
end

LevelTransitionHandler.get_current_extra_packages = function (self)
	-- function 38
	local get_extra_packages

	if not self._network_state then
		get_extra_packages = self._network_state:get_extra_packages()

		if not get_extra_packages then
			-- Nothing
		end
	end

	get_extra_packages = self._offline_level_data.extra_packages

	::label_38_0::

	return get_extra_packages
end

LevelTransitionHandler.get_current_mechanism = function (self)
	-- function 39
	local get_mechanism

	if not self._network_state then
		get_mechanism = self._network_state:get_mechanism()

		if not get_mechanism then
			-- Nothing
		end
	end

	get_mechanism = self._offline_level_data.mechanism

	::label_39_0::

	return get_mechanism
end

LevelTransitionHandler.get_current_level_session_id = function (self)
	-- function 40
	local get_level_session_id

	if not self._network_state then
		get_level_session_id = self._network_state:get_level_session_id()

		if not get_level_session_id then
			-- Nothing
		end
	end

	get_level_session_id = self._offline_level_data.level_session_id

	::label_40_0::

	return get_level_session_id
end

LevelTransitionHandler.get_current_level_transition_type = function (self)
	-- function 41
	local get_level_transition_type

	if not self._network_state then
		get_level_transition_type = self._network_state:get_level_transition_type()

		if not get_level_transition_type then
			-- Nothing
		end
	end

	get_level_transition_type = self._offline_level_data.level_transition_type

	::label_41_0::

	return get_level_transition_type
end

LevelTransitionHandler.get_current_checkpoint = function (self)
	-- function 42
	local get_check_point

	if not self._network_state then
		get_check_point = self._network_state:get_check_point()

		if not get_check_point then
			-- Nothing
		end
	end

	get_check_point = self._offline_level_data.check_point

	::label_42_0::

	return get_check_point
end

LevelTransitionHandler.get_current_level_keys = function (self)
	-- function 43
	return self:get_current_level_key()
end

LevelTransitionHandler.all_packages_loaded = function (self)
	-- function 44
	return not not self:needs_level_load() or self._has_loaded_all_packages == true
end

LevelTransitionHandler._set_next_level = function (self, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9, arg_45_10, arg_45_11)
	-- function 45
	local flag = not self._network_state and self._network_state:is_server()

	fassert(flag, "only the server handles next level logic")

	local apply_defaults_to_level_data, var_45_2, var_45_3, var_45_4, var_45_5, var_45_6, var_45_7, var_45_8, var_45_9, var_45_10 = self:apply_defaults_to_level_data(arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9, arg_45_10, arg_45_11, flag)

	self:_append_event_packages(apply_defaults_to_level_data, var_45_10)

	local random_seed = math.random_seed()

	fn_2("set_next_level( lvl:%s, mc:%s, gm:%s, env:%s, seed:%d, conflict:%s, lckd_director_funcs:{%s}, diff:%s, diff_tweak:%d, id:%d, lt:%s, extra_packages:%s)", tostring(apply_defaults_to_level_data), var_45_4, var_45_5, tostring(var_45_2), var_45_3, var_45_6, table.concat(var_45_7, ","), var_45_8, var_45_9, random_seed, arg_45_1, table.tostring(var_45_10))

	self._next_level_data = {
		level_key = apply_defaults_to_level_data,
		mechanism = var_45_4,
		game_mode = var_45_5,
		level_seed = var_45_3,
		environment_variation_id = var_45_2,
		conflict_director = var_45_6,
		locked_director_functions = var_45_7,
		difficulty = var_45_8,
		difficulty_tweak = var_45_9,
		level_session_id = random_seed,
		level_transition_type = arg_45_1,
		extra_packages = var_45_10
	}
end

LevelTransitionHandler._append_event_packages = function (arg_46_0, arg_46_1, arg_46_2)
	-- function 46
	local var_46_0 = LevelSettings[arg_46_1]

	if not var_46_0 and var_46_0.hub_level or not var_46_0.tutorial_level then
		return
	end

	local get_special_events = Managers.backend:get_interface("live_events"):get_special_events()

	if not get_special_events then
		return
	end

	local tbl = {}

	for i = 1, #get_special_events do
		local var_46_3 = get_special_events[i]
		local level_keys = var_46_3.level_keys

		if not level_keys and table.is_empty(level_keys) or not table.contains(level_keys, arg_46_1) then
			local weekly_event = var_46_3.weekly_event

			if not weekly_event then
				if weekly_event == "override" then
					table.clear(tbl)
					table.append(tbl, var_46_3.mutators)
				elseif weekly_event == "append" then
					table.append(tbl, var_46_3.mutators)
				end
			end
		end
	end

	for j = 1, #tbl do
		local var_46_6 = tbl[j]
		local packages = MutatorTemplates[var_46_6].packages

		if not packages then
			for k = 1, #packages do
				local var_46_8 = packages[k]

				if not table.contains(arg_46_2, var_46_8) then
					table.insert(arg_46_2, var_46_8)
				end
			end
		end
	end
end

LevelTransitionHandler._load_level_packages = function (self, arg_47_1)
	-- function 47
	local flag = true
	local package = Managers.package
	local var_47_2 = arg_47_1
	local var_47_3 = LevelSettings[arg_47_1]
	local packages = var_47_3.packages

	if not packages then
		for i = 1, #packages do
			local var_47_5 = packages[i]

			package:load(var_47_5, var_47_2, nil, flag)
		end
	end

	local hero_specific_packages = var_47_3.hero_specific_packages

	if not hero_specific_packages then
		local profile_synchronizer = Managers.mechanism:profile_synchronizer()
		local flag_2 = not profile_synchronizer and profile_synchronizer:profile_by_peer(Network.peer_id(), 1)

		if not flag_2 then
			local network_handler = Managers.mechanism:network_handler()

			flag_2 = not network_handler and network_handler.wanted_profile_index
		end

		local var_47_10 = SPProfiles[flag_2]
		local flag_3 = not var_47_10 and var_47_10.display_name
		local var_47_12 = hero_specific_packages[flag_3]

		if not var_47_12 then
			for j = 1, #var_47_12 do
				local var_47_13 = var_47_12[j]

				package:load(var_47_13, var_47_2, nil, flag)
			end

			self.hero_specific_packages[arg_47_1] = var_47_12
			self.selected_hero_name_on_load = flag_3
		end
	end
end

LevelTransitionHandler._unload_level_packages = function (self, arg_48_1)
	-- function 48
	local var_48_0 = arg_48_1
	local package = Managers.package
	local packages = LevelSettings[arg_48_1].packages
	local var_48_3 = self.hero_specific_packages[arg_48_1]

	if not var_48_3 then
		for i = #var_48_3, 1, -1 do
			local var_48_4 = var_48_3[i]

			if package:has_loaded(var_48_4, var_48_0) or not package:is_loading(var_48_4) then
				package:unload(var_48_4, var_48_0)
			end
		end

		self.hero_specific_packages[arg_48_1] = nil
		self.selected_hero_name_on_load = nil
	end

	if not packages then
		for j = #packages, 1, -1 do
			local var_48_5 = packages[j]

			if package:has_loaded(var_48_5, var_48_0) or not package:is_loading(var_48_5) then
				package:unload(var_48_5, var_48_0)
			end
		end
	end
end

LevelTransitionHandler._level_packages_loaded = function (self, arg_49_1)
	-- function 49
	local var_49_0 = arg_49_1
	local package = Managers.package
	local packages = LevelSettings[arg_49_1].packages

	if not packages then
		for i = 1, #packages do
			local var_49_3 = packages[i]

			if not package:has_loaded(var_49_3, var_49_0) then
				return false
			end
		end
	end

	local var_49_4 = self.hero_specific_packages[arg_49_1]

	if not var_49_4 then
		for j = #var_49_4, 1, -1 do
			local var_49_5 = var_49_4[j]

			if not package:has_loaded(var_49_5, var_49_0) then
				return false
			end
		end
	end

	return true
end

LevelTransitionHandler.create_level_seed = function ()
	-- function 50
	local num = os.clock() * 10000 % 961748927
	local time = os.time()
	local num_2 = (num + tonumber(tostring(string.format("%d", time)):reverse():sub(1, 6))) % 15485867

	return (math.floor(num_2))
end

LevelTransitionHandler.apply_defaults_to_level_data = function (self, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8, arg_51_9, arg_51_10, arg_51_11)
	-- function 51
	if arg_51_4 or not arg_51_1 then
		arg_51_4 = LevelSettings[arg_51_1].mechanism
	end

	if not arg_51_4 then
		local get_current_level_key = self:get_current_level_key()

		if not get_current_level_key then
			arg_51_4 = LevelSettings[get_current_level_key].mechanism
		end
	end

	arg_51_4 = arg_51_4 or "adventure"

	if not arg_51_1 then
		local class_name = MechanismSettings[arg_51_4].class_name

		arg_51_1 = rawget(_G, class_name).get_starting_level()
	end

	local var_51_2 = LevelSettings[arg_51_1]

	arg_51_5 = arg_51_5 or var_51_2.game_mode

	if not arg_51_5 then
		local var_51_3 = MechanismSettings[arg_51_4]

		if not var_51_2.hub_level then
			arg_51_5 = arg_51_5 or var_51_3.gamemode_lookup.keep
		else
			arg_51_5 = arg_51_5 or var_51_3.gamemode_lookup.default
		end
	end

	local var_51_4 = GameModeSettings[arg_51_5]
	local flag = not var_51_4 and var_51_4.forced_difficulty

	arg_51_2 = arg_51_2 or 0
	arg_51_6 = script_data.override_conflict_settings or arg_51_6 or var_51_2.conflict_settings or "default"
	arg_51_7 = arg_51_7 or {}
	arg_51_8 = script_data.current_difficulty_setting or flag or arg_51_8 or "normal"
	arg_51_9 = script_data.current_difficulty_tweak_setting or arg_51_9 or 0

	if not (not arg_51_11 and not script_data.random_level_seed_from_toolcenter and arg_51_3) then
		arg_51_3 = Development.parameter("level_seed") or LevelTransitionHandler.create_level_seed()
	else
		local tonumber = tonumber

		if not arg_51_3 then
			-- Nothing
		end

		::label_51_0::

		local parameter = Development.parameter("level_seed")

		parameter = parameter or GameMechanismManager.create_level_seed()

		::label_51_1::

		arg_51_3 = tonumber(parameter)
	end

	arg_51_10 = arg_51_10 or {}

	return arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8, arg_51_9, arg_51_10
end

LevelTransitionHandler._update_debug = function (self)
	-- function 52
	if not script_data.debug_level_seed_and_level_packages then
		local get_current_level_seed = self:get_current_level_seed()

		for k, v in pairs(self.loaded_levels) do
			Debug.text("Level %q is_loaded: %s", k, tostring(v))
		end

		Debug.text("Level Seed: %d", get_current_level_seed or -1)
	end
end

LevelTransitionHandler.in_hub_level = function (self)
	-- function 53
	local get_current_level_key = self:get_current_level_key()

	if not get_current_level_key then
		return LevelSettings[get_current_level_key].hub_level
	end
end

LevelTransitionHandler.queue_create_networked_flow_state = function (self, arg_54_1, ...)
	-- function 54
	local level = Unit.level(arg_54_1)
	local var_54_1 = self._queued_network_flow_states[level]

	var_54_1 = var_54_1 or {}
	self._queued_network_flow_states[level] = var_54_1
	var_54_1[#var_54_1 + 1] = arg_54_1
end

LevelTransitionHandler.create_queued_networked_flow_states = function (self, arg_55_1)
	-- function 55
	local var_55_0 = self._queued_network_flow_states[arg_55_1]

	if not var_55_0 then
		for i = 1, #var_55_0 do
			if not Unit.alive(var_55_0[i]) then
				Unit.flow_event(var_55_0[i], "Create")
			end
		end
	end

	table.clear(self._queued_network_flow_states)
end
