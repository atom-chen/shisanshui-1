using UnityEngine;
using System.Collections;

public class TableLand : MonoBehaviour {

    public ScreenOrientation orient = ScreenOrientation.Unknown;
	// Use this for initialization
	void Awake() {
        if (orient != ScreenOrientation.Unknown)
        {
            Screen.orientation = orient; ;
            UIRoot root = GameObject.Find("uiroot_xy").GetComponent<UIRoot>();
            if (orient == ScreenOrientation.Portrait) {
                root.fitHeight = true;
                root.fitWidth = false;
            }
            else if(orient == ScreenOrientation.LandscapeLeft){
                root.fitWidth = true;
                root.fitHeight = false;
            }
        }
    }
	
	// Update is called once per frame
	void Update () {
	
	}
}
