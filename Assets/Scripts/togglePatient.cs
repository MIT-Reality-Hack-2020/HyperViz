using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class togglePatient : MonoBehaviour
{
    public GameObject patient;
    public GameObject scanData;
    public Text txt;
    public Text txt1;
    public Text txt2;
    public Text txt3;
    public Text txt4;

    // Start is called before the first frame update
    void Start()
    {
        patient.SetActive(true);
        scanData.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void toggleVis()
    {
        patient.SetActive(!patient.activeInHierarchy);
        scanData.SetActive(!scanData.activeInHierarchy);
        if (patient.active == false)
        {
            txt.text = "View Patient";
            txt1.text = "Skin";
            txt2.text = "Soft Tissue";
            txt3.text = "Bone";
            txt4.text = "Rotation";
        }
        else
        {
            txt.text = "View Scan";
            txt1.text = "";
            txt2.text = "";
            txt3.text = "";
            txt4.text = "";

        }
    }
}
