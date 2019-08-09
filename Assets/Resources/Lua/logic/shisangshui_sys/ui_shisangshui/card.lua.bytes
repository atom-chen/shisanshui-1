PlayerCard = {}

PlayerCard.__index = PlayerCard
this = PlayerCard


function PlayerCard.New( transform )
 	local this = {}
 	setmetatable(this, PlayerCard)
 	this.transform = transform
	this.viewSeat = -1
	this.all_score = 0
 	local function FindChild()
	 	this.roomCardLabel = subComponentGet(this.transform, "bg/roomCard/roomCardNum", typeof(UILabel))
	 	-- 花牌图标
	 	this.huaPoint = child(this.transform, "bg/roomCard")

	    
	 	this.cardNum = subComponentGet(this.transform, "cardNum", typeof(UISprite));
	 	this.color1 = subComponentGet(this.transform, "color1", typeof(UISprite));
	 	this.color2 = subComponentGet(this.transform, "color2", typeof(UISprite));
	end

    --更新牌值
	function this.UpdateCard( num )
		if this.scorelabel==nil then
			this.scorelabel = this.score.gameObject:GetComponent(typeof(UILabel))
		end
		if score == nil then score = 0 end
		this.all_score =  tonumber(this.all_score) + tonumber(score)
		log("+++++更新总积分+++"..tostring(this.all_score).."坐位号"..tostring(this.viewSeat))
	--	this.scorelabel.text = score
		this.scorelabel.text =  tostring(this.all_score)
	end
	FindChild()

 	return this
end




