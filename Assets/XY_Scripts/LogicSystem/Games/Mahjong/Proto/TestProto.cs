using UnityEngine;
using System.Collections;
using Mahjong;
using LitJson;

public class TestProto : MonoBehaviour {

	// Use this for initialization
	void Start () {
        Deal d = new Deal();

        d.cardCount.Add("p1", 13);
        d.cardCount.Add("p2", 13);
        d.cardCount.Add("p3", 13);
        d.cardCount.Add("p4", 14);
        string json_bill = JsonMapper.ToJson(d);
        Debug.Log(json_bill);

    }
	
	// Update is called once per frame
	void Update () {
	
	}
}
