'use client';
import {useEffect, useState} from "react";
import Link from "next/link";
import React from 'react'

const JeuPage = () => {

    const [number, setNumber] = useState(0);

    const increment = () => {
        setNumber((previous) => previous + 1);
    }

    useEffect(() => {
        console.log("Number a changé :o")
    }, [number])

    useEffect(() => {
        console.log("La page est chargée")
    }, [])

    useEffect(() => {
        console.log("Quelque chose a changé")
    })

    useEffect(() => {
        return () => {
            console.log("Le composant est démonté")

        }
    }, [])

    return (
        <>
            <div>{number}</div>
            <button onClick={increment}>Increment</button>
            <p>This page show state changes</p>
        </>
    )
}
export default JeuPage
