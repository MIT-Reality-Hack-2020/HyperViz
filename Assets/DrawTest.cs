using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawTest : MonoBehaviour
{
    public GameObject objectToInstantiate;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    public void InstantiateObjects()
    {
        GameObject tempObj = Instantiate(objectToInstantiate);
        tempObj.transform.position = transform.position;
        Debug.Log("Drawing");


    }


}
