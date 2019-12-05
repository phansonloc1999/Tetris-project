---@class RectButton
RectButton = Class {}

function RectButton:init(x, y, funcOnClick, textures, defaultTexture, animations)
    self._hitbox = RectHitbox(x, y, 0, 0)
    self._textures = textures ---@type Image[]
    self._animations = animations
    self._funcOnClick = funcOnClick

    if (textures) then
        self._currentTexture = defaultTexture
        assert(self._textures[self._currentTexture], "Default texture must exist!")
        self._hitbox._width, self._hitbox._height =
            self._textures[self._currentTexture]:getWidth(),
            self._textures[self._currentTexture]:getHeight()
    end
end

function RectButton:render()
    if (self._textures) then
        love.graphics.draw(self._textures[self._currentTexture], self._hitbox._pos._x, self._hitbox._pos._y)
    end
end

function RectButton:collidesWithMouse()
    local mouse = {
        _pos = {
            _x = love.mouse.getX(),
            _y = love.mouse.getY()
        },
        _width = 1,
        _height = 1
    }
    return self._hitbox:collides(mouse)
end

function RectButton:onClick(...)
    self._funcOnClick(...)
end

function RectButton:setPos(newX, newY)
    self._hitbox._pos._x, self._hitbox._pos._y = newX, newY
end

function RectButton:getX()
    return self._hitbox._pos._x
end

function RectButton:getY()
    return self._hitbox._pos._y
end

function RectButton:getPos()
    return self:getX(), self:getY()
end

function RectButton:getWidth()
    return self._hitbox._width
end

function RectButton:getHeight()
    return self._hitbox._height
end

function RectButton:onSelect()
    if (not self._selected) then
        AudioManager.play("hover")

        self._currentTexture = "selected"

        self._hitbox._pos:setPos(
            self._hitbox._pos._x + self._hitbox._width / 2 - self._textures[self._currentTexture]:getWidth() / 2,
            self._hitbox._pos._y + self._hitbox._height / 2 - self._textures[self._currentTexture]:getHeight() / 2
        )

        self._hitbox._width, self._hitbox._height =
            self._textures[self._currentTexture]:getWidth(),
            self._textures[self._currentTexture]:getHeight()

        self._selected = true
    end
end

function RectButton:onDeselect()
    if (self._selected) then
        self._currentTexture = "deselected"

        self._hitbox._pos:setPos(
            self._hitbox._pos._x + self._hitbox._width / 2 - self._textures[self._currentTexture]:getWidth() / 2,
            self._hitbox._pos._y + self._hitbox._height / 2 - self._textures[self._currentTexture]:getHeight() / 2
        )

        self._hitbox._width, self._hitbox._height =
            self._textures[self._currentTexture]:getWidth(),
            self._textures[self._currentTexture]:getHeight()

        self._selected = false
    end
end
