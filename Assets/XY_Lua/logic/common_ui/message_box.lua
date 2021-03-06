--[[--
 * @Description: 弹框提示
 * @Author:      shine
 * @FileName:    message_box.lua
 * @DateTime:    2015-07-06 19:52
 ]]

message_box = ui_base.New() 
local this=message_box  
 
--[[--
	 * @Description: 显示UI
	                title: 标题，可以为空
					content: 正文，可以为空
					btnNumber: 按钮数量，不能超过 3
					btnCallback: 事件回调，带一个参数(index)：点击了第几个按钮，-1表示关闭按钮, 可以为空----table类型
                    btbname:fonts_01 确定，fonts_02 取消，fonts_05 放弃，fonts_06 充值，fonts_07立即领取， 

	 * @Return:     message_box 类对象，可以操纵其它接口

	 ]]
 
function message_box.ShowGoldBox(content,goldNumber,btnNumber,btnCallback,btnname,btnbacksprite, closeCallback)
    message_box:Close()
    local obj = newNormalUI("Prefabs/UI/Common/message_box")
    validPosition = obj.transform.position
    validPosition.z = -1001
    obj.transform.localPosition = validPosition
    this.gameObject = obj
    if obj ~= nil then  
		this.SetGoldBaseInfo(content,goldNumber,btnNumber, btnCallback,btnname,btnbacksprite, closeCallback)
	end 
	return obj
end


function message_box:Close()
	if this.gameObject~=nil then
        log("nil------------------")
        GameObject.Destroy(this.gameObject)
        this.gameObject=nil
    end
end 

--[[--
 * @Description: 基本信息设置
                title: 标题，可以为空
				content: 正文，可以为空
				btnNumber: 按钮数量，不能超过 3
				btnCallback: 事件回调，带两个参数(1：点击了第几个按钮，从1开始，-1表示关闭按钮。2：customData）可以为空
 ]]
function this.SetGoldBaseInfo(content,goldNumber,btnNumber, btnCallback,btnname, btnbacksprite, closeCallback) 
	--content
    this.closebtn=child(this.transform,"bg/sv_gold/btn_close");
    if this.closebtn~=nil then
        if closeCallback ~= nil then
            addClickCallbackSelf(this.closebtn.gameObject,closeCallback)
        else
            addClickCallbackSelf(this.closebtn.gameObject,this.Close)
        end
    end

    local lb_content_gt = child(this.transform, "bg/sv_gold/lab_content")
    this.lb_content_g=componentGet(lb_content_gt.gameObject,"UILabel") 
    this.lb_content_g.text=content  

    if btnNumber == nil then btnNumber = 1 end
    for k = 1, btnNumber do
        local btn=child(this.transform,"bg/sv_gold/btn_grid/btn_0"..tostring(k)) 
        if btn~=nil then
          btn.gameObject:SetActive(false)
        end
    end
	--btns
	for k = 1, btnNumber,1 do
        local btn=child(this.transform,"bg/sv_gold/btn_grid/btn_0"..tostring(k)) 
        if btn~=nil then
           addClickCallbackSelf(btn.gameObject,btnCallback[k],this) 
        else 
            local obj=child(this.transform,"bg/sv_gold/btn_grid/btn_0"..tostring(k-1)) 
            btn=GameObject.Instantiate(obj)
            btn.transform.parent=obj.parent
            btn.transform.localScale={x=1,y=1,z=1}
            btn.name="btn_0"..tostring(k)
            addClickCallbackSelf(btn.gameObject,btnCallback[k],this) 
        end
        btn.gameObject:SetActive(true)
 --       if btnname[k]~=nil then
 --           local btn_sp=child(btn.transform,"Sprite");
--            log(btn_sp.name)
            -- componentGet(btn_sp.gameObject,"UISprite").spriteName=btnname[k]
            -- componentGet(btn_sp.gameObject,"UISprite"):MakePixelPerfect()
            -- if btnname[k]=="quding" then
            --     componentGet(child(btn.transform,"Background").gameObject,"UISprite").spriteName="a01"
            -- else    
            --     componentGet(child(btn.transform,"Background").gameObject,"UISprite").spriteName="a02"
            -- end

 --       end 
        -- if  btnbacksprite~=nil and btnbacksprite[k]~=nil then 
        --     componentGet(child(btn.transform,"Background").gameObject,"UISprite").spriteName=btnbacksprite[k]
        -- end
	end 
end
 