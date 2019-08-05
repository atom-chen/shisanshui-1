using UnityEngine;
using System.Collections; 
public  class YX_MoblieAPI:Singleton<YX_MoblieAPI>  {
    public  delegate void onFinishTx(UITexture tx);
    public  onFinishTx onfinishtx;
    public  void shake()
    {
        Debug.Log("shake");
#if UNITY_ANDROID  
        Handheld.Vibrate();
#endif
    } 
    public  void GetCenterPicture(string mFileName)
    {
        UITexture tx=null;
        StartCoroutine(CaptureByRect(mFileName,tx));
         
    }
    public  IEnumerator CaptureByRect(string mFileName, UITexture tx)
    {
        Rect mRect = new Rect(0, 0, Screen.width, Screen.height);
        //等待渲染线程结束  
        yield return new WaitForEndOfFrame();
        //初始化Texture2D  
        Texture2D mTexture = new Texture2D((int)mRect.width, (int)mRect.height, TextureFormat.RGB24, false);
        //读取屏幕像素信息并存储为纹理数据  
        mTexture.ReadPixels(mRect, 0, 0);
        //应用  
        mTexture.Apply();


        //将图片信息编码为字节信息  
        byte[] bytes = mTexture.EncodeToPNG();
        //保存  
        Debug.Log(YX_APIManage.Instance.onGetStoragePath() + mFileName);
        System.IO.File.WriteAllBytes(YX_APIManage.Instance.onGetStoragePath()+ mFileName, bytes);
        if(tx!=null)
         tx.mainTexture = mTexture;
        onfinishtx(tx);
        //如果需要可以返回截图  
        //return mTexture;  
    }
    
}
