---@class SelectModeState
SelectModeState = Class {__includes = BaseState}

function SelectModeState:init()
    self._buttons = {}

    self._buttons.oneplayer =
        RectButton(
        WINDOW_WIDTH / 2 - gTextures.buttons.oneplayer.deselected:getWidth() - 50,
        WINDOW_HEIGHT / 2 + 50,
        function()
            gStateMachine:change("select-animal", {numOfPlayers = 1})
        end,
        {
            deselected = gTextures.buttons.oneplayer.deselected,
            selected = gTextures.buttons.oneplayer.selected
        },
        "deselected"
    )

    self._buttons.twoplayer =
        RectButton(
        WINDOW_WIDTH / 2 + 50,
        WINDOW_HEIGHT / 2 + 50,
        function()
            gStateMachine:change("select-animal", {numOfPlayers = 2})
        end,
        {
            deselected = gTextures.buttons.twoplayer.deselected,
            selected = gTextures.buttons.twoplayer.selected
        },
        "deselected"
    )

    self._buttons.back =
        RectButton(
        WINDOW_WIDTH / 2 - gTextures.buttons.back.deselected:getWidth() / 2,
        WINDOW_HEIGHT - 100,
        function()
            gStateMachine:change("menu")
        end,
        {
            deselected = gTextures.buttons.back.deselected,
            selected = gTextures.buttons.back.selected
        },
        "deselected"
    )

    self._emotes = {}

    self._emotes.oneplayer =
        RectButton(
        self._buttons.oneplayer:getX() + self._buttons.oneplayer:getWidth() / 2 -
            gTextures.mode_emotes.oneplayer.deselected:getWidth() / 2,
        self._buttons.oneplayer:getY() - 20 - gTextures.mode_emotes.oneplayer.deselected:getHeight(),
        function()
        end,
        {
            deselected = gTextures.mode_emotes.oneplayer.deselected,
            selected = gTextures.mode_emotes.oneplayer.selected
        },
        "deselected"
    )

    self._emotes.twoplayer =
        RectButton(
        self._buttons.twoplayer:getX() + self._buttons.twoplayer:getWidth() / 2 -
            gTextures.mode_emotes.twoplayer.deselected:getWidth() / 2,
        self._buttons.twoplayer:getY() - 20 - gTextures.mode_emotes.twoplayer.deselected:getHeight(),
        function()
        end,
        {
            deselected = gTextures.mode_emotes.twoplayer.deselected,
            selected = gTextures.mode_emotes.twoplayer.selected
        },
        "deselected"
    )

    self._buttons.oneplayer._emoteMapping = self._emotes.oneplayer
    self._buttons.twoplayer._emoteMapping = self._emotes.twoplayer
    self._buttons.back._emoteMapping = {
        onSelect = function()
        end,
        onDeselect = function()
        end
    }
end

function SelectModeState:render()
    love.graphics.draw(gTextures.background)

    love.graphics.draw(
        gTextures.titles.mode,
        WINDOW_WIDTH / 2 - gTextures.titles.mode:getWidth() / 2,
        TITLE_TOP_SPACING
    )

    for key, button in pairs(self._buttons) do
        button:render()
    end

    for key, emote in pairs(self._emotes) do
        emote:render()
    end
end

function SelectModeState:update(dt)
    for key, button in pairs(self._buttons) do
        if (button:collidesWithMouse()) then
            button:onSelect()
            button._emoteMapping:onSelect()

            if (love.mouse.wasPressed(1)) then
                button:onClick()
            end
        elseif (button._selected) then
            button:onDeselect()
            button._emoteMapping:onDeselect()
        end
    end
end
