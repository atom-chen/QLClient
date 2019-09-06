--[[
闪屏界面, 进入游戏时显示, 渐隐之后进入下一个状态
--]]
local csbPath = app.UISplashCsb
local super = app.UIBase

local UISplash = class("UISplash", super, function () return app.Util:loadCSBNode(csbPath) end)

function UISplash:ctor()
end

function UISplash:needBlackMask()
	return false
end

function UISplash:isFullScreen()
    return true
end

-- 获取显示大层层级,需要修改默认层级的，覆盖这个函数
function UISplash:getGradeLayerLevel()
	return 2
end

function UISplash:onShow(...)
    self:playAnimation(csbPath,"splash",handler(self,self._enterUpdateState))
end

function UISplash:_enterUpdateState()
	app.GameFSM:getInstance():enterState("GameState_Update")
end

return UISplash