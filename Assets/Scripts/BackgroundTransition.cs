using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BackgroundTransition : MonoBehaviour
{
    private Renderer _renderer;
    private float transitionValue = -1f;
    

    // Start is called before the first frame update
    void Start()
    {
        _renderer = gameObject.GetComponent<Renderer>();
        _renderer.material.SetFloat("LinearTransition", -transitionValue);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void OnBackgroundTransition()
    {

        transitionValue++;
            Debug.Log(transitionValue);

            
        
    }
}
