using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit.UI;

public class RotationScript : MonoBehaviour
{
    //private Renderer _renderer;

    // Start is called before the first frame update
    void Start()
    {
        //_renderer = gameObject.GetComponent<Renderer>();
    }



    public void SliderRotation(SliderEventData eventData)
    {
        this.transform.rotation = Quaternion.Euler(-90, 180, -90 + eventData.NewValue * 360 + 80);

        //Debug.Log(eventData.NewValue + 1);
    }
}
