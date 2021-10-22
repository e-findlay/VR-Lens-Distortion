using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    public Vector3 Angles;
    // Start is called before the first frame update
    void Start()
    {

        //transform.Rotate(new Vector3(0,45,0));
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(Angles * Time.deltaTime);

    }
}