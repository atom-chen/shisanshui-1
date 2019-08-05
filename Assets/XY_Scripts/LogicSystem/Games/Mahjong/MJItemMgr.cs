using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MJItemMgr {

    private List<MJItem> _mjItemList;
    public List<MJItem> MJItemList
    {
        get { return _mjItemList; }
    }
    private GameObject _prefab;//麻将
    public GameObject Prefab
    {
        get { return _prefab; }
    }


    public void InitMJItem()
    {
        if (_mjItemList != null)
        {
            for (int i = 0; i < _mjItemList.Count; ++i)
            {
                MJItem item = _mjItemList[i];
                if (item != null)
                    _mjItemList[i].gameObject.SetActive(false);
            }
        }else
        {
            _mjItemList = new List<MJItem>(136);
            for (int i = 0; i < 136; ++i)
            {
                _mjItemList.Add(null);
            }
            _prefab = Resources.Load<GameObject>(MJResMgr.prefabPath + "MJ");
            if (_prefab == null)
            {
                Debug.LogError("CreatMJWall");
            }
        }
    }
}
