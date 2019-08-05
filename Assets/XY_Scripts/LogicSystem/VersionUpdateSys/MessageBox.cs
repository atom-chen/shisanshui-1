using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

public class MessageBox : MonoBehaviour
{
    [SerializeField]
    private UIGrid grid;
    [SerializeField]
    private UILabel title_Lab;
    [SerializeField]
    private UILabel content_Lab;
    [SerializeField]
    private List<UIButton> btnList; //UIButton最多为3

    public void ShowMessageBox(string title, string content, List<ButtonEvent> btnEventList)
    {
        grid.repositionNow = true;
        title_Lab.text = title;
        content_Lab.text = content;

        for (int i = 0; i < btnList.Count; i++)
        {
            if (i < btnEventList.Count)
            {
                btnList[i].gameObject.SetActive(true);
                btnList[i].transform.Find("text").GetComponent<UILabel>().text = btnEventList[i].btnText;

                if (i == 0)
                {
                    UIEventListener.Get(btnList[i].gameObject).onClick = delegate
                    {
                        btnEventList[0].btnEvent.Invoke();
                    };
                }
                else if(i == 1)
                {
                    UIEventListener.Get(btnList[i].gameObject).onClick = delegate
                    {
                        btnEventList[1].btnEvent.Invoke();
                    };
                }
                else if(i == 2)
                {
                    UIEventListener.Get(btnList[i].gameObject).onClick = delegate
                    {
                        btnEventList[1].btnEvent.Invoke();
                    };
                }
            }
            else
            {
                btnList[i].gameObject.SetActive(false);
            }
        }
    }

    public static MessageBox CreateMessageBox()
    {
        XYHY.IResourceMgr resMgr = Framework.GameKernel.Get<XYHY.IResourceMgr>();
        UnityEngine.Object verUpdateObj = resMgr.LoadNormalObjSync(new AssetBundleParams("Prefabs/UI/VersionUpdate/message_box_ui", typeof(GameObject)));
        GameObject verUpdateGo = GameObject.Instantiate(verUpdateObj) as GameObject;
        XYHY.LuaDestroyBundle ctrl = verUpdateGo.AddComponent<XYHY.LuaDestroyBundle>();
        ctrl.BundleName = "Prefabs/UI/VersionUpdate/message_box_ui";
        ctrl.ResType = typeof(GameObject);
        verUpdateGo.transform.parent = UICamera.mainCamera.transform;
        verUpdateGo.transform.localScale = Vector3.one;

        return verUpdateGo.GetComponent<MessageBox>();
    }
}

public struct ButtonEvent
{
    public string btnText;
    public Action btnEvent;

    public ButtonEvent(string btnText, Action btnEvent)
    {
        this.btnText = btnText;
        this.btnEvent = btnEvent;
    }
}