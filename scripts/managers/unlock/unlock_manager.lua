-- chunkname: @scripts/managers/unlock/unlock_manager.lua

require("scripts/managers/unlock/unlock_clan")
require("scripts/managers/unlock/unlock_dlc")
require("scripts/managers/unlock/unlock_dlc_bundle")
require("scripts/managers/unlock/unlock_game")
require("scripts/managers/unlock/always_unlocked")
require("scripts/settings/unlock_settings")
require("scripts/ui/dlc_upsell/common_popup_settings")

UnlockManager = class(UnlockManager)

UnlockManager.init = function (self)
	-- function 1
	self:_init_unlocks()

	if not IS_WINDOWS then
		self._state = "handle_reminder_popup"
	else
		self._state = "query_unlocked"
	end

	self._query_unlocked_index = 0
	self._dlc_status_changed = nil
	self._update_unlocks = false
	self._popup_ids = {}
	self._xbox_dlc_package_names = {}
	self._excluded_dlcs = {}
	self._handled_reminders_popups = false

	if not IS_XB1 then
		self._unlocks_ready = false

		local licensed_packages = XboxDLC.licensed_packages()

		licensed_packages = licensed_packages or {}
		self._licensed_packages = licensed_packages

		for i, v in ipairs(self._licensed_packages) do
			local display_name = XboxDLC.display_name(v)

			display_name = display_name or " "

			local gsub = string.gsub(display_name, "%c", "")

			self._xbox_dlc_package_names[v] = gsub
		end
	end

	self._reward_queue = {}
	self._reward_queue_id = 0
end

UnlockManager.enable_update_unlocks = function (self, arg_2_1)
	-- function 2
	self._update_unlocks = arg_2_1
end

UnlockManager._init_unlocks = function (self)
	-- function 3
	local tbl = {}
	local tbl_2 = {}

	for i, v in ipairs(UnlockSettings) do
		tbl_2[i] = {}

		for k, v_2 in pairs(v.unlocks) do
			local class = v_2.class
			local id = v_2.id
			local IS_PS4 = IS_PS4

			IS_PS4 = not IS_PS4 and v_2.fallback_id

			local backend_reward_id = v_2.backend_reward_id
			local always_unlocked_game_app_ids = v_2.always_unlocked_game_app_ids
			local requires_restart = v_2.requires_restart
			local cosmetic = v_2.cosmetic
			local is_legacy_console_dlc = v_2.is_legacy_console_dlc
			local bundle_contains = v_2.bundle_contains
			local var_3_11 = rawget(_G, class):new(k, id, backend_reward_id, always_unlocked_game_app_ids, cosmetic, IS_PS4, requires_restart, is_legacy_console_dlc, bundle_contains)

			tbl[k] = var_3_11
			tbl_2[i][k] = var_3_11
		end
	end

	self._unlocks = tbl
	self._unlocks_indexed = tbl_2
end

local tbl = {}

UnlockManager.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not IS_XB1 then
		if not self._update_unlocks then
			self._dlc_status_changed = nil

			if XboxDLC.status() ~= XboxDLC.IDLE then
				self:_check_licenses()
				self:_reinitialize_backend_dlc()
			end

			if not table.is_empty(self._popup_ids) then
				self:_handle_popups()
			else
				self:_update_console_backend_unlocks()
			end
		end
	elseif not IS_PS4 then
		if not self._update_unlocks then
			self:_check_ps4_dlc_status()

			if not table.is_empty(self._popup_ids) then
				self:_handle_popups()
			else
				self:_update_console_backend_unlocks()
			end
		end
	elseif not self._update_unlocks then
		if not table.is_empty(self._popup_ids) then
			self:_handle_popups()
		else
			self:_update_backend_unlocks(arg_4_2)
		end
	end
end

UnlockManager._handle_popups = function (self)
	-- function 5
	table.clear(tbl)

	for i, v in ipairs(self._popup_ids) do
		local query_result = Managers.popup:query_result(v)

		if not query_result then
			self:_handle_popup_results(query_result)

			tbl[#tbl + 1] = i
		end
	end

	if not table.is_empty(tbl) then
		for k = #tbl, 1, -1 do
			local var_5_1 = tbl[k]

			table.remove(self._popup_ids, var_5_1)
		end
	end
end

UnlockManager._handle_popup_results = function (arg_6_0, arg_6_1)
	-- function 6
	if arg_6_1 == "restart_game" then
		if not IS_WINDOWS then
			Managers.ui:restart_game()
		else
			Managers.account:force_exit_to_title_screen()
		end
	elseif arg_6_1 == "quit_game" then
		Boot.quit_game = true
	end
end

UnlockManager._check_ps4_dlc_status = function (self)
	-- function 7
	if self._state ~= "done" then
		return
	end

	if not PS4DLC.has_fetched_dlcs() then
		return
	end

	if not self._updating_ps4_entitlements then
		if not PS4.entitlements_dirty() then
			print("************************************************")
			print("*************** DETECTED NEW DLC ***************")
			print("************************************************")
			PS4DLC.fetch_owned_dlcs()

			self._updating_ps4_entitlements = true
		end
	else
		local get_interface = Managers.backend:get_interface("dlcs")

		if not get_interface:updating_dlc_ownership() then
			local get_owned_dlcs = get_interface:get_owned_dlcs()
			local get_platform_dlcs = get_interface:get_platform_dlcs()

			for i = 1, #get_platform_dlcs do
				local var_7_3 = get_platform_dlcs[i]

				if not table.find(get_owned_dlcs, var_7_3) then
					local var_7_4 = self._unlocks[var_7_3]

					if not var_7_4 and not var_7_4.update_license then
						var_7_4:update_license()
					end

					if not var_7_4 and not var_7_4:unlocked() then
						print("New DLC Unlocked: ", var_7_3)
						self:_reinitialize_backend_dlc()
					end
				end
			end

			self._updating_ps4_entitlements = false
		end
	end
end

UnlockManager._reinitialize_backend_dlc = function (self)
	-- function 8
	self._state = "query_unlocked"
	self._query_unlocked_index = 0
end

UnlockManager._check_licenses = function (self)
	-- function 9
	Application.warning("[UnlockManager] Checking DLC licenses")

	local str = ""
	local str_2 = ""
	local licensed_packages = XboxDLC.licensed_packages()

	for i, v in ipairs(licensed_packages) do
		if not table.find(self._licensed_packages, v) then
			local display_name = XboxDLC.display_name(v)

			display_name = display_name or " "

			local gsub = string.gsub(display_name, "%c", "")

			str = str .. gsub .. "\n"
			self._xbox_dlc_package_names[v] = gsub
		end
	end

	for i_2, v_2 in ipairs(self._licensed_packages) do
		if not table.find(licensed_packages, v_2) then
			local var_9_5 = self._xbox_dlc_package_names[v_2]

			var_9_5 = var_9_5 or " "
			str_2 = str_2 .. var_9_5 .. "\n"
		end
	end

	self._licensed_packages = licensed_packages

	for k, v_3 in pairs(self._unlocks) do
		if not v_3.update_license then
			v_3:update_license()
		end
	end

	local is_in_view_state = Managers.ui:is_in_view_state("HeroViewStateStore")

	if str ~= "" then
		if not Managers.state.event then
			Managers.state.event:trigger("event_dlc_status_changed")
		end

		if not is_in_view_state then
			self._popup_ids[#self._popup_ids + 1] = Managers.popup:queue_popup(str, Localize("new_dlc_installed"), "ok", Localize("button_ok"))
		end

		self._dlc_status_changed = true
	elseif str_2 ~= "" then
		if not Managers.state.event then
			Managers.state.event:trigger("event_dlc_status_changed")
		end

		self._popup_ids[#self._popup_ids + 1] = Managers.popup:queue_popup(str_2, Localize("dlc_license_terminated"), "ok", Localize("button_ok"))
		self._dlc_status_changed = true
	end
end

UnlockManager.dlc_status_changed = function (self)
	-- function 10
	return self._dlc_status_changed
end

UnlockManager._update_console_backend_unlocks = function (self)
	-- function 11
	if self._state == "query_unlocked" then
		local backend = Managers.backend

		if not backend:profiles_loaded() then
			if not backend:available() then
				self._state = "backend_not_available"

				return
			end

			if not backend:is_tutorial_backend() then
				return
			end

			if not self._unlocks_ready then
				local flag = true

				for k, v in pairs(self._unlocks) do
					if not v:ready() then
						flag = false

						break
					end
				end

				if not flag then
					self._unlocks_ready = true

					print("[UnlockManager] All unlocks ready")
				else
					return
				end
			end

			local num = self._query_unlocked_index + 1

			if num > #self._unlocks_indexed then
				self._state = "update_backend_dlcs"

				Managers.backend:get_interface("peddler"):refresh_chips()

				return
			end

			self._query_unlocked_index = num

			local interface = UnlockSettings[num].interface

			if not interface then
				local var_11_4 = self._unlocks_indexed[num]
				local get_interface = Managers.backend:get_interface(interface)

				for k_2, v_2 in pairs(var_11_4) do
					local backend_reward_id = v_2:backend_reward_id()
					local is_legacy_console_dlc = v_2:is_legacy_console_dlc()

					if not backend_reward_id and not is_legacy_console_dlc then
						if not v_2:has_error() then
							v_2:remove_backend_reward_id()
						else
							local reward_claimed = get_interface:reward_claimed(backend_reward_id)
							local unlocked = v_2:unlocked()

							if not (not unlocked and reward_claimed) then
								get_interface:claim_reward(backend_reward_id, callback(self, "cb_reward_claimed", v_2))
							elseif (unlocked or not reward_claimed) and not IS_PS4 then
								get_interface:remove_reward(backend_reward_id, callback(self, "cb_reward_removed", v_2))
							end
						end
					end
				end
			end
		end
	elseif self._state == "update_backend_dlcs" then
		local get_interface_2 = Managers.backend:get_interface("dlcs")

		if not get_interface_2:updating_dlc_ownership() then
			get_interface_2:update_dlc_ownership()

			self._state = "waiting_for_backend_dlc_update"
		end
	elseif self._state == "waiting_for_backend_dlc_update" then
		if not Managers.backend:get_interface("dlcs"):updating_dlc_ownership() then
			Managers.backend:get_interface("dlcs")._backend_mirror:request_characters()

			self._state = "waiting_for_backend_refresh"
		end
	elseif self._state == "waiting_for_backend_refresh" then
		if not Managers.backend:get_interface("dlcs")._backend_mirror:ready() then
			self._state = "check_unseen_rewards"
		end
	elseif self._state == "check_unseen_rewards" then
		if Managers.ui:is_in_view_state("HeroViewStateStore") == false then
			self:_handle_unseen_rewards()

			self._state = "wait_for_rewards"
		end
	elseif self._state == "wait_for_rewards" then
		if #self._reward_queue <= self._reward_queue_id then
			local get_hud_component = Managers.ui:get_hud_component("GiftPopupUI")

			if not (not get_hud_component and get_hud_component:has_presentation_data()) then
				self._state = "evaluate_restart"
			end
		end
	elseif self._state ~= "evaluate_restart" or not table.is_empty(self._popup_ids) then
		local flag_2 = false

		for k_3, v_3 in pairs(self._unlocks) do
			if not v_3:requires_restart() then
				flag_2 = true

				break
			end
		end

		if not flag_2 then
			self._popup_ids[#self._popup_ids + 1] = Managers.popup:queue_popup(Localize("popup_console_dlc_needs_restart"), Localize("popup_notice_topic"), "restart_game", Localize("menu_return_to_title_screen"))
		end

		self._state = "done"
	end
end

UnlockManager.cb_reward_claimed = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	if not arg_12_2 then
		arg_12_1:remove_backend_reward_id()
	elseif not arg_12_3 and not arg_12_4 then
		self:_add_reward(arg_12_3, arg_12_4)
	end
end

UnlockManager.cb_reward_removed = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	if not arg_13_2 then
		arg_13_1:remove_backend_reward_id()
	end
end

local tbl_2 = {
	ranged = 2,
	weapon_skin = 3,
	hat = 4,
	frame = 6,
	melee = 1,
	skin = 5,
	deed = 8,
	keep_decoration_painting = 7
}

UnlockManager._add_reward = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local item_rarity_order = UISettings.item_rarity_order

	table.sort(arg_14_1, function (self, arg_15_1)
		-- function 15
		local var_15_0 = item_rarity_order
		local rarity = self.rarity

		rarity = rarity or self.data.rarity

		local var_15_2 = var_15_0[rarity]

		var_15_2 = var_15_2 or -1

		local var_15_3 = item_rarity_order
		local rarity_2 = arg_15_1.rarity

		rarity_2 = rarity_2 or arg_15_1.data.rarity

		local var_15_5 = var_15_3[rarity_2]

		var_15_5 = var_15_5 or -1

		if var_15_2 ~= var_15_5 then
			return var_15_2 < var_15_5
		end

		local var_15_6 = tbl_2
		local slot_type = self.data.slot_type

		slot_type = slot_type or self.data.item_type

		local var_15_8 = var_15_6[slot_type]

		var_15_8 = var_15_8 or 99

		local var_15_9 = tbl_2
		local slot_type_2 = arg_15_1.data.slot_type

		slot_type_2 = slot_type_2 or arg_15_1.data.item_type

		local var_15_11 = var_15_9[slot_type_2]

		var_15_11 = var_15_11 or 99

		if var_15_8 ~= var_15_11 then
			return var_15_8 < var_15_11
		end
	end)

	local count = #arg_14_1
	local num = 45

	if num <= count then
		local ceil = math.ceil(count / num)

		for i = 1, ceil do
			local num_2 = (i - 1) * num + 1
			local slice = table.slice(arg_14_1, num_2, num)

			arg_14_0._reward_queue[#arg_14_0._reward_queue + 1] = {
				items = slice,
				presentation_text = arg_14_2
			}
		end
	else
		arg_14_0._reward_queue[#arg_14_0._reward_queue + 1] = {
			items = arg_14_1,
			presentation_text = arg_14_2
		}
	end
end

UnlockManager.poll_rewards = function (self)
	-- function 16
	if #self._reward_queue <= self._reward_queue_id then
		return
	end

	self._reward_queue_id = self._reward_queue_id + 1

	return self._reward_queue[self._reward_queue_id]
end

UnlockManager.get_unlocked_dlcs = function (self)
	-- function 17
	local _unlocks = self._unlocks
	local tbl = {}

	for k, v in pairs(_unlocks) do
		if not v:unlocked() then
			tbl[#tbl + 1] = k
		end
	end

	return tbl
end

UnlockManager.get_installed_dlcs = function (self)
	-- function 18
	local _unlocks = self._unlocks
	local tbl = {}

	for k, v in pairs(_unlocks) do
		if not v:installed() then
			tbl[#tbl + 1] = k
		end
	end

	return tbl
end

UnlockManager.get_dlcs = function (self)
	-- function 19
	return self._unlocks
end

UnlockManager.get_dlc = function (self, arg_20_1)
	-- function 20
	return self._unlocks[arg_20_1]
end

UnlockManager.dlc_requires_restart = function (self, arg_21_1)
	-- function 21
	return self._unlocks[arg_21_1]:requires_restart()
end

UnlockManager.is_dlc_unlocked = function (self, arg_22_1)
	-- function 22
	if not script_data.all_dlcs_unlocked then
		return true
	end

	local var_22_0 = self._unlocks[arg_22_1]

	if not (IS_WINDOWS or IS_LINUX or var_22_0) then
		return false
	end

	fassert(var_22_0, "No such unlock %q", arg_22_1 or "nil")

	if not DEDICATED_SERVER then
		return true
	end

	return not var_22_0 and var_22_0:unlocked()
end

UnlockManager.is_dlc_cosmetic = function (self, arg_23_1)
	-- function 23
	local var_23_0 = self._unlocks[arg_23_1]

	if not (IS_WINDOWS or IS_LINUX or var_23_0) then
		return true
	end

	fassert(var_23_0, "No such unlock %q", arg_23_1 or "nil")

	return not var_23_0 and var_23_0:is_cosmetic()
end

UnlockManager.dlc_exists = function (self, arg_24_1)
	-- function 24
	return self._unlocks[arg_24_1] ~= nil
end

UnlockManager.dlc_id = function (self, arg_25_1)
	-- function 25
	local var_25_0 = self._unlocks[arg_25_1]

	fassert(var_25_0, "No such unlock %q", arg_25_1 or "nil")

	return var_25_0:id()
end

UnlockManager.dlc_name_from_id = function (self, arg_26_1)
	-- function 26
	for k, v in pairs(self._unlocks) do
		if v:id() == arg_26_1 then
			return k
		end
	end
end

UnlockManager.open_dlc_page = function (arg_27_0, arg_27_1)
	-- function 27
	if not IS_WINDOWS and not HAS_STEAM then
		local var_27_0 = StoreDlcSettingsByName[arg_27_1]
		local flag = not var_27_0 and var_27_0.store_page_url

		if not flag then
			Steam.open_url(flag)
		end
	elseif not IS_XB1 then
		local id = UnlockSettings[1].unlocks[arg_27_1].id
		local user_id = Managers.account:user_id()

		XboxLive.show_product_details(user_id, id)
	elseif not IS_PS4 then
		local user_id_2 = Managers.account:user_id()
		local var_27_5 = ProductLabels[arg_27_1]

		Managers.system_dialog:open_commerce_dialog(NpCommerceDialog.MODE_PRODUCT, user_id_2, {
			var_27_5
		})
	end
end

UnlockManager.ps4_dlc_product_label = function (self, arg_28_1)
	-- function 28
	assert(IS_PS4, "Only call this function on a PS4")

	local var_28_0 = self._unlocks[arg_28_1]

	fassert(var_28_0, "No such unlock %q", arg_28_1 or "nil")

	return var_28_0:product_label()
end

UnlockManager.debug_add_console_dlc_reward = function (self, arg_29_1)
	-- function 29
	local var_29_0
	local var_29_1

	for i, v in ipairs(self._unlocks_indexed) do
		for k, v_2 in pairs(v) do
			local backend_reward_id = v_2:backend_reward_id()

			if not (not backend_reward_id and backend_reward_id ~= arg_29_1) then
				var_29_0 = v_2
				var_29_1 = i

				break
			end
		end
	end

	fassert(var_29_0, "No unlock with reward_id", arg_29_1)

	local interface = UnlockSettings[var_29_1].interface
	local get_interface = Managers.backend:get_interface(interface)

	local function fn(arg_30_0, arg_30_1, arg_30_2)
		-- function 30
		if not arg_30_0 then
			print("Failed adding reward")
		elseif not arg_30_1 and not arg_30_2 then
			print("Reward added")
			self:_add_reward(arg_30_1, arg_30_2)

			self._state = "query_unlocked"
		end
	end

	get_interface:claim_reward(arg_29_1, fn)

	self._state = "claiming_reward"
end

UnlockManager.debug_remove_console_dlc_reward = function (self, arg_31_1)
	-- function 31
	local var_31_0
	local var_31_1

	for i, v in ipairs(self._unlocks_indexed) do
		for k, v_2 in pairs(v) do
			local backend_reward_id = v_2:backend_reward_id()

			if not (not backend_reward_id and backend_reward_id ~= arg_31_1) then
				var_31_0 = v_2
				var_31_1 = i

				break
			end
		end
	end

	fassert(var_31_0, "No unlock with reward_id", arg_31_1)

	local interface = UnlockSettings[var_31_1].interface
	local get_interface = Managers.backend:get_interface(interface)

	local function fn(arg_32_0)
		-- function 32
		if not arg_32_0 then
			print("Failed removing reward")
		else
			print("Reward removed")

			self._state = "query_unlocked"
		end
	end

	get_interface:remove_reward(arg_31_1, fn)

	self._state = "removing_reward"
end

UnlockManager._update_backend_unlocks = function (self, arg_33_1)
	-- function 33
	if self._state == "handle_reminder_popup" then
		if not self._handled_reminders_popups then
			local new_dlcs_unlocks = SaveData.new_dlcs_unlocks

			new_dlcs_unlocks = new_dlcs_unlocks or {}

			for k, v in pairs(new_dlcs_unlocks) do
				local var_33_1 = CommonPopupSettings[k]

				if not var_33_1 then
					if not ((v or not var_33_1.display_on_every_boot) and var_33_1.popup_type ~= "reminder") then
						Managers.state.event:trigger("ui_show_popup", k, "reminder")
					else
						new_dlcs_unlocks[k] = false
					end
				else
					new_dlcs_unlocks[k] = false
				end
			end

			self._handled_reminders_popups = true
		elseif not self:_has_new_dlc() then
			self._state = "query_unlocked"
		end
	elseif self._state == "query_unlocked" then
		local backend = Managers.backend

		if not backend:interfaces_ready() then
			if not backend:available() then
				self._state = "backend_not_available"

				return
			end

			if not backend:is_tutorial_backend() then
				return
			end

			if not backend:is_benchmark_backend() then
				return
			end

			if not GameSettingsDevelopment.read_only_backend then
				return
			end

			if not self._unlocks_ready then
				local flag = true

				for k_2, v_2 in pairs(self._unlocks) do
					if not v_2:ready() then
						flag = false

						break
					end
				end

				if not flag then
					self._unlocks_ready = true

					print("[UnlockManager] All unlocks ready")
				else
					return
				end
			end

			if HAS_STEAM or not Development.parameter("use_lan_backend") then
				local get_interface = Managers.backend:get_interface("dlcs")
				local get_owned_dlcs = get_interface:get_owned_dlcs()
				local get_platform_dlcs = get_interface:get_platform_dlcs()
				local flag_2 = false
				local var_33_8

				for i4 = 1, #get_platform_dlcs do
					local var_33_9 = get_platform_dlcs[i4]

					if not self._excluded_dlcs[var_33_9] then
						local var_33_10 = self._unlocks[var_33_9]

						if not var_33_10 and not var_33_10.update_is_installed then
							local update_is_installed, var_33_12 = var_33_10:update_is_installed()

							if not var_33_12 then
								printf("INSTALLED: %q", var_33_9)

								flag_2 = true
							end
						end
					end
				end

				if not flag_2 then
					self._state = "update_backend_dlcs"

					return
				end

				local flag_3

				flag_3 = not flag_2 and "update_backend_dlcs" and "check_unseen_rewards"
				self._state = flag_3
			end
		end
	elseif self._state == "update_backend_dlcs" then
		local get_interface_2 = Managers.backend:get_interface("dlcs")

		if not get_interface_2:updating_dlc_ownership() then
			get_interface_2:update_dlc_ownership()

			self._state = "waiting_for_backend_dlc_update"
		end
	elseif self._state == "waiting_for_backend_dlc_update" then
		if not Managers.backend:get_interface("dlcs"):updating_dlc_ownership() then
			Managers.backend:get_interface("dlcs")._backend_mirror:request_characters()

			self._state = "waiting_for_backend_refresh"
		end
	elseif self._state == "waiting_for_backend_refresh" then
		if not Managers.backend:get_interface("dlcs")._backend_mirror:ready() then
			self._state = "check_unseen_rewards"
		end
	elseif self._state == "check_unseen_rewards" then
		if not Managers.ui:is_in_view_state("HeroViewStateStore") then
			self:_handle_unseen_rewards()

			self._state = "wait_for_rewards"
		end
	elseif self._state == "wait_for_rewards" then
		if #self._reward_queue <= self._reward_queue_id then
			local get_hud_component = Managers.ui:get_hud_component("GiftPopupUI")

			if not (not get_hud_component and get_hud_component:has_presentation_data()) then
				self._state = "evaluate_restart"
			end
		end
	elseif self._state ~= "evaluate_restart" or not table.is_empty(self._popup_ids) then
		local flag_4 = false

		for k_3, v_3 in pairs(self._unlocks) do
			if not v_3:requires_restart() then
				flag_4 = true

				if not v_3.set_status_changed then
					v_3:set_status_changed(false)
				end
			end
		end

		if not flag_4 then
			local str = "restart_game"
			local var_33_18 = Localize("menu_return_to_title_screen")

			if not IS_WINDOWS then
				str = "quit_game"
				var_33_18 = Localize("menu_quit")
			end

			self._popup_ids[#self._popup_ids + 1] = Managers.popup:queue_popup(Localize("popup_console_dlc_needs_restart"), Localize("popup_notice_topic"), str, var_33_18)
		end

		self._state = "query_unlocked"
	end
end

UnlockManager._handle_unseen_rewards = function (self)
	-- function 34
	local get_interface = Managers.backend:get_interface("items")
	local get_unseen_item_rewards = get_interface:get_unseen_item_rewards()

	if not get_unseen_item_rewards then
		return
	end

	local tbl = {}

	for i = 1, #get_unseen_item_rewards do
		local var_34_3 = get_unseen_item_rewards[i]
		local var_34_4

		if var_34_3.item_type == "weapon_skin" then
			local item_id = var_34_3.item_id
			local var_34_6 = WeaponSkins.skins[item_id]

			if not var_34_6 then
				local rarity = var_34_6.rarity

				rarity = rarity or "plentiful"
				var_34_4 = {
					skin = item_id,
					data = {
						item_type = "weapon_skin",
						slot_type = "weapon_skin",
						information_text = "information_weapon_skin",
						matching_item_key = var_34_6.item_type,
						can_wield = CanWieldAllItemTemplates,
						rarity = rarity
					}
				}
			end
		elseif var_34_3.reward_type == "weapon_pose" then
			var_34_4 = get_interface:get_item_from_key(var_34_3.item_id)
		elseif var_34_3.reward_type == "keep_decoration_painting" then
			local keep_decoration_name = var_34_3.keep_decoration_name
			local var_34_9 = Paintings[keep_decoration_name]
			local rarity_2 = var_34_3.rarity

			if not rarity_2 then
				rarity_2 = var_34_9.rarity
				rarity_2 = rarity_2 or "plentiful"
			end

			var_34_4 = {
				painting = keep_decoration_name,
				data = {
					slot_type = "keep_decoration_painting",
					information_text = "information_text_painting",
					item_type = "keep_decoration_painting",
					matching_item_key = "keep_decoration_painting",
					can_wield = CanWieldAllItemTemplates,
					rarity = rarity_2,
					display_name = var_34_9.display_name,
					description = var_34_9.description,
					inventory_icon = var_34_9.icon
				}
			}
		elseif not CosmeticUtils.is_cosmetic_item(var_34_3.reward_type) then
			local get_backend_id_from_cosmetic_item = get_interface:get_backend_id_from_cosmetic_item(var_34_3.item_id)

			var_34_4 = get_interface:get_item_from_id(get_backend_id_from_cosmetic_item)
		else
			var_34_4 = get_interface:get_item_from_id(var_34_3.backend_id)
		end

		if not var_34_4 then
			local rewarded_from = var_34_3.rewarded_from
			local find_by_key, var_34_14 = table.find_by_key(UISettings.dlc_order_data, "dlc", rewarded_from)
			local display_name

			if not var_34_14 then
				display_name = var_34_14.display_name

				if not display_name then
					-- Nothing
				end
			end

			display_name = "lb_unknown"

			::label_34_0::

			local var_34_16 = tbl[display_name]

			if not var_34_16 then
				var_34_16 = {}
				tbl[display_name] = var_34_16
			end

			var_34_16[#var_34_16 + 1] = var_34_4
		else
			table.dump(var_34_3, "reward", 3)
			Crashify.print_exception("UnlockManager", "An unseen reward is an unknown item")
		end
	end

	for i_2, v in ipairs(UISettings.dlc_order_data) do
		local display_name_2 = v.display_name
		local var_34_18 = tbl[display_name_2]

		if not var_34_18 then
			self:_add_reward(var_34_18, display_name_2)

			tbl[display_name_2] = nil
		end
	end

	for k, v_2 in pairs(tbl) do
		self:_add_reward(v_2, k)
	end
end

UnlockManager.set_excluded_dlcs = function (self, arg_35_1)
	-- function 35
	local _excluded_dlcs = self._excluded_dlcs

	table.clear(_excluded_dlcs)

	if not arg_35_1 then
		return
	end

	for i = 1, #arg_35_1 do
		_excluded_dlcs[arg_35_1[i]] = true
	end
end

UnlockManager._has_new_dlc = function (arg_36_0)
	-- function 36
	if not SaveData.new_dlcs_unlocks then
		for k, v in pairs(SaveData.new_dlcs_unlocks) do
			if v == true then
				return true
			end
		end
	end

	Managers.save:auto_save(SaveFileName, SaveData)

	return false
end

UnlockManager.is_waiting_for_gift_popup_ui = function (self)
	-- function 37
	return self._state == "wait_for_rewards"
end
