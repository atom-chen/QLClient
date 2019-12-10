local EventConfig = {}

--测试框架专用
EventConfig["TEST_CASE_FILE_REFRESH"] = "TEST_CASE_FILE_REFRESH"

--连接建立成功
EventConfig["EVENT_CONNECTION_CREATED"] = "EVENT_CONNECTION_CREATED"
--连接被断开
EventConfig["EVENT_CONNECTION_LOST"] = "EVENT_CONNECTION_LOST"
--收到心跳回包
EventConfig["EVENT_CONNECTION_HEART"] = "EVENT_CONNECTION_HEART"

--用户数据获取成功
EventConfig["USER_DATA_RETRIVED"] = "USER_DATA_RETRIVED"
--用户登出
EventConfig["USER_LOGOUT"] = "USER_LOGOUT"

return EventConfig