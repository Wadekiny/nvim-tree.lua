local M = {}

local config = {
  threshold = vim.log.levels.INFO,
}

local modes = {
  { name = "trace", level = vim.log.levels.TRACE },
  { name = "debug", level = vim.log.levels.DEBUG },
  { name = "info", level = vim.log.levels.INFO },
  { name = "warn", level = vim.log.levels.WARN },
  { name = "error", level = vim.log.levels.ERROR },
}

do
  local has_notify, notify_plugin = pcall(require, "notify")

  local dispatch = function(level, msg)
    if level < config.threshold  or level == 3 then -- 进入没被git track的文件夹会冒出来一堆弹窗，忽略
      return
    end

    vim.schedule(function()
      if has_notify and notify_plugin then
        notify_plugin(msg, level, { title = "NvimTree" })
    --    print('nvim-tree, err_level:', level)
      else
        vim.notify("[NvimTree] " .. msg, level)
      end
    end)
  end

  for _, x in ipairs(modes) do
    M[x.name] = function(msg, ...)
      return dispatch(x.level, msg, ...)
    end
  end
end

function M.setup(opts)
  opts = opts or {}
  config.threshold = opts.notify.threshold or vim.log.levels.INFO
end

return M
