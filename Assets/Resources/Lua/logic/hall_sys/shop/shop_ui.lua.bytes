--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


--endregion 

shop_ui = ui_base.New()
local this = shop_ui
 
this.gameObject=nil  
this.productlist={}
function this.Show()  
    if this.gameObject==nil then
		require ("logic/hall_sys/shop/shop_ui")
		this.gameObject=newNormalUI("Prefabs/UI/Hall/shop_ui")
	else
		this.gameObject:SetActive(true)
	end   
     
    this.RegisterEvent()
end



function this.Hide()  
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
	if this.gameObject==nil then 
        return
	else
		GameObject.Destroy(this.gameObject)
        this.gameObject=nil
	end
    
end
 

function  this.RegisterEvent()
    local price= child(this.transform,"panel_shop/Panel_Middle/Sprite/lab_price") 
    if price~=nil then
        componentGet(price.gameObject,"UILabel").text="售价"..string.format("%0.f",this.productlist[1].price) .."元"
    end

    local btn_open=child(this.transform,"panel_shop/Panel_Middle/btn_buy")
    if btn_open~=nil then
        addClickCallbackSelf(btn_open.gameObject,this.open,this)
    end 
    local btn_buy=child(this.transform,"panel_shop/panel_buy/buy_panel/Panel_Middle/btn_buy")
    if btn_buy~=nil then
        addClickCallbackSelf(btn_buy.gameObject,this.buy,this)
    end 
    local btn_increase=child(this.transform,"panel_shop/panel_buy/buy_panel/Panel_Middle/sp_background/btn_increase")
    if btn_increase~=nil then
        addClickCallbackSelf(btn_increase.gameObject,this.increase,this)
    end 
    local btn_decrease=child(this.transform,"panel_shop/panel_buy/buy_panel/Panel_Middle/sp_background/btn_decrease")
    if btn_decrease~=nil then
        addClickCallbackSelf(btn_decrease.gameObject,this.decrease,this)
    end 
    this.lab_number=child(this.transform,"panel_shop/panel_buy/buy_panel/Panel_Middle/sp_background/lab_number")
    this.lab_count=child(this.transform,"panel_shop/panel_buy/buy_panel/Panel_Middle/sp_background2/lab_number")

    local btn_close=child(this.transform,"panel_shop/btn_close")
    if btn_close~=nil then
        addClickCallbackSelf(btn_close.gameObject,this.Hide,this)
    end 

    local btn_c=child(this.transform,"panel_shop/panel_buy/buy_panel/btn_close")
    if btn_c~=nil then
        addClickCallbackSelf(btn_c.gameObject,this.close,this)
    end 
    this.updateCount()
end

function this.buy()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    log("buy")
    http_request_interface.getProductCfg({["ptype"]=1},function (code,m,str) 
        log(str)
        local s=string.gsub(str,"\\/","/")  
        local t=ParseJsonStr(s)
        if tonumber( t.ret)==0 then
             require "logic/recharge/recharge_sys"
            local pid =t.productlist[1].pid
             recharge_sys.requestIAppPayOrder(rechargeConfig.IAppPay,pid,tonumber(componentGet(this.lab_number.gameObject,"UILabel").text))
            
        end   
    end)
end

function this.increase()
    componentGet(this.lab_number.gameObject,"UILabel").text=tonumber(componentGet(this.lab_number.gameObject,"UILabel").text)+1 
    this.updateCount()
end

function this.decrease()
    if tonumber(componentGet(this.lab_number.gameObject,"UILabel").text)>0 then
       componentGet(this.lab_number.gameObject,"UILabel").text=tonumber(componentGet(this.lab_number.gameObject,"UILabel").text)-1 
    end
    this.updateCount()
end

function this.updateCount()
    local count= tonumber(componentGet(this.lab_number.gameObject,"UILabel").text)
    componentGet(this.lab_count.gameObject,"UILabel").text=count*tonumber(this.productlist[1].price)
end

function this.open()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    local panel=child(this.transform,"panel_shop/panel_buy")
    panel.gameObject:SetActive(true)
end

function this.close()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    local panel=child(this.transform,"panel_shop/panel_buy")
    panel.gameObject:SetActive(false)
end