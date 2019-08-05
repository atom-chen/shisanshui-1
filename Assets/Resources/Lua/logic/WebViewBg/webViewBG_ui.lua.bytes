webViewBG_ui = ui_base.New()
local this = webViewBG_ui
function this.Show()
	print("webViewBG_ui.show-------------------------------------2")
	if this.gameObject==nil then
		newNormalUI("Prefabs/UI/WebViewBg/webViewBG_ui")
	else
		this.gameObject:SetActive(true)
	end
end

function this.Start()
	this:InitPanelRenderQueue()
	this.CloseBtn()
end

function  this.CloseBtn()
	local closeBtn = child(this.transform,"commonbg1/CloseBtn")
 	if closeBtn ~= nil then
        addClickCallbackSelf(closeBtn.gameObject,this.OnBtnCloseClick,this)
    end
end

function this.OnBtnCloseClick()
	SingleWeb.Instance:Hide()
	print("hello untiy")
	destroy(this.gameObject);
	this.gameObject=nil
end
function this.UpdateTitle(spName)
	local title=child(this.transform,"commonbg1/Bg/title")
	local sprite= componentGet(title,"UISprite")
	--print(spName.."hello ......................")
	if sprite ~= nil then
	   sprite.spriteName=spName
    end
end

