local SocketManager = class("SocketManager")

function SocketManager:ctor(  )
	self.hallSocket = nil
	self.gameSocket = nil

	self.session = nil	
end


function SocketManager:createSocket(sockeName, url, binderName, _svrID, _dst)
	if not _svrID then 
		_svrID = 1
	end
	if sockeName == "hall" then
		if not self.hallSocket then
			print("SocketManager:createSocket----Hall")
			self.hallSocket = require("logic.network.SocketClient"):create(sockeName,url,5,1000)
			self.hallSocket:BindingServer(binderName, _svrID)
			self.hallSocket:setRcvCallback(function ( _svrName, _svrID, _event  )
				self:onReceveHallData(_svrName, _svrID, _event )
			end)
			self.hallSocket:setStatusCallback(function ( _status )
				self:onHallStatusCallback(_status)
			end)

			self.hallSocket:connect()
		end
	elseif sockeName == "game" then
		if not self.gameSocket then
			print("SocketManager:createSocket----Game")

			self.gameSocket = require("logic.network.SocketClient"):create(sockeName,url,5,3)
			self.gameSocket:BindingServer(binderName, _svrID, _dst)

			self.gameSocket:setRcvCallback(function ( _svrName, _svrID, _event  )
				self:onReceveGameData(_svrName, _svrID, _event )
			
			end)
			self.gameSocket:setStatusCallback(function ( _status )
				self:onGameStatusCallback(_status)
			end)

			self.gameSocket:connect()
		end
	end
end

function SocketManager:closeSocket( sockeName )
	if sockeName == "hall" then
		if self.hallSocket then
			self.hallSocket:destroy()
		end
		self.hallSocket = nil
	elseif sockeName == "game" then
		if self.gameSocket then
			self.gameSocket:destroy()
		end
		self.gameSocket = nil
		self:setGameSession(nil)
	end
end

function SocketManager:onHallStatusCallback( _status )
	LogW("onHallStatusCallback " ,_status)
	--[[

local NetStatus = {
	closed = "closed", -- 已关闭

	connecting = "connecting", -- 正在连接
	connected = "connected", -- 已连接
	
	reconnect = "reconnect", -- 重连
	
	stoped = "stoped" , -- 连接停止了
}

	]]

	if _status == "reconnect" then
		net_tip.Show("您的网络状态不好，正在进行重连处理")
	elseif _status == "connected" then
		net_tip.Hide()
	elseif _status == "closed" then
		  -- message_box.ShowGoldBox("亲,网络连接断开，请检查您的网络!", nil, 1,  
    --     {function ()message_box.Close() end}, {"fonts_01"}) 
	elseif  _status == "stoped" then
		message_box.ShowGoldBox("亲,网络连接断开，请检查您的网络!", nil, 1,  
        {function ()message_box.Close() end}, {"fonts_01"})
	end
end

function SocketManager:reconnect()
	if self.gameSocket then
		self.gameSocket:forceReconnect()
	end
end

--[[--
 * @Description: 设置程序切到后台的时间,在切换到后台的时候开始到切换到前台 
 * para 时间间隔 
 ]]
function SocketManager:setLeaveTime(_time)
	if self.gameSocket then
		self.gameSocket:setLeaveTime(_time)
	end
end

function SocketManager:onGameStatusCallback( _status )
	LogW("onGameStatusCallback " ,_status)

	if _status == "reconnect" then
		net_tip.Show("正在努力连接游戏服务器")
	elseif _status == "connecting" then
		--net_tip.Show("正在努力连接游戏服务器")
	elseif _status == "connected" then
		-- EnterGameReq
		if self.gameOpenCallBack then
			self.gameOpenCallBack()
		end
		net_tip.Hide()
	

	elseif _status == "closed" then
		  -- message_box.ShowGoldBox("亲,网络连接断开，请检查您的网络!", nil, 1,  
    --     {function ()message_box.Close() end}, {"fonts_01"}) 
	elseif  _status == "stoped" then
		net_tip.Hide()
		message_box.ShowGoldBox("亲,网络不给力,是否重试？", nil, 2,  
        {
        function ()
       		message_box.Close() 
        	game_scene.gotoHall()
        end, 
        function ()
        	message_box.Close()
        	if self.gameSocket then
				self.gameSocket:forceReconnect()
			end
        end}, {"fonts_02", "fonts_20"})
	end
end

function SocketManager:onHallSendData( pkgBuffer )
	if self.hallSocket then
		self.hallSocket:sendEvent(pkgBuffer)
	end
end

function SocketManager:onGameSendData( pkgBuffer )
	if self.gameSocket then
		self.gameSocket:sendEvent(pkgBuffer)
	end
end

function SocketManager:onGameOpenCallBack( openCallBack )
	self.gameOpenCallBack = openCallBack
	LogW("onGameOpenCallBack----Enter",self.session)
	-- if self.gameSocket and  self.session then
	-- 	LogW("onGameOpenCallBack----Enter1------",self.session)
	-- 	self.gameSocket:SetDst(self.session)
	-- end
	
end

function SocketManager:setGameSession( sessionTab  )
	
	self.session = {}
	if not sessionTab then return end
	self.session._chair =  sessionTab._chair
	self.session._gt = sessionTab._gt
end

function SocketManager:onReceveHallData( _svrName, _svrID, _event )
	--LogW("onReceveHallData " ,_svrName, _svrID, _event)
	if _event._cmd ~= "heart_beat" then
		
		if _event._cmd == "query_state" then
			LogW("query_state  setGameSession enter" ,_event._para._dst)
			self:setGameSession(_event._para._dst)
		end
		msg_dispatch_mgr.HandleRecvData(_event._cmd, _event)
	end
	

end

function SocketManager:onReceveGameData( _svrName, _svrID, _event )
	--LogW("onReceveGameData" ,_svrName, _svrID, _event)
	if _event._cmd ~= "heart_beat" then
		msg_dispatch_mgr.HandleRecvData(_event._cmd, _event)
		if _event._cmd == "session" then
			LogW("onReceveGameData=====session ", _event)
			if self.gameSocket then
				local para = _event._para
				local session = {}
				session._chair =  para._chair
				session._gt = para._gt
				self:setGameSession(session)
				self.gameSocket:SetDst(session)
			end
		end
	end

end



return SocketManager


