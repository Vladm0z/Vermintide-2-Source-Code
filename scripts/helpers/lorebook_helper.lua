-- chunkname: @scripts/helpers/lorebook_helper.lua

local LoreBookHelper = LoreBookHelper

LoreBookHelper = LoreBookHelper or {}
LoreBookHelper = LoreBookHelper

local tbl = {}

LoreBookHelper.save_new_pages = function ()
	-- function 1
	local SaveData = SaveData
	local new_lorebook_ids = SaveData.new_lorebook_ids

	new_lorebook_ids = new_lorebook_ids or {}

	for k, v in pairs(tbl) do
		new_lorebook_ids[k] = true
	end

	SaveData.new_lorebook_ids = new_lorebook_ids

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

LoreBookHelper.mark_page_id_as_new = function (arg_2_0)
	-- function 2
	tbl[arg_2_0] = true
end

LoreBookHelper.unmark_page_id_as_new = function (arg_3_0)
	-- function 3
	local new_lorebook_ids = SaveData.new_lorebook_ids

	assert(new_lorebook_ids, "Requested to unmark lorebook page id %d without any save data.", arg_3_0)

	new_lorebook_ids[arg_3_0] = nil

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

LoreBookHelper.get_new_page_ids = function ()
	-- function 4
	return SaveData.new_lorebook_ids
end
