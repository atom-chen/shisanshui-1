--[[--
 * @Description: mahjong operation component
 * @Author:      ShushingWong
 * @FileName:    comp_operatorcard.lua
 * @DateTime:    2017-06-20 15:24:36
 ]]

comp_operatorcard = {}

function comp_operatorcard.create()
	require "logic/mahjong_sys/mode_components/mode_comp_base"
	local this = mode_comp_base.create()
	this.Class = comp_operatorcard
	this.name = "comp_operatorcard"


	this.operObj =nil --操作组对象
	this.operData = nil --操作组数据
	this.keyItem = nil --关键牌，通过需要做特殊旋转的牌
	this.itemList = {} --操作组麻将列表

	this.base_init = this.Initialize

	function this:Initialize()
		this.base_init()
	end

	--[[--
	 * @Description: 创建操作对象  
	 ]]
	local function CreateOperObj()
		this.operObj = GameObject.New()
		this.operObj.name = "oper_root"
	end

	--[[--

	 * @Description: 获取总宽度  
	 ]]

	function this:GetWidth()
		if this.operData.operType == MahjongOperAllEnum.Collect then
			return mahjongConst.MahjongOffset_x * 3
		end

		if this.operData.operType == MahjongOperAllEnum.TripletLeft or
			this.operData.operType == MahjongOperAllEnum.TripletCenter or
			this.operData.operType == MahjongOperAllEnum.TripletRight then
			return mahjongConst.MahjongOffset_x * 2 + mahjongConst.MahjongOffset_z
		end

		if this.operData.operType == MahjongOperAllEnum.DarkBar then
			return mahjongConst.MahjongOffset_x * 4
		end

		if this.operData.operType == MahjongOperAllEnum.BrightBarLeft or
			this.operData.operType == MahjongOperAllEnum.BrightBarCenter or
			this.operData.operType == MahjongOperAllEnum.BrightBarRight then
			return mahjongConst.MahjongOffset_x * 3 + mahjongConst.MahjongOffset_z
		end

		if this.operData.operType == MahjongOperAllEnum.AddBar or
			this.operData.operType == MahjongOperAllEnum.AddBarLeft or
			this.operData.operType == MahjongOperAllEnum.AddBarCenter or
			this.operData.operType == MahjongOperAllEnum.AddBarRight then
			return mahjongConst.MahjongOffset_x * 3 + mahjongConst.MahjongOffset_z
		end

		return 0
	end

	--[[--
	 * @Description: 显示  
	 ]]
	function this:Show(operData, operCardList)
		this.operData = operData
		this.itemList = operCardList
		local keyIndex = operData:GetKeyCardIndex()
		if(keyIndex>0) then
			this.keyItem = operCardList[keyIndex]
		end
		local xOffset = 0
		for i=1,#operCardList do
			operCardList[i].mjObj.transform:SetParent(this.operObj.transform, false)

			if(i == keyIndex) then
				operCardList[i].mjObj.transform:DOLocalMove(

                    Vector3(xOffset, 0, mahjongConst.MahjongOffset_z / 4-mahjongConst.MahjongOffset_x/2), 
                    0.05,
                    false)
                operCardList[i].mjObj.transform:DOLocalRotate(Vector3(0,90,0), 0.05, DG.Tweening.RotateMode.Fast)
            else
            	operCardList[i].mjObj.transform:DOLocalMove(Vector3(xOffset, 0, 0), 0.05, false)
            	if operData.operType == MahjongOperAllEnum.DarkBar and i~=1 then
	            	operCardList[i].mjObj.transform:DOLocalRotate(Vector3(0, 0, 180), 0.05, DG.Tweening.RotateMode.Fast)
	            else
	            	operCardList[i].mjObj.transform:DOLocalRotate(Vector3.zero, 0.05, DG.Tweening.RotateMode.Fast)
	            end
            end

            if (i == keyIndex or i == keyIndex-1)then
                xOffset = xOffset + (mahjongConst.MahjongOffset_x+ mahjongConst.MahjongOffset_z)/ 2
            else
                xOffset = xOffset + mahjongConst.MahjongOffset_x
            end

            RecursiveSetLayerVal(operCardList[i].mjObj.transform, this.operObj.layer)
		end
	end


	--[[--
	 * @Description: 在操作组上加一个牌  
	 * @param:       isChangeToBright 是否变成明杠 
	 ]]
	function this:AddShow(operData, mj,isChangeToBright)
		mj.mjObj.transform:SetParent(this.operObj.transform, false)

		if isChangeToBright then
			print("AddShow-----------this.operData "..tostring(this.operData))
			if this.operData.operType == MahjongOperAllEnum.TripletLeft or this.operData.operType == MahjongOperAllEnum.TripletCenter then
				mj.mjObj.transform:DOLocalMove(
				this.itemList[#this.itemList].mjObj.transform.localPosition + Vector3(mahjongConst.MahjongOffset_x, 0, 0), 
				0.05,
				false)
	        	mj.mjObj.transform:DOLocalRotate(Vector3.zero, 0.05, DG.Tweening.RotateMode.Fast)
	        elseif this.operData.operType == MahjongOperAllEnum.TripletRight then
	        	mj.mjObj.transform:DOLocalMove(
				this.itemList[1].mjObj.transform.localPosition, 
				0.05,
				false)
	        	mj.mjObj.transform:DOLocalRotate(Vector3.zero, 0.05, DG.Tweening.RotateMode.Fast)
	        	for i,v in ipairs(this.itemList) do
	        		v.mjObj.transform:DOLocalMove(
					v.mjObj.transform.localPosition + Vector3(mahjongConst.MahjongOffset_x, 0, 0), 
					0.05,
					false)
	        	end
	        end
		else
			mj.mjObj.transform:DOLocalMove(
				this.keyItem.mjObj.transform.localPosition + Vector3(0, 0, mahjongConst.MahjongOffset_x), 
				0.05,
				false)
	        mj.mjObj.transform:DOLocalRotate(Vector3(0, 90, 0), 0.05, DG.Tweening.RotateMode.Fast)
	    end
	    this.operData = operData
	    table.insert(this.itemList,mj)
        RecursiveSetLayerVal(mj.mjObj.transform, this.operObj.layer)
	end

	--[[--
	 * @Description: 断线恢复  
	 ]]
	function this:ReShow( operData, operCardList )
		this.operData = operData
		this.itemList = operCardList
		local keyIndex = operData:GetKeyCardIndex()
		if(keyIndex>0) then
			this.keyItem = operCardList[keyIndex]
		end
		local xOffset = 0
		for i=1,#operCardList do
			operCardList[i].mjObj.transform:SetParent(this.operObj.transform, false)

			if(i == keyIndex) then

				operCardList[i].mjObj.transform.localPosition = Vector3(xOffset, 0, mahjongConst.MahjongOffset_z / 4-mahjongConst.MahjongOffset_x/2)
                operCardList[i].mjObj.transform.localEulerAngles = Vector3(0,90,0)
            else
            	operCardList[i].mjObj.transform.localPosition = Vector3(xOffset, 0, 0)
            	if operData.operType == MahjongOperAllEnum.DarkBar and i~=1 then
	            	operCardList[i].mjObj.transform.localEulerAngles=Vector3(0, 0, 180)
	            else
	            	operCardList[i].mjObj.transform.localEulerAngles=Vector3.zero
	            end
            end

            if (i == keyIndex or i == keyIndex-1)then
                xOffset = xOffset + (mahjongConst.MahjongOffset_x+ mahjongConst.MahjongOffset_z)/ 2
            else
                xOffset = xOffset + mahjongConst.MahjongOffset_x
            end

            RecursiveSetLayerVal(operCardList[i].mjObj.transform, this.operObj.layer)
		end
	end

	this.base_unInit = this.Uninitialize
	
	function this:Uninitialize()
		this.base_unInit()
	end

	CreateOperObj()

	return this
end