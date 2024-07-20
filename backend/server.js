const express = require("express");
const cors = require("cors");
const axios = require("axios");
const app = express();
const port = 3001;

app.use(express.json());
app.use(cors());
const API_KEY = "1657f46a50b0bcf1661c1368a6a322e4";
const BASE_URL = "http://api.coinlayer.com/";

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

app.post("/crypto-price", async (req, res) => {
  const symbol = req.body.symbol.toUpperCase();
  console.log(`Fetching price for symbol: ${symbol}`);
  if (!symbol) {
    return res.status(400).json({ error: "Symbol is required" });
  }
  try {
    const response = await axios.get(`${BASE_URL}live`, {
      params: {
        access_key: API_KEY,
      },
    });
    // console.log(response.data);
    const rates = response.data.rates;
    if (rates && rates[symbol]) {
      const price = rates[symbol];
      return res.json({ price });
    } else {
      return res.status(404).json({ error: "Invalid cryptocurrency symbol" });
    }
  } catch (error) {
    console.error(error);
  }
});
