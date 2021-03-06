local pb = cocos.pb()
local content = cc.FileUtils:getInstance():getDataFromFile("res/pb/test.pb")
--FYD android 文件,如果是在程序包中,assets目录下,那么是无法用io.open打开的,因为文件在assets.zip中
local writePath = cc.FileUtils:getInstance():getWritablePath()
local file = io.open(writePath.."test.pb","wb")
file:write(content)
file:close()
local content1 = cc.FileUtils:getInstance():getDataFromFile(writePath.."test.pb")
assert(content1 == content,"FALSE=>"..tostring(content1))
release_print("FYD======>",writePath.."test.pb")
release_print("AAAAAAAAA",pb.loadfile(writePath.."test.pb"))

local person = { -- 我们定义一个addressbook里的 Person 消息
   name = "Alice",
   id = 12345,
   phone = {
      { number = "1301234567" },
      { number = "87654321", type = "WORK" },
   },
   test = {1,2,3,4,5},
   abc = "asdgg", --不在proto中定义的字段不会被打包进去
}
--检查协议message是否存在
assert(pb.type "tutorial.Person")
-- 序列化成二进制数据
local data = assert(pb.encode("tutorial.Person", person))
print(pb.tohex(data))
-- 从二进制数据解析出实际消息
local msg = assert(pb.decode("tutorial.Person", data))
dump(msg,"FYD========")
print("FFFFKKKKK  ",msg.AAAK)  --访问不存在的字段不会报错
--[[
package tutorial;

option java_package = "com.example.tutorial";
option java_outer_classname = "AddressBookProtos";

message Person {
  required string name = 1;
  required int32 id = 2;        // Unique ID number for this person.
  optional string email = 3;

  enum PhoneType {
    MOBILE = 0;
    HOME = 1;
    WORK = 2;
  }

  message PhoneNumber {
    required string number = 1;
    optional PhoneType type = 2 [default = HOME];
  }

  repeated PhoneNumber phone = 4;
  repeated int32 test = 5;

  extensions 10 to max; 
}

// Our address book file is just one of these.
message AddressBook {
  repeated Person person = 1;
}
]]
