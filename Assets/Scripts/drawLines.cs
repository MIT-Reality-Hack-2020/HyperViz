using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class drawLines : MonoBehaviour
{

    public bool ann;
    public bool col;
    public GameObject thumb;
    //public Material lineMaterial;
    public Text txt;

    //public List<LineRenderer> lines = new List<LineRenderer>();
    int count;

    // Start is called before the first frame update
    void Start()
    {
        ann = false;
        col = false;
        count = 0;
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void toggleAnn()
    {
        ann = !ann;
        if (ann)
        {
            txt.text = "Annotation On";
        }
        else
        {
            txt.text = "Annotation Off";
        }
    }

    void OnCollisionEnter(Collision collision)
    {
        //Check for a match with the specified name on any GameObject that collides with your GameObject
        if (collision.gameObject.name == thumb.name)
        {
            if (ann)
            {
                count++;
                col = true;
                //If the GameObject's name matches the one you suggest, output this message in the console
                Debug.Log("Do something here");

                LineRenderer line = new GameObject().AddComponent<LineRenderer>();
                line.transform.parent = transform;
                line.SetPosition(0, transform.position);
                line.SetPosition(1, transform.position);
                string lineName = "_" + count;
                line.transform.name = lineName;
                line.sortingLayerName = "OnTop";
                line.sortingOrder = 5;
                line.SetWidth(0.005f, 0.005f);
                line.useWorldSpace = true;
                //line.material = lineMaterial;
                //lines.Add(line);
            }
        }
    }

    void OnCollisionStay(Collision collision)
    {
        if (ann)
        {
            LineRenderer line = GameObject.Find("_" + count).GetComponent<LineRenderer>();
            line.SetPosition(1, transform.position);
        }
    }

    public void removeChildren()
    {
        foreach (Transform child in transform)
        {
            Destroy(child.gameObject);
        }
    }
}
