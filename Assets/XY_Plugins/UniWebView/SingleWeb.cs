using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;
#if UNITY_ANDROID || UNITY_IPHONE || UNITY_IOS
public delegate void OnloadComplete(UniWebView webView, bool success, string errorMessage);
public delegate void OnReceiveMessage(UniWebView webView, UniWebViewMessage message);
#endif    
public class WebPage
{
#if UNITY_ANDROID || UNITY_IPHONE || UNITY_IOS
    public UniWebView webView;
    public OnloadComplete complete;
    public OnReceiveMessage receive;
    public WebPage(UniWebView webView, string url)
    {
        this.webView = webView;
        if (url != null)
        {
            webView.url = url;
        }
        else
        {
            webView.url = "http://baidu.com";
        }
        webView.Load();
        webView.OnReceivedMessage += this.ReceiveMsg;
        webView.OnLoadComplete += this.CompleteMsg;
    }

    void CompleteMsg(UniWebView webView, bool success, string errorMessage)
    {
        if (complete != null)
        {
            complete(webView, success, errorMessage);
        }
    }

    void ReceiveMsg(UniWebView webView, UniWebViewMessage message)
    {
        if (receive != null)
        {
            receive(webView, message);
        }
    }
    public void Show()
    {
        webView.Show();
    }
    public void Hide()
    {
        webView.Hide();
    }
    public void SetSize(int top, int bottom, int left, int right)
    {
        this.webView.insets = new UniWebViewEdgeInsets(top, left, bottom, right);
    }
    public void RunJavaScript(string fun, string method)
    {
        webView.AddJavaScript(fun);//"function concatme(){publicWebFunction(); }"
        webView.EvaluatingJavaScript(method);//"concatme()"
    }
#endif
}
public class SingleWeb : Singleton<SingleWeb> {
#if UNITY_ANDROID || UNITY_IPHONE || UNITY_IOS
    public UniWebView _webView;
    public string url = "http://baidu.com";
    public  OnloadComplete Complete; 
    public  OnReceiveMessage Receive;


    public Dictionary<string, WebPage> dic = new Dictionary<string, WebPage>();
    public void InitWebPage(string url)
    {
        GameObject go = new GameObject("test");
        go.AddComponent<UniWebView>();
        UniWebView webView = go.GetComponent<UniWebView>();
        WebPage webPage = new WebPage(webView, url);
        if (!dic.ContainsKey(url))
        {
            dic.Add(url, webPage);
        }
    }
    public WebPage GetDicObj(string url)
    {
        if (dic.ContainsKey(url))
        {
            return dic[url];
        }
        else
        {
            return null;
        }
    }
    public void DestroyDicObj(string url)
    {
        if (dic.ContainsKey(url))
        {
            WebPage webPage = SingleWeb.Instance.GetDicObj(url);
            UniWebView webView = webPage.webView;
            dic.Remove(url);
            webView.CleanCache();
            Destroy(webView);
        }
    }

    public void Init(string url)
    {
        _webView = gameObject.GetComponent<UniWebView>();
        if (_webView == null)
            _webView = gameObject.AddComponent<UniWebView>();
        
        if(string.IsNullOrEmpty(url))
            _webView.url =this.url;
        else _webView.url = url;
        _webView.Load();
        _webView.OnLoadComplete += this.OnComplete;
        _webView.OnReceivedMessage += this.OnReceive;
    }

    private void OnReceive(UniWebView webView, UniWebViewMessage message)
    {
         if (Receive!=null)
             Receive(webView,message);
    }

    private void OnComplete(UniWebView webView, bool success, string errorMessage)
    {
        //_webView.Show();
        if(Complete!=null)
         Complete(webView, success, errorMessage);
    }
    public void Show()
    {
        _webView.Show();
    }
    public void Hide()
    {
        _webView.Hide();
    }
    public void setsize(int top,int bottom,int left,int right)
    {
        _webView.insets = new UniWebViewEdgeInsets(top, left, bottom, right);
    } 
#endif    
}
