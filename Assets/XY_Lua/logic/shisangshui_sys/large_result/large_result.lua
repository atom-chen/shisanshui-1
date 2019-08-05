require "logic/network/http_request_interface"
require "logic/mahjong_sys/_model/room_usersdata_center"
require "logic/shisangshui_sys/shisangshui_play_sys"

large_result =ui_base.New()
local this =large_result
local transform



function this.Awake()
   this.initinfor()   
  	--this.registerevent() 
end


function this.Show()
	if this.gameObject == nil then
		require "logic/shisangshui_sys/large_result/large_result"
		this.gameObject = newNormalUI("Prefabs/UI/LargeResult/large_result")
	else
		this.gameObject:SetActive(true)
	end
	
	--his.LoadAllResult()
	require "logic/hall_sys/openroom/room_data"
	print("总结算")
	if room_data.GetRid() == nil then
		print("---room_data.rid == nil-----")
    else
		---根据房id查找房间信息 {"rid":房号}
		http_request_interface.getRoomByRid(room_data.GetRid(),1,this.OnGetRoomReturnDate) 
	end
	roomdata_center.isStart = false
  	--this.addlistener()
end

--[[--
 * @Description: 逻辑入口  
 ]]
function this.Start()
	this.registerevent()
end


--[[--
 * @Description: 销毁  
 ]]
function this.OnDestroy()
end

function this.initinfor()
	print("Large_Result initinfor")
end
	
	

function this.Hide()
	if this.gameObject == nil then
		return
	else
		GameObject.Destroy(this.gameObject)
		this.gameObject = nil
	end
end

--注册事件
function this.registerevent()
	local endbtn = child(this.transform, "Panel/endbtn")
	if endbtn ~= nil then
		UIEventListener.Get(endbtn.gameObject).onClick = this.EndBtnClick
	end
    local btn_share=child(this.transform,"Panel/sharebtn")
    if btn_share ~= nil then
		UIEventListener.Get(btn_share.gameObject).onClick = this.ShareClick
	end
end


function this.LoadAllResult(result)
	local compTemp=0
	local highestNum
	for i = 1, 6 do
		local trans0 = child(this.transform, "Panel/userGrid/user"..i)
		trans0.gameObject:SetActive(false)
	end
	for k, v in pairs(result) do
	--for i = 1, 6 do
		local i = room_usersdata_center.GetLogicSeatByStr(k)	
		if v ~= nil then	
			print("总结算数据单条"..tostring(i))
			
			local trans = child(this.transform, "Panel/userGrid/user"..i)
			trans.gameObject:SetActive(true)
							-----------------总结算用户信息-----------------------
			--[[ 名字等接微信
			local tran = child(this.transform,"Panel/userGrid/user"..i.."/namelbl")
			if tran~=nil then
			print("tran")
			end
			local NameLbl = componentGet(tran, "UILabel")
			NameLbl.text=result[i].name
			--]]
			local obj1 = child(this.transform,"Panel/userGrid/user"..i.."/IDlbl")
			local IDLbl = componentGet(obj1, "UILabel")
			local obj2 = child(this.transform,"Panel/userGrid/user"..i.."/namelbl")
			local NameLbl = componentGet(obj2, "UILabel")
			
							-----------------总结算获胜情况-----------------------		
			local winLbl = componentGet(child(this.transform,"Panel/userGrid/user"..i.."/winState/count1"), "UILabel")
			local shotLbl = componentGet(child(this.transform,"Panel/userGrid/user"..i.."/winState/count2"), "UILabel")
			local allshotLbl = componentGet(child(this.transform,"Panel/userGrid/user"..i.."/winState/count3"), "UILabel")
			local specialLbl = componentGet(child(this.transform,"Panel/userGrid/user"..i.."/winState/count4"), "UILabel")
			local tex_photo= componentGet(child(this.transform, "Panel/userGrid/user"..i.."/picFrame"), "UITexture")
            print("---------------------------------------------------------------------------")    
            print(room_usersdata_center.GetUserByLogicSeat(i).headurl.."room_usersdata_center.GetUserByLogicSeat(number).headurl")
            print(i.."tex_photo.name")
            hall_data.getuserimage(tex_photo,2,room_usersdata_center.GetUserByLogicSeat(i).headurl)
            print("---------------------------------------------------------------------------")
			
			IDLbl.text="ID:"..v.uid
			NameLbl.text=v.nickname
			local score = v["score"]
			for i = 1, #score do
				if score[i]["nWinNums"] ~= nil then
					winLbl.text="次数：".. score[i]["nWinNums"] .."次"
				end
				if score[i]["nShootNums"] ~= nil then
					shotLbl.text="次数：".. score[i]["nShootNums"] .."次"
				end
				if score[i]["nAllShootNums"] ~= nil then
					allshotLbl.text="次数：".. score[i]["nAllShootNums"] .."次"
				end
				if score[i]["nSpecialNums"] ~= nil then
					specialLbl.text="次数：".. score[i]["nSpecialNums"] .."次"
				end
			end
			
			local totalScores=v.all_score	
			----取最高分的i----
			if compTemp <= totalScores then	
				compTemp = totalScores
				highestNum = i 
			end
			local reduceScoreLbl = componentGet(child(this.transform, "Panel/userGrid/user"..i.."/winState/negScore"), "UILabel")
			local addScoreLbl = componentGet(child(this.transform, "Panel/userGrid/user"..i.."/winState/posScore"), "UILabel")
			if totalScores<=0 then
				reduceScoreLbl.text = tostring(totalScores)
				reduceScoreLbl.gameObject:SetActive(true)
				addScoreLbl.gameObject:SetActive(false)
			else
				addScoreLbl.text ="+"..totalScores
				reduceScoreLbl.gameObject:SetActive(false)
				addScoreLbl.gameObject:SetActive(true)
			end
		end
		--]]
		print("large result user"..k.."=nil")
	end
	this.ShowHighest(highestNum)
	local grid = componentGet(child(this.transform,"Panel/userGrid"), "UIGrid")
	grid.enabled = true
end

---------http回调处理--------
function this.OnGetRoomReturnDate(code,m,str)
	local s=string.gsub(str,"\\/","/")
	print("-------this.OnGetRoomReturnDate-------"..tostring(s))
    local t=ParseJsonStr(s)
    if tonumber(t.ret)~=0 then
        return
    end
	
	local ownerIndex=t["data"].accountc.banker
	local reward = t["data"].accountc.rewards
	if reward == nil then
		print("reward == nil")
	else
		print("总结算")
		this.LoadAllResult(reward)
		this.ShowOwner(ownerIndex) ---房主
	end
end

function this.EndBtnClick(obj)
	this.Hide()
	shisangshui_play_sys.LeaveReq()
end

function this.ShareClick(obj)
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    print("share")
    YX_MoblieAPI.Instance:GetCenterPicture("screenshot.png")
    YX_MoblieAPI.Instance.onfinishtx=function(tx) 
        local shareType = 0--0微信好友，1朋友圈，2微信收藏
        local contentType = 2 --1文本，2图片，3声音，4视频，5网页
        local title = "我在测试"  
        local filePath = YX_APIManage.Instance:onGetStoragePath().."screenshot.png"
        local url = "http://connect.qq.com/"
        local description = "test"
        YX_APIManage.Instance:WeiXinShare(shareType,contentType,title,filePath,url,description)
    end
end
------最高分加特技------
function this.ShowHighest(i)
	local winCrown=componentGet(child(this.transform, "Panel/userGrid/user"..i.."/crown"), "UISprite")
	local winFrame=componentGet(child(this.transform, "Panel/userGrid/user"..i.."/frame"), "UISprite")
	winCrown.gameObject:SetActive(true)
	winFrame.gameObject:SetActive(true)
end

function this.ShowOwner(i)
	local fangzhu=componentGet(child(this.transform, "Panel/userGrid/user"..i.."/fangzhu"), "UISprite")
	fangzhu.gameObject:SetActive(true)
end