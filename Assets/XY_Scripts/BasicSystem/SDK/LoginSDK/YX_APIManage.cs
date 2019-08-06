
using System.Collections;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using System.ComponentModel;
using System;
using System.Threading;
using UnityEngine;
using LuaInterface;

public class YX_APIManage : Singleton<YX_APIManage>
{
    private static AndroidInterface androidInterface;


    public void Awake()
    {
#if UNITY_ANDROID && !UNITY_EDITOR
        androidInterface = new AndroidInterface();
        if(androidInterface != null)
            Debug.Log("androidInterface aleard Create");
#endif

    }
    public delegate void DelegateNetHallCallBack();
    public DelegateNetHallCallBack delegateNetHallCallBack;
    public void setHallTimer(DelegateNetHallCallBack delegateNet) {
        delegateNetHallCallBack = delegateNet;
    }
    public delegate void DelegateNetGameCallBack();
    public DelegateNetGameCallBack delegateNetGameCallBack;
    public void setGameTimer(DelegateNetGameCallBack delegateNet) {
        delegateNetGameCallBack = delegateNet;
    }

    //检测网络状态，如果网络状态有变动则做相应的处理
    private NetworkReachability m_currentReachability;
    public NetworkReachability CurrentReachability
    {
        get { return m_currentReachability; }
        set
        {
            if (m_currentReachability != value)
            {
                m_currentReachability = value;
                switch (m_currentReachability)
                {
                    case NetworkReachability.NotReachable:
                        break;
                    case NetworkReachability.ReachableViaCarrierDataNetwork:
                        break;
                    case NetworkReachability.ReachableViaLocalAreaNetwork:
                        break;
                }
            }
        }
    }

    private void Start()
    {
        CurrentReachability = Application.internetReachability;
    }

    public void Update()
    {
        if (delegateNetHallCallBack != null) {
            delegateNetHallCallBack();
        }
        if (delegateNetGameCallBack != null)
        {
            delegateNetGameCallBack();
        }

        //检查网络状态
        if (CurrentReachability != Application.internetReachability)
        {
            CheckNetState(CurrentReachability);
            CurrentReachability = Application.internetReachability;
        }
    }

    void CheckNetState(NetworkReachability netState)
    {
        //Debug.Log("NetworkReachability-------------------------------");
        LuaFunction func = LuaClient.GetMainState().GetFunction("network_mgr.NetworkReachability");
        if (func != null)
        {
            func.BeginPCall();
            func.Push((int)netState);
            func.PCall();
            func.EndPCall();
            func = null;
        }
    }

    private void OnApplicationPause(bool isPause)
    {
        if (isPause)
        {
            LuaFunction func = LuaClient.GetMainState().GetFunction("network_mgr.AppPauseNotify");
            func.BeginPCall();
            func.Push(1);
            func.PCall();
            func.EndPCall();
            func = null;
        }
        else
        {
            LuaFunction func = LuaClient.GetMainState().GetFunction("network_mgr.AppPauseNotify");
            func.BeginPCall();
            func.Push(0);
            func.PCall();
            func.EndPCall();
            func = null;
        }
    }

    private void OnApplicationFocus(bool focus)
    {    
#if UNITY_EDITOR || UNITY_STANDALONE
        return;
#endif
    }

    public delegate void BatteryCallBack(string persion);
    public BatteryCallBack batteryCallBack;


    //SDK初始化
    public void InitPlugins(bool isTest)
    {
#if UNITY_IOS && !UNITY_EDITOR
            //IOSInterface.Init(this.gameObject.name, isTest, "");
#elif UNITY_ANDROID && !UNITY_EDITOR
			androidInterface.InitPlugins(isTest, this.gameObject.name);
#endif
    }
    /// <summary>
    /// 微信登录
    /// </summary>
    ///
    public delegate void DelegateLoginResp(string msg);
    public DelegateLoginResp delegateLoginResp;
    //  private Action<string> ActionLoginResp;
    public void WeiXinLogin(DelegateLoginResp resp)
    {
        delegateLoginResp = resp;
#if UNITY_ANDROID && !UNITY_EDITOR
        androidInterface.WeiXinLogin();
#elif UNITY_IOS && !UNITY_EDITOR
#endif
    }


    /// <summary>
    /// 
    /// </summary>
    /// <param name="shareType">0微信好友，1朋友圈，2微信收藏</param>
    /// <param name="type">1文本，2图片，3声音，4视频，5网页</param>
    ///
    public void WeiXinShare(int shareType, int type, string title, string filePath, string url, string description)
    {
#if UNITY_ANDROID && !UNITY_EDITOR
        androidInterface.WeiXinShare(shareType, type, title,filePath,url,description);
#endif
    }
    public void QQLogin(DelegateLoginResp resp)
    {
        delegateLoginResp = resp;
#if UNITY_ANDROID && !UNITY_EDITOR
        androidInterface.QQLogin();
#elif UNITY_IOS && !UNITY_EDITOR
#endif
    }



    public void YX_IsEnableBattery(bool isEnable)
    {
#if UNITY_ANDROID && !UNITY_EDITOR
        androidInterface.GetBattery(isEnable);
#elif UNITY_IOS && !UNITY_EDITOR
#endif
    }

    public void YX_GetPhoneStreng()
    {
#if UNITY_ANDROID && !UNITY_EDITOR
        androidInterface.GetPhoneStreng();
#elif UNITY_IOS && !UNITY_EDITOR
#endif
    }
   
    public void onPluginsInitFinsh(string msg)
    {
        //Debug.Log("收到回调啦啦啦");
        string dataPath = Application.dataPath;
        //Debug.Log("Application.dataPath -------" + dataPath);
    }
    public void onWeiXinLoginCallBack(string msg)
    {
        //Debug.Log("LoginCallBack:" + msg);
        if (delegateLoginResp != null)
        {
            delegateLoginResp(msg);
            delegateLoginResp = null;
        }

    }

    public void onQQLoginCallBack(string msg)
    {
        //Debug.Log("onQQLoginCallBack" + msg);
        if (delegateLoginResp != null)
        {
            delegateLoginResp(msg);
            delegateLoginResp = null;
        }

    }
    public delegate void onCopyCall(string msg);
    public onCopyCall oncopyCallback;
    public void onCopyCallBack(string msg)
    { 
        if (oncopyCallback != null)
            oncopyCallback(msg);
    }
    public void onCopy(string msg, onCopyCall delegateCallback)
    {
        oncopyCallback = delegateCallback; 
#if UNITY_ANDROID && !UNITY_EDITOR
        string callbackname="";
        androidInterface.onCopy(msg);
#elif UNITY_IOS && !UNITY_EDITOR
#endif
    }
    public void onPhoneBattery(string msg)
    {
        //Debug.Log("onPhoneBattery" + msg);
        if (batteryCallBack != null)
        {
            batteryCallBack(msg);
        }
    }

    public void onPhoneSignal(string msg)
    {
        //Debug.Log("onPhoneSignal" + msg);
    }

    public delegate void DelegateIAppPayResp(string msg);
    public DelegateIAppPayResp delegateIAppPayResp;
    public void startIAppPay(string msg, DelegateIAppPayResp resp)
    {
        delegateIAppPayResp = resp;
        //Debug.Log("YX_APIManager startIAppPay ");
#if UNITY_ANDROID && !UNITY_EDITOR
        androidInterface.startIAppPay(msg);
#endif

    }
    public void onIAppPayCallBack(string msg)
    {
        //Debug.Log("onIAppPayCallBack" + msg);
        if (delegateIAppPayResp != null)
        {
            delegateIAppPayResp(msg);
        }
    }
    public string onGetStoragePath()
    {
        
        string filepath = "";
#if UNITY_EDITOR
        filepath = Application.persistentDataPath + "/";

#elif UNITY_IPHONE
	  filepath = Application.persistentDataPath+ "/";
 
#elif UNITY_ANDROID
	   filepath =  Application.persistentDataPath + "/";
#endif

        //Debug.Log("onGetStoragePath ");
        if (filepath != null)
        {
            //Debug.Log("onGetStoragePath filepath " + filepath);
            return filepath;
        }
        return "";
    }
    public  string read(string filename)
    {
        //Debug.Log(onGetStoragePath() + filename);
        if (System.IO.File.Exists(onGetStoragePath() + filename))
        {
            string filePath = onGetStoragePath() + filename;
            string text= System.IO.File.ReadAllText(filePath);
            //Debug.Log("read  filePath " + filePath + " text= " + text);
            return text;
        }

        return null;
    }

    public void deleteFile(string filename) {

        if (System.IO.File.Exists(onGetStoragePath() + filename))
        {
            string filePath = onGetStoragePath() + filename;
            //Debug.Log("deleteFile  filePath " + filePath);
            System.IO.File.Delete(filePath);
        }
    }
}





