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

return{
  version = 2,
  FileName = "SampleData1",
  FilePath = "/home/user/MasterRepos/LuaValidator/sample/SampleData1",
  usedInTest = true,
  testDataArray = {
      [1] =     {
          name= "Pranav",
          phone= 123456,
          address= "Satyamev Jayte",
          state ="Gujarat"
      },
      [2] =     {
          name= "Sneha",
          phone= 098765,
          address= "sky Elegance",
          state ="Gujarat"
      },
  },
  testDataMap ={
      noOfData = 3,
      repeatedData = false
      dataMap = {
          name= "Parents",
          phone= 135790,
          address= "Vishwas 5",
          state ="Gujarat"
      },
  },
  testFun = function (str) print(str) end ,
  testResult = "fail"
}