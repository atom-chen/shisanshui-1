/*******************************************************************************
*Author         :  xuemin.lin
*Description    :  http要用的一些基础功能
*Other          :  none
*Modify Record  :  none
*******************************************************************************/

using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BestHTTP;
using System.Net.NetworkInformation;
using System.IO;


public enum ServerUrl 
{
    INTERNET_URL = 1,
    LANFZMJ_URL,
    LANSSS_URL,
    DEVELOP_URL,
    RELEASE_URL,
    DEFAULT,
}
    
public class NetWorkManage : Singleton<NetWorkManage>
{
    public static string testAccount = "";
    public static ServerUrl _serverUrl;
    private string          m_BaseUrl;
    private ServerUrl       m_ServerUrl;
    private string          m_WsUrl;
    private string          m_SubPath;
    public string           m_physicalAddress;         

    public string BaseUrl
    {
        get { return m_BaseUrl; }
        set
        {
            m_BaseUrl = value;
        }
    }

    public ServerUrl ServerUrl
    {
        get
        {
            return m_ServerUrl;
        }
        set
        {
            m_ServerUrl = value;
        }
    }

    public int ServerUrlType
    {
        get
        {
            return (int)m_ServerUrl;
        }
    }

    public string WsUrl
    {
        get { return m_WsUrl; }
        set { m_WsUrl = value; }
    }

    public string SubPath
    {
        get { return m_SubPath; }
        set { m_SubPath = value; }
    }
    private void Awake()
    {
        path = "file://" + Application.dataPath + "/StreamingAssets/jsontest.json";
        filepath = Application.persistentDataPath;
#if UNITY_EDITOR
        GetMacAddress();

        LuaInterface.Debugger.Log("MacAddress" + m_physicalAddress);
#endif
        this.Init();
    }

    private void Init()
    {
        SubPath = "?win_param=";
        ServerUrl = _serverUrl;       
    }

    public void HttpPOSTRequest(string param, Action<int, string, string> callBack)
    {
        string url = BaseUrl + SubPath + param;
        Debug.Log("请求：" + url);
        HTTPManager.SendRequest(url,HTTPMethods.Post, (HTTPRequest originalRequest, HTTPResponse response) => {

            if (response == null)
            {
                callBack(-1, "", "");
                return;
            }            
            string responseStr = "";
            int result = 0;
            string msg = "";
            if (response.IsSuccess)
            {
                 responseStr = Encoding.UTF8.GetString(response.Data);
            }
            else
            {
                result = response.StatusCode;
                msg = response.Message;
            }
            if (callBack != null)
            {
                Debug.Log("错误码：" + result + " 返回：" + msg);
                Debug.Log("responseStr：" + responseStr);
                callBack(result,msg,responseStr);
            }
        });
    }

   public void HttpRequestByMothdType(HTTPMethods methodType, string param, bool isKeepAlive,bool disableCache, Action<int, string, string> callBack)
    {
        string url = BaseUrl + SubPath + param;
        HTTPManager.SendRequest(url, methodType,isKeepAlive, disableCache, (HTTPRequest originalRequest, HTTPResponse response) =>
        {

            if (response == null)
            {
                callBack(-1, "", "");
                return;
            }
            string responseStr = "";
            int result = 0;
            string msg = "";
            if (response.IsSuccess)
            {
                responseStr = Encoding.UTF8.GetString(response.Data);
            }
            else
            {

                result = response.StatusCode;
                msg = response.Message;


            }
            if (callBack != null)
            {
                callBack(result, msg, responseStr);
            }
        });
    }

    public void HttpDownImage(string url,int imageWidth,int imageHeight,Action<HTTPRequestStates, Texture2D> callBack)
    {       
         HTTPRequest request = new HTTPRequest(new Uri(url), (req, resp) => {
            //HTTPRequest request = HTTPManager.SendRequest(new Uri(url).ToString(), HTTPMethods.Get,(req, resp) => {
            if(req.State == HTTPRequestStates.Finished)
            {
                Texture2D texture = null;
                int result;
                if (resp.IsSuccess)
                {
                    texture = req.Tag as Texture2D;
                    texture.LoadImage(resp.Data);
                }
                else
                {
                    result = resp.StatusCode;
                }
                if (callBack != null)
                {
                    callBack(req.State, texture);
                }
            }
            else
            {
                if (callBack != null)
                {
                    callBack(req.State, null);
                }
            }
        });
        request.Tag = new Texture2D(imageWidth,imageHeight);
        request.Send();
    }

    public void HttpDownAssetBundle(string url, Action<HTTPRequestStates, AssetBundle> callBack)
    {
        StartCoroutine(DownloadAssetAssetBundle(url, callBack));
    }

    private IEnumerator DownloadAssetAssetBundle(string url,Action<HTTPRequestStates, AssetBundle> callBack)
    {
        HTTPRequest request = new HTTPRequest(new Uri(url)).Send();
        while(request.State < HTTPRequestStates.Finished)
        {
            yield return new WaitForSeconds(0.1f);
        }
        switch(request.State)
        {
            case HTTPRequestStates.Finished:
                if (request.Response.IsSuccess)
                {
                    AssetBundleCreateRequest asyncAssetBundle = AssetBundle.LoadFromMemoryAsync(request.Response.Data);
                    yield return asyncAssetBundle;
                    if (callBack != null)
                    {
                        callBack(HTTPRequestStates.Finished, asyncAssetBundle.assetBundle);
                    }
                }
                break;
            default:
                if (callBack != null)
                {
                    callBack(request.State, null);
                }
                break;
        }
       
    }

    public void HttpDownloadFile(string url,Action<HTTPRequestStates, string,List<byte[]>> callBack)
    {
        HTTPRequest requset = new HTTPRequest(new Uri(url), (req, resp) => {

            switch(req.State)
            {
                case HTTPRequestStates.Processing:
                    //下载进度
                    string processingLength = resp.GetFirstHeaderValue("content-length");
                    if(callBack != null)
                    {
                        callBack(HTTPRequestStates.Processing, processingLength, resp.GetStreamedFragments());
                    }
                    break;
                case HTTPRequestStates.Finished:
                    if(resp.IsSuccess)
                    {
                        //完全下载完
                        if(resp.IsStreamingFinished)
                        {
                            if (callBack != null)
                            {
                                callBack(HTTPRequestStates.Finished, resp.GetFirstHeaderValue("content-length"), resp.GetStreamedFragments());
                            }
                        }
                    }
                    else
                    {
                      string  str = string.Format("Request finished Successfully, but the server sent an error. Status Code: {0}-{1} Message: {2}",
                                                           resp.StatusCode,
                                                           resp.Message,
                                                           resp.DataAsText);
                        Debug.LogWarning(str);
                    }
                    break;
                default:
                    if (callBack != null)
                    {
                        callBack(req.State, "", null);
                    }
                    break;
            }
        });
        requset.DisableCache = true;
        requset.StreamFragmentSize = HTTPResponse.MinBufferSize;
        requset.Send();
    }

    string path;
    //GameRule
    string filepath;
    public void HttpDownTextAsset(string url, Action<HTTPRequestStates, string> callBack, string filepath = "")
    {
        
        HTTPRequest request = new HTTPRequest(new Uri(url), (req, resp) =>
        {
            if (req.State == HTTPRequestStates.Finished)
            {
                int result;
                if (resp.IsSuccess)
                {
                    int index = url.LastIndexOf('/');
                    string fileName = url.Substring(index + 1, url.Length - index -1);
                    string context = System.Text.Encoding.UTF8.GetString(resp.Data);
                    CreateFile(filepath, fileName, context);
                    if(callBack !=null)
                    {
                        callBack(req.State, context);
                    }
                }
                else
                {
                    result = resp.StatusCode;
                }
                if (callBack != null)
                {
                    callBack(req.State, null);
                }
            }
            else
            {
                if (callBack != null)
                {
                    callBack(req.State, null);
                }
            }
        });
        request.Send();
    }

    void CreateFile(string path, string name ,string info)
    {
        if (!Directory.Exists(path))
        {
            Directory.CreateDirectory(path);
        }

        StreamWriter sw;
        FileInfo t = new FileInfo(path + "//" + name);
        if(!t.Exists)
        {
            sw = t.CreateText();
        }
        else
        {
            t.Delete();
            sw = t.CreateText();
        }
        sw.Write(info);
        sw.Close();
        sw.Dispose();
    }

    public string GetMacAddress()
    {

        m_physicalAddress = SystemInfo.deviceUniqueIdentifier;
#if UNITY_EDITOR
        NetworkInterface[] nice = NetworkInterface.GetAllNetworkInterfaces();

        foreach (NetworkInterface adaper in nice)
        {

            LuaInterface.Debugger.Log(adaper.Description);

            if (adaper.Description == "en0")
            {
                m_physicalAddress = adaper.GetPhysicalAddress().ToString() + testAccount;
                break;
            }
            else
            {
                m_physicalAddress = adaper.GetPhysicalAddress().ToString() + testAccount;
                if (m_physicalAddress != "")
                {
                    break;
                };
            }
        }
#endif
        return m_physicalAddress;
    }


}
