local UITableViewCell = game.UITableViewCell
local Util = game.Util
local HandCard = class("HandCard",UITableViewCell)


function HandCard:init()
    self._imgFace = Util:seekNodeByName(self,"imgFace","ccui.ImageView")
    self._imgBack = Util:seekNodeByName(self,"imgBack","ccui.ImageView")
end

function HandCard:setData(data)
    local cardValue = data.cardValue
    if cardValue == 255 then
        self._imgBack:setVisible(true)
    else
        self._imgBack:setVisible(false)
        self._imgFace:loadTexture("art/mahjong/faces/"..tostring(cardValue)..".png")
    end
end

return HandCard