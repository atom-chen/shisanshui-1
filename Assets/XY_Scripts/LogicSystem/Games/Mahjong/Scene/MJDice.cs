using UnityEngine;
using System.Collections;

public class MJDice : MonoBehaviour {

    private float AllTime;
    private bool bAni;
    private bool bLaterHide;
    private float midTime;
    private float passTime;
    private float rSpeed = 3000f;
    private Vector3 offsetMax = new Vector3(0f, 0f, 0.3f);
    private Vector3 offsetMin = new Vector3(0f, 0f, 0.1f);
    private GameObject objSelf;
    private Transform tranSelf;
    private Quaternion quatSaizi0 = Quaternion.identity;
    private Quaternion quatSaizi1 = Quaternion.identity;
    [SerializeField]
    private Transform[] tranSaizi = new Transform[2];

    private void Awake()
    {
        this.FindChild();
        this.objSelf.SetActive(false);
    }

    protected virtual void FindChild()
    {
        this.objSelf = base.gameObject;
        this.tranSelf = base.transform;
        for (int i = 0; i < 2; i++)
        {
            this.tranSaizi[i] = tranSelf.FindChild("Dice"+i.ToString());
        }

    }

    private Quaternion getSaiziRotate(int val)
    {
        Quaternion identity;
        Quaternion quaternion2;
        switch (val)
        {
            case 4:
                identity = Quaternion.identity * Quaternion.AngleAxis(-90f, Vector3.forward);
                quaternion2 = Quaternion.AngleAxis((float)UnityEngine.Random.Range(0, 360), Vector3.left);
                break;

            case 1:
                identity = Quaternion.identity * Quaternion.AngleAxis(180f, Vector3.right);
                quaternion2 = Quaternion.AngleAxis((float)UnityEngine.Random.Range(0, 360), Vector3.up);
                break;

            case 2:
                identity = Quaternion.identity * Quaternion.AngleAxis(90f, Vector3.forward);
                quaternion2 = Quaternion.AngleAxis((float)UnityEngine.Random.Range(0, 360), Vector3.left);
                break;

            case 3:
                identity = Quaternion.identity * Quaternion.AngleAxis(-90f, Vector3.right);
                quaternion2 = Quaternion.AngleAxis((float)UnityEngine.Random.Range(0, 360), Vector3.forward);
                break;

            case 5:
                identity = Quaternion.identity * Quaternion.AngleAxis(90f, Vector3.right);
                quaternion2 = Quaternion.AngleAxis((float)UnityEngine.Random.Range(0, 360), Vector3.forward);
                break;

            default:
                quaternion2 = Quaternion.AngleAxis((float)UnityEngine.Random.Range(0, 360), Vector3.up);
                identity = Quaternion.identity;
                break;
        }
        return (identity * quaternion2);
    }

    public void Init()
    {
        this.bAni = false;
        this.AllTime = 2f;
        this.passTime = 0f;
        this.midTime = 0f;
        this.tranSaizi[0].localRotation = this.getSaiziRotate(UnityEngine.Random.Range(1, 7));
        this.tranSaizi[1].localRotation = this.getSaiziRotate(UnityEngine.Random.Range(1, 7));
        this.objSelf.SetActive(false);
    }

    public void Play(bool hide)
    {
        if (!this.bAni)
        {
            if (!this.objSelf.activeSelf)
            {
                this.objSelf.SetActive(true);
            }
            this.midTime = this.AllTime * 0.5f;
            this.passTime = 0f;
            this.bLaterHide = hide;
            int val = 1;
            int num2 = 4;
            this.quatSaizi0 = this.getSaiziRotate(val);
            this.quatSaizi1 = this.getSaiziRotate(num2);
            this.bAni = true;
        }
    }

    private void Update()
    {
        if (this.bAni)
        {
            this.passTime += Time.deltaTime;
            if (this.passTime < this.AllTime)
            {
                float t = this.passTime / this.AllTime;
                this.tranSelf.Rotate(Vector3.up, (float)(Time.deltaTime * Mathf.Lerp(this.rSpeed, 0f, t)));
                this.tranSelf.Rotate(Vector3.up, (float)1f);
                if (this.passTime < this.midTime)
                {
                    t = this.passTime / this.midTime;
                    this.tranSaizi[0].localPosition = Vector3.Lerp(this.offsetMin, this.offsetMax, t);
                    this.tranSaizi[1].localPosition = -this.tranSaizi[0].localPosition;
                    this.tranSaizi[0].localRotation = UnityEngine.Random.rotation;
                    this.tranSaizi[1].localRotation = UnityEngine.Random.rotation;
                }
                else
                {
                    t = (this.passTime - this.midTime) / (this.AllTime - this.midTime);
                    this.tranSaizi[0].localPosition = Vector3.Lerp(this.offsetMax, this.offsetMin, t);
                    this.tranSaizi[1].localPosition = -this.tranSaizi[0].localPosition;
                    this.tranSaizi[0].localRotation = Quaternion.Slerp(this.tranSaizi[0].localRotation, this.quatSaizi0, t);
                    this.tranSaizi[1].localRotation = Quaternion.Slerp(this.tranSaizi[1].localRotation, this.quatSaizi1, t);
                }
            }
            else if (!this.bLaterHide)
            {
                this.bAni = false;
            }
            else if (this.passTime > this.AllTime)
            {
                if (this.bLaterHide)
                {
                    base.StartCoroutine(this.Hide(4f));
                }
                this.bAni = false;
            }
        }
    }

    public void Hide()
    {
        this.objSelf.SetActive(false);
    }

    IEnumerator Hide(float time)
    {
        yield return new WaitForSeconds(time);
        Hide();
    }
}
