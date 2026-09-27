-- chunkname: @foundation/scripts/util/reportify.lua

local Reportify = Reportify

Reportify = Reportify or {}
Reportify = Reportify

Reportify.setup = function (self)
	-- function 1
	self.has_setup = true

	local content_revision = script_data.settings.content_revision

	content_revision = content_revision or ""
	self.content_revision = content_revision

	local build_identifier = Application.build_identifier()

	build_identifier = build_identifier or ""
	self.engine_revision = build_identifier
	self.project = "HON"
end

Reportify.get_data = function (self)
	-- function 2
	if not self.has_setup then
		self:setup()
	end

	local _get_location, var_2_1 = self:_get_location()
	local _get_player_info = self:_get_player_info()

	Application.console_send({
		type = "reportify",
		project = self.project,
		fields = {
			customfield_10031 = self.content_revision,
			customfield_10032 = self.engine_revision
		},
		custom = {
			level = self:_get_level(),
			position = _get_location,
			rotation = var_2_1,
			archetype = _get_player_info.class_name,
			wielded_slot = _get_player_info.wielded_slot,
			primary_slot = _get_player_info.primary_name,
			secondary_slot = _get_player_info.secondary_name
		}
	})
end

Reportify._get_level = function (arg_3_0)
	-- function 3
	if not Managers.state.game_mode then
		return ""
	end

	return Managers.state.game_mode:level_key() or ""
end

Reportify._get_location = function (self)
	-- function 4
	local _get_local_player = self:_get_local_player()

	if not (not _get_local_player and Managers.state.camera) then
		return ""
	end

	return tostring(Managers.state.camera:camera_position(_get_local_player.viewport_name)), tostring(Managers.state.camera:camera_rotation(_get_local_player.viewport_name))
end

Reportify._get_player_info = function (self)
	-- function 5
	local tbl = {
		wielded_slot = "",
		primary_name = "",
		class_name = "",
		secondary_name = ""
	}
	local _get_local_player = self:_get_local_player()

	if not _get_local_player then
		return tbl
	end

	local profile_index = _get_local_player:profile_index()
	local var_5_3 = SPProfiles[profile_index]

	if not var_5_3 then
		tbl.class_name = var_5_3.display_name
	end

	local has_extension = ScriptUnit.has_extension(_get_local_player.player_unit, "inventory_system")

	if not has_extension then
		local get_wielded_slot_name = has_extension:get_wielded_slot_name()

		get_wielded_slot_name = get_wielded_slot_name or ""
		tbl.wielded_slot = get_wielded_slot_name

		local get_item_name = has_extension:get_item_name("slot_melee")

		get_item_name = get_item_name or ""
		tbl.primary_name = get_item_name

		local get_item_name_2 = has_extension:get_item_name("slot_ranged")

		get_item_name_2 = get_item_name_2 or ""
		tbl.secondary_name = get_item_name_2
	end

	return tbl
end

Reportify._get_local_player = function (arg_6_0)
	-- function 6
	if not Managers.player then
		return false
	end

	if Managers.player:num_players() == 0 then
		return false
	end

	return Managers.player:local_player(1)
end
