local base = require("logic.framework.ui.uibase.ui_childwindow")
local Tab_a = class("Tab_a",base)
function Tab_a:ctor()
	base.ctor(self)
end

function Tab_a:OnInit()
	base.OnInit(self)
end

function Tab_a:OnOpen()
	base.OnOpen(self)
	log("Tab_a OnOpen")
end

function Tab_a:OnClose()
	base.OnClose(self)
	log("Tab_a OnClose")
end

return Tab_a