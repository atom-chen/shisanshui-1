using UnityEngine;
using System.Collections;
using Spine.Unity;

//使用时将特效放入新加的UIPanel子节点下，UIPanel或特效上挂载UIEffect脚本
//通过控制特效Panel深度达到UI与特效直接的相互遮罩
//如果Custom为true，则使用自定义的渲染队列
public class UIEffect : MonoBehaviour
{
    public bool mIsCustom = false;
    public int mRenderQueue = 0;
    
    Renderer[] mRenderers;
    UIPanel panel;
    SkeletonAnimation[] skeletonAnimations;
    void Awake()
    {
        mRenderers = GetComponentsInChildren<Renderer>(true);
        panel = NGUITools.FindInParents<UIPanel>(gameObject);

        skeletonAnimations = GetComponentsInChildren<SkeletonAnimation>(true);

        SetRenderQueue();
    }
    void SetRenderQueue()
    {
        if (!mIsCustom && panel != null)
        {
            mRenderQueue = panel.startingRenderQueue;
        }

        if (skeletonAnimations != null && skeletonAnimations.Length > 0)
        {
            foreach (SkeletonAnimation skeleton in skeletonAnimations)
            {
                skeleton.ChangeQueue(mRenderQueue);
            }
        }
        if (mRenderers != null && mRenderers.Length > 0)
        {
            foreach (Renderer r in mRenderers)
            {
                if (r != null)
                {
                    Material[] materials = r.materials;
                    foreach (Material m in materials)
                    {
                        if (m != null)
                        {
                            m.renderQueue = mRenderQueue;
                        }
                    }
                }
            }
        }
    }
}
