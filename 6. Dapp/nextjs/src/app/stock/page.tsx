'use client'
import React, {useState, useEffect} from 'react'
import axios from 'axios';

//https://dumbstockapi.com/stock?exchanges=NYSE
interface Stock {
    ticker: string;
    name: string;
}

const StockPage = () => {

    const [data, setData] = useState<Stock[] | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await axios.get<Stock[]>("https://dumbstockapi.com/stock?exchanges=NYSE")
                console.table(response.data);
                setData(response.data)
            } catch {

            } finally {
                setLoading(false)
            }
            await fetchData();
        }
    }, [])

    return (
        <div>
            {loading ? (
                <p>Loading......</p>
            ) : (
                <div>
                    {data?.map((item) => {
                        return <p key={item.ticker}>{item.ticker} - {item.name}</p>
                    })}
                </div>
            )}
        </div>
    )
}
export default StockPage
