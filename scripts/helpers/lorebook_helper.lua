-- chunkname: @scripts/helpers/lorebook_helper.lua

LoreBookHelper = LoreBookHelper or {}

local var_0_0 = {}

function LoreBookHelper.save_new_pages()
	local var_1_0 = SaveData
	local var_1_1 = var_1_0.new_lorebook_ids or {}

	for iter_1_0, iter_1_1 in pairs(var_0_0) do
		var_1_1[iter_1_0] = true
	end

	var_1_0.new_lorebook_ids = var_1_1

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

function LoreBookHelper.mark_page_id_as_new(arg_2_0)
	var_0_0[arg_2_0] = true
end

function LoreBookHelper.unmark_page_id_as_new(arg_3_0)
	local var_3_0 = SaveData.new_lorebook_ids

	assert(var_3_0, "Requested to unmark lorebook page id %d without any save data.", arg_3_0)

	var_3_0[arg_3_0] = nil

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

function LoreBookHelper.get_new_page_ids()
	return SaveData.new_lorebook_ids
end
