using UnityEngine;
using System.Collections;

public class MJResMgr {

    public static string prefabPath = "Prefabs/Scene/Mahjong/";

    private Mesh[] _mjMesh = new Mesh[42];

    public Mesh GetMahjongMesh(int index)
    {
        return _mjMesh[index];
    }

    public GameObject CreateMJTable()
    {
        GameObject prefab = Resources.Load<GameObject>(prefabPath+"MJTable");
        if (prefab == null)
        {
            Debug.LogError("CreateMJTable");
            return null;
        }
        return prefab;
    }

    public void LoadMJMesh()
    {
        GameObject prefab = Resources.Load<GameObject>(prefabPath + "MahjongTiles");
        MeshFilter[] meshFileters = prefab.GetComponentsInChildren<MeshFilter>();
        for (int i = 0; i < meshFileters.Length; ++i)
        {
            _mjMesh[i] = meshFileters[i].sharedMesh;
        }
    }

    public GameObject CreateDice()
    {
        GameObject prefab = Resources.Load<GameObject>(prefabPath + "MJDice");
        if (prefab == null)
        {
            Debug.LogError("CreateDice");
            return null;
        }
        return prefab;
    }

    public GameObject CreatePlayers()
    {
        GameObject prefab = Resources.Load<GameObject>(prefabPath + "MJPlayer");
        if (prefab == null)
        {
            Debug.LogError("CreatePlayers");
            return null;
        }
        return prefab;
    }
}
