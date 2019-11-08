local csbPath = "ui/csb/mengya/UIHelp.csb"
local super = game.UIBase
local Util = game.Util
local UITableView = game.UITableView
local UIManager = game.UIManager
local UIHelpLeftItem = require("app.ui.items.UIHelpLeftItem")

local UIHelp = class("UIHelp", super, function() return Util:loadCSBNode(csbPath) end)
 
function UIHelp:ctor()
    self._btnBack = Util:seekNodeByName(self,"btnBack","ccui.Button")
    Util:bindTouchEvent(self._btnBack,handler(self,self._onBtnBackClick))

    local node = Util:seekNodeByName(self,"scrollListLeft","ccui.ScrollView")
    self._scrollListLeft = UITableView.extend(node,UIHelpLeftItem,handler(self,self._onItemClick))
end

function UIHelp:_onItemClick(item,data)
    
end

function UIHelp:_onBtnBackClick()
    UIManager:getInstance():hide("UIHelp")
end

function UIHelp:getGradeLayerId()
    return game.UIConstant.UILAYER_LEVEL.BOTTOM
end

function UIHelp:isFullScreen()
    return true
end

function UIHelp:onShow()
    local datas = game.UIConstant.GAME_TYPES
    self._scrollListLeft:updateDatas(datas)
end

 
return UIHelp