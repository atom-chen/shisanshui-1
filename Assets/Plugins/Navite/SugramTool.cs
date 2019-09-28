using System;
using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;
using System.Collections.Generic;

//namespace Native
//{

    public class SugramTool: IShare
    {
        public delegate void IntCallBack(int p);
        public delegate void StringCallBack(string p);

        public static string AppID;
        static SugramTool _ins;

        /// <summary>
        /// 游戏登陆回调
        /// </summary>
        static Action<string> mLoginCallBack;
        /// <summary>
        /// 分享游戏回调
        /// </summary>
        static Action<int> mShareCallBack;
        /// <summary>
        /// 游戏支付回调
        /// </summary>
        static Action<int> mGamePayCallBack;

        public static string Schemes { get; set; }
#if UNITY_EDITOR
#elif UNITY_ANDROID
        AndroidJavaObject schemes;
#endif
        public SugramTool()
        {
            UnityThreadHelper.EnsureHelper();
#if UNITY_EDITOR
#elif UNITY_ANDROID
        using (var mSugramTool = new AndroidJavaClass("com.sugram.SugramTool"))
            {
                schemes = mSugramTool.CallStatic<AndroidJavaObject>("Create", AppID);
            }
#elif UNITY_IOS
            SugramInit(AppID,Schemes);
#endif

        }
        static public SugramTool getInstance()
        {
            if (_ins == null)
            {
                _ins = new SugramTool();
            }
            return _ins;
        }

        static public bool isSugramInstalled()
        {
#if !UNITY_EDITOR && UNITY_IOS
            return isInstallSugram();
#else
            return true;
#endif
        }

        [AOT.MonoPInvokeCallback(typeof(StringCallBack))]
        static public void loginCallback(string data)
        {
            if (mLoginCallBack != null)
            {
                UnityThreadHelper.Dispatcher.Dispatch(() =>
                {
                    mLoginCallBack(data);
                    mLoginCallBack = null;
                });
            }
        }

        public void Login(Action<string> callback)
        {
            mLoginCallBack = callback;
#if UNITY_EDITOR
            loginCallback("{}");
#elif UNITY_ANDROID           
            IntPtr fn = Marshal.GetFunctionPointerForDelegate((StringCallBack)loginCallback);            
            schemes.Call("login", (int)fn);
#elif UNITY_IOS
            SugramLogin(loginCallback);
#endif
        }

        [AOT.MonoPInvokeCallback(typeof(IntCallBack))]
        static public void shareCallback(int err)
        {
            if (mShareCallBack != null)
            {
                UnityThreadHelper.Dispatcher.Dispatch(() =>
                {
                    mShareCallBack(err);
                    mShareCallBack = null;
                });
            }
        }

        public void ShareText(string text, ShareType type, Action<int> callback)
        {
            mShareCallBack = callback;
#if UNITY_EDITOR
            shareCallback(0);
#elif UNITY_ANDROID
            IntPtr fn = Marshal.GetFunctionPointerForDelegate((IntCallBack)shareCallback);
            schemes.Call("ShareText", text, (int)type, (int)fn);
           
#elif UNITY_IOS
            SugramShareText(text,(int)type, shareCallback);
#endif
        }

        public void ShareImage(string img_path, string icon_path, ShareType type, Action<int> callback)
        {
            mShareCallBack = callback;
#if UNITY_EDITOR
            shareCallback(0);
#elif UNITY_ANDROID
            
            IntPtr fn = Marshal.GetFunctionPointerForDelegate((IntCallBack)shareCallback);
            schemes.Call("ShareImage", img_path, icon_path, (int)type, (int)fn);
           
#elif UNITY_IOS
            SugramShareImage(img_path, icon_path, (int)type, shareCallback);
#endif

        }

        public void ShareWepPage(string url, string title, string des, string icon_path, ShareType type, Action<int> callback)
        {
            mShareCallBack = callback;
#if UNITY_EDITOR
            shareCallback(0);
#elif UNITY_ANDROID
            IntPtr fn = Marshal.GetFunctionPointerForDelegate((IntCallBack)shareCallback);
            schemes.Call("ShareWebPage", url, title, des, icon_path, (int)type, (int)fn);
           
#elif UNITY_IOS
            SugramShareWebPage(url, title, des, icon_path, (int)type, shareCallback);
#endif

        }

        public void ShareGameRoom(string url, string title, string des, string roomId, string roomToken, string icon_path, ShareType type, Action<int> callback)
        {
            mShareCallBack = callback;
#if UNITY_EDITOR
            shareCallback(0);
#elif UNITY_ANDROID
            IntPtr fn = Marshal.GetFunctionPointerForDelegate((IntCallBack)shareCallback);
            schemes.Call("ShareGameRoom", url, title, des, roomId, roomToken, icon_path, (int)type, (int)fn);
           
#elif UNITY_IOS
            SugramShareGameRoom(url, title, des, roomId, roomToken, icon_path, (int)type, shareCallback);
#endif
        }

#if UNITY_IOS
        #region IOS Native

        private const string Native = "__Internal";

        [DllImport(Native)]
        private static extern void SugramInit(string app_id,string schemes);
        
        [DllImport(Native)]
        private static extern bool isInstallSugram();

        [DllImport(Native)]
        private static extern bool SugramLogin(StringCallBack cb);

        [DllImport(Native)]
        private static extern void SugramShareText(string text, int type, IntCallBack cb);

        [DllImport(Native)]
        private static extern void SugramShareImage(string img_path, string icon_path, int type, IntCallBack cb);

        [DllImport(Native)]
        private static extern void SugramShareWebPage(string url, string title, string desc, string icon_path, int type, IntCallBack cb);

        [DllImport(Native)]
        private static extern void SugramShareGameRoom(string url, string title, string desc, string roomId, string roomToken, string icon_path, int type, IntCallBack cb);
        
        [DllImport(Native)]
        private static extern void SugramGamePay(string json, int type, IntCallBack cb);

        #endregion
#endif

        [AOT.MonoPInvokeCallback(typeof(IntCallBack))]
        static public void gamePayCallback(int data)
        {
            if (mGamePayCallBack != null)
            {
                UnityThreadHelper.Dispatcher.Dispatch(() =>
                {
                    mGamePayCallBack(data);
                    mGamePayCallBack = null;
                });
            }
        }

        /// <summary>
        /// 游戏支付
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="type">支付类型 1微信/ 2支付宝</param>
        /// <param name="callback"></param>
        public void Payment(string json, int type, Action<int> callback)
        {
            mGamePayCallBack = callback;
#if UNITY_EDITOR
            gamePayCallback(0);
#elif UNITY_ANDROID           
            IntPtr fn = Marshal.GetFunctionPointerForDelegate((IntCallBack)gamePayCallback);            
            schemes.Call("GamePay", json, type, (int)fn);
#elif UNITY_IOS
            //string json = SimpleJson.SimpleJson.SerializeObject(obj);
            SugramGamePay(json, type, gamePayCallback);
#endif
        }


    }
//}
