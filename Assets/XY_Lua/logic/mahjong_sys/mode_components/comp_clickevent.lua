--[[--
 * @Description: mahjong click event component
 * @Author:      ShushingWong
 * @FileName:    comp_clickevent.lua
 * @DateTime:    2017-06-20 15:21:03
 ]]

comp_clickevent = {}

function comp_clickevent.create()
	require "logic/mahjong_sys/mode_components/mode_comp_base"
	local this = mode_comp_base.create()
	this.Class = comp_clickevent
	this.name = "comp_clickevent"


      this.Camera2D = nil--2D相机comp
      local cameraMain = nil--主摄像机comp
      local comp_mjItemMgr = nil--麻将子管理组件
      local ray = nil--射线
      local isCast = false--是否碰撞
      local rayhit = nil--碰撞体


	this.base_init = this.Initialize

	function this:Initialize()
		this.base_init()
            this.Init()
	end

      --[[--
       * @Description: 初始化  
       ]]
      function this.Init()

            this.Camera2D = GameObject.Find("2D Camera"):GetComponent(typeof(Camera))
            cameraMain = Camera.main
            comp_mjItemMgr = mode_manager.GetCurrentMode():GetComponent("comp_mjItemMgr")
      end

	this.base_unInit = this.Uninitialize
	
	function this:Uninitialize()
		this.base_unInit()
	end



	function this:Update()
		if(Input.GetMouseButtonUp(0)) then
                  ray = this.Camera2D:ScreenPointToRay(Input.mousePosition)
                  --ray = cameraMain:ScreenPointToRay(Input.mousePosition)
                  
                  if ray ~= nil then
                        isCast, rayhit = Physics.Raycast(ray, nil)
                  end
                  if(isCast) then
                  	local tempObj = rayhit.collider.gameObject
                  	if (tempObj.name == "mjobj") then                                 	
                  		local mjComp = comp_mjItemMgr.mjObjDict[tempObj.transform.parent.gameObject]
                  		if(mjComp~=nil) then
                                    if mjComp.isDrag then
                                          return
                                    end
                  			if mjComp.eventPai~=nil then
                  				mjComp.eventPai(mjComp)
                                          return
                  			else
                  				log("Click not hand card")
                  			end
                  		else
                                    if tempObj.transform.parent.gameObject.name == "MJ(Clone)" then
                                          tempObj.transform.parent.gameObject:SetActive(false)
                                    end
                  			log("!!!!!!!!!!!!!mjComp error")
                  		end
                  	end
                  end
                  this.mode:GetComponent("comp_playerMgr"):GetPlayer(1):CancelClick()
            end
	end

	return this
end