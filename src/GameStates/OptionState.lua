---@class OptionState
OptionState = Class {__includes = BaseState}

local ABOUT_Y = 10
local BACKGROUND_LEFT_X = PLAYSTATE_WINDOW_WIDTH / 2 - gTextures.background:getWidth() / 2
local PLAYER1_Y = ABOUT_Y + gTextures.titles.about:getHeight() - 20
local PAGE_BUTTON_SPACING = 10

KEY_SETTINGS = {
    spaceads_settings = {
        rotate = "space",
        left = "a",
        right = "d",
        accelerate = "s"
    },
    updownleftright_settings = {
        rotate = "up",
        left = "left",
        right = "right",
        accelerate = "down"
    }
}

gKeySettings = {
    player1 = {
        rotate = "space",
        left = "a",
        right = "d",
        accelerate = "s"
    },
    player2 = {
        rotate = "up",
        left = "left",
        right = "right",
        accelerate = "down"
    }
}
gTimeLimit = 999

function OptionState:init()
    self._buttons = {}
    self._buttons.ok =
        RectButton(
        PLAYSTATE_WINDOW_WIDTH / 2 - gTextures.buttons.ok.deselected:getWidth() / 2,
        PLAYSTATE_WINDOW_HEIGHT - gTextures.buttons.ok.selected:getHeight() - 15,
        function()
            if (self._timeLimit.string ~= "") then
                gStateMachine:change("menu")
            end
        end,
        {
            selected = gTextures.buttons.ok.selected,
            deselected = gTextures.buttons.ok.deselected
        },
        "deselected"
    )
    self._buttons.prev =
        RectButton(
        self._buttons.ok._hitbox._pos._x - PAGE_BUTTON_SPACING - gTextures.buttons.prev.deselected:getWidth(),
        PLAYSTATE_WINDOW_HEIGHT - gTextures.buttons.ok.deselected:getHeight() - 15 +
            gTextures.buttons.ok.deselected:getHeight() / 2 -
            gTextures.buttons.prev.deselected:getHeight() / 2 +
            5,
        function()
            self._isInKeySettings = not self._isInKeySettings
        end,
        {
            selected = gTextures.buttons.prev.selected,
            deselected = gTextures.buttons.prev.deselected
        },
        "deselected"
    )
    self._buttons.next =
        RectButton(
        self._buttons.ok._hitbox._pos._x + PAGE_BUTTON_SPACING + gTextures.buttons.ok.deselected:getWidth(),
        PLAYSTATE_WINDOW_HEIGHT - gTextures.buttons.ok.deselected:getHeight() - 15 +
            gTextures.buttons.ok.deselected:getHeight() / 2 -
            gTextures.buttons.next.deselected:getHeight() / 2 +
            5,
        function()
            self._isInKeySettings = not self._isInKeySettings
        end,
        {
            selected = gTextures.buttons.next.selected,
            deselected = gTextures.buttons.next.deselected
        },
        "deselected"
    )

    self._keypads = {}
    self._keypads.player1 = {
        texture = gTextures.option_state.spaceads_settings,
        updownleftright = gTextures.option_state.spaceads_settings,
        currentSettings = "spaceads_settings"
    }

    self._keypads.player2 = {
        texture = gTextures.option_state.updownleftright_settings,
        updownleftright = gTextures.option_state.updownleftright_settings,
        currentSettings = "updownleftright_settings"
    }

    self._buttons.keySettingsPlayer1Prev =
        RectButton(
        PLAYSTATE_WINDOW_WIDTH / 2 - gTextures.buttons.prev.deselected:getWidth() - 115,
        PLAYER1_Y + gTextures.option_state.player1:getHeight() / 2 + 20 -
            gTextures.option_state.button_names:getHeight() / 2 +
            gTextures.buttons.prev.deselected:getHeight() / 2,
        function()
            self:changeKeySettings()
        end,
        {
            deselected = gTextures.buttons.prev.deselected,
            selected = gTextures.buttons.prev.selected
        },
        "deselected"
    )
    self._buttons.keySettingsPlayer1Prev._isOnlyInTimeSettings = true
    self._buttons.keySettingsPlayer1Next =
        RectButton(
        PLAYSTATE_WINDOW_WIDTH / 2 + 106,
        PLAYER1_Y + gTextures.option_state.player1:getHeight() / 2 + 20 -
            gTextures.option_state.button_names:getHeight() / 2 +
            gTextures.buttons.next.deselected:getHeight() / 2,
        function()
            self:changeKeySettings()
        end,
        {
            deselected = gTextures.buttons.next.deselected,
            selected = gTextures.buttons.next.selected
        },
        "deselected"
    )
    self._buttons.keySettingsPlayer1Next._isOnlyInTimeSettings = true

    self._buttons.keySettingsPlayer2Prev =
        RectButton(
        PLAYSTATE_WINDOW_WIDTH / 2 - gTextures.buttons.prev.deselected:getWidth() - 115,
        PLAYER1_Y + gTextures.option_state.player1:getHeight() - 45 + gTextures.option_state.player1:getHeight() / 2 -
            gTextures.option_state.button_names:getHeight() / 2 +
            15 +
            gTextures.buttons.prev.deselected:getHeight() / 2 +
            5,
        function()
            self:changeKeySettings()
        end,
        {
            deselected = gTextures.buttons.prev.deselected,
            selected = gTextures.buttons.prev.selected
        },
        "deselected"
    )
    self._buttons.keySettingsPlayer2Prev._isOnlyInTimeSettings = true
    self._buttons.keySettingsPlayer2Next =
        RectButton(
        PLAYSTATE_WINDOW_WIDTH / 2 + 105,
        PLAYER1_Y + gTextures.option_state.player1:getHeight() - 45 + gTextures.option_state.player1:getHeight() / 2 -
            gTextures.option_state.button_names:getHeight() / 2 +
            15 +
            gTextures.buttons.next.deselected:getHeight() / 2 +
            5,
        function()
            self:changeKeySettings()
        end,
        {
            deselected = gTextures.buttons.next.deselected,
            selected = gTextures.buttons.next.selected
        },
        "deselected"
    )
    self._buttons.keySettingsPlayer2Next._isOnlyInTimeSettings = true

    self._isInKeySettings = true

    self._timeLimit = {
        text = love.graphics.newText(gFonts.default, "999"),
        value = gTimeLimit,
        string = "999"
    }
end

function OptionState:render()
    love.graphics.draw(gTextures.background, BACKGROUND_LEFT_X)

    love.graphics.draw(
        gTextures.titles.about,
        PLAYSTATE_WINDOW_WIDTH / 2 - gTextures.titles.about:getWidth() / 2,
        ABOUT_Y
    )

    if (self._isInKeySettings) then
        -- Player 1 settings
        love.graphics.draw(
            gTextures.option_state.player1,
            PLAYSTATE_WINDOW_WIDTH / 2 - gTextures.option_state.player1:getWidth() / 2,
            PLAYER1_Y
        )
        love.graphics.draw(
            gTextures.option_state.button_names,
            PLAYSTATE_WINDOW_WIDTH / 2 -
                (gTextures.option_state.button_names:getWidth() + gTextures.option_state.spaceads_settings:getWidth()) /
                    2,
            PLAYER1_Y + gTextures.option_state.player1:getHeight() / 2 -
                gTextures.option_state.button_names:getHeight() / 2 +
                15
        )
        love.graphics.draw(
            self._keypads.player1.texture,
            PLAYSTATE_WINDOW_WIDTH / 2 -
                (gTextures.option_state.button_names:getWidth() + gTextures.option_state.spaceads_settings:getWidth()) /
                    2 +
                gTextures.option_state.button_names:getWidth(),
            PLAYER1_Y + gTextures.option_state.player1:getHeight() / 2 -
                gTextures.option_state.button_names:getHeight() / 2 +
                20
        )

        -- Player 2 settings
        love.graphics.draw(
            gTextures.option_state.player2,
            PLAYSTATE_WINDOW_WIDTH / 2 - gTextures.option_state.player2:getWidth() / 2,
            PLAYER1_Y + gTextures.option_state.player1:getHeight() - 45
        )
        love.graphics.draw(
            gTextures.option_state.button_names,
            PLAYSTATE_WINDOW_WIDTH / 2 -
                (gTextures.option_state.button_names:getWidth() + gTextures.option_state.spaceads_settings:getWidth()) /
                    2,
            PLAYER1_Y + gTextures.option_state.player1:getHeight() - 45 + gTextures.option_state.player1:getHeight() / 2 -
                gTextures.option_state.button_names:getHeight() / 2 +
                15
        )
        love.graphics.draw(
            self._keypads.player2.texture,
            PLAYSTATE_WINDOW_WIDTH / 2 -
                (gTextures.option_state.button_names:getWidth() +
                    gTextures.option_state.updownleftright_settings:getWidth()) /
                    2 +
                gTextures.option_state.button_names:getWidth(),
            PLAYER1_Y + gTextures.option_state.player1:getHeight() - 45 + gTextures.option_state.player1:getHeight() / 2 -
                gTextures.option_state.button_names:getHeight() / 2 +
                20
        )
    else
        love.graphics.draw(
            gTextures.option_state.time_limit_setting,
            PLAYSTATE_WINDOW_WIDTH / 2 - gTextures.option_state.time_limit_setting:getWidth() / 2,
            PLAYSTATE_WINDOW_HEIGHT / 2 - gTextures.option_state.time_limit_setting:getHeight() / 2
        )

        love.graphics.draw(
            self._timeLimit.text,
            PLAYSTATE_WINDOW_WIDTH / 2 - self._timeLimit.text:getWidth() / 2,
            PLAYSTATE_WINDOW_HEIGHT / 2 - self._timeLimit.text:getHeight() / 2 - 25
        )
    end

    for key, button in pairs(self._buttons) do
        if (self._isInKeySettings == false and button._isOnlyInTimeSettings == true) then
        else
            button:render()
        end
    end
end

function OptionState:update(dt)
    for key, button in pairs(self._buttons) do
        if (button:collidesWithMouse()) then
            button:onSelect()

            if (love.mouse.wasPressed(1)) then
                button:onClick()
            end
        elseif (button._selected) then
            button:onDeselect()
        end
    end

    if (not self._isInKeySettings) then
        local number_keys = {
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "kp0",
            "kp1",
            "kp2",
            "kp3",
            "kp4",
            "kp5",
            "kp6",
            "kp7",
            "kp8",
            "kp9"
        }
        for i = 1, #number_keys do
            if (love.keyboard.wasPressed(number_keys[i])) then
                self._timeLimit.string = self._timeLimit.string .. string.sub(number_keys[i], #number_keys[i])
                self:getTimelimitValueAndText()
            end
        end
        if (love.keyboard.wasPressed("backspace")) then
            self._timeLimit.string = string.sub(self._timeLimit.string, 1, #self._timeLimit.string - 1)
            self:getTimelimitValueAndText()
        end
    end
end

function OptionState:getTimelimitValueAndText()
    self._timeLimit.text = love.graphics.newText(gFonts.default, self._timeLimit.string)
    self._timeLimit.value = tonumber(self._timeLimit.string)
    gTimeLimit = self._timeLimit.value
end

function OptionState:changeKeySettings()
    self._keypads.player1.currentSettings =
        self._keypads.player1.currentSettings == "spaceads_settings" and "updownleftright_settings" or
        "spaceads_settings"
    self._keypads.player2.currentSettings =
        self._keypads.player2.currentSettings == "spaceads_settings" and "updownleftright_settings" or
        "spaceads_settings"
    self._keypads.player1.texture = gTextures.option_state[self._keypads.player1.currentSettings]
    self._keypads.player2.texture = gTextures.option_state[self._keypads.player2.currentSettings]
    gKeySettings.player1 = KEY_SETTINGS[self._keypads.player1.currentSettings]
    gKeySettings.player2 = KEY_SETTINGS[self._keypads.player2.currentSettings]
end
