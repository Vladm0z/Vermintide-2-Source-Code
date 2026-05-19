-- chunkname: @scripts/game_state/components/level_transition_handler.lua

require("scripts/game_state/components/enemy_package_loader")
require("scripts/game_state/components/transient_package_loader")
require("scripts/game_state/components/pickup_package_loader")
require("scripts/game_state/components/general_synced_package_loader")

local var_0_0 = print

local function var_0_1(...)
	if script_data.level_transition_handler_debug_logging then
		local var_1_0 = sprintf(...)

		var_0_0("[LevelTransitionHandler] ", var_1_0)
	end
end

local function var_0_2(...)
	local var_2_0 = sprintf(...)

	var_0_0("[LevelTransitionHandler] ", var_2_0)
end

LevelTransitionHandler = class(LevelTransitionHandler)

function LevelTransitionHandler.init(arg_3_0)
	var_0_1("init")

	arg_3_0.loading_packages = {}
	arg_3_0._has_loaded_all_packages = nil
	arg_3_0.loaded_levels = {}
	arg_3_0._queued_network_flow_states = {}
	arg_3_0.enemy_package_loader = EnemyPackageLoader:new()
	arg_3_0.transient_package_loader = TransientPackageLoader:new()
	arg_3_0.pickup_package_loader = PickupPackageLoader:new()
	arg_3_0.general_synced_package_loader = GeneralSyncedPackageLoader:new()
	arg_3_0._network_state = nil

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

	if DEDICATED_SERVER then
		var_3_3 = "versus"
	end

	local var_3_10, var_3_11, var_3_12, var_3_13, var_3_14, var_3_15, var_3_16, var_3_17, var_3_18, var_3_19 = arg_3_0:apply_defaults_to_level_data(var_3_0, var_3_2, var_3_1, var_3_3, var_3_4, var_3_5, var_3_6, var_3_7, var_3_8, var_3_9)
	local var_3_20 = {
		level_transition_type = "load_next_level",
		level_key = var_3_10,
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

	arg_3_0._offline_level_data = table.clone(var_3_20)
	arg_3_0._offline_level_data.level_session_id = math.random_seed()
	arg_3_0._default_level_data = var_3_20
	arg_3_0._next_level_data = nil
	arg_3_0._checkpoint_data = nil
	arg_3_0.hero_specific_packages = {}
end

function LevelTransitionHandler.register_network_state(arg_4_0, arg_4_1)
	arg_4_0._network_state = arg_4_1

	var_0_1("register_network_state")

	local var_4_0 = arg_4_0._offline_level_data

	if arg_4_1:is_server() then
		arg_4_1:set_level_data(var_4_0.level_key, var_4_0.environment_variation_id, var_4_0.level_seed, var_4_0.mechanism, var_4_0.game_mode, var_4_0.conflict_director, var_4_0.locked_director_functions, var_4_0.difficulty, var_4_0.difficulty_tweak, var_4_0.level_session_id, var_4_0.level_transition_type, var_4_0.extra_packages)
	end

	arg_4_0._offline_level_data = nil
	arg_4_0._next_level_data = nil
	arg_4_0._checkpoint_data = nil
end

function LevelTransitionHandler.deregister_network_state(arg_5_0)
	var_0_1("deregister_network_state")

	arg_5_0._next_level_data = nil
	arg_5_0._network_state = nil
	arg_5_0._offline_level_data = table.clone(arg_5_0._default_level_data)
	arg_5_0._offline_level_data.level_session_id = math.random_seed()
	arg_5_0._currently_loaded_level_session_id = nil
end

function LevelTransitionHandler.register_rpcs(arg_6_0, arg_6_1)
	arg_6_0.enemy_package_loader:register_rpcs(arg_6_1)
	arg_6_0.transient_package_loader:register_rpcs(arg_6_1)
end

function LevelTransitionHandler.unregister_rpcs(arg_7_0)
	arg_7_0.enemy_package_loader:unregister_rpcs()
	arg_7_0.transient_package_loader:unregister_rpcs()
end

function LevelTransitionHandler.reload_level(arg_8_0, arg_8_1, arg_8_2)
	fassert(not arg_8_0._network_state or arg_8_0._network_state:is_server(), "only the server can reload")
	var_0_2("reload_level")

	arg_8_0._checkpoint_data = arg_8_1

	local var_8_0 = true
	local var_8_1 = "reload_level"

	arg_8_0:_set_next_level(var_8_1, arg_8_0:get_current_level_key(), arg_8_0:get_current_environment_variation_id(), arg_8_2 or arg_8_0:get_current_level_seed(), arg_8_0:get_current_mechanism(), arg_8_0:get_current_game_mode(), arg_8_0:get_current_conflict_director(), arg_8_0:get_current_locked_director_functions(), arg_8_0:get_current_difficulty(), arg_8_0:get_current_difficulty_tweak(), table.shallow_copy(arg_8_0:get_current_extra_packages(), var_8_0))
end

function LevelTransitionHandler.get_checkpoint_data(arg_9_0)
	fassert(not arg_9_0._network_state or arg_9_0._network_state:is_server(), "only the server handles checkpoint data")

	return arg_9_0._checkpoint_data
end

function LevelTransitionHandler.get_current_environment_variation_name(arg_10_0)
	local var_10_0 = arg_10_0:get_current_environment_variation_id()
	local var_10_1 = arg_10_0:get_current_level_key()

	if var_10_0 and var_10_1 then
		local var_10_2 = LevelSettings[var_10_1].environment_variations

		return var_10_2 and var_10_2[var_10_0]
	end

	return nil
end

function LevelTransitionHandler.update(arg_11_0)
	local var_11_0 = false

	for iter_11_0, iter_11_1 in pairs(arg_11_0.loading_packages) do
		var_11_0 = true

		if arg_11_0:_level_packages_loaded(iter_11_0) then
			arg_11_0.loaded_levels[iter_11_0] = true
			arg_11_0.loading_packages[iter_11_0] = nil
		end
	end

	if var_11_0 then
		arg_11_0._has_loaded_all_packages = false
	elseif not arg_11_0._has_loaded_all_packages and not var_11_0 then
		var_0_2("Level load completed!")

		arg_11_0._has_loaded_all_packages = true
	end

	arg_11_0.enemy_package_loader:update()
	arg_11_0.pickup_package_loader:update()
	arg_11_0.general_synced_package_loader:update()
	arg_11_0.transient_package_loader:update()
end

function LevelTransitionHandler.promote_next_level_data(arg_12_0)
	fassert(arg_12_0._network_state and arg_12_0._network_state:is_server() or not arg_12_0._network_state, "only server can promote")
	fassert(arg_12_0._next_level_data, "can't promote without previously calling set_next_level")
	var_0_2("promote_next_level_data")

	if arg_12_0._network_state then
		arg_12_0._network_state:set_level_data(arg_12_0._next_level_data.level_key, arg_12_0._next_level_data.environment_variation_id, arg_12_0._next_level_data.level_seed, arg_12_0._next_level_data.mechanism, arg_12_0._next_level_data.game_mode, arg_12_0._next_level_data.conflict_director, arg_12_0._next_level_data.locked_director_functions, arg_12_0._next_level_data.difficulty, arg_12_0._next_level_data.difficulty_tweak, arg_12_0._next_level_data.level_session_id, arg_12_0._next_level_data.level_transition_type, arg_12_0._next_level_data.extra_packages)
	else
		arg_12_0._offline_level_data = arg_12_0._next_level_data
	end

	arg_12_0._next_level_data = nil
end

function LevelTransitionHandler.needs_level_load(arg_13_0)
	return arg_13_0:get_current_level_session_id() ~= arg_13_0._currently_loaded_level_session_id
end

function LevelTransitionHandler.load_current_level(arg_14_0)
	local var_14_0 = arg_14_0:get_current_level_key()
	local var_14_1 = arg_14_0:get_current_extra_packages()
	local var_14_2 = arg_14_0:get_current_environment_variation_id()
	local var_14_3 = arg_14_0:get_current_level_session_id()

	printf("load_current_level, loading %s %s", var_14_0, tostring(var_14_2))
	fassert(LevelSettings[var_14_0], "The level named %q does not exist in LevelSettings.", tostring(var_14_0))

	local var_14_4 = arg_14_0._currently_loaded_level_key
	local var_14_5 = arg_14_0._currently_loaded_environment_variation_id

	arg_14_0:_release_extra_packages(var_14_4)

	if var_14_4 and var_14_0 ~= var_14_4 then
		arg_14_0:_release_level_resources(var_14_4)
	end

	local var_14_6 = not arg_14_0.loading_packages[var_14_0]
	local var_14_7 = not arg_14_0:_level_packages_loaded(var_14_0)

	arg_14_0:_load_extra_packages(var_14_0, var_14_1)

	if var_14_4 ~= var_14_0 or var_14_5 ~= var_14_2 or var_14_6 and var_14_7 then
		arg_14_0:_load_level_packages(var_14_0)

		local var_14_8 = LevelSettings[var_14_0]
		local var_14_9 = var_14_8.packages

		var_0_1("loading level: %q", var_14_0)
		var_0_1("loading packages: %s", table.tostring(var_14_9))
		var_0_1("loading extra packages: [%s] %s", var_14_0, table.tostring(var_14_1))

		arg_14_0.loading_packages[var_14_0] = true

		local var_14_10 = var_14_4 and LevelSettings[var_14_4]
		local var_14_11 = var_14_10 and var_14_10.render_settings_overrides

		if var_14_11 then
			var_0_1("Restoring override render_settings for level: %q", var_14_0)

			for iter_14_0, iter_14_1 in pairs(var_14_11) do
				local var_14_12 = Application.user_setting("render_settings", iter_14_0)

				var_0_1("Restoring: %q = %q", iter_14_0, var_14_12)
				Application.set_render_setting(iter_14_0, tostring(var_14_12))
			end
		end

		local var_14_13 = var_14_8.render_settings_overrides

		if var_14_13 then
			var_0_1("Setting render_settings overrides for level: %q", var_14_0)

			for iter_14_2, iter_14_3 in pairs(var_14_13) do
				var_0_1("Overriding: %q = %q", iter_14_2, iter_14_3)
				Application.set_render_setting(iter_14_2, tostring(iter_14_3))
			end
		end
	end

	arg_14_0._currently_loaded_level_key = var_14_0
	arg_14_0._currently_loaded_environment_variation_id = var_14_2
	arg_14_0._currently_loaded_level_session_id = var_14_3
	arg_14_0._has_loaded_all_packages = false
end

function LevelTransitionHandler.release_level_resources(arg_15_0)
	local var_15_0 = arg_15_0._currently_loaded_level_key

	if not var_15_0 then
		return
	end

	arg_15_0:_release_extra_packages(var_15_0)
	arg_15_0:_release_level_resources(var_15_0)

	arg_15_0._currently_loaded_level_key = nil
	arg_15_0._currently_loaded_environment_variation_id = nil
end

function LevelTransitionHandler._release_level_resources(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.loaded_levels[arg_16_1]
	local var_16_1 = arg_16_0.loading_packages[arg_16_1]

	if not LEVEL_EDITOR_TEST and (var_16_0 or var_16_1) then
		arg_16_0:_unload_level_packages(arg_16_1)

		arg_16_0.loading_packages[arg_16_1] = nil
		arg_16_0.loaded_levels[arg_16_1] = false
	end
end

function LevelTransitionHandler._load_extra_packages(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_2 and #arg_17_2 > 0 then
		fassert(arg_17_0._extra_packages == nil, "Trying to load level before releasing previous one properly. _extra_packages have not been unloaded.")

		arg_17_0._extra_packages = arg_17_2

		local var_17_0 = true
		local var_17_1 = arg_17_1
		local var_17_2 = Managers.package

		for iter_17_0 = 1, #arg_17_2 do
			local var_17_3 = arg_17_2[iter_17_0]

			var_17_2:load(var_17_3, var_17_1, nil, var_17_0)
		end
	end
end

function LevelTransitionHandler._release_extra_packages(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._extra_packages

	if var_18_0 then
		var_0_1("unloading extra packages: [%s] %s", arg_18_1, table.tostring(var_18_0))

		local var_18_1 = Managers.package

		for iter_18_0 = #var_18_0, 1, -1 do
			local var_18_2 = var_18_0[iter_18_0]

			if var_18_1:has_loaded(var_18_2, arg_18_1) or var_18_1:is_loading(var_18_2) then
				var_18_1:unload(var_18_2, arg_18_1)
			end
		end

		arg_18_0._extra_packages = nil
	end
end

function LevelTransitionHandler.has_next_level(arg_19_0)
	fassert(not arg_19_0._network_state or arg_19_0._network_state:is_server(), "only the server handles next level logic")

	return arg_19_0._next_level_data ~= nil
end

function LevelTransitionHandler.clear_next_level(arg_20_0)
	fassert(not arg_20_0._network_state or arg_20_0._network_state:is_server(), "only the server handles next level logic")
	var_0_1("clear_next_level")

	arg_20_0._next_level_data = nil
end

function LevelTransitionHandler.set_next_level(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8, arg_21_9, arg_21_10)
	local var_21_0 = "load_next_level"

	arg_21_0:_set_next_level(var_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8, arg_21_9, arg_21_10)
end

function LevelTransitionHandler.get_next_level_key(arg_22_0)
	fassert(not arg_22_0._network_state or arg_22_0._network_state:is_server(), "only the server handles next level logic")

	return arg_22_0._next_level_data and arg_22_0._next_level_data.level_key
end

function LevelTransitionHandler.get_next_level_seed(arg_23_0)
	fassert(not arg_23_0._network_state or arg_23_0._network_state:is_server(), "only the server handles next level logic")

	return arg_23_0._next_level_data and arg_23_0._next_level_data.level_seed
end

function LevelTransitionHandler.get_next_game_mode(arg_24_0)
	fassert(not arg_24_0._network_state or arg_24_0._network_state:is_server(), "only the server handles next level logic")

	return arg_24_0._next_level_data and arg_24_0._next_level_data.game_mode
end

function LevelTransitionHandler.get_next_conflict_director(arg_25_0)
	fassert(not arg_25_0._network_state or arg_25_0._network_state:is_server(), "only the server handles next level logic")

	return arg_25_0._next_level_data and arg_25_0._next_level_data.conflict_director
end

function LevelTransitionHandler.get_next_environment_variation_id(arg_26_0)
	fassert(not arg_26_0._network_state or arg_26_0._network_state:is_server(), "only the server handles next level logic")

	return arg_26_0._next_level_data and arg_26_0._next_level_data.environment_variation_id
end

function LevelTransitionHandler.get_next_locked_director_functions(arg_27_0)
	fassert(not arg_27_0._network_state or arg_27_0._network_state:is_server(), "only the server handles next level logic")

	return arg_27_0._next_level_data and arg_27_0._next_level_data.locked_director_functions
end

function LevelTransitionHandler.get_next_difficulty(arg_28_0)
	fassert(not arg_28_0._network_state or arg_28_0._network_state:is_server(), "only the server handles next level logic")

	return arg_28_0._next_level_data and arg_28_0._next_level_data.difficulty
end

function LevelTransitionHandler.get_next_difficulty_tweak(arg_29_0)
	fassert(not arg_29_0._network_state or arg_29_0._network_state:is_server(), "only the server handles next level logic")

	return arg_29_0._next_level_data and arg_29_0._next_level_data.difficulty_tweak
end

function LevelTransitionHandler.get_current_level_key(arg_30_0)
	return arg_30_0._network_state and arg_30_0._network_state:get_level_key() or arg_30_0._offline_level_data and arg_30_0._offline_level_data.level_key
end

function LevelTransitionHandler.get_current_level_seed(arg_31_0)
	return arg_31_0._network_state and arg_31_0._network_state:get_level_seed() or arg_31_0._offline_level_data.level_seed
end

function LevelTransitionHandler.get_current_game_mode(arg_32_0)
	return arg_32_0._network_state and arg_32_0._network_state:get_game_mode() or arg_32_0._offline_level_data.game_mode
end

function LevelTransitionHandler.get_current_conflict_director(arg_33_0)
	return arg_33_0._network_state and arg_33_0._network_state:get_conflict_director() or arg_33_0._offline_level_data.conflict_director
end

function LevelTransitionHandler.get_current_environment_variation_id(arg_34_0)
	return arg_34_0._network_state and arg_34_0._network_state:get_environment_variation_id() or arg_34_0._offline_level_data.environment_variation_id
end

function LevelTransitionHandler.get_current_locked_director_functions(arg_35_0)
	return arg_35_0._network_state and arg_35_0._network_state:get_locked_director_functions() or arg_35_0._offline_level_data.locked_director_functions
end

function LevelTransitionHandler.get_current_difficulty(arg_36_0)
	return arg_36_0._network_state and arg_36_0._network_state:get_difficulty() or arg_36_0._offline_level_data.difficulty
end

function LevelTransitionHandler.get_current_difficulty_tweak(arg_37_0)
	return arg_37_0._network_state and arg_37_0._network_state:get_difficulty_tweak() or arg_37_0._offline_level_data.difficulty_tweak
end

function LevelTransitionHandler.get_current_extra_packages(arg_38_0)
	return arg_38_0._network_state and arg_38_0._network_state:get_extra_packages() or arg_38_0._offline_level_data.extra_packages
end

function LevelTransitionHandler.get_current_mechanism(arg_39_0)
	return arg_39_0._network_state and arg_39_0._network_state:get_mechanism() or arg_39_0._offline_level_data.mechanism
end

function LevelTransitionHandler.get_current_level_session_id(arg_40_0)
	return arg_40_0._network_state and arg_40_0._network_state:get_level_session_id() or arg_40_0._offline_level_data.level_session_id
end

function LevelTransitionHandler.get_current_level_transition_type(arg_41_0)
	return arg_41_0._network_state and arg_41_0._network_state:get_level_transition_type() or arg_41_0._offline_level_data.level_transition_type
end

function LevelTransitionHandler.get_current_checkpoint(arg_42_0)
	return arg_42_0._network_state and arg_42_0._network_state:get_check_point() or arg_42_0._offline_level_data.check_point
end

function LevelTransitionHandler.get_current_level_keys(arg_43_0)
	return arg_43_0:get_current_level_key()
end

function LevelTransitionHandler.all_packages_loaded(arg_44_0)
	return not arg_44_0:needs_level_load() and arg_44_0._has_loaded_all_packages == true
end

function LevelTransitionHandler._set_next_level(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9, arg_45_10, arg_45_11)
	local var_45_0 = not arg_45_0._network_state or arg_45_0._network_state:is_server()

	fassert(var_45_0, "only the server handles next level logic")

	local var_45_1, var_45_2, var_45_3, var_45_4, var_45_5, var_45_6, var_45_7, var_45_8, var_45_9, var_45_10 = arg_45_0:apply_defaults_to_level_data(arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9, arg_45_10, arg_45_11, var_45_0)

	arg_45_0:_append_event_packages(var_45_1, var_45_10)

	local var_45_11 = math.random_seed()

	var_0_2("set_next_level( lvl:%s, mc:%s, gm:%s, env:%s, seed:%d, conflict:%s, lckd_director_funcs:{%s}, diff:%s, diff_tweak:%d, id:%d, lt:%s, extra_packages:%s)", tostring(var_45_1), var_45_4, var_45_5, tostring(var_45_2), var_45_3, var_45_6, table.concat(var_45_7, ","), var_45_8, var_45_9, var_45_11, arg_45_1, table.tostring(var_45_10))

	arg_45_0._next_level_data = {
		level_key = var_45_1,
		mechanism = var_45_4,
		game_mode = var_45_5,
		level_seed = var_45_3,
		environment_variation_id = var_45_2,
		conflict_director = var_45_6,
		locked_director_functions = var_45_7,
		difficulty = var_45_8,
		difficulty_tweak = var_45_9,
		level_session_id = var_45_11,
		level_transition_type = arg_45_1,
		extra_packages = var_45_10
	}
end

function LevelTransitionHandler._append_event_packages(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = LevelSettings[arg_46_1]

	if not var_46_0 or var_46_0.hub_level or var_46_0.tutorial_level then
		return
	end

	local var_46_1 = Managers.backend:get_interface("live_events"):get_special_events()

	if not var_46_1 then
		return
	end

	local var_46_2 = {}

	for iter_46_0 = 1, #var_46_1 do
		local var_46_3 = var_46_1[iter_46_0]
		local var_46_4 = var_46_3.level_keys

		if not var_46_4 or table.is_empty(var_46_4) or table.contains(var_46_4, arg_46_1) then
			local var_46_5 = var_46_3.weekly_event

			if var_46_5 then
				if var_46_5 == "override" then
					table.clear(var_46_2)
					table.append(var_46_2, var_46_3.mutators)
				elseif var_46_5 == "append" then
					table.append(var_46_2, var_46_3.mutators)
				end
			end
		end
	end

	for iter_46_1 = 1, #var_46_2 do
		local var_46_6 = var_46_2[iter_46_1]
		local var_46_7 = MutatorTemplates[var_46_6].packages

		if var_46_7 then
			for iter_46_2 = 1, #var_46_7 do
				local var_46_8 = var_46_7[iter_46_2]

				if not table.contains(arg_46_2, var_46_8) then
					table.insert(arg_46_2, var_46_8)
				end
			end
		end
	end
end

function LevelTransitionHandler._load_level_packages(arg_47_0, arg_47_1)
	local var_47_0 = true
	local var_47_1 = Managers.package
	local var_47_2 = arg_47_1
	local var_47_3 = LevelSettings[arg_47_1]
	local var_47_4 = var_47_3.packages

	if var_47_4 then
		for iter_47_0 = 1, #var_47_4 do
			local var_47_5 = var_47_4[iter_47_0]

			var_47_1:load(var_47_5, var_47_2, nil, var_47_0)
		end
	end

	local var_47_6 = var_47_3.hero_specific_packages

	if var_47_6 then
		local var_47_7 = Managers.mechanism:profile_synchronizer()
		local var_47_8 = var_47_7 and var_47_7:profile_by_peer(Network.peer_id(), 1)

		if not var_47_8 then
			local var_47_9 = Managers.mechanism:network_handler()

			var_47_8 = var_47_9 and var_47_9.wanted_profile_index
		end

		local var_47_10 = SPProfiles[var_47_8]
		local var_47_11 = var_47_10 and var_47_10.display_name
		local var_47_12 = var_47_6[var_47_11]

		if var_47_12 then
			for iter_47_1 = 1, #var_47_12 do
				local var_47_13 = var_47_12[iter_47_1]

				var_47_1:load(var_47_13, var_47_2, nil, var_47_0)
			end

			arg_47_0.hero_specific_packages[arg_47_1] = var_47_12
			arg_47_0.selected_hero_name_on_load = var_47_11
		end
	end
end

function LevelTransitionHandler._unload_level_packages(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_1
	local var_48_1 = Managers.package
	local var_48_2 = LevelSettings[arg_48_1].packages
	local var_48_3 = arg_48_0.hero_specific_packages[arg_48_1]

	if var_48_3 then
		for iter_48_0 = #var_48_3, 1, -1 do
			local var_48_4 = var_48_3[iter_48_0]

			if var_48_1:has_loaded(var_48_4, var_48_0) or var_48_1:is_loading(var_48_4) then
				var_48_1:unload(var_48_4, var_48_0)
			end
		end

		arg_48_0.hero_specific_packages[arg_48_1] = nil
		arg_48_0.selected_hero_name_on_load = nil
	end

	if var_48_2 then
		for iter_48_1 = #var_48_2, 1, -1 do
			local var_48_5 = var_48_2[iter_48_1]

			if var_48_1:has_loaded(var_48_5, var_48_0) or var_48_1:is_loading(var_48_5) then
				var_48_1:unload(var_48_5, var_48_0)
			end
		end
	end
end

function LevelTransitionHandler._level_packages_loaded(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_1
	local var_49_1 = Managers.package
	local var_49_2 = LevelSettings[arg_49_1].packages

	if var_49_2 then
		for iter_49_0 = 1, #var_49_2 do
			local var_49_3 = var_49_2[iter_49_0]

			if not var_49_1:has_loaded(var_49_3, var_49_0) then
				return false
			end
		end
	end

	local var_49_4 = arg_49_0.hero_specific_packages[arg_49_1]

	if var_49_4 then
		for iter_49_1 = #var_49_4, 1, -1 do
			local var_49_5 = var_49_4[iter_49_1]

			if not var_49_1:has_loaded(var_49_5, var_49_0) then
				return false
			end
		end
	end

	return true
end

function LevelTransitionHandler.create_level_seed()
	local var_50_0 = os.clock() * 10000 % 961748927
	local var_50_1 = os.time()
	local var_50_2 = (var_50_0 + tonumber(tostring(string.format("%d", var_50_1)):reverse():sub(1, 6))) % 15485867

	return (math.floor(var_50_2))
end

function LevelTransitionHandler.apply_defaults_to_level_data(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8, arg_51_9, arg_51_10, arg_51_11)
	if not arg_51_4 and arg_51_1 then
		arg_51_4 = LevelSettings[arg_51_1].mechanism
	end

	if not arg_51_4 then
		local var_51_0 = arg_51_0:get_current_level_key()

		if var_51_0 then
			arg_51_4 = LevelSettings[var_51_0].mechanism
		end
	end

	arg_51_4 = arg_51_4 or "adventure"

	if not arg_51_1 then
		local var_51_1 = MechanismSettings[arg_51_4].class_name

		arg_51_1 = rawget(_G, var_51_1).get_starting_level()
	end

	local var_51_2 = LevelSettings[arg_51_1]

	arg_51_5 = arg_51_5 or var_51_2.game_mode

	if not arg_51_5 then
		local var_51_3 = MechanismSettings[arg_51_4]

		if var_51_2.hub_level then
			arg_51_5 = arg_51_5 or var_51_3.gamemode_lookup.keep
		else
			arg_51_5 = arg_51_5 or var_51_3.gamemode_lookup.default
		end
	end

	local var_51_4 = GameModeSettings[arg_51_5]
	local var_51_5 = var_51_4 and var_51_4.forced_difficulty

	arg_51_2 = arg_51_2 or 0
	arg_51_6 = script_data.override_conflict_settings or arg_51_6 or var_51_2.conflict_settings or "default"
	arg_51_7 = arg_51_7 or {}
	arg_51_8 = script_data.current_difficulty_setting or var_51_5 or arg_51_8 or "normal"
	arg_51_9 = script_data.current_difficulty_tweak_setting or arg_51_9 or 0

	if arg_51_11 and script_data.random_level_seed_from_toolcenter and not arg_51_3 then
		arg_51_3 = Development.parameter("level_seed") or LevelTransitionHandler.create_level_seed()
	else
		arg_51_3 = tonumber(arg_51_3 or Development.parameter("level_seed") or GameMechanismManager.create_level_seed())
	end

	arg_51_10 = arg_51_10 or {}

	return arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8, arg_51_9, arg_51_10
end

function LevelTransitionHandler._update_debug(arg_52_0)
	if script_data.debug_level_seed_and_level_packages then
		local var_52_0 = arg_52_0:get_current_level_seed()

		for iter_52_0, iter_52_1 in pairs(arg_52_0.loaded_levels) do
			Debug.text("Level %q is_loaded: %s", iter_52_0, tostring(iter_52_1))
		end

		Debug.text("Level Seed: %d", var_52_0 or -1)
	end
end

function LevelTransitionHandler.in_hub_level(arg_53_0)
	local var_53_0 = arg_53_0:get_current_level_key()

	if var_53_0 then
		return LevelSettings[var_53_0].hub_level
	end
end

function LevelTransitionHandler.queue_create_networked_flow_state(arg_54_0, arg_54_1, ...)
	local var_54_0 = Unit.level(arg_54_1)
	local var_54_1 = arg_54_0._queued_network_flow_states[var_54_0] or {}

	arg_54_0._queued_network_flow_states[var_54_0] = var_54_1
	var_54_1[#var_54_1 + 1] = arg_54_1
end

function LevelTransitionHandler.create_queued_networked_flow_states(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0._queued_network_flow_states[arg_55_1]

	if var_55_0 then
		for iter_55_0 = 1, #var_55_0 do
			if Unit.alive(var_55_0[iter_55_0]) then
				Unit.flow_event(var_55_0[iter_55_0], "Create")
			end
		end
	end

	table.clear(arg_55_0._queued_network_flow_states)
end
