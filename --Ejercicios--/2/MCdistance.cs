using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MCdistance : MonoBehaviour
{
    [SerializeField] private Material material;
    [SerializeField] private Transform mc;

    private Vector3 mcPos;
    
    private static readonly int Position = Shader.PropertyToID("_Position");

    void Awake()
    {
        mcPos = mc.position;
    }

    // Update is called once per frame
    void Update()
    {
        material.SetVector(Position, mc.position);
    }   
}
