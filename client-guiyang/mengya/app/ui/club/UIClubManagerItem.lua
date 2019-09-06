local Util = app.Util
local UITableViewCell = app.UITableViewCell
local UIClubManagerItem = class("UIClubManagerItem",UITableViewCell)
local UIManager = app.UIManager

function UIClubManagerItem:init()
    self._txtBmfTitle = Util:seekNodeByName(self,"txtBmfTitle","ccui.TextBMFont")
    self._txtIntroduce = Util:seekNodeByName(self,"txtIntroduce","ccui.Text")
    self._cbxOperate = Util:seekNodeByName(self,"cbxOperate","ccui.CheckBox")

end

-- 整体设置数据
function UIClubManagerItem:updateData(data)
    self._txtBmfTitle:setString(data.name)
end
 

return UIClubManagerItem