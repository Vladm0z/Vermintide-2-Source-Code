-- chunkname: @scripts/managers/unlock/unlock_manager.lua

require("scripts/managers/unlock/unlock_clan")
require("scripts/managers/unlock/unlock_dlc")
require("scripts/managers/unlock/unlock_dlc_bundle")
require("scripts/managers/unlock/unlock_game")
require("scripts/managers/unlock/always_unlocked")
require("scripts/settings/unlock_settings")
require("scripts/ui/dlc_upsell/common_popup_settings")

UnlockManager = class(UnlockManager)

UnlockManager.init = function (arg_1_0)
	arg_1_0:_init_unlocks()

	if IS_WINDOWS then
		arg_1_0._state = "handle_reminder_popup"
	else
		arg_1_0._state = "query_unlocked"
	end

	arg_1_0._query_unlocked_index = 0
	arg_1_0._dlc_status_changed = nil
	arg_1_0._update_unlocks = false
	arg_1_0._popup_ids = {}
	arg_1_0._xbox_dlc_package_names = {}
	arg_1_0._excluded_dlcs = {}
	arg_1_0._handled_reminders_popups = false

	if IS_XB1 then
		arg_1_0._unlocks_ready = false
		arg_1_0._licensed_packages = XboxDLC.licensed_packages() or {}

		for iter_1_0, iter_1_1 in ipairs(arg_1_0._licensed_packages) do
			local var_1_0 = XboxDLC.display_name(iter_1_1) or " "
			local var_1_1 = string.gsub(var_1_0, "%c", "")

			arg_1_0._xbox_dlc_package_names[iter_1_1] = var_1_1
		end
	end

	arg_1_0._reward_queue = {}
	arg_1_0._reward_queue_id = 0
end

UnlockManager.enable_update_unlocks = function (arg_2_0, arg_2_1)
	arg_2_0._update_unlocks = arg_2_1
end

UnlockManager._init_unlocks = function (arg_3_0)
	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in ipairs(UnlockSettings) do
		var_3_1[iter_3_0] = {}

		for iter_3_2, iter_3_3 in pairs(iter_3_1.unlocks) do
			local var_3_2 = iter_3_3.class
			local var_3_3 = iter_3_3.id
			local var_3_4 = IS_PS4 and iter_3_3.fallback_id
			local var_3_5 = iter_3_3.backend_reward_id
			local var_3_6 = iter_3_3.always_unlocked_game_app_ids
			local var_3_7 = iter_3_3.requires_restart
			local var_3_8 = iter_3_3.cosmetic
			local var_3_9 = iter_3_3.is_legacy_console_dlc
			local var_3_10 = iter_3_3.bundle_contains
			local var_3_11 = rawget(_G, var_3_2):new(iter_3_2, var_3_3, var_3_5, var_3_6, var_3_8, var_3_4, var_3_7, var_3_9, var_3_10)

			var_3_0[iter_3_2] = var_3_11
			var_3_1[iter_3_0][iter_3_2] = var_3_11
		end
	end

	arg_3_0._unlocks = var_3_0
	arg_3_0._unlocks_indexed = var_3_1
end

local var_0_0 = {}

UnlockManager.update = function (arg_4_0, arg_4_1, arg_4_2)
	if IS_XB1 then
		if arg_4_0._update_unlocks then
			arg_4_0._dlc_status_changed = nil

			if XboxDLC.status() ~= XboxDLC.IDLE then
				arg_4_0:_check_licenses()
				arg_4_0:_reinitialize_backend_dlc()
			end

			if not table.is_empty(arg_4_0._popup_ids) then
				arg_4_0:_handle_popups()
			else
				arg_4_0:_update_console_backend_unlocks()
			end
		end
	elseif IS_PS4 then
		if arg_4_0._update_unlocks then
			arg_4_0:_check_ps4_dlc_status()

			if not table.is_empty(arg_4_0._popup_ids) then
				arg_4_0:_handle_popups()
			else
				arg_4_0:_update_console_backend_unlocks()
			end
		end
	elseif arg_4_0._update_unlocks then
		if not table.is_empty(arg_4_0._popup_ids) then
			arg_4_0:_handle_popups()
		else
			arg_4_0:_update_backend_unlocks(arg_4_2)
		end
	end
end

UnlockManager._handle_popups = function (arg_5_0)
	table.clear(var_0_0)

	for iter_5_0, iter_5_1 in ipairs(arg_5_0._popup_ids) do
		local var_5_0 = Managers.popup:query_result(iter_5_1)

		if var_5_0 then
			arg_5_0:_handle_popup_results(var_5_0)

			var_0_0[#var_0_0 + 1] = iter_5_0
		end
	end

	if not table.is_empty(var_0_0) then
		for iter_5_2 = #var_0_0, 1, -1 do
			local var_5_1 = var_0_0[iter_5_2]

			table.remove(arg_5_0._popup_ids, var_5_1)
		end
	end
end

UnlockManager._handle_popup_results = function (arg_6_0, arg_6_1)
	if arg_6_1 == "restart_game" then
		if IS_WINDOWS then
			Managers.ui:restart_game()
		else
			Managers.account:force_exit_to_title_screen()
		end
	elseif arg_6_1 == "quit_game" then
		Boot.quit_game = true
	end
end

UnlockManager._check_ps4_dlc_status = function (arg_7_0)
	if arg_7_0._state ~= "done" then
		return
	end

	if not PS4DLC.has_fetched_dlcs() then
		return
	end

	if not arg_7_0._updating_ps4_entitlements then
		if PS4.entitlements_dirty() then
			print("************************************************")
			print("*************** DETECTED NEW DLC ***************")
			print("************************************************")
			PS4DLC.fetch_owned_dlcs()

			arg_7_0._updating_ps4_entitlements = true
		end
	else
		local var_7_0 = Managers.backend:get_interface("dlcs")

		if not var_7_0:updating_dlc_ownership() then
			local var_7_1 = var_7_0:get_owned_dlcs()
			local var_7_2 = var_7_0:get_platform_dlcs()

			for iter_7_0 = 1, #var_7_2 do
				local var_7_3 = var_7_2[iter_7_0]

				if not table.find(var_7_1, var_7_3) then
					local var_7_4 = arg_7_0._unlocks[var_7_3]

					if var_7_4 and var_7_4.update_license then
						var_7_4:update_license()
					end

					if var_7_4 and var_7_4:unlocked() then
						print("New DLC Unlocked: ", var_7_3)
						arg_7_0:_reinitialize_backend_dlc()
					end
				end
			end

			arg_7_0._updating_ps4_entitlements = false
		end
	end
end

UnlockManager._reinitialize_backend_dlc = function (arg_8_0)
	arg_8_0._state = "query_unlocked"
	arg_8_0._query_unlocked_index = 0
end

UnlockManager._check_licenses = function (arg_9_0)
	Application.warning("[UnlockManager] Checking DLC licenses")

	local var_9_0 = ""
	local var_9_1 = ""
	local var_9_2 = XboxDLC.licensed_packages()

	for iter_9_0, iter_9_1 in ipairs(var_9_2) do
		if not table.find(arg_9_0._licensed_packages, iter_9_1) then
			local var_9_3 = XboxDLC.display_name(iter_9_1) or " "
			local var_9_4 = string.gsub(var_9_3, "%c", "")

			var_9_0 = var_9_0 .. var_9_4 .. "\n"
			arg_9_0._xbox_dlc_package_names[iter_9_1] = var_9_4
		end
	end

	for iter_9_2, iter_9_3 in ipairs(arg_9_0._licensed_packages) do
		if not table.find(var_9_2, iter_9_3) then
			local var_9_5 = arg_9_0._xbox_dlc_package_names[iter_9_3] or " "

			var_9_1 = var_9_1 .. var_9_5 .. "\n"
		end
	end

	arg_9_0._licensed_packages = var_9_2

	for iter_9_4, iter_9_5 in pairs(arg_9_0._unlocks) do
		if iter_9_5.update_license then
			iter_9_5:update_license()
		end
	end

	local var_9_6 = Managers.ui:is_in_view_state("HeroViewStateStore")

	if var_9_0 ~= "" then
		if Managers.state.event then
			Managers.state.event:trigger("event_dlc_status_changed")
		end

		if not var_9_6 then
			arg_9_0._popup_ids[#arg_9_0._popup_ids + 1] = Managers.popup:queue_popup(var_9_0, Localize("new_dlc_installed"), "ok", Localize("button_ok"))
		end

		arg_9_0._dlc_status_changed = true
	elseif var_9_1 ~= "" then
		if Managers.state.event then
			Managers.state.event:trigger("event_dlc_status_changed")
		end

		arg_9_0._popup_ids[#arg_9_0._popup_ids + 1] = Managers.popup:queue_popup(var_9_1, Localize("dlc_license_terminated"), "ok", Localize("button_ok"))
		arg_9_0._dlc_status_changed = true
	end
end

UnlockManager.dlc_status_changed = function (arg_10_0)
	return arg_10_0._dlc_status_changed
end

UnlockManager._update_console_backend_unlocks = function (arg_11_0)
	if arg_11_0._state == "query_unlocked" then
		local var_11_0 = Managers.backend

		if var_11_0:profiles_loaded() then
			if not var_11_0:available() then
				arg_11_0._state = "backend_not_available"

				return
			end

			if var_11_0:is_tutorial_backend() then
				return
			end

			if not arg_11_0._unlocks_ready then
				local var_11_1 = true

				for iter_11_0, iter_11_1 in pairs(arg_11_0._unlocks) do
					if not iter_11_1:ready() then
						var_11_1 = false

						break
					end
				end

				if var_11_1 then
					arg_11_0._unlocks_ready = true

					print("[UnlockManager] All unlocks ready")
				else
					return
				end
			end

			local var_11_2 = arg_11_0._query_unlocked_index + 1

			if var_11_2 > #arg_11_0._unlocks_indexed then
				arg_11_0._state = "update_backend_dlcs"

				Managers.backend:get_interface("peddler"):refresh_chips()

				return
			end

			arg_11_0._query_unlocked_index = var_11_2

			local var_11_3 = UnlockSettings[var_11_2].interface

			if var_11_3 then
				local var_11_4 = arg_11_0._unlocks_indexed[var_11_2]
				local var_11_5 = Managers.backend:get_interface(var_11_3)

				for iter_11_2, iter_11_3 in pairs(var_11_4) do
					local var_11_6 = iter_11_3:backend_reward_id()
					local var_11_7 = iter_11_3:is_legacy_console_dlc()

					if var_11_6 and var_11_7 then
						if iter_11_3:has_error() then
							iter_11_3:remove_backend_reward_id()
						else
							local var_11_8 = var_11_5:reward_claimed(var_11_6)
							local var_11_9 = iter_11_3:unlocked()

							if var_11_9 and not var_11_8 then
								var_11_5:claim_reward(var_11_6, callback(arg_11_0, "cb_reward_claimed", iter_11_3))
							elseif not var_11_9 and var_11_8 and IS_PS4 then
								var_11_5:remove_reward(var_11_6, callback(arg_11_0, "cb_reward_removed", iter_11_3))
							end
						end
					end
				end
			end
		end
	elseif arg_11_0._state == "update_backend_dlcs" then
		local var_11_10 = Managers.backend:get_interface("dlcs")

		if not var_11_10:updating_dlc_ownership() then
			var_11_10:update_dlc_ownership()

			arg_11_0._state = "waiting_for_backend_dlc_update"
		end
	elseif arg_11_0._state == "waiting_for_backend_dlc_update" then
		if not Managers.backend:get_interface("dlcs"):updating_dlc_ownership() then
			Managers.backend:get_interface("dlcs")._backend_mirror:request_characters()

			arg_11_0._state = "waiting_for_backend_refresh"
		end
	elseif arg_11_0._state == "waiting_for_backend_refresh" then
		if Managers.backend:get_interface("dlcs")._backend_mirror:ready() then
			arg_11_0._state = "check_unseen_rewards"
		end
	elseif arg_11_0._state == "check_unseen_rewards" then
		if Managers.ui:is_in_view_state("HeroViewStateStore") == false then
			arg_11_0:_handle_unseen_rewards()

			arg_11_0._state = "wait_for_rewards"
		end
	elseif arg_11_0._state == "wait_for_rewards" then
		if #arg_11_0._reward_queue <= arg_11_0._reward_queue_id then
			local var_11_11 = Managers.ui:get_hud_component("GiftPopupUI")

			if var_11_11 and not var_11_11:has_presentation_data() then
				arg_11_0._state = "evaluate_restart"
			end
		end
	elseif arg_11_0._state == "evaluate_restart" and table.is_empty(arg_11_0._popup_ids) then
		local var_11_12 = false

		for iter_11_4, iter_11_5 in pairs(arg_11_0._unlocks) do
			if iter_11_5:requires_restart() then
				var_11_12 = true

				break
			end
		end

		if var_11_12 then
			arg_11_0._popup_ids[#arg_11_0._popup_ids + 1] = Managers.popup:queue_popup(Localize("popup_console_dlc_needs_restart"), Localize("popup_notice_topic"), "restart_game", Localize("menu_return_to_title_screen"))
		end

		arg_11_0._state = "done"
	end
end

UnlockManager.cb_reward_claimed = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	if not arg_12_2 then
		arg_12_1:remove_backend_reward_id()
	elseif arg_12_3 and arg_12_4 then
		arg_12_0:_add_reward(arg_12_3, arg_12_4)
	end
end

UnlockManager.cb_reward_removed = function (arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_2 then
		arg_13_1:remove_backend_reward_id()
	end
end

local var_0_1 = {
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
	local var_14_0 = UISettings.item_rarity_order

	table.sort(arg_14_1, function (arg_15_0, arg_15_1)
		local var_15_0 = var_14_0[arg_15_0.rarity or arg_15_0.data.rarity] or -1
		local var_15_1 = var_14_0[arg_15_1.rarity or arg_15_1.data.rarity] or -1

		if var_15_0 ~= var_15_1 then
			return var_15_0 < var_15_1
		end

		local var_15_2 = var_0_1[arg_15_0.data.slot_type or arg_15_0.data.item_type] or 99
		local var_15_3 = var_0_1[arg_15_1.data.slot_type or arg_15_1.data.item_type] or 99

		if var_15_2 ~= var_15_3 then
			return var_15_2 < var_15_3
		end
	end)

	local var_14_1 = #arg_14_1
	local var_14_2 = 45

	if var_14_2 <= var_14_1 then
		local var_14_3 = math.ceil(var_14_1 / var_14_2)

		for iter_14_0 = 1, var_14_3 do
			local var_14_4 = (iter_14_0 - 1) * var_14_2 + 1
			local var_14_5 = table.slice(arg_14_1, var_14_4, var_14_2)

			arg_14_0._reward_queue[#arg_14_0._reward_queue + 1] = {
				items = var_14_5,
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

UnlockManager.poll_rewards = function (arg_16_0)
	if #arg_16_0._reward_queue <= arg_16_0._reward_queue_id then
		return
	end

	arg_16_0._reward_queue_id = arg_16_0._reward_queue_id + 1

	return arg_16_0._reward_queue[arg_16_0._reward_queue_id]
end

UnlockManager.get_unlocked_dlcs = function (arg_17_0)
	local var_17_0 = arg_17_0._unlocks
	local var_17_1 = {}

	for iter_17_0, iter_17_1 in pairs(var_17_0) do
		if iter_17_1:unlocked() then
			var_17_1[#var_17_1 + 1] = iter_17_0
		end
	end

	return var_17_1
end

UnlockManager.get_installed_dlcs = function (arg_18_0)
	local var_18_0 = arg_18_0._unlocks
	local var_18_1 = {}

	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		if iter_18_1:installed() then
			var_18_1[#var_18_1 + 1] = iter_18_0
		end
	end

	return var_18_1
end

UnlockManager.get_dlcs = function (arg_19_0)
	return arg_19_0._unlocks
end

UnlockManager.get_dlc = function (arg_20_0, arg_20_1)
	return arg_20_0._unlocks[arg_20_1]
end

UnlockManager.dlc_requires_restart = function (arg_21_0, arg_21_1)
	return arg_21_0._unlocks[arg_21_1]:requires_restart()
end

UnlockManager.is_dlc_unlocked = function (arg_22_0, arg_22_1)
	if script_data.all_dlcs_unlocked then
		return true
	end

	local var_22_0 = arg_22_0._unlocks[arg_22_1]

	if not IS_WINDOWS and not IS_LINUX and not var_22_0 then
		return false
	end

	fassert(var_22_0, "No such unlock %q", arg_22_1 or "nil")

	if DEDICATED_SERVER then
		return true
	end

	return var_22_0 and var_22_0:unlocked()
end

UnlockManager.is_dlc_cosmetic = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._unlocks[arg_23_1]

	if not IS_WINDOWS and not IS_LINUX and not var_23_0 then
		return true
	end

	fassert(var_23_0, "No such unlock %q", arg_23_1 or "nil")

	return var_23_0 and var_23_0:is_cosmetic()
end

UnlockManager.dlc_exists = function (arg_24_0, arg_24_1)
	return arg_24_0._unlocks[arg_24_1] ~= nil
end

UnlockManager.dlc_id = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._unlocks[arg_25_1]

	fassert(var_25_0, "No such unlock %q", arg_25_1 or "nil")

	return var_25_0:id()
end

UnlockManager.dlc_name_from_id = function (arg_26_0, arg_26_1)
	for iter_26_0, iter_26_1 in pairs(arg_26_0._unlocks) do
		if iter_26_1:id() == arg_26_1 then
			return iter_26_0
		end
	end
end

UnlockManager.open_dlc_page = function (arg_27_0, arg_27_1)
	if IS_WINDOWS and HAS_STEAM then
		local var_27_0 = StoreDlcSettingsByName[arg_27_1]
		local var_27_1 = var_27_0 and var_27_0.store_page_url

		if var_27_1 then
			Steam.open_url(var_27_1)
		end
	elseif IS_XB1 then
		local var_27_2 = UnlockSettings[1].unlocks[arg_27_1].id
		local var_27_3 = Managers.account:user_id()

		XboxLive.show_product_details(var_27_3, var_27_2)
	elseif IS_PS4 then
		local var_27_4 = Managers.account:user_id()
		local var_27_5 = ProductLabels[arg_27_1]

		Managers.system_dialog:open_commerce_dialog(NpCommerceDialog.MODE_PRODUCT, var_27_4, {
			var_27_5
		})
	end
end

UnlockManager.ps4_dlc_product_label = function (arg_28_0, arg_28_1)
	assert(IS_PS4, "Only call this function on a PS4")

	local var_28_0 = arg_28_0._unlocks[arg_28_1]

	fassert(var_28_0, "No such unlock %q", arg_28_1 or "nil")

	return var_28_0:product_label()
end

UnlockManager.debug_add_console_dlc_reward = function (arg_29_0, arg_29_1)
	local var_29_0
	local var_29_1

	for iter_29_0, iter_29_1 in ipairs(arg_29_0._unlocks_indexed) do
		for iter_29_2, iter_29_3 in pairs(iter_29_1) do
			local var_29_2 = iter_29_3:backend_reward_id()

			if var_29_2 and var_29_2 == arg_29_1 then
				var_29_0 = iter_29_3
				var_29_1 = iter_29_0

				break
			end
		end
	end

	fassert(var_29_0, "No unlock with reward_id", arg_29_1)

	local var_29_3 = UnlockSettings[var_29_1].interface
	local var_29_4 = Managers.backend:get_interface(var_29_3)

	local function var_29_5(arg_30_0, arg_30_1, arg_30_2)
		if not arg_30_0 then
			print("Failed adding reward")
		elseif arg_30_1 and arg_30_2 then
			print("Reward added")
			arg_29_0:_add_reward(arg_30_1, arg_30_2)

			arg_29_0._state = "query_unlocked"
		end
	end

	var_29_4:claim_reward(arg_29_1, var_29_5)

	arg_29_0._state = "claiming_reward"
end

UnlockManager.debug_remove_console_dlc_reward = function (arg_31_0, arg_31_1)
	local var_31_0
	local var_31_1

	for iter_31_0, iter_31_1 in ipairs(arg_31_0._unlocks_indexed) do
		for iter_31_2, iter_31_3 in pairs(iter_31_1) do
			local var_31_2 = iter_31_3:backend_reward_id()

			if var_31_2 and var_31_2 == arg_31_1 then
				var_31_0 = iter_31_3
				var_31_1 = iter_31_0

				break
			end
		end
	end

	fassert(var_31_0, "No unlock with reward_id", arg_31_1)

	local var_31_3 = UnlockSettings[var_31_1].interface
	local var_31_4 = Managers.backend:get_interface(var_31_3)

	local function var_31_5(arg_32_0)
		if not arg_32_0 then
			print("Failed removing reward")
		else
			print("Reward removed")

			arg_31_0._state = "query_unlocked"
		end
	end

	var_31_4:remove_reward(arg_31_1, var_31_5)

	arg_31_0._state = "removing_reward"
end

UnlockManager._update_backend_unlocks = function (arg_33_0, arg_33_1)
	if arg_33_0._state == "handle_reminder_popup" then
		if not arg_33_0._handled_reminders_popups then
			local var_33_0 = SaveData.new_dlcs_unlocks or {}

			for iter_33_0, iter_33_1 in pairs(var_33_0) do
				local var_33_1 = CommonPopupSettings[iter_33_0]

				if var_33_1 then
					if (iter_33_1 or var_33_1.display_on_every_boot) and var_33_1.popup_type == "reminder" then
						Managers.state.event:trigger("ui_show_popup", iter_33_0, "reminder")
					else
						var_33_0[iter_33_0] = false
					end
				else
					var_33_0[iter_33_0] = false
				end
			end

			arg_33_0._handled_reminders_popups = true
		elseif not arg_33_0:_has_new_dlc() then
			arg_33_0._state = "query_unlocked"
		end
	elseif arg_33_0._state == "query_unlocked" then
		local var_33_2 = Managers.backend

		if var_33_2:interfaces_ready() then
			if not var_33_2:available() then
				arg_33_0._state = "backend_not_available"

				return
			end

			if var_33_2:is_tutorial_backend() then
				return
			end

			if var_33_2:is_benchmark_backend() then
				return
			end

			if script_data["eac-untrusted"] then
				return
			end

			if not arg_33_0._unlocks_ready then
				local var_33_3 = true

				for iter_33_2, iter_33_3 in pairs(arg_33_0._unlocks) do
					if not iter_33_3:ready() then
						var_33_3 = false

						break
					end
				end

				if var_33_3 then
					arg_33_0._unlocks_ready = true

					print("[UnlockManager] All unlocks ready")
				else
					return
				end
			end

			if HAS_STEAM or Development.parameter("use_lan_backend") then
				local var_33_4 = Managers.backend:get_interface("dlcs")
				local var_33_5 = var_33_4:get_owned_dlcs()
				local var_33_6 = var_33_4:get_platform_dlcs()
				local var_33_7 = false
				local var_33_8

				for iter_33_4 = 1, #var_33_6 do
					local var_33_9 = var_33_6[iter_33_4]

					if not arg_33_0._excluded_dlcs[var_33_9] then
						local var_33_10 = arg_33_0._unlocks[var_33_9]

						if var_33_10 and var_33_10.update_is_installed then
							local var_33_11, var_33_12 = var_33_10:update_is_installed()

							if var_33_12 then
								printf("INSTALLED: %q", var_33_9)

								var_33_7 = true
							end
						end
					end
				end

				if var_33_7 then
					arg_33_0._state = "update_backend_dlcs"

					return
				end

				arg_33_0._state = var_33_7 and "update_backend_dlcs" or "check_unseen_rewards"
			end
		end
	elseif arg_33_0._state == "update_backend_dlcs" then
		local var_33_13 = Managers.backend:get_interface("dlcs")

		if not var_33_13:updating_dlc_ownership() then
			var_33_13:update_dlc_ownership()

			arg_33_0._state = "waiting_for_backend_dlc_update"
		end
	elseif arg_33_0._state == "waiting_for_backend_dlc_update" then
		if not Managers.backend:get_interface("dlcs"):updating_dlc_ownership() then
			Managers.backend:get_interface("dlcs")._backend_mirror:request_characters()

			arg_33_0._state = "waiting_for_backend_refresh"
		end
	elseif arg_33_0._state == "waiting_for_backend_refresh" then
		if Managers.backend:get_interface("dlcs")._backend_mirror:ready() then
			arg_33_0._state = "check_unseen_rewards"
		end
	elseif arg_33_0._state == "check_unseen_rewards" then
		if not Managers.ui:is_in_view_state("HeroViewStateStore") then
			arg_33_0:_handle_unseen_rewards()

			arg_33_0._state = "wait_for_rewards"
		end
	elseif arg_33_0._state == "wait_for_rewards" then
		if #arg_33_0._reward_queue <= arg_33_0._reward_queue_id then
			local var_33_14 = Managers.ui:get_hud_component("GiftPopupUI")

			if var_33_14 and not var_33_14:has_presentation_data() then
				arg_33_0._state = "evaluate_restart"
			end
		end
	elseif arg_33_0._state == "evaluate_restart" and table.is_empty(arg_33_0._popup_ids) then
		local var_33_15 = false

		for iter_33_5, iter_33_6 in pairs(arg_33_0._unlocks) do
			if iter_33_6:requires_restart() then
				var_33_15 = true

				if iter_33_6.set_status_changed then
					iter_33_6:set_status_changed(false)
				end
			end
		end

		if var_33_15 then
			local var_33_16 = "restart_game"
			local var_33_17 = Localize("menu_return_to_title_screen")

			if IS_WINDOWS then
				var_33_16 = "quit_game"
				var_33_17 = Localize("menu_quit")
			end

			arg_33_0._popup_ids[#arg_33_0._popup_ids + 1] = Managers.popup:queue_popup(Localize("popup_console_dlc_needs_restart"), Localize("popup_notice_topic"), var_33_16, var_33_17)
		end

		arg_33_0._state = "query_unlocked"
	end
end

UnlockManager._handle_unseen_rewards = function (arg_34_0)
	local var_34_0 = Managers.backend:get_interface("items")
	local var_34_1 = var_34_0:get_unseen_item_rewards()

	if not var_34_1 then
		return
	end

	local var_34_2 = {}

	for iter_34_0 = 1, #var_34_1 do
		local var_34_3 = var_34_1[iter_34_0]
		local var_34_4

		if var_34_3.item_type == "weapon_skin" then
			local var_34_5 = var_34_3.item_id
			local var_34_6 = WeaponSkins.skins[var_34_5]
			local var_34_7 = var_34_6.rarity or "plentiful"

			var_34_4 = {
				skin = var_34_5,
				data = {
					item_type = "weapon_skin",
					slot_type = "weapon_skin",
					information_text = "information_weapon_skin",
					matching_item_key = var_34_6.item_type,
					can_wield = CanWieldAllItemTemplates,
					rarity = var_34_7
				}
			}
		elseif var_34_3.reward_type == "weapon_pose" then
			var_34_4 = var_34_0:get_item_from_key(var_34_3.item_id)
		elseif var_34_3.reward_type == "keep_decoration_painting" then
			local var_34_8 = var_34_3.keep_decoration_name
			local var_34_9 = Paintings[var_34_8]
			local var_34_10 = var_34_3.rarity or var_34_9.rarity or "plentiful"

			var_34_4 = {
				painting = var_34_8,
				data = {
					slot_type = "keep_decoration_painting",
					information_text = "information_text_painting",
					item_type = "keep_decoration_painting",
					matching_item_key = "keep_decoration_painting",
					can_wield = CanWieldAllItemTemplates,
					rarity = var_34_10,
					display_name = var_34_9.display_name,
					description = var_34_9.description,
					inventory_icon = var_34_9.icon
				}
			}
		elseif CosmeticUtils.is_cosmetic_item(var_34_3.reward_type) then
			local var_34_11 = var_34_0:get_backend_id_from_cosmetic_item(var_34_3.item_id)

			var_34_4 = var_34_0:get_item_from_id(var_34_11)
		else
			var_34_4 = var_34_0:get_item_from_id(var_34_3.backend_id)
		end

		if var_34_4 then
			local var_34_12 = var_34_3.rewarded_from
			local var_34_13, var_34_14 = table.find_by_key(UISettings.dlc_order_data, "dlc", var_34_12)
			local var_34_15 = var_34_14 and var_34_14.display_name or "lb_unknown"
			local var_34_16 = var_34_2[var_34_15]

			if not var_34_16 then
				var_34_16 = {}
				var_34_2[var_34_15] = var_34_16
			end

			var_34_16[#var_34_16 + 1] = var_34_4
		else
			table.dump(var_34_3, "reward", 3)
			Crashify.print_exception("UnlockManager", "An unseen reward is an unknown item")
		end
	end

	for iter_34_1, iter_34_2 in ipairs(UISettings.dlc_order_data) do
		local var_34_17 = iter_34_2.display_name
		local var_34_18 = var_34_2[var_34_17]

		if var_34_18 then
			arg_34_0:_add_reward(var_34_18, var_34_17)

			var_34_2[var_34_17] = nil
		end
	end

	for iter_34_3, iter_34_4 in pairs(var_34_2) do
		arg_34_0:_add_reward(iter_34_4, iter_34_3)
	end
end

UnlockManager.set_excluded_dlcs = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._excluded_dlcs

	table.clear(var_35_0)

	if not arg_35_1 then
		return
	end

	for iter_35_0 = 1, #arg_35_1 do
		var_35_0[arg_35_1[iter_35_0]] = true
	end
end

UnlockManager._has_new_dlc = function (arg_36_0)
	if SaveData.new_dlcs_unlocks then
		for iter_36_0, iter_36_1 in pairs(SaveData.new_dlcs_unlocks) do
			if iter_36_1 == true then
				return true
			end
		end
	end

	Managers.save:auto_save(SaveFileName, SaveData)

	return false
end

UnlockManager.is_waiting_for_gift_popup_ui = function (arg_37_0)
	return arg_37_0._state == "wait_for_rewards"
end
