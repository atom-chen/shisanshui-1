ClubUtil = {}
local GameUtil = GameUtil

ClubUtil.AgentGameSelectCount = 5
ClubUtil.NormalGameSelectCount = 5

ClubUtil.iconIdToNameMap = 
{
	[1] = "icon_27",
	[2] = "icon_28",
	[3] = "icon_29",
}

ClubUtil.locationTab = nil
ClubUtil.provinceIdList = {}
ClubUtil.locationProvinceToCityMap = {}

ClubUtil.SupportProvinceList = {350000}

-- type -> gidslist
ClubUtil.gameTypeMap = {}
-- gid -> typelist
ClubUtil.gidToGameTypeMap = nil

function ClubUtil.InitGameType()
	ClubUtil.gidToGameTypeMap = {}
	local configs = model_manager:GetModel("GameModel"):GetTypeList()
	for key, v in pairs(configs) do
		v.key = key
		for i = 1, #v.gids do
			if ClubUtil.gidToGameTypeMap[v.gids[i]] == nil then
				ClubUtil.gidToGameTypeMap[v.gids[i]] = {}
				ClubUtil.gidToGameTypeMap[v.gids[i]][1] = key
			else
				table.insert(ClubUtil.gidToGameTypeMap[v.gids[i]], key)
			end
		end
	end
end

-- 根据gid列表获取 标签页信息列表
function ClubUtil.GetGameTypeListAndTypeToGidMapByGidList(gids, sort)
	if gids == nil or #gids == 0 then
		return {}
	end
	-- gametype -> list
	local typeMap = {}
	local typeList = {}
	for i = 1, #gids do
		local list = ClubUtil.GetGameTypeListByGid(gids[i])
		if list ~= nil then
			for j = 1, #list do
				if not typeMap[list[j]] then
					local cfg = model_manager:GetModel("GameModel"):GetTypeList()[list[j]] -- config_mgr.getConfig("cfg_gametype", list[j])
					table.insert(typeList, cfg)
					typeMap[list[j]] = {}
					typeMap[list[j]][1] = gids[i]
				else
					table.insert(typeMap[list[j]], gids[i])
				end
			end
		end
	end

	if sort then
		table.sort(typeList, ClubUtil.SortGameType)
	end

	return typeList,typeMap
end


function ClubUtil.GetAllGameType(sort)
	local list = config_mgr.getConfigs()
	---  这会把配置表给排序  如果有问题，需要深拷贝再排序
	if sort then
		table.sort(list,  ClubUtil.SortGameType)
	end
	return list
end


function ClubUtil.SortGameType(left, right)
	if left == right then
		return false
	end
	if left == nil then
		return false
	end
	if right == nil then
		return false
	end
	if right.order == nil or left.order == nil then
		return false
	end
	return left.order <= right.order
end


-- 获取某个gid的标签
function ClubUtil.GetGameTypeListByGid(gid)
	if ClubUtil.gidToGameTypeMap == nil then
		ClubUtil.InitGameType()
	end
	if ClubUtil.gidToGameTypeMap[gid] ~= nil then
		return ClubUtil.gidToGameTypeMap[gid]
	else
		return {}
	end
end


function ClubUtil.GetOpenClubGids(clubGids)
	log("开放的俱乐部列表")
	log(GetTblData(clubGids))
	if type(clubGids) =="number" then 
		local gids = {}
		table.insert(gids,clubGids) 
		log(GetTblData(gids))
		return gids
	end
	local legal_gids = {}
	--local open_gids = model_manager:GetModel("GameModel"):GetOpenGidList()
	for _,gid in pairs(clubGids or {}) do
		--if IsTblIncludeValue(gid,open_gids) then
			table.insert(legal_gids,gid)
		--end
	end
	return legal_gids
end


function ClubUtil.GetClubIconName(id)
	if id == nil or ClubUtil.iconIdToNameMap[id] == nil then
		return "icon_27"
	else
		return ClubUtil.iconIdToNameMap[id]
	end
end

function ClubUtil.GetClubMemberCapacity()
	return 50
end

function ClubUtil.GetGameContent(gids, sp, count)
	if gids == nil then
		return ""
	end
	gids = ClubUtil.GetOpenClubGids(gids)
	sp = sp or "、"
	local strTab = {}
	for i = 1, #gids do
		if global_define.CheckHasName(gids[i]) then
			strTab[#strTab + 1] = GameUtil.GetGameName(gids[i])
		end
	end
	local content = table.concat(strTab, sp)
	return ClubUtil.FormatGameStr(content, count)
end


function ClubUtil.CopyClubInfo(dest, source)
	if source == nil then
		return
	end
	for k, v in pairs(source) do
		dest[k] = source[k] 
	end
end


function ClubUtil.InitLocations()
	log("ClubUtil.InitLocations 初始化。。。。。。。")
	local path = data_center.GetAppConfDataTble().appPath.."/config/txt/location/location"
	local locationTxtAsset = newNormalObjSync(path, typeof(UnityEngine.TextAsset))
	locationTxtAsset = '{"100000":{"name":"直辖市","city":{"110000":{"name":"北京市"},"310000":{"name":"上海市"},"120000":{"name":"天津市"},"500000":{"name":"重庆市"}}},"130000":{"name":"河北省","city":{"130100":{"name":"石家庄市"},"130200":{"name":"唐山市"},"130300":{"name":"秦皇岛市"},"130400":{"name":"邯郸市"},"130500":{"name":"邢台市"},"130600":{"name":"保定市"},"130700":{"name":"张家口市"},"130800":{"name":"承德市"},"130900":{"name":"沧州市"},"131000":{"name":"廊坊市"},"131100":{"name":"衡水市"}}},"140000":{"name":"山西省","city":{"140100":{"name":"太原市"},"140200":{"name":"大同市"},"140300":{"name":"阳泉市"},"140400":{"name":"长治市"},"140500":{"name":"晋城市"},"140600":{"name":"朔州市"},"140700":{"name":"晋中市"},"140800":{"name":"运城市"},"140900":{"name":"忻州市"},"141000":{"name":"临汾市"},"141100":{"name":"吕梁市"}}},"150000":{"name":"内蒙古","city":{"150100":{"name":"呼和浩特市"},"150200":{"name":"包头市"},"150300":{"name":"乌海市"},"150400":{"name":"赤峰市"},"150500":{"name":"通辽市"},"150600":{"name":"鄂尔多斯市"},"150700":{"name":"呼伦贝尔市"},"150800":{"name":"巴彦淖尔市"},"150900":{"name":"乌兰察布市"},"152200":{"name":"兴安盟"},"152500":{"name":"锡林郭勒盟"},"152900":{"name":"阿拉善盟"}}},"210000":{"name":"辽宁省","city":{"210100":{"name":"沈阳市"},"210200":{"name":"大连市"},"210300":{"name":"鞍山市"},"210400":{"name":"抚顺市"},"210500":{"name":"本溪市"},"210600":{"name":"丹东市"},"210700":{"name":"锦州市"},"210800":{"name":"营口市"},"210900":{"name":"阜新市"},"211000":{"name":"辽阳市"},"211100":{"name":"盘锦市"},"211200":{"name":"铁岭市"},"211300":{"name":"朝阳市"},"211400":{"name":"葫芦岛市"}}},"220000":{"name":"吉林省","city":{"220100":{"name":"长春市"},"220200":{"name":"吉林市"},"220300":{"name":"四平市"},"220400":{"name":"辽源市"},"220500":{"name":"通化市"},"220600":{"name":"白山市"},"220700":{"name":"松原市"},"220800":{"name":"白城市"},"222400":{"name":"延边朝鲜族自治州"}}},"230000":{"name":"黑龙江省","city":{"230100":{"name":"哈尔滨市"},"230200":{"name":"齐齐哈尔市"},"230300":{"name":"鸡西市"},"230400":{"name":"鹤岗市"},"230500":{"name":"双鸭山市"},"230600":{"name":"大庆市"},"230700":{"name":"伊春市"},"230800":{"name":"佳木斯市"},"230900":{"name":"七台河市"},"231000":{"name":"牡丹江市"},"231100":{"name":"黑河市"},"231200":{"name":"绥化市"},"232700":{"name":"大兴安岭地区"}}},"320000":{"name":"江苏省","city":{"320100":{"name":"南京市"},"320200":{"name":"无锡市"},"320300":{"name":"徐州市"},"320400":{"name":"常州市"},"320500":{"name":"苏州市"},"320600":{"name":"南通市"},"320700":{"name":"连云港市"},"320800":{"name":"淮安市"},"320900":{"name":"盐城市"},"321000":{"name":"扬州市"},"321100":{"name":"镇江市"},"321200":{"name":"泰州市"},"321300":{"name":"宿迁市"}}},"330000":{"name":"浙江省","city":{"330100":{"name":"杭州市"},"330200":{"name":"宁波市"},"330300":{"name":"温州市"},"330400":{"name":"嘉兴市"},"330500":{"name":"湖州市"},"330600":{"name":"绍兴市"},"330700":{"name":"金华市"},"330800":{"name":"衢州市"},"330900":{"name":"舟山市"},"331000":{"name":"台州市"},"331100":{"name":"丽水市"}}},"340000":{"name":"安徽省","city":{"340100":{"name":"合肥市"},"340200":{"name":"芜湖市"},"340300":{"name":"蚌埠市"},"340400":{"name":"淮南市"},"340500":{"name":"马鞍山市"},"340600":{"name":"淮北市"},"340700":{"name":"铜陵市"},"340800":{"name":"安庆市"},"341000":{"name":"黄山市"},"341100":{"name":"滁州市"},"341200":{"name":"阜阳市"},"341300":{"name":"宿州市"},"341400":{"name":"巢湖市"},"341500":{"name":"六安市"},"341600":{"name":"亳州市"},"341700":{"name":"池州市"},"341800":{"name":"宣城市"}}},"350000":{"name":"福建省","city":{"350100":{"name":"福州市"},"350200":{"name":"厦门市"},"350300":{"name":"莆田市"},"350400":{"name":"三明市"},"350500":{"name":"泉州市"},"350600":{"name":"漳州市"},"350700":{"name":"南平市"},"350800":{"name":"龙岩市"},"350900":{"name":"宁德市"}}},"360000":{"name":"江西省","city":{"360100":{"name":"南昌市"},"360200":{"name":"景德镇市"},"360300":{"name":"萍乡市"},"360400":{"name":"九江市"},"360500":{"name":"新余市"},"360600":{"name":"鹰潭市"},"360700":{"name":"赣州市"},"360800":{"name":"吉安市"},"360900":{"name":"宜春市"},"361000":{"name":"抚州市"},"361100":{"name":"上饶市"}}},"370000":{"name":"山东省","city":{"370100":{"name":"济南市"},"370200":{"name":"青岛市"},"370300":{"name":"淄博市"},"370400":{"name":"枣庄市"},"370500":{"name":"东营市"},"370600":{"name":"烟台市"},"370700":{"name":"潍坊市"},"370800":{"name":"济宁市"},"370900":{"name":"泰安市"},"371000":{"name":"威海市"},"371100":{"name":"日照市"},"371200":{"name":"莱芜市"},"371300":{"name":"临沂市"},"371400":{"name":"德州市"},"371500":{"name":"聊城市"},"371600":{"name":"滨州市"},"371700":{"name":"荷泽市"}}},"410000":{"name":"河南省","city":{"410100":{"name":"郑州市"},"410200":{"name":"开封市"},"410300":{"name":"洛阳市"},"410400":{"name":"平顶山市"},"410500":{"name":"安阳市"},"410600":{"name":"鹤壁市"},"410700":{"name":"新乡市"},"410800":{"name":"焦作市"},"410900":{"name":"濮阳市"},"411000":{"name":"许昌市"},"411100":{"name":"漯河市"},"411200":{"name":"三门峡市"},"411300":{"name":"南阳市"},"411400":{"name":"商丘市"},"411500":{"name":"信阳市"},"411600":{"name":"周口市"},"411700":{"name":"驻马店市"}}},"420000":{"name":"湖北省","city":{"420100":{"name":"武汉市"},"420200":{"name":"黄石市"},"420300":{"name":"十堰市"},"420500":{"name":"宜昌市"},"420600":{"name":"襄樊市"},"420700":{"name":"鄂州市"},"420800":{"name":"荆门市"},"420900":{"name":"孝感市"},"421000":{"name":"荆州市"},"421100":{"name":"黄冈市"},"421200":{"name":"咸宁市"},"421300":{"name":"随州市"},"422800":{"name":"恩施土家族苗族自治州"}}},"430000":{"name":"湖南省","city":{"430100":{"name":"长沙市"},"430200":{"name":"株洲市"},"430300":{"name":"湘潭市"},"430400":{"name":"衡阳市"},"430500":{"name":"邵阳市"},"430600":{"name":"岳阳市"},"430700":{"name":"常德市"},"430800":{"name":"张家界市"},"430900":{"name":"益阳市"},"431000":{"name":"郴州市"},"431100":{"name":"永州市"},"431200":{"name":"怀化市"},"431300":{"name":"娄底市"},"433100":{"name":"湘西土家族苗族自治州"}}},"440000":{"name":"广东省","city":{"440100":{"name":"广州市"},"440200":{"name":"韶关市"},"440300":{"name":"深圳市"},"440400":{"name":"珠海市"},"440500":{"name":"汕头市"},"440600":{"name":"佛山市"},"440700":{"name":"江门市"},"440800":{"name":"湛江市"},"440900":{"name":"茂名市"},"441200":{"name":"肇庆市"},"441300":{"name":"惠州市"},"441400":{"name":"梅州市"},"441500":{"name":"汕尾市"},"441600":{"name":"河源市"},"441700":{"name":"阳江市"},"441800":{"name":"清远市"},"441900":{"name":"东莞市"},"442000":{"name":"中山市"},"445100":{"name":"潮州市"},"445200":{"name":"揭阳市"},"445300":{"name":"云浮市"}}},"450000":{"name":"广西","city":{"450100":{"name":"南宁市"},"450200":{"name":"柳州市"},"450300":{"name":"桂林市"},"450400":{"name":"梧州市"},"450500":{"name":"北海市"},"450600":{"name":"防城港市"},"450700":{"name":"钦州市"},"450800":{"name":"贵港市"},"450900":{"name":"玉林市"},"451000":{"name":"百色市"},"451100":{"name":"贺州市"},"451200":{"name":"河池市"},"451300":{"name":"来宾市"},"451400":{"name":"崇左市"}}},"460000":{"name":"海南省","city":{"460100":{"name":"海口市"},"460200":{"name":"三亚市"}}},"510000":{"name":"四川省","city":{"510100":{"name":"成都市"},"510300":{"name":"自贡市"},"510400":{"name":"攀枝花市"},"510500":{"name":"泸州市"},"510600":{"name":"德阳市"},"510700":{"name":"绵阳市"},"510800":{"name":"广元市"},"510900":{"name":"遂宁市"},"511000":{"name":"内江市"},"511100":{"name":"乐山市"},"511300":{"name":"南充市"},"511400":{"name":"眉山市"},"511500":{"name":"宜宾市"},"511600":{"name":"广安市"},"511700":{"name":"达州市"},"511800":{"name":"雅安市"},"511900":{"name":"巴中市"},"512000":{"name":"资阳市"},"513200":{"name":"阿坝藏族羌族自治州"},"513300":{"name":"甘孜藏族自治州"},"513400":{"name":"凉山彝族自治州"}}},"520000":{"name":"贵州省","city":{"520100":{"name":"贵阳市"},"520200":{"name":"六盘水市"},"520300":{"name":"遵义市"},"520400":{"name":"安顺市"},"522200":{"name":"铜仁地区"},"522300":{"name":"黔西南布依族苗族自治州"},"522400":{"name":"毕节地区"},"522600":{"name":"黔东南苗族侗族自治州"},"522700":{"name":"黔南布依族苗族自治州"}}},"530000":{"name":"云南省","city":{"530100":{"name":"昆明市"},"530300":{"name":"曲靖市"},"530400":{"name":"玉溪市"},"530500":{"name":"保山市"},"530600":{"name":"昭通市"},"530700":{"name":"丽江市"},"530800":{"name":"思茅市"},"530900":{"name":"临沧市"},"532300":{"name":"楚雄彝族自治州"},"532500":{"name":"红河哈尼族彝族自治州"},"532600":{"name":"文山壮族苗族自治州"},"532800":{"name":"西双版纳傣族自治州"},"532900":{"name":"大理白族自治州"},"533100":{"name":"德宏傣族景颇族自治州"},"533300":{"name":"怒江傈僳族自治州"},"533400":{"name":"迪庆藏族自治州"}}},"540000":{"name":"西藏","city":{"540100":{"name":"拉萨市"},"542100":{"name":"昌都地区"},"542200":{"name":"山南地区"},"542300":{"name":"日喀则地区"},"542400":{"name":"那曲地区"},"542500":{"name":"阿里地区"},"542600":{"name":"林芝地区"}}},"610000":{"name":"陕西省","city":{"610100":{"name":"西安市"},"610200":{"name":"铜川市"},"610300":{"name":"宝鸡市"},"610400":{"name":"咸阳市"},"610500":{"name":"渭南市"},"610600":{"name":"延安市"},"610700":{"name":"汉中市"},"610800":{"name":"榆林市"},"610900":{"name":"安康市"},"611000":{"name":"商洛市"}}},"620000":{"name":"甘肃省","city":{"620100":{"name":"兰州市"},"620200":{"name":"嘉峪关市"},"620300":{"name":"金昌市"},"620400":{"name":"白银市"},"620500":{"name":"天水市"},"620600":{"name":"武威市"},"620700":{"name":"张掖市"},"620800":{"name":"平凉市"},"620900":{"name":"酒泉市"},"621000":{"name":"庆阳市"},"621100":{"name":"定西市"},"621200":{"name":"陇南市"},"622900":{"name":"临夏回族自治州"},"623000":{"name":"甘南藏族自治州"}}},"630000":{"name":"青海省","city":{"630100":{"name":"西宁市"},"632100":{"name":"海东地区"},"632200":{"name":"海北藏族自治州"},"632300":{"name":"黄南藏族自治州"},"632500":{"name":"海南藏族自治州"},"632600":{"name":"果洛藏族自治州"},"632700":{"name":"玉树藏族自治州"},"632800":{"name":"海西蒙古族藏族自治州"}}},"640000":{"name":"宁夏","city":{"640100":{"name":"银川市"},"640200":{"name":"石嘴山市"},"640300":{"name":"吴忠市"},"640400":{"name":"固原市"},"640500":{"name":"中卫市"}}},"650000":{"name":"新疆","city":{"650100":{"name":"乌鲁木齐市"},"650200":{"name":"克拉玛依市"},"652100":{"name":"吐鲁番地区"},"652200":{"name":"哈密地区"},"652300":{"name":"昌吉回族自治州"},"652700":{"name":"博尔塔拉蒙古自治州"},"652800":{"name":"巴音郭楞蒙古自治州"},"652900":{"name":"阿克苏地区"},"653000":{"name":"克孜勒苏柯尔克孜自治州"},"653100":{"name":"喀什地区"},"653200":{"name":"和田地区"},"654000":{"name":"伊犁哈萨克自治州"},"654200":{"name":"塔城地区"},"654300":{"name":"阿勒泰地区"}}},"990000":{"name":"其他地区","city":{"810000":{"name":"香港"},"820000":{"name":"澳门"},"710000":{"name":"台湾"}}}}'
	if locationTxtAsset == nil then
		logError("加载不到location.txt")
		return
	end
	ClubUtil.locationTab = ParseJsonStr(locationTxtAsset.text)
	ClubUtil.InitLocationMap()
end

function ClubUtil.GetProvinceCitys(id)
	id = tostring(id - id % 10000)
	if ClubUtil.locationProvinceToCityMap[id] == nil then
		return {}
	end
	return ClubUtil.locationProvinceToCityMap[id]
end


function ClubUtil.GetProvinceId(cityId)
	local provinceid = tostring(cityId - cityId % 10000)
	return provinceid
end

function ClubUtil.InitLocationMap()
	ClubUtil.locationProvinceToCityMap = {}
	ClubUtil.provinceIdList = {}
	for provinceid, province in pairs(ClubUtil.locationTab) do
		if ClubUtil.locationProvinceToCityMap[provinceid] == nil then
			ClubUtil.locationProvinceToCityMap[provinceid] = {}
		end
		table.insert(ClubUtil.provinceIdList, {provinceid, province.name})
		if province.city ~= nil then
			for id, city in pairs(province.city) do
				table.insert(ClubUtil.locationProvinceToCityMap[provinceid], {id, city.name})
			end
			Utils.sort(ClubUtil.locationProvinceToCityMap[provinceid], function(a,b) return a[1] > b[1] end)
		else
			table.insert(ClubUtil.locationProvinceToCityMap[provinceid], {provinceid, province.name})
		end
	end

	Utils.sort(ClubUtil.provinceIdList, function(a,b) return a[1] > b[1] end)
end

function ClubUtil.SearchClubSortFunc(clubA, clubB)
	if clubA == nil or clubB == nil then
		return false
	end
	if model_manager:GetModel("ClubModel"):IsClubMember(clubA.cid) then
		return false
	end
	if model_manager:GetModel("ClubModel"):IsClubMember(clubB.cid) then
		return true
	end
	return false
end


function ClubUtil.RoomListSortFunc(clubA, clubB)
	if clubA == nil or clubB == nil then
		return false
	end
	if clubA.uid == clubB.uid  then
		return false
	end
	if clubA.uid == model_manager:GetModel("ClubModel").selfPlayerId then
		return true
	elseif clubB.uid == model_manager:GetModel("ClubModel").selfPlayerId then
		return false
	end
	return false
end

function ClubUtil.FormatGameStr(content, maxCount)
	if maxCount == nil then
		return content
	end
	if Utils.utf8len(content) <= maxCount then
		return content
	end
	local str = Utils.utf8sub(content, 1, maxCount - 1)
	return str .. "..."
end


function ClubUtil.OpenCreateClub()
	UI_Manager:Instance():ShowUiForms("ClubCreateUI")
end


function ClubUtil.CloseCreateClub()
	UI_Manager:Instance():CloseUiForms("ClubCreateUI")
end

function ClubUtil.GetLocationNameById(id, defaultStr)

	defaultStr = defaultStr or "中国"
	if id == nil then
		return defaultStr
	end
	id = tostring(id)
	local info

	if id % 10000 == 0 then
		--info = ClubUtil.locationTab["100000"].city[id] or ClubUtil.locationTab["990000"].city[id]
		info = {name="北京市"}
	else
		local province = tostring(id  - id % 10000)
		if ClubUtil.locationTab[province] ~= nil then
			if id % 100 == 0 then
				info = ClubUtil.locationTab[province].city[id]
			else
				local city = ClubUtil.locationTab[province].city[tostring(id - id * 100)]
				if city ~= nil and city.area ~= nil then
					info = city.area[id]
				end
			end
		end
	end

	-- -- city
	-- if id % 100 == 0 then
	-- 	info = ClubUtil.locationTab.city[id]
	-- else
	-- 	local cityId = id - id % 100 
	-- 	local city = ClubUtil.locationTab.city[tostring(cityId)]
	-- 	if city ~= nil then
	-- 		info = city.area[id]
	-- 	end
	-- end
	if info == nil then
		return  defaultStr
	else
		return info.name
	end
end

