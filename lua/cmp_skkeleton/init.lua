local source = {}
source.__index = source

function source.new()
    return setmetatable({}, source)
end

---@return boolean
function source:is_available()
    return vim.fn["skkeleton#is_enabled"]()
end

---@return string
function source:get_debug_name()
    return "skkeleton"
end

---@return string
local function get_marker()
    local skkeleton_config = vim.fn["skkeleton#get_config"]()
    return skkeleton_config.markerHenkan
end

---@return string
function source:get_keyword_pattern()
    return get_marker() .. [[.\+]]
end

---@param key string
---@param args? any[]
---@return unknown
local function request(key, args)
    args = vim.F.if_nil(args, {})
    return vim.fn["denops#request"]("skkeleton", key, args)
end

---@param _ cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(_, callback)
    local candidates = request("getCandidates")
    local items = {}
    local marker = get_marker()
    for _, cand in ipairs(candidates) do
        local kana = cand[1]
        for _, word in ipairs(cand[2]) do
            table.insert(items, {
                label = word:gsub(";.*$", ""),
                filterText = marker .. kana,
                data = {
                    kana = kana,
                    word = word,
                },
            })
        end
    end
    callback({ items = items, isIncomplete = true })
end

---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:resolve(completion_item, callback)
    local word = completion_item.data.word
    if word:find(";") then
        local documentation = word:match(";%s*(.*)$")
        completion_item.documentation = documentation
    end
    callback(completion_item)
end

---@param completion_item lsp.CompletionItem
---@param _ fun(completion_item: lsp.CompletionItem|nil)
function source:execute(completion_item, _)
    request("completeCallback", { completion_item.data.kana, completion_item.data.word })
end

return source
