using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;

public class MJTable : MonoBehaviour {

    public Transform[] WallPoints;

    private Transform _trans;

    void Awake()
    {
        _trans = this.transform;
    }

    /// <summary>
    /// 创建牌墩
    /// </summary>
    /// <returns></returns>
    public IEnumerator CreatMJWall()
    {
        yield return null;
        float x, y, z;
        int index = 0;
        for (int i = 0; i < 17; ++i)
        {
            x = i * MahjongConst.MahjongOffset_x;
            for (int j = 0; j < 2; ++j)
            {
                y = j * MahjongConst.MahjongOffset_y;
                for(int k = 0; k < 4; ++k)
                {
                    MJItem mjItem = MJControl.Instance._mjItemMgr.MJItemList[k * 34 + index];
                    GameObject mj = null;
                    if (mjItem == null)
                        mj = Instantiate(MJControl.Instance._mjItemMgr.Prefab) as GameObject;
                    else
                        mj = mjItem.gameObject;
                    mj.transform.SetParent(WallPoints[k]);
                    mj.transform.localPosition = new Vector3(x, y, 0);
                    mj.transform.localEulerAngles = new Vector3(0, 0, 180);
                    mj.name = MJControl.Instance._mjItemMgr.Prefab.name + index;
                    MJItem item = mj.GetComponent<MJItem>();
                    MJControl.Instance._mjItemMgr.MJItemList[k * 34 + index] = item;
                    mj.SetActive(true);
                }
                index++;
                yield return new WaitForSeconds(0.03f);
            }
        }
    }



}
