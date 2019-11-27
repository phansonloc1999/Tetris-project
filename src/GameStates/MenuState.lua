---@class MenuState
MenuState = Class {__includes = BaseState}

function MenuState:init()
    self._buttons = {}
    local BUTTON_SPACING = 40

    self._buttons.startButton =
        RectButton(
        WINDOW_WIDTH / 2 - gTextures.buttons.start.deselected:getWidth() / 2,
        150,
        function()
            gStateMachine:change("select-mode")
        end,
        {
            selected = gTextures.buttons.start.selected,
            deselected = gTextures.buttons.start.deselected
        },
        "deselected"
    )

    self._buttons.aboutButton =
        RectButton(
        WINDOW_WIDTH / 2 - gTextures.buttons.about.deselected:getWidth() / 2,
        self._buttons.startButton:getY() + self._buttons.startButton:getHeight() + BUTTON_SPACING,
        function()
            gStateMachine:change("about")
        end,
        {
            selected = gTextures.buttons.about.selected,
            deselected = gTextures.buttons.about.deselected
        },
        "deselected"
    )

    self._buttons.optionButton =
        RectButton(
        WINDOW_WIDTH / 2 - gTextures.buttons.option.deselected:getWidth() / 2,
        self._buttons.aboutButton:getY() + self._buttons.aboutButton:getHeight() + BUTTON_SPACING,
        function()
            gStateMachine:change("option")
        end,
        {
            selected = gTextures.buttons.option.selected,
            deselected = gTextures.buttons.option.deselected
        },
        "deselected"
    )

    self._buttons.quitButton =
        RectButton(
        WINDOW_WIDTH / 2 - gTextures.buttons.menu_quit.deselected:getWidth() / 2,
        self._buttons.optionButton:getY() + self._buttons.optionButton:getHeight() + BUTTON_SPACING,
        function()
            love.event.quit()
        end,
        {
            selected = gTextures.buttons.menu_quit.selected,
            deselected = gTextures.buttons.menu_quit.deselected
        },
        "deselected"
    )

    local INDENT_TO_BUTTONS = 40

    self._emotes = {pet1 = {}, pet2 = {}}

    self._emotes.pet1[1] =
        RectButton(
        self._buttons.startButton:getX() + self._buttons.startButton:getWidth() + INDENT_TO_BUTTONS,
        self._buttons.startButton:getY() + self._buttons.startButton:getHeight() / 2 -
            gTextures.pet_emotes.pet1.deselected:getHeight() / 2,
        function()
        end,
        {
            deselected = gTextures.pet_emotes.pet1.deselected,
            selected = gTextures.pet_emotes.pet1.selected
        },
        "deselected"
    )

    self._emotes.pet1[2] =
        RectButton(
        self._buttons.optionButton:getX() + self._buttons.optionButton:getWidth() + INDENT_TO_BUTTONS,
        self._buttons.optionButton:getY() + self._buttons.optionButton:getHeight() / 2 -
            gTextures.pet_emotes.pet1.deselected:getHeight() / 2,
        function()
        end,
        {
            deselected = gTextures.pet_emotes.pet1.deselected,
            selected = gTextures.pet_emotes.pet1.selected
        },
        "deselected"
    )

    self._emotes.pet2[1] =
        RectButton(
        self._buttons.aboutButton:getX() - INDENT_TO_BUTTONS - gTextures.pet_emotes.pet2.deselected:getWidth(),
        self._buttons.aboutButton:getY() + self._buttons.aboutButton:getHeight() / 2 -
            gTextures.pet_emotes.pet2.deselected:getHeight() / 2,
        function()
        end,
        {
            deselected = gTextures.pet_emotes.pet2.deselected,
            selected = gTextures.pet_emotes.pet2.selected
        },
        "deselected"
    )

    self._emotes.pet2[2] =
        RectButton(
        self._buttons.quitButton:getX() - INDENT_TO_BUTTONS - gTextures.pet_emotes.pet2.deselected:getWidth(),
        self._buttons.quitButton:getY() + self._buttons.quitButton:getHeight() / 2 -
            gTextures.pet_emotes.pet2.deselected:getHeight() / 2,
        function()
        end,
        {
            deselected = gTextures.pet_emotes.pet2.deselected,
            selected = gTextures.pet_emotes.pet2.selected
        },
        "deselected"
    )

    self._buttons.startButton._emoteMapping = self._emotes.pet1[1]
    self._buttons.optionButton._emoteMapping = self._emotes.pet1[2]
    self._buttons.aboutButton._emoteMapping = self._emotes.pet2[1]
    self._buttons.quitButton._emoteMapping = self._emotes.pet2[2]
end

function MenuState:render()
    love.graphics.draw(gTextures.background)

    love.graphics.draw(
        gTextures.titles.menu,
        WINDOW_WIDTH / 2 - gTextures.titles.menu:getWidth() / 2,
        TITLE_TOP_SPACING
    )

    for key, button in pairs(self._buttons) do
        button:render()
    end

    for key, petEmote in pairs(self._emotes) do
        for i = 1, #petEmote do
            petEmote[i]:render()
        end
    end
end

function MenuState:update(dt)
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
