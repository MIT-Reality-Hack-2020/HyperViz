using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit.UI;

public class CrossSectionDistribution : MonoBehaviour
{
    private Renderer _renderer;

    // Start is called before the first frame update
    void Start()
    {
        _renderer = gameObject.GetComponent<Renderer>();
    }

   
    
    public void CrossSection(SliderEventData eventData)
    {
        _renderer.material.SetFloat("_CrossSectionDistribution", eventData.NewValue+1);
        
        Debug.Log(eventData.NewValue+1);
    }
}
