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

-- Lua file must be returning table 
local function loadTableFromFile(fileName)
    local fn, err = loadfile(fileName)
    local tbl
    if err == nil then
        -- execute function to get table data
        tbl = fn()
    end
    return tbl, err
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

--- A string validator.
--
-- @param value
-- value to validate
-- @param schemaData
-- Schema against which data to validate
-- @return
--   This validator return value is either true on success or false and
--   an error message.
local function isString(value, schemaData)
    if type(value) ~= 'string' then
        return false, error_message(value, 'a string')
    else
        return true
    end
end

--- A stringEnum validator.
--
-- @param value
-- value to validate
-- @param schemaData
-- List to check if value is there or not 
-- @return
--   This validator return value is either true on success or false and
--   an error message.
local function isStringEnum(value, schemaData)
    if type(value) ~= 'string' then
        return false, error_message(value, 'a string')
    else
        local enumList = schemaData.enum
        return inList(value, enumList)
    end
end

--- A number validator.
--
-- @param value
-- value to validate
-- @return
--   This validator return value is either true on success or false and
--   an error message.
---
local function isNumber(value, schemaData)
    if type(value) ~= 'number' then
        return false, error_message(value, 'a number')
    else
        return true
    end
end

--- A number range validator.
--
-- @param value
-- value to validate
-- @return
--   This validator return value is either true on success or false and
--   an error message.
---
local function isNumberRange(value, schemaData)
    if type(value) ~= 'number' then
        return false, error_message(value, 'a number')
    else
        local minVal = schemaData.minimum
        local maxVal = schemaData.maximum
        if value >= minVal and value <= maxVal then
            return true
        else
            return false, error_message(value, 'number not is range')
        end
    end
end
  
--- A boolean validator.
--
-- @param value
-- value to validate
-- @param schemaData
-- Schema against which data to validate
-- @return
--   This validator return value is either true on success or false and
--   an error message.
local function isBoolean(value, schemaData)
    if type(value) ~= 'boolean' then
        return false, error_message(value, 'a boolean')
    else
        return true
    end
end

--
-- A Map(Table recursively checked) value type 
--
-- @param value
--   Schema used to validate the table.
--
-- @return
--   This validator return value is either true on success or false and
--   an error message.
local function isMap(value, schemaData)
    if type(value) ~= 'table' then
       return false, error_message(value, 'a map')
    else
        return Validation.validateSchemaData(value, schemaData)
    end
end
  
--
-- A Table value type 
--
-- @param value
--   value to validate.
-- @param schemaData
-- Schema against which data to validate
--
-- @return
--   This validator return value is either true on success or false and
--   an error message.
local function isTable(value, schemaData)
    if type(value) ~= 'table' then
       return false, error_message(value, 'a table')
    else
        return true
    end
end  
  
--- an array validator. 
--
-- Validate an array by applying same validator to all elements.
--
-- @param value
--   value used to validate 
-- @param schemaData
--   schema against which data to validate
--
-- @return
--   Array validator function.
--   This validator return value is either true on success or false and
--   an error message.
---
local function isArray(value, schemaData)
    -- Iterate the array and validate them.
    local errorTable = {}
    local result = nil
    if type(value) == 'table' then
        local itemSchema = schemaData.items
        for index in pairs(value) do
            local data = value[index]
            local r, t = Validation.validateSchemaData(data, itemSchema)
            result = result and r
            -- accumulate all the errors in table
            if type(t) == 'table' then
                for k,v in pairs(t) do
                    insert(errorTable, v)
                end
            end
        end
        return result, errorTable
    else
        insert(errorTable, error_message(value, 'an array') )
        return false, errorTable
    end
end

-- fill all the functions into table for fast function find [better than if/else]
local validateFunctionTable = {}
validateFunctionTable["number"] = isNumber
validateFunctionTable["string"] = isString
validateFunctionTable["boolean"] = isBoolean
validateFunctionTable["function"] = isFunction
validateFunctionTable["stringEnum"] = isStringEnum
validateFunctionTable["numberRange"] = isNumberRange
validateFunctionTable["map"] = isMap
validateFunctionTable["array"] = isArray


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
    dataTable, err = loadTableFromFile(dataTableFile)
    if dataTable == nil then
        insert(errorTable, "Not valid data file-" .. err)
        return false, errorTable
    end
    
    -- load schema data
    local schemaTable = nil
    schemaTable, err = loadTableFromFile(schemaTableFile)
    if schemaTable == nil then
        insert(errorTable, "Not valid schema file-" .. err)
        return false, errorTable
    end
    
    -- as both table loaded start validator
    --print("dataTable:", dataTable)
    --print("schemaTable:", schemaTable)  
    return validator.validateAgainstSchema(dataTable, schemaTable)
end
