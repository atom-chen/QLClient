
�7
replay.proto!com.kodgames.message.proto.replay"�
GRDestroyRoomSYN
roomId (

createTime (
clubId (
areaId (
	managerId (
destroyerId (


destroyDescription	 (	
destroyTime
 (
leagueId (J
playerInfos (25.com.kodgames.message.proto.replay.PlayerHistoryPROTO"p
RoomHistoryPlayerInfoElem
roleId (
position (
nickname (	

headImgUrl (	
sex ("d
RoomHistoryPlayerInfoK
elems (2<.com.kodgames.message.proto.replay.RoomHistoryPlayerInfoElem")
RoomHistoryGamePlays
	gameplays ("E
RoomHistoryRecordPlayerInfoElem
roleId (

totalPoint ("p
RoomHistoryRecordPlayerInfoQ
elems (2B.com.kodgames.message.proto.replay.RoomHistoryRecordPlayerInfoElem"�
PlayerHistoryPROTO
roleId (
position (
nickname (	

headImgUrl (	
sex (

totalPoint (
clubId (
clubName (	"�
RoundReportPROTO

	startTime (
	lastCards (
isHuang (

version (
destroyerId (
endTime (

scoreRatio	 (
gameplayName
 (	"�
RoomHistoryPROTO
roomId (

createTime (L

	roundType (
	gameplays (

roundCount (
playerMaxCardCount (

isProcessed	 (
isAbnormalRoom
 (
clubId (
destroyTime (

scoreRatio
gameplayName (	

GRMatchResultSYN
roomId (

createTime (
	roundType (

roundCount (
payCard (

playerMaxCardCount (
clubId (


 (N
roundReportRecord (23.com.kodgames.message.proto.replay.RoundReportPROTO
	gameplays (L

version (
areaId (
leagueId ("3
CRGameHistoryREQ
version (
areaId ("}
RCGameHistoryRES
result (
version (H
roomRecords (23.com.kodgames.message.proto.replay.RoomHistoryPROTO"[
CRHistoryRoomREQ
roomId (

createTime (
queryRoleId (
areaId ("�
RCHistoryRoomRES
result (

createTime (
roomId (
queryRoleId (O
roundReportRecords (23.com.kodgames.message.proto.replay.RoundReportPROTO

CRHistoryPlaybackREQ
roomId (
	creatTime (
recordIndex (
areaId ("=
RCHistoryPlaybackRES
result (

CRShareHistoryREQ
roleId (
roomId (
roundNumber (
clubId (

createTime (
areaId ("�
RCShareHistoryRES
result (H
roomRecords (23.com.kodgames.message.proto.replay.RoomHistoryPROTOO
roundReportRecords (23.com.kodgames.message.proto.replay.RoundReportPROTO

CRProcessHistoryREQ
roomId (

createTime (
isProcessed (
areaId ("%
RCProcessHistoryRES
result ("�
ClubRoomInfoPROTO
roomId (

createTime (
costCard (

roundCount (

isFinished (
winnerScore (
isAbnormalDestroy ("[
ClubHourRoomInfoListC
rooms (24.com.kodgames.message.proto.replay.ClubRoomInfoPROTO"O
CRQueryRoomDestroyInfoREQ
roomId (

createTime (
areaId ("�
RCQueryRoomDestroyInfoRES
result (

destroyerId (

destroyDescription (	"w
CRShareHistoryRoundForCodeREQ
roomId (

createTime (

roundIndex (
clubId (
areaId ("E
RCShareHistoryRoundForCodeRES
result (
playbackCode (	">
CRHistoryRoomByCodeREQ
playbackCode (	
areaId ("�
RCHistoryRoomByCodeRES
result (

createTime (
roomId (
queryRoleId (N
roundReportRecord (23.com.kodgames.message.proto.replay.RoundReportPROTO

roomRecords (23.com.kodgames.message.proto.replay.RoomHistoryPROTO

roundIndex ("�
CCLClubHistoryREQ
clubId (
start (
num (
queryRoleId (
	queryTime (
minScore (
onlyAbnormalRoom ("�
CLCClubHistoryRES
result (
start (
clubId (H
roomRecords (23.com.kodgames.message.proto.replay.RoomHistoryPROTO"�
CLRClubHistoryREQ
clubId (
start (
num (
	queryTime (
minScore (
onlyAbnormalRoom (
areaId (
queryAll (
queryRoleIds	 (
roleId
 (
callback ("�
RCLClubHistoryRES
result (
start (
clubId (H
roomRecords (23.com.kodgames.message.proto.replay.RoomHistoryPROTO
roleId (
callback ("I
CCLCheckClubBillREQ
clubId (
	startTime (
endTime ("�
CLCCheckClubBillRES
result (
clubId (
	startTime (
endTime (

settledRoomNum (
settledRoomCost (
unsettledRoomNum (
unsettledRoomCost	 ("{
CLRCheckClubBillREQ
clubId (
	startTime (
endTime (
areaId (
roleId (
callback ("�
RCLCheckClubBillRES
result (
clubId (
	startTime (
endTime (

settledRoomNum (
settledRoomCost (
unsettledRoomNum (
unsettledRoomCost	 (
roleId
 (
callback ("*
CCLCheckClubBillTodayREQ
clubId ("�
CLCCheckClubBillTodayRES
result (
clubId (
todayRoomNum (
yesterdayRoomNum (

yesterdayRoomCost ("\
CLRCheckClubBillTodayREQ
clubId (
areaId (
roleId (
callback ("�
RCLCheckClubBillTodayRES
result (
clubId (
todayRoomNum (
yesterdayRoomNum (

yesterdayRoomCost (
roleId (
callback ("�
CCLQueryLeagueRoomHistoryREQ
leagueId (
clubId (
start (
num (
	queryTime (
minScore (
onlyAbnormalRoom (
queryRoleId (
roomId	 ("�
CLCQueryLeagueRoomHistoryRES
result (
start (H
roomRecords (23.com.kodgames.message.proto.replay.RoomHistoryPROTO"�
CLRQueryLeagueRoomHistoryREQ
roleId (
areaId (
leagueId (
start (
num (
	queryTime (
minScore (
onlyAbnormalRoom (
queryRoleId	 (
queryClubId
 (
callback (
roomId ("�
RCLQueryLeagueRoomHistoryRES
result (
start (
roleId (
callback (
leagueId (H
roomRecords (23.com.kodgames.message.proto.replay.RoomHistoryPROTO"Z
ScoreListPROTO
roleId (
roleName (	
	realScore (
theoryScore ("�
CLRLeaguePlayerScoreResultSYN
roomId (
leagueId (
clubId (

createTime (D
	scoreList (21.com.kodgames.message.proto.replay.ScoreListPROTOBBReplayProtoBuf