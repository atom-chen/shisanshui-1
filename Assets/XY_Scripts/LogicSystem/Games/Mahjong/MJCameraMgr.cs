using UnityEngine;
using System.Collections;

public class MJCameraMgr {

    private Camera _Camera2D;
    public Camera Camera2D
    {
		get { return _Camera2D; }
	}

    public void Init()
    {
        _Camera2D = GameObject.Find("2D Camera").GetComponent<Camera>();
    }
}
