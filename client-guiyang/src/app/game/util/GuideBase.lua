---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by wanminhua.
--- DateTime: 2019/3/14 14:53

--[[
    这是向导UI的基类， 向导的UI可以继承此UI去完成某些按钮的向导功能
    底层是通过 cc.ClippingNode 去实现的
    Usage:
        参考 UIGuide_UIWallet_1.lua 的实现方法

        在需要向导的UI上显示一个半透明的UI，并且在这个半透明的UI上去显示某些图片或者文字执行玩家使用新的功能。
        GuideBase 只关心应该去引导哪个UI，并不关心透明的引导UI上有什么东西。
]]

local UtilsFunctions = require("app.game.util.UtilsFunctions")
local Array = require("ds.Array")
------@class GuideBase
local GuideBase = class("GuideBase")

function GuideBase:ctor()
    self._spriteArray = Array.new()
    self._clippingNode = cc.ClippingNode:create()
    self:addChild(self._clippingNode)
    self._clippingNode:setLocalZOrder(-1)

    self._background = cc.Node:create()
    self._foreground = cc.Node:create()
    self._clippingNode:addChild(self._background)
    self._clippingNode:setStencil(self._foreground)

    self._bgImageView = ccui.ImageView:create("img/img_black.png")
    self._bgImageView:setScale9Enabled(true)
    self._bgImageView:setContentSize(CC_DESIGN_RESOLUTION.screen.size())
    self._bgImageView:setPosition(cc.p(568, 320))
    self._bgImageView:setTouchEnabled(true)
    self._bgImageView:setOpacity(255 * 0.85)
    self._background:addChild(self._bgImageView)

    self._clippingNode:setAlphaThreshold(0.05)
    self._clippingNode:setInverted(true)
end

-- 直接的向导
---@param pos cc.p 被向导对象的位置，这个位置是相对 GuideBase 而言的
---@param size cc.size 被向导对象的大小
function GuideBase:guideDirect(pos, size)
    local sprite = self:_newForegroundSprite(pos, size)
    sprite.strokeImg = self:_newStrokeImage(pos, size)
    return self._spriteArray:getCount()
end

---@param node cc.Node 被向导的对象， 他的位置在此转为 GuideBase 的坐标
---@param size cc.size 被向导的对象的大小
function GuideBase:guide(node, size)
    local srcPos = node:getParent():convertToWorldSpace(cc.p(node:getPosition()))
    local dstPos = self:convertToNodeSpace(srcPos)
    local ap = node:getAnchorPoint()
    local nodeSize = node:getContentSize()
    local offset = cc.p((0.5 - ap.x) * nodeSize.width, (0.5 - ap.y) * nodeSize.height)
    dstPos = cc.pAdd(dstPos, offset)
    return self:guideDirect(dstPos, size)
end

---@private
---@param pos cc.p 遮罩的位置， 相对 GuideBase 而言
---@param size cc.size 遮罩的大小
---新建一个遮罩体
function GuideBase:_newForegroundSprite(pos, size)
    local sprite = ccui.ImageView:create(self:getForegroundResPath())
    sprite:setScale9Enabled(true)
    sprite:setPosition(pos)
    sprite:setContentSize(size)
    self._foreground:addChild(sprite)
    self._spriteArray:add(sprite)
    return sprite
end

---@private
---@param pos cc.p 描边的位置， 相对 GuideBase 而言
---@param size cc.size 描边的大小 内部会修改
---如果子类有重写方法并且返回正确的值，则会在遮罩之上添加一个额外的图片
function GuideBase:_newStrokeImage(pos, size)
    -- 添加描边的图片
    local strokeResPath = self:getStrokeResPath()
    if strokeResPath and strokeResPath ~= "" then
        local strokeImg = ccui.ImageView:create(strokeResPath)
        strokeImg:setScale9Enabled(true)
        strokeImg:setPosition(pos)
        -- 放大0.02倍，遮挡掉锯齿
        strokeImg:setContentSize(UtilsFunctions.sizeMul(size, 1.02))
        self:addChild(strokeImg)
        return strokeImg
    end
end

--- 清空所有的遮罩对象
function GuideBase:cleanAllGuide()
    self._spriteArray:forEach(function(item)
        item:removeFromParent()
        if item.strokeImg then
            item.strokeImg:removeFromParent()
        end
    end)
    self._spriteArray:clear()
end

--- 提供一个遮罩的描边图片地址， 用来在遮罩之后， 叠加在其之上
function GuideBase:getStrokeResPath()
    return ""
end

--- 通过遮罩形状的图片， 遮罩的形状与提供的形状相同
function GuideBase:getForegroundResPath()
    return "img/img_black.png"
end
return GuideBase