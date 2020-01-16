
# Lua Schema Validator

Validates data stored in [Lua](https://www.lua.org/  "Lua") tables against given schema or Validates schema for the given Lua table data.

  

It's very easy to store data in [Lua tables](https://www.lua.org/pil/2.5.html  "Lua tables") while writing Lua code, because that is **the only data structure avaialble.**

> "Tables in Lua are not a data structure; they are [the data structure](https://www.lua.org/pil/11.html  "the data structure")"

## Which data needs validation

Any repetitive data stored in Lua table which get modified often and need data update (mostly repeated editing) need to be validated to make sure data is correct all the time.

## How to write Schema for given data table

For a give recurring Lua data, first, we need to come up with schema so that with all such upcoming data we can use schema to do the validation.

Following are some set of rule to follow to generate the schema.

### Special fields while generating schema

1. required: It says the weather this field is mandatory or not if this field is not present in data it should throw an error.

2. default: In says default value for this field in case of boolean, stringEnum, numberRange.

### Basic types

#### number:

    data: version = 1.2
    Schema: version = { type = "number",required = true}

#### Integer

    Data: value= 2
    Schema: value = { type = "integer", default = 4}

boolean

    Data: downloadData = false
    Schema: downloadData = { type = "boolean"}

string

    Data : testName = "Test item name"
    Schema :  testName = { type = "string"}

### Recurring types

#### table: (map)

A table schema must contain type and properties to capture all data inside a table.

    Data:  abcTable = { aTable = { bBool = true} }
    Schema: abcTable = { type = "map", properties = 
    										{  aTable = { type = "map", properties = 
    											    { bBool = {type = "boolean", default = "true"}
    											    }
    									     }
    									 }
							


#### array:

Which is another way of representing table data, we distinguish array data from table data when we need to index given data in a numerical way, for such

data same schema should be used to validate each entry in the array

    Data:
    Schema:

#### arraykeyPattern:

Represents arrays with the repeated pattern but the index is a string with incresing number

    Data
    Schema

#### referenceMap:

when data is duplicated at multiple places but they all need the same schema to validate, use referenceMap which is similar to Map but it refers to global

schema rather than repeating schema at all the places in the schema file.

    Data
    Schema

### Hybrid types
Mixed data of basic type with range or enums.

#### numberRange

Data is number and it falls between specific range which can be represented in the schema as numberRange

    Data 
    Schema

#### stringEnum

When a specific set of data either list of random number or particular strings can be represented as stringEnum.

    Data 
    Schema

## How to call validation

This library provides two API which can be called to validate Lua data.

### File-based API: 
Validation.validateFromFile(dataFile, SchemaFile) : Use this API when you have data file and schema file available to validate. Eventually, the file gets converted into table data and then use the following API to validate data against the schema.

### Table-based API: 
Validation.validateAgainstSchema(dataTable, schemaTable): Use this when data and schema available as table.

## Understanding the result

Above mentioned both API returns boolean, errorTable which says if validation passed or not using the boolean result as true or false.

In the case of boolean true, errorTable will be empty. Also, it is the responsibility of end-user to interpret result and error tables to print where required. 

In the case of the boolean false, errorTable has all the errors user required to know where validation has failed. Following are possible understanding for

### messages in error table

1. If schema says filed is required and not present in data should be represented as an error. 
2. If schema field's type does not match with data's type error should be there in error table. 
3. If data's filePath, numberRange or stringEnum fields does not match schema requirement should be there in the error table. 
4. If passed table, array, arrayKeyPattern data is not correct at any level it should be present in the error table.
