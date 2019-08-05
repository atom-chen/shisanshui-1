using UnityEngine;

public class HideAndroidButtons : MonoBehaviour
{
    public static void Init()
    {
        #if UNITY_ANDROID && !UNITY_EDITOR
        GameObject go = new GameObject("HideAndroidButtons");
        HideAndroidButtons hab = go.GetComponent<HideAndroidButtons>();
        if (hab == null)
        {
            hab = go.AddComponent<HideAndroidButtons>();
        }
        DontDestroyOnLoad(go);
        #endif
    }

#if UNITY_ANDROID && !UNITY_EDITOR
    const int SYSTEM_UI_FLAG_IMMERSIVE_STICKY = 4096;
    const int SYSTEM_UI_FLAG_HIDE_NAVIGATION = 2;
    const int SYSTEM_UI_FLAG_FULLSCREEN = 4;

    AndroidJavaObject decorView;
    AndroidJavaObject activity;

    void Awake()
    {
        //print("**********HideAndroidButtons.Awake()**********");
        AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
        activity = jc.GetStatic<AndroidJavaObject>("currentActivity");
        AndroidJavaObject window = activity.Call<AndroidJavaObject>("getWindow");
        decorView = window.Call<AndroidJavaObject>("getDecorView");

        TurnImmersiveModeOn();
    }
    void OnApplicationFocus(bool focusStatus)
    {
        //print("**********HideAndroidButtons.OnApplicationFocus()**********");
        if(focusStatus)
        {
            TurnImmersiveModeOn();
        }
    }
    void TurnImmersiveModeOn()
    {
        //print("**********HideAndroidButtons.TurnImmersiveModeOn()**********");
        activity.Call("runOnUiThread", new AndroidJavaRunnable(TurnImmersiveModeOnRunable));
    }

    public void TurnImmersiveModeOnRunable()
    {
        //print("**********HideAndroidButtons.TurnImmersiveModeOnRunable()**********");
        decorView.Call("setSystemUiVisibility", SYSTEM_UI_FLAG_FULLSCREEN | SYSTEM_UI_FLAG_HIDE_NAVIGATION | SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
    }

    void OnDestroy()
    {
        //print("**********HideAndroidButtons.OnDestroy()**********");
        decorView.Dispose();
    }
#endif
}