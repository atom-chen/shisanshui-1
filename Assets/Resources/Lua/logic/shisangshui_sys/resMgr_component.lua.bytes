resMgr_component = {}
--this.cardMeshs = {}

--[[
function this.LoadCardMesh()
	local resCardMeshObj = newNormalObjSync("Prefabs/Scene/shisangshui/Poker")
	local meshFilters = resCardMeshObj:GetComponentsInChildren(typeof(UnityEngine.MeshFilter))
	for i = 0, meshFilters.Length - 1,1 do
		table.insert(this.cardMeshs,meshFilters[i].sharedMesh)
		
	end
end
	
function this.GetCardMesh(index)
	local mesh = this.cardMeshs[index+1]
	if mesh == nil then
		log("GetCardMesh !!!!!!!!!!!!!!!!!!!!!!!!!! error !!!!!!!!! index"..index)
	end
	return mesh
end
]]

function resMgr_component.create()
	require "logic/mahjong_sys/mode_components/mode_comp_base"
	local this = mode_comp_base.create()
	this.Class = resMgr_component
	this.name = "resMgr_component"
		
	this.cardMeshs = {}	
	
	local highLightMat = nil 

	this.base_init = this.Initialize
	function this:Initialize()
		this.base_init()
	end
	
	this.base_unInit = this.Uninitialize	
	function this:Uninitialize()
		this.base_unInit()
	end

	function this.LoadCardMesh()
		local resCardMeshObj = newNormalObjSync("Prefabs/Scene/shisangshui/Poker")
		local meshFilters = resCardMeshObj:GetComponentsInChildren(typeof(UnityEngine.MeshFilter))
		for i = 0, meshFilters.Length - 1,1 do
			table.insert(this.cardMeshs,meshFilters[i].sharedMesh)		
		end
	end
		
	function this.GetCardMesh(index)
		local mesh = this.cardMeshs[index+1]
		if mesh == nil then
			log("GetCardMesh !!!!!!!!!!!!!!!!!!!!!!!!!! error !!!!!!!!! index"..index)
		end
		return mesh
	end		
	
    --[[--
     * @Description: 加载高亮材质  
     ]]
    local function LoadHighLightMat()
        highLightMat = newNormalObjSync("shisanshui/meterials/poker_highlight", typeof(UnityEngine.Material))
    end

    --[[--
     * @Description: 获取高亮材质  
     ]]
    function this.GetHighLightMat()
        return highLightMat
    end


	log("----------------------LoadCardMesh")
 	--LoadCardMesh()
	return this
	
end