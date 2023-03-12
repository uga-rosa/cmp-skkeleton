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
function source:get_keyword_pattern()
  -- U+3041-U+3094 & U+30A1-U+30F4 & U+FF66-U+FF9F
  -- ひらがな & 全角カタカナ & 半角カタカナ
  return [=[\V\[ぁ-ゔァ-ヴｦ-ﾟ]]=]
end

---@param key string
---@param args? any[]
---@return unknown
local function request(key, args)
  args = vim.F.if_nil(args, {})
  return vim.fn["denops#request"]("skkeleton", key, args)
end

---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
  local candidates = request("getCandidates")
  local pre_edit = request("getPreEdit")
  local pre_edit_len = request("getPreEditLength")
  local cursor = params.context.cursor
  local items = {}

  local text_edit_range = {
    start = {
      line = cursor.line,
      character = cursor.character - pre_edit_len,
    },
    ["end"] = {
      line = cursor.line,
      character = cursor.character,
    },
  }

  for _, cand in ipairs(candidates) do
    local kana = cand[1]
    for _, word in ipairs(cand[2]) do
      local label = word:gsub(";.*$", "")
      table.insert(items, {
        label = label,
        filterText = pre_edit,
        textEdit = {
          range = text_edit_range,
          newText = label,
        },
        data = {
          skkeleton = true,
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
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:execute(completion_item, callback)
  request("completeCallback", { completion_item.data.kana, completion_item.data.word })
  callback(completion_item)
end

return source
