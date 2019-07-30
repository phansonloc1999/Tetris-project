---@class StackState
StateStack = Class{}

function StateStack:init(table)
    self._stack = table or {} ---@type BaseState[]
end

function StateStack:push(newState, params)
    self._stack[#self._stack + 1] = newState
    self._stack[#self._stack]:enter(params)
end

function StateStack:pop()
    if (#self._stack > 0) then
        return table.remove(self._stack, #self._stack)
    end
end

function StateStack:peek()
    return self._stack[#self._stack]
end

function StateStack:iterate()
    return self._stack
end

function StateStack:render()
    self._stack[#self._stack]:render()
end

function StateStack:update(dt)
    self._stack[#self._stack]:update(dt)
end