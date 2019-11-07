-- MIT License

-- Copyright (c) 2019 CyberCBM(https://github.com/cyberCBM)

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

-- @Scope validator
validator = {}

-- Import from global environment and make local for easy usage.
local type = type
local pairs = pairs
local format = string.format
local insert = table.insert
local next = next

local function loadTableFromFile(fileName)
    return true
end

--- Generate error message for validators.
--
-- @param data mixed
--   Value that failed validator.
-- @param expected_type string
--   Expected type for data
--
-- @return
--   String describing the error.
---
local function error_message(data, expected_type)
    if data then
        return format('%s is not %s.',tostring(data), expected_type)
    end

    return format(' is missing and should be %s.', expected_type)
end


-- One of the main validator function 
--
-- @param dataTable Table
--
-- @param schemaTable Table
-- @return
--   result and Table 
--   This validator return value is either true on success or false and
--   a nested table holding all errors.

function validator.validateFromFile(dataTableFile, schemaTableFile)
    local result, err = nil
    local dataTable = nil
    local errorTable = {}
    
    -- load table data
    result, err, dataTable = loadTableFromFile(dataTableFile)
    if result == false then
        insert(errorTable, "Not valid data file-" .. err)
        return false, errorTable
    end
    
    -- load schema data
    local schemaTable = nil
    result, err, schemaTable = loadTableFromFile(schemaTableFile)
    if result == false then
        insert(errorTable, "Not valid schema file-" .. err)
        return false, errorTable
    end
    
    -- as both table loaded start validator
    --print("dataTable:", dataTable)
    --print("schemaTable:", schemaTable)  
    return validator.validateAgainstSchema(dataTable, schemaTable)
end

