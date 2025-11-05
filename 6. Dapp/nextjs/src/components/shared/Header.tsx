import Link from "next/link";

export default function Header (){
    return (
        <>
            <Link href="/">Acceuil</Link>
            <Link href="/about">about</Link>
            <Link href="/contact">contact</Link>
            <Link href="/jeu">jeu</Link>
            <Link href="/cv">cv</Link>
            <Link href="/stock">stocks</Link>
        </>
    );
}
