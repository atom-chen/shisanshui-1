--[[--
 * @Description: mahjong resourse manager
 * @Author:      ShushingWong
 * @FileName:    comp_resMgr.lua
 * @DateTime:    2017-06-20 15:25:30
 ]]

comp_resMgr = {}

function comp_resMgr.create()
	require "logic/mahjong_sys/mode_components/mode_comp_base"
	local this = mode_comp_base.create()
	this.Class = comp_resMgr
	this.name = "comp_resMgr"

    local mjMeshs = {} --麻将mesh列表
    local outCardEfObj = nil -- 出牌标志
    local highLightMat = nil -- 高亮材质

	this.base_init = this.Initialize

	function this:Initialize()
		this.base_init()
	end

    --[[--
     * @Description: 加载麻将网格  
     ]]
    local function LoadMJMesh()
        local resMJMeshObj = newNormalObjSync("Prefabs/Scene/Mahjong/MahjongTiles", typeof(GameObject))
        local meshFilters = resMJMeshObj:GetComponentsInChildren(typeof(UnityEngine.MeshFilter))
        for i = 0,meshFilters.Length-1,1 do
            table.insert(mjMeshs, meshFilters[i].sharedMesh)
        end
    end

    --[[--
     * @Description: 初始化出牌标志
     ]]
    local function InitOutCardEfObj()
        local outCardEfRes = newNormalObjSync("Prefabs/Scene/Mahjong/jiantou", typeof(GameObject))
        outCardEfObj = newobject(outCardEfRes)        
    end
    
    --[[--
     * @Description: 加载高亮材质  
     ]]
    local function LoadHighLightMat()
        highLightMat = newNormalObjSync("Materials/MahjongTileSpecular_new_blue", typeof(UnityEngine.Material))
    end

    --[[--
     * @Description: 获取麻将mesh  
     ]]
    function this:GetMahjongMesh(index)
    	local mesh = mjMeshs[index]
    	if mesh == nil then
    		print("GetMahjongMesh !!!!!!!!!!!!!!!!!!!!!!!!!! error !!!!!!!!! index"..index)
    	end
        return mesh
    end

    function this:GetOutCardEfObj()
        return outCardEfObj
    end

    --[[--
     * @Description: 设置出牌标志  
     ]]
    function this:SetOutCardEfObj(pos)
        outCardEfObj.transform.position = pos
    end

    --[[--
     * @Description: 隐藏出牌标志  
     ]]
    function this:HideOutCardEfObj()
        outCardEfObj.transform.position = outCardEfObj.transform.position + Vector3(0,-1,0)
    end

    --[[--
     * @Description: 获取高亮材质  
     ]]
    function this:GetHighLightMat()
        return highLightMat
    end

    local mjItemPool = {} --麻将子克隆池

    --[[--
     * @Description: 创建一个麻将子克隆  
     ]]
    function this:CeateMJItem(original)
        local mj
        if #mjItemPool >0 then
            mj = mjItemPool[#mjItemPool]
            table.remove(mjItemPool,#mjItemPool)
        else
            mj = comp_mjItem.create()
        end
        if original~=nil then
            mj.mjObj.transform.position = original.mjObj.transform.position
            mj.mjObj.transform.eulerAngles = original.mjObj.transform.eulerAngles
            mj:SetMesh(original.paiValue)
            mj:SetHun(original.isHun)
            RecursiveSetLayerVal(mj.mjObj.transform,original.mjModelObj.layer)
        end
        mj.mjObj:SetActive(true)
        return mj
    end

    --[[--
     * @Description: 销毁一个麻将子克隆  
     ]]
    function this:DestroyMJItem(mj)
        mj.mjObj:SetActive(false)
        table.insert(mjItemPool,mj)
    end

	this.base_unInit = this.Uninitialize
	
	function this:Uninitialize()
		this.base_unInit()
        if not IsNil(outCardEfObj) then
            GameObject.DestroyImmediate(outCardEfObj)
        end
        for i,v in ipairs(mjItemPool) do
            if v~=nil then
                v:Uninitialize()
            end
        end
	end

    LoadMJMesh()
    InitOutCardEfObj()
    LoadHighLightMat()

	return this
end