-- chunkname: @scripts/entity_system/systems/tutorial/tutorial_system.lua

require("scripts/entity_system/systems/tutorial/tutorial_templates")
require("scripts/entity_system/systems/tutorial/tutorial_condition_evaluator")

local num = 30
local num_2 = 0.3
local num_3 = 100
local flag = true

function tutprintf(...)
	-- function 1
	if not script_data.tutorial_debug then
		printf(...)
	end
end

local function fn()
	-- function 2
	print("Tutorial - save done")
end

local function fn_2(self)
	-- function 3
	local SaveData = SaveData

	SaveData.tutorial_points = self.points
	SaveData.completed_tutorials = self.completed_tutorials

	Managers.save:auto_save(SaveFileName, SaveData, fn)
end

local tbl = {
	"PlayerTutorialExtension",
	"ObjectiveHealthTutorialExtension",
	"ObjectivePickupTutorialExtension",
	"ObjectiveSocketTutorialExtension",
	"ObjectiveUnitExtension"
}

TutorialSystem = class(TutorialSystem, ExtensionSystemBase)

TutorialSystem.init = function (self, arg_4_1, arg_4_2)
	-- function 4
	TutorialSystem.super.init(self, arg_4_1, arg_4_2, tbl)

	self.player_units = {}
	self.pacing = "pacing_relax"
	self.dice_keeper = arg_4_1.dice_keeper
	self.health_extensions = {}
	self.raycast_units = {}
	self._objective_tooltip_prioritized_list = nil
	self.frozen_unit_extension_data = {}
	self.unit_extension_data = {}
	self.gui = World.create_screen_gui(self.world, "material", "materials/fonts/gw_fonts", "immediate")

	local network_event_delegate = arg_4_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, "rpc_tutorial_message", "rpc_pacing_changed", "rpc_objective_unit_set_active", "rpc_prioritize_objective_tooltip", "rpc_objective_unit_set_always_show")

	local SaveData = SaveData
	local seen_handbook_popups = SaveData.seen_handbook_popups

	seen_handbook_popups = seen_handbook_popups or {}
	SaveData.seen_handbook_popups = seen_handbook_popups

	Managers.state.event:register(self, "tutorial_trigger", "on_tutorial_trigger")

	self._condition_context = TutorialConditionEvaluator:new()
	flag = false
end

TutorialSystem.destroy = function (self)
	-- function 5
	Managers.state.event:unregister(self, "tutorial_trigger")
	self.network_event_delegate:unregister(self)
	table.clear(self)
end

local tbl_2 = {}

TutorialSystem.on_add_extension = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local tbl = {}

	if arg_6_3 == "PlayerTutorialExtension" then
		self.player_units[arg_6_2] = tbl

		local completed_tutorials = SaveData.completed_tutorials

		completed_tutorials = completed_tutorials or {}
		tbl.completed_tutorials = completed_tutorials
		tbl.points = #tbl.completed_tutorials
		tbl.tooltip_tutorial = {
			active = false
		}
		tbl.objective_tooltips = {
			units_n = 0,
			active = false,
			units = {}
		}
		tbl.shown_times = {}
		tbl.data = {
			player_id = Network.peer_id(),
			statistics_db = self.statistics_db,
			dice_keeper = self.dice_keeper
		}

		local TutorialTemplates = TutorialTemplates

		for k, v in pairs(TutorialTemplates) do
			tbl.shown_times[k] = -1000

			v.init_data(tbl.data)
		end
	end

	if arg_6_3 == "ObjectiveHealthTutorialExtension" then
		Managers.state.event:trigger("tutorial_event_add_health_bar", arg_6_2)

		self.health_extensions[arg_6_2] = tbl
	end

	if arg_6_3 == "ObjectivePickupTutorialExtension" then
		local get_data = Unit.get_data(arg_6_2, "approach_text")

		get_data = get_data or "<approach_text not set>"
		tbl.approach_text = get_data

		local get_data_2 = Unit.get_data(arg_6_2, "disable_objective_ui")

		get_data_2 = get_data_2 or false
		tbl.disregard = get_data_2
	end

	if arg_6_3 == "ObjectiveSocketTutorialExtension" then
		local get_data_3 = Unit.get_data(arg_6_2, "approach_text")

		get_data_3 = get_data_3 or "<approach_text not set>"
		tbl.approach_text = get_data_3

		local get_data_4 = Unit.get_data(arg_6_2, "pickup_text")

		get_data_4 = get_data_4 or "<pickup_text not set>"
		tbl.pickup_text = get_data_4
	end

	if arg_6_3 == "ObjectiveUnitExtension" then
		local get_data_5 = Unit.get_data(arg_6_2, "objective_server_only")
		local var_6_8
		local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()

		if not LevelSettings[get_current_level_keys].hub_level then
			var_6_8 = Unit.get_data(arg_6_2, "network_synced")
		else
			var_6_8 = true
		end

		local var_6_10

		if not (not Managers.player.is_server and get_data_5) then
			function var_6_10(self, arg_7_1)
				-- function 7
				if self.active == arg_7_1 then
					Application.warning("[ObjectiveUnitExtension] Trying to set active on unit %q to %q when it's already %q", tostring(arg_6_2), arg_7_1, self.active)
				else
					self.active = arg_7_1

					if not self.network_synced then
						local network = Managers.state.network
						local game_object_or_level_id, var_7_2 = network:game_object_or_level_id(self.unit)

						network.network_transmit:send_rpc_clients("rpc_objective_unit_set_active", game_object_or_level_id, var_7_2, arg_7_1)
					end
				end
			end
		elseif not (Managers.player.is_server or get_data_5) then
			function var_6_10(self, arg_8_1)
				-- function 8
				self.active = arg_8_1
			end
		else
			function var_6_10(self, arg_9_1)
				-- function 9
				self.active = arg_9_1
			end
		end

		tbl.unit = arg_6_2
		tbl.active = false
		tbl.proxy_active = arg_6_4.proxy_active
		tbl.set_active = var_6_10
		tbl.server_only = get_data_5
		tbl.network_synced = var_6_8

		local always_show = arg_6_4.always_show

		always_show = always_show or Unit.get_data(arg_6_2, "always_show")
		tbl.always_show = always_show

		tbl.set_always_show = function (self, arg_10_1)
			-- function 10
			self.always_show = arg_10_1

			if not Managers.player.is_server and get_data_5 or not self.network_synced then
				local network = Managers.state.network
				local game_object_or_level_id, var_10_2 = network:game_object_or_level_id(self.unit)

				network.network_transmit:send_rpc_clients("rpc_objective_unit_set_always_show", game_object_or_level_id, var_10_2, arg_10_1)
			end
		end
	end

	if not POSITION_LOOKUP[arg_6_2] then
		POSITION_LOOKUP[arg_6_2] = Unit.world_position(arg_6_2, 0)
	end

	ScriptUnit.set_extension(arg_6_2, "tutorial_system", tbl, tbl_2)

	self.unit_extension_data[arg_6_2] = tbl

	return tbl
end

TutorialSystem.on_remove_extension = function (self, arg_11_1, arg_11_2)
	-- function 11
	self:_cleanup_extension(arg_11_1)

	self.frozen_unit_extension_data[arg_11_1] = nil

	ScriptUnit.remove_extension(arg_11_1, "tutorial_system")
end

TutorialSystem.on_freeze_extension = function (self, arg_12_1, arg_12_2)
	-- function 12
	self:freeze(arg_12_1, arg_12_2)
end

TutorialSystem.freeze = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local frozen_unit_extension_data = self.frozen_unit_extension_data

	if not frozen_unit_extension_data[arg_13_1] then
		return
	end

	local var_13_1 = self.unit_extension_data[arg_13_1]

	fassert(var_13_1, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(arg_13_1)

	frozen_unit_extension_data[arg_13_1] = var_13_1
end

TutorialSystem.unfreeze = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local var_14_0 = self.frozen_unit_extension_data[arg_14_1]

	fassert(var_14_0, "Unit to unfreeze didn't have frozen extension")

	self.frozen_unit_extension_data[arg_14_1] = nil
	self.unit_extension_data[arg_14_1] = var_14_0

	if arg_14_2 == "ObjectiveHealthTutorialExtension" then
		Managers.state.event:trigger("tutorial_event_add_health_bar", arg_14_1)

		self.health_extensions[arg_14_1] = var_14_0
	elseif arg_14_2 == "PlayerTutorialExtension" then
		self.player_units[arg_14_1] = var_14_0
	end

	if not POSITION_LOOKUP[arg_14_1] then
		POSITION_LOOKUP[arg_14_1] = Unit.world_position(arg_14_1, 0)
	end
end

TutorialSystem._cleanup_extension = function (self, arg_15_1)
	-- function 15
	if not self.health_extensions[arg_15_1] then
		self.health_extensions[arg_15_1] = nil

		Managers.state.event:trigger("tutorial_event_remove_health_bar", arg_15_1)
	end

	self.player_units[arg_15_1] = nil

	local var_15_0 = self.unit_extension_data[arg_15_1]

	if not var_15_0 and not var_15_0.active then
		var_15_0:set_active(false)
	end

	self.unit_extension_data[arg_15_1] = nil
end

TutorialSystem.physics_async_update = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not script_data.tutorial_disabled then
		return
	end

	local world = self.world
	local raycast_units = self.raycast_units

	for k, v in pairs(self.player_units) do
		local var_16_2 = raycast_units[k]

		raycast_units[k] = nil

		local is_looking_at_interactable = ScriptUnit.extension(k, "interactor_system"):is_looking_at_interactable()

		if not is_looking_at_interactable then
			v.tooltip_tutorial.active = false
		end

		local extension = ScriptUnit.extension(k, "status_system")

		if not (is_looking_at_interactable or extension:is_disabled()) then
			self:iterate_tooltips(arg_16_2, k, v, var_16_2, world)
		end

		self:iterate_objective_tooltips(arg_16_2, k, v, var_16_2, world)

		if not ((self.pacing == "pacing_peak_fade" or self.pacing == "pacing_relax") and script_data.info_slates_disabled) then
			self:iterate_info_slates(arg_16_2, k, v, var_16_2, world)
		end

		if not (not v.tooltip_tutorial.active and not (arg_16_2 > v.shown_times[v.tooltip_tutorial.name] + num_2)) then
			v.tooltip_tutorial.active = false
		end

		if not script_data.tutorial_debug then
			if not DebugKeyHandler.key_pressed("f10", "add debug info slate", "tutorials") then
				local num_3 = math.random() * 5

				Managers.state.event:trigger("tutorial_event_queue_info_slate_entry", "tutorial", "DEBUG INFO SLATE, LOOK AT IT GOOOO", num_3 + 5)
			end

			local res_w = RESOLUTION_LOOKUP.res_w
			local res_h = RESOLUTION_LOOKUP.res_h

			Gui.rect(self.gui, Vector3(0, 0, 100), Vector2(350, res_h), Color(100, 25, 25, 25))
			Debug.text("Tutorial points : %d", v.points)
			Debug.text("Completed tutorials:")
			Debug.text("Shelved tutorials:")

			for k_2, v_2 in pairs(TutorialTemplates) do
				local var_16_8 = v.shown_times[k_2]

				if arg_16_2 < var_16_8 + num then
					Debug.text(" * %s, %.1fs", k_2, var_16_8 + num - arg_16_2)
				end
			end

			if not v.tooltip_tutorial.active then
				Debug.text("Tooltip tutorial: " .. v.tooltip_tutorial.name)

				if not v.tooltip_tutorial.world_position then
					QuickDrawer:sphere(v.tooltip_tutorial.world_position:unbox(), 1, Colors.get("brown"))
				end
			else
				Debug.text("Tooltip tutorial: inactive")
			end

			if var_16_2 == nil then
				Debug.text("Raycast unit: none")
			else
				Debug.text("Raycast unit: %s", Unit.debug_name(var_16_2))
			end

			Debug.text("Extension data:")

			for k_3, v_3 in pairs(v.data) do
				Debug.text(" * %s = %s", k_3, tostring(v_3))
			end
		end
	end

	flag = false
end

TutorialSystem.iterate_tooltips = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	local TutorialTooltipTemplates = TutorialTooltipTemplates
	local TutorialTooltipTemplates_n = TutorialTooltipTemplates_n
	local active = Managers.state.entity:system("play_go_tutorial_system"):active()
	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
	local hub_level = LevelSettings[get_current_level_keys].hub_level

	for i = 1, TutorialTooltipTemplates_n do
		repeat
			local var_17_5 = TutorialTooltipTemplates[i]
			local name = var_17_5.name

			if not (not active and var_17_5.allowed_in_tutorial) then
				break
			elseif active or not var_17_5.incompatible_in_game then
				-- Nothing
			elseif hub_level or not var_17_5.inn_only then
				break
			end

			var_17_5.update_data(arg_17_1, arg_17_2, arg_17_3.data)

			local can_show, var_17_8 = var_17_5.can_show(arg_17_1, arg_17_2, arg_17_3.data, arg_17_4, arg_17_5)

			if not can_show then
				break
			end

			if not var_17_5.get_text then
				var_17_5.text = var_17_5.get_text(arg_17_3.data)
			end

			if not var_17_5.get_inputs then
				var_17_5.inputs = var_17_5.get_inputs(arg_17_3.data)
			end

			if not var_17_5.get_gamepad_inputs then
				var_17_5.gamepad_inputs = var_17_5.get_gamepad_inputs(arg_17_3.data)
			end

			if not var_17_5.get_force_update then
				var_17_5.force_update = var_17_5.get_force_update(arg_17_3.data)
			end

			arg_17_3.tooltip_tutorial.active = true
			arg_17_3.tooltip_tutorial.name = name

			if not var_17_8 then
				arg_17_3.tooltip_tutorial.world_position = Vector3Box(var_17_8)
			else
				arg_17_3.tooltip_tutorial.world_position = nil
			end

			arg_17_3.shown_times[name] = arg_17_1

			return
		until true
	end
end

local local_position = Unit.local_position
local distance_squared = Vector3.distance_squared
local var_0_10

local function fn_3(arg_18_0, arg_18_1)
	-- function 18
	local var_18_0 = local_position(arg_18_0, 0)
	local var_18_1 = local_position(arg_18_1, 0)

	return distance_squared(var_0_10, var_18_0) < distance_squared(var_0_10, var_18_1)
end

TutorialSystem.prioritize_objective_tooltip = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not arg_19_2 then
		self._objective_tooltip_prioritized_list = nil
		self._prioritized_objective_tooltip = nil

		return
	end

	fassert(TutorialTemplates[arg_19_1], "[TutorialSystem] There is no TutorialObjectiveTooltipTemplate with the name %s", arg_19_1)
	fassert(TutorialTemplates[arg_19_1].display_type == "objective_tooltip", "[TutorialSystem] The tutorial template with the name %s is not an objective tooltip template (%s)", arg_19_1, TutorialTemplates[arg_19_1].display_type)

	local TutorialObjectiveTooltipTemplates_n = TutorialObjectiveTooltipTemplates_n

	self._objective_tooltip_prioritized_list = {}
	self._objective_tooltip_prioritized_list[#self._objective_tooltip_prioritized_list + 1] = TutorialTemplates[arg_19_1]

	for i = 1, TutorialObjectiveTooltipTemplates_n do
		if TutorialObjectiveTooltipTemplates[i].name ~= arg_19_1 then
			self._objective_tooltip_prioritized_list[#self._objective_tooltip_prioritized_list + 1] = TutorialObjectiveTooltipTemplates[i]
		end
	end

	self._prioritized_objective_tooltip = arg_19_1
end

TutorialSystem.iterate_objective_tooltips = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local _objective_tooltip_prioritized_list = self._objective_tooltip_prioritized_list

	_objective_tooltip_prioritized_list = _objective_tooltip_prioritized_list or TutorialObjectiveTooltipTemplates

	local TutorialObjectiveTooltipTemplates_n = TutorialObjectiveTooltipTemplates_n
	local objective_tooltips = arg_20_3.objective_tooltips

	objective_tooltips.units_n = 0

	for i = 1, TutorialObjectiveTooltipTemplates_n do
		repeat
			local var_20_3 = _objective_tooltip_prioritized_list[i]
			local name = var_20_3.name

			var_20_3.update_data(arg_20_1, arg_20_2, arg_20_3.data)

			local can_show, var_20_6, var_20_7 = var_20_3.can_show(arg_20_1, arg_20_2, arg_20_3.data, arg_20_4, arg_20_5)

			if not can_show then
				break
			end

			if not var_20_3.get_text then
				var_20_3.text = var_20_3.get_text(arg_20_3.data)
			end

			if not var_20_3.get_action then
				var_20_3.action = var_20_3.get_action(arg_20_3.data)
			end

			if not var_20_3.get_icon then
				var_20_3.icon = var_20_3.get_icon(arg_20_3.data)
			end

			if not var_20_3.get_alert then
				var_20_3.alerts_horde = var_20_3.get_alert(arg_20_3.data)
			end

			if not var_20_3.get_wave then
				var_20_3.wave = var_20_3.get_wave(arg_20_3.data)
			end

			objective_tooltips.active = true
			objective_tooltips.name = name
			objective_tooltips.units_n = var_20_7

			local units = objective_tooltips.units

			for j = 1, var_20_7 do
				units[j] = var_20_6[j]
			end

			local num = var_20_7 + 1

			while not units[num] do
				units[num] = nil
				num = num + 1
			end

			if var_20_7 > 1 then
				var_0_10 = Unit.local_position(arg_20_2, 0)

				local var_20_10 = fn_3

				table.sort(units, var_20_10)

				var_0_10 = nil
			end

			return
		until true
	end
end

TutorialSystem.verify_info_slate = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	local var_21_0 = self.player_units[arg_21_2]
	local world = self.world

	if not arg_21_4.do_not_verify then
		return true
	end

	return arg_21_4.can_show(arg_21_1, arg_21_2, var_21_0.data, arg_21_3, world)
end

TutorialSystem.iterate_info_slates = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	if not Application.user_setting("tutorials_enabled") then
		local TutorialInfoSlateTemplates = TutorialInfoSlateTemplates
		local TutorialInfoSlateTemplates_n = TutorialInfoSlateTemplates_n

		for i = 1, TutorialInfoSlateTemplates_n do
			repeat
				local var_22_2 = TutorialInfoSlateTemplates[i]
				local name = var_22_2.name
				local cooldown

				if not var_22_2.cooldown then
					cooldown = var_22_2.cooldown

					if not cooldown then
						-- Nothing
					end
				end

				cooldown = num_3

				::label_22_0::

				if arg_22_1 < arg_22_3.shown_times[name] + cooldown then
					break
				end

				if not var_22_2.can_show(arg_22_1, arg_22_2, arg_22_3.data, arg_22_4, arg_22_5) then
					arg_22_3.shown_times[name] = arg_22_1

					local get_text

					if not var_22_2.get_text then
						get_text = var_22_2.get_text(arg_22_3.data, var_22_2)

						if not get_text then
							-- Nothing
						end
					end

					get_text = var_22_2.text

					::label_22_1::

					local var_22_6 = Localize(get_text)

					Managers.state.event:trigger("tutorial_event_queue_info_slate_entry", var_22_6, nil, nil, var_22_2, arg_22_2, arg_22_4)
				end
			until true
		end
	else
		Managers.state.event:trigger("tutorial_event_clear_tutorials")
	end
end

TutorialSystem.on_tutorial_trigger = function (self, arg_23_1)
	-- function 23
	local _condition_context = self._condition_context

	if not _condition_context:get("has_max_level_character") then
		return
	end

	_condition_context:clear_cache()

	local seen_handbook_popups = SaveData.seen_handbook_popups

	for k, v in pairs(HandbookSettings.popups) do
		if not seen_handbook_popups[k] then
			-- Nothing
		elseif not table.find(v.triggers, arg_23_1) then
			-- Nothing
		else
			local conditions = v.conditions

			if not conditions then
				for k_2 = 1, #conditions do
					local var_23_3 = conditions[k_2]

					if not _condition_context:get(var_23_3) then
						goto label_23_0
					end
				end
			end

			local custom_condition = v.custom_condition

			if not (not custom_condition and custom_condition(_condition_context)) then
				-- Nothing
			else
				Managers.state.event:trigger("ui_show_popup", k, "handbook")

				seen_handbook_popups[k] = true
			end
		end

		::label_23_0::
	end
end

TutorialSystem.rpc_tutorial_message = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local var_24_0 = NetworkLookup.tutorials[arg_24_2]

	if not var_24_0 then
		return
	end

	local var_24_1 = NetworkLookup.tutorials[arg_24_3]
	local var_24_2 = TutorialTemplates[var_24_0]

	for k, v in pairs(self.player_units) do
		local data = v.data

		var_24_2.on_message(data, var_24_1)
	end
end

TutorialSystem.rpc_pacing_changed = function (self, arg_25_1, arg_25_2)
	-- function 25
	local var_25_0 = NetworkLookup.pacing[arg_25_2]

	self.pacing = var_25_0

	tutprintf("Changing pacing state to %s", var_25_0)
end

TutorialSystem.rpc_objective_unit_set_active = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_26_2, arg_26_3)
	local has_extension = ScriptUnit.has_extension(game_object_or_level_unit, "tutorial_system")

	if not has_extension then
		has_extension:set_active(arg_26_4)
	end
end

TutorialSystem.rpc_prioritize_objective_tooltip = function (self, arg_27_1, arg_27_2)
	-- function 27
	local var_27_0 = NetworkLookup.objective_tooltips[arg_27_2]

	self:prioritize_objective_tooltip(var_27_0)
end

TutorialSystem.rpc_objective_unit_set_always_show = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_28_2, arg_28_3)
	local has_extension = ScriptUnit.has_extension(game_object_or_level_unit, "tutorial_system")

	if not has_extension then
		has_extension:set_always_show(arg_28_4)
	end
end

TutorialSystem.flow_callback_show_health_bar = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	Managers.state.event:trigger("tutorial_event_show_health_bar", arg_29_1, arg_29_2)
end

TutorialSystem.flow_callback_tutorial_message = function (arg_30_0, arg_30_1, arg_30_2)
	-- function 30
	if not Managers.player.is_server then
		local var_30_0 = NetworkLookup.tutorials[arg_30_1]
		local var_30_1 = NetworkLookup.tutorials[arg_30_2]

		Managers.state.network.network_transmit:send_rpc_all("rpc_tutorial_message", var_30_0, var_30_1)
	end
end

TutorialSystem.hot_join_sync = function (self, arg_31_1)
	-- function 31
	local network = Managers.state.network
	local get_entities = Managers.state.entity:get_entities("ObjectiveUnitExtension")

	for k, v in pairs(get_entities) do
		if not v.active and v.server_only or not v.network_synced then
			local game_object_or_level_id, var_31_3 = network:game_object_or_level_id(k)

			network.network_transmit:send_rpc("rpc_objective_unit_set_active", arg_31_1, game_object_or_level_id, var_31_3, true)
		end
	end

	if not self._prioritized_objective_tooltip then
		local var_31_4 = NetworkLookup.objective_tooltips[self._prioritized_objective_tooltip]

		network.network_transmit:send_rpc("rpc_prioritize_objective_tooltip", arg_31_1, var_31_4)
	end
end

TutorialSystem.update = function (self, arg_32_1, arg_32_2)
	-- function 32
	if not script_data.tutorial_disabled then
		return
	end

	local world = self.world
	local get_data = World.get_data(self.world, "physics_world")
	local raycast_units = self.raycast_units

	for k, v in pairs(self.player_units) do
		if flag or not DebugKeyHandler.key_pressed("f3", "reset tutorials", "tutorials") then
			v.completed_tutorials = {}
			v.points = 0
			v.tooltip_tutorial.active = false
			v.data = {
				player_id = Network.peer_id(),
				statistics_db = self.statistics_db,
				dice_keeper = self.dice_keeper
			}

			for k_2, v_2 in pairs(TutorialTemplates) do
				v.shown_times[k_2] = -1000

				v_2.init_data(v.data)
			end
		end

		local extension = ScriptUnit.extension(k, "first_person_system")
		local current_position = extension:current_position()
		local current_rotation = extension:current_rotation()
		local forward = Quaternion.forward(current_rotation)
		local immediate_raycast, var_32_8, var_32_9, var_32_10, var_32_11 = PhysicsWorld.immediate_raycast(get_data, current_position + forward, forward, 30, "closest", "collision_filter", "filter_tutorial")
		local var_32_12

		if not immediate_raycast and not var_32_11 then
			var_32_12 = Actor.unit(var_32_11)

			if not HEALTH_ALIVE[var_32_12] then
				var_32_12 = nil
			end
		end

		raycast_units[k] = var_32_12
	end
end
