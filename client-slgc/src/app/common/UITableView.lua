--extern Layout
local UITableView = class("UITableView")

function UITableView.extend(self, cellTemplate,clickFunc)
    local t = tolua.getpeer(self)
    if not t then
        t = {}
        tolua.setpeer(self, t)
    end
    setmetatable(t, UITableView)
    self:initWithCellTemplate(cellTemplate,clickFunc)
    assert(self:getDescription() == "ScrollView","must be scrollView")

    return self
end

function UITableView:initWithCellTemplate(cellTemplate,clickFunc)
    self._cellTemplate = cellTemplate
    self._clickFunc = clickFunc
    local children = self:getChildren()
    self._cellNode = children[1]
    self._cellSize = self._cellNode:getContentSize()
    self._cellNode:setVisible(false)
    self._tableViewSize = self:getContentSize()
    self._cellNodeAnchor = self._cellNode:getAnchorPoint()
    self._container = self:getInnerContainer()
    self:setScrollBarEnabled(false)

    --间隔默认0个像素
    self:setDeltUnit(0)
    --默认竖直滑动
    self:setVirtical(self:getDirection() == ccui.ScrollViewDir.vertical)
    --元素的排列是否翻转  例如:水平方向的列表  1,2,3,4 翻转=>4,3,2,1
    self:setRevertOrder(false)
    --设置元素是否循环
    self:setLoop(false)

    self._datas = {}
    self._usedCell = {}

    self._currentSelectedIdx = nil
    self:addEventListener(function(sender, eventType)
        if eventType ==  ccui.ScrollviewEventType.containerMoved then
            self:update()
        elseif eventType == ccui.ScrollviewEventType.autoscrollEnded then
            if self._scrollItemToCenter then
                self:scrollItemToCenter()
            end
        end
    end)
end

function UITableView:moveToContainerByVector(vector)
    local containerPos = cc.p(self._container:getPosition())
    self._container:setPosition(cc.pAdd(containerPos,vector))
    self:update()
end

function UITableView:getCellSize()
    return self._cellSize
end

function UITableView:setScrollItemToCenterView(toCenter)
    self._scrollItemToCenter = toCenter
end

function UITableView:setLoop(loop)
    self._loop = loop
end

function UITableView:setRevertOrder(revert)
    self._revert = revert
end

function UITableView:getRevertOrder(revert)
    return self._revert
end

--设置列表元素间隔
function UITableView:setDeltUnit(deltUnit)
    self._deltUnit = deltUnit
end

--设置滑动方向
function UITableView:setVirtical(isVirtical)
    self._isVertical = isVirtical
end

function UITableView:getVirtical(isVirtical)
    return self._isVertical
end

function UITableView:updateContentSize()
    self._tableViewSize = self:getContentSize()
    self:clear()
    self:updateDatas(self._datas)
end

--单纯刷新数据,刷新完数据后容器仍在原来的位置
function UITableView:refreshDatas(datas)
    if #self._datas == #datas then
        self._datas = clone(datas)
        for idx, cell in pairs(self._usedCell) do
            cell:setData(self:getDataByIndex(idx))
        end
    else
        local pos = cc.p(self._container:getPosition())
        self:updateDatas(datas)
        self._container:setPosition(pos)
        self:update()
    end
    
end

function UITableView:updateDatas(datas)
    self:clear()
    local datas = clone(datas)
    self._datas = datas
    if self._revert then
        self._datas = {}
        for i = #datas, 1,-1 do
            table.insert(self._datas,datas[i])
        end
    end
    --伪循环
    local loopNum = 100
    if self._loop then
        self._datas = {}
        for i = 1, loopNum do
            for i, data in ipairs(datas) do
                table.insert(self._datas,data)
            end
        end
    end

    local num = #self._datas
    local size = clone(self._tableViewSize)
    if self._isVertical then
        size.height = num * self._cellSize.height + (num - 1) * self._deltUnit
    else
        size.width = num * self._cellSize.width + (num - 1) * self._deltUnit
    end
    self:setInnerContainerSize(size)
    if self._isVertical then
        self:jumpToPercentVertical(0)
    else
        self:jumpToPercentHorizontal(0)
    end
    if self._loop then
        if self._isVertical then
            local posX = self._container:getPositionX()
            self._container:setPosition(cc.p(posX,-size.height/2 + self._tableViewSize.height))
        else
            local posY = self._container:getPositionY()
            self._container:setPosition(cc.p(-size.width/2 - self._tableViewSize.width/2,posY))
        end
    elseif self._revert then
        if self._isVertical then
            self:jumpToBottom()
        else
            self:jumpToRight()
        end
    end

    self:checkAddCell()
    if self._clickFunc then
        self:setCurrentSelectIndex(1)
    end
end

function UITableView:update(dt)
    if #self._datas <= 0 then
        return
    end
    local containPos = cc.p(self._container:getPosition())
    if not self._containerPos then
        self._containerPos = containPos
        return
    end
    if cc.pGetDistance(self._containerPos,containPos) == 0 then
        return
    end

    self:checkRemoveCell()
    self:checkAddCell()
end

function UITableView:revertZOrder(enable)
    self._enableRevertZOrder = enable
end

function UITableView:enabledZOrder(enable)
    self._enableZOrder = enable
end

function UITableView:dequeueCell(idx)
    if not self._queue then
        self._queue = {}
    end
    local cell
    if #self._queue > 0 then
        cell = table.remove(self._queue)
    else
        cell = self._cellTemplate:extend(self._cellNode:clone(),self)
        self._container:addChild(cell)
    end
    cell:setVisible(true)
    local data = self:getDataByIndex(idx)
    cell:setIdx(idx)
    cell:setData(data)
    if self._enableZOrder then
        cell:setLocalZOrder(idx)
    elseif self._enableRevertZOrder then
        cell:setLocalZOrder(-1 * idx)
    end
    self._usedCell[idx] = cell

    if self._clickFunc then
        cell:setTouchEnabled(true)
        cell:addTouchEventListener(function(cell, eventType)
            if eventType == ccui.TouchEventType.ended then
                local selectIdx = cell:getIdx()
                self:setCurrentSelectIndex(selectIdx)
                local data = cell:getData()
                self._clickFunc(cell,data)
            end
        end)
        cell:setSelectState(idx == self._currentSelectedIdx)
    end

    return cell
end

function UITableView:setCurrentSelectIndex(selectIdx)
    if self._currentSelectedIdx == selectIdx then
        return
    end
    self._currentSelectedIdx = selectIdx
    for idx, ucell in pairs(self._usedCell) do
        ucell:setSelectState(idx == self._currentSelectedIdx)
    end
end

function UITableView:getCurrentSelectIndex()
    return self._currentSelectedIdx
end

function UITableView:getCellByIndex(idx)
    return self._usedCell[idx]
end

function UITableView:getUsedCell()
    return self._usedCell
end

function UITableView:pushQueue(cell)
    cell:setPosition(cc.p(-10000000,-10000000))
    cell:setVisible(false)
    table.insert(self._queue,cell)
end

function UITableView:getDataByIndex(idx)
    return self._datas[idx]
end

function UITableView:getDatas()
    return clone(self._datas)
end

function UITableView:getCellPosByIndex(idx)
    local size = self:getInnerContainerSize()
    local posX,posY = self._cellNode:getPosition()
    if self._isVertical then
        local distance = idx * self._cellSize.height + (idx - 1)*self._deltUnit
        posY = size.height - distance + self._cellNodeAnchor.y * self._cellSize.height
    else
        posX = idx * self._cellSize.width + (idx - 1) * self._deltUnit - (1 - self._cellNodeAnchor.x) * self._cellSize.width
    end

    local targetPos = cc.p(posX,posY)
    local boundingBox = {x = posX - self._cellNodeAnchor.x * self._cellSize.width,
                         y = posY - self._cellNodeAnchor.y *self._cellSize.height,
                         width = self._cellSize.width, height = self._cellSize.height
                        }
    return targetPos,boundingBox
end

function UITableView:checkAddCell()
    local centerIdx = self:getCenterPosIdx()
    for idx = centerIdx, 1,-1 do
        if not self._usedCell[idx] and self._datas[idx] then
            local targetPos,boundingBox = self:getCellPosByIndex(idx)
            if self:isInRectView(idx) then
                local cell = self:dequeueCell(idx)
                cell:setPosition(targetPos)
            else
                break
            end
        elseif self._usedCell[idx] then
            if self._usedCell[idx]:getData() ~= self._datas[idx] then
                self._usedCell[idx]:setData(self._datas[idx])
            end
        end
    end

    for idx = centerIdx+1, #self._datas do
        if not self._usedCell[idx] and self._datas[idx] then
            local targetPos,boundingBox = self:getCellPosByIndex(idx)
            if self:isInRectView(idx) then
                local cell = self:dequeueCell(idx)
                cell:setPosition(targetPos)
            else
                break
            end
        elseif self._datas[idx] then
            if self._usedCell[idx]:getData() ~= self._datas[idx] then
                self._usedCell[idx]:setData(self._datas[idx])
            end
        end
    end
end

function UITableView:clear()
    local keys = table.keys(self._usedCell)
    table.sort(keys,function(a,b)
        return a > b
    end)
    for _, idx in ipairs(keys) do
        self:pushQueue(self._usedCell[idx])
    end

    self._usedCell = {}
end

function UITableView:checkRemoveCell()
    for idx, cell in pairs(self._usedCell) do
        if not self:isInRectView(idx) then
            self:pushQueue(cell)
            self._usedCell[idx] = nil
        end
    end
end

--获取中间位置需要显示的cell 的Idx
function UITableView:getCenterPosIdx()
    local worldPos = self:convertToWorldSpace(cc.p(self._tableViewSize.width/2,self._tableViewSize.height/2))
    local nodePos = self._container:convertToNodeSpace(worldPos)
    local size = self:getInnerContainerSize()
    if self._isVertical then
        local idx = (size.height - nodePos.y + self._deltUnit) / (self._deltUnit + self._cellSize.height)
        return math.ceil(idx)
    else
        local idx = (nodePos.x - self._deltUnit) / (self._deltUnit + self._cellSize.width)
        return math.ceil(idx)
    end
end

function UITableView:isInRectView(idx)
    local targetPos,boundingBox = self:getCellPosByIndex(idx)
    --检测点是否在可视区域内
    local origin = self._container:convertToNodeSpace(self:convertToWorldSpace(cc.p(0,0)))
    local rect = {x=origin.x,y=origin.y,width=self._tableViewSize.width,height=self._tableViewSize.height}
    if cc.rectIntersectsRect(rect,boundingBox ) then
        return true
    end
end

function UITableView:getCurrentCenterItemData()
    local idx = self:getCenterPosIdx()
    return self:getDataByIndex(idx)
end

function UITableView:scrollItemToCenter()
    local p = cc.p(self._container:getPosition())
    if self._isVertical then
        local unitDistance = (self._cellSize.height + self._deltUnit)
        local dy = p.y%unitDistance
        if dy > unitDistance/2 then
            dy = dy - unitDistance + self._deltUnit
        end
        local posX,posY = self._container:getPosition()
        self._container:runAction(cc.Sequence:create(cc.MoveTo:create(0.05,cc.p(posX, posY-dy))))
    else
        local unitDistance = (self._cellSize.width + self._deltUnit)
        local dx = p.x%unitDistance
        if dx > unitDistance/2 then
            dx = dx - unitDistance + self._deltUnit
        end
        local posX,posY = self._container:getPosition()
        self._container:runAction(cc.Sequence:create(cc.MoveTo:create(0.05,cc.p(posX - dx,posY))))
    end
end

--[[
example:
    Cell编写
    local UITableViewCell = require("app.game.util.UITableViewCell")
    local UITestSceneCell = class("UITestSceneCell",UITableViewCell)

    function UITestSceneCell:init()
        self._title = seekNodeByName(self,"BitmapFontLabel_PlayType","ccui.TextBMFont")
    end

    -- 整体设置数据
    function UITestSceneCell:updateData(data)
        self._title:setString(data.title)
    end
    

    return UITestSceneCell

    单行水平、纵向可重用列表
    local tbScrollView = seekNodeByName(self,"tbScrollView","ccui.ScrollView")
    self._tbScrollView = UITableViewE.extend(tbScrollView,UITestSceneCell)
    self._tbScrollView:updateDatas({
       {title = 1},{title = 2},{title = 3},
       {title = 4},{title = 5},{title = 6},
       {title = 7}
    })
]]

return UITableView
