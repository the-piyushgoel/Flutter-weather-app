/**
 * Weather Backend Server
 * 
 * Express server that proxies OpenWeatherMap API requests,
 * extracts only required fields, and implements in-memory caching.
 */

require('dotenv').config();
const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;
const API_KEY = process.env.OPENWEATHER_API_KEY;

// ── Middleware ──────────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());

// ── In-Memory Cache ────────────────────────────────────────────────────────────
// Cache structure: { [cityKey]: { data, timestamp } }
const cache = new Map();
const CACHE_TTL_MS = 10 * 60 * 1000; // 10 minutes

/**
 * Returns cached data if fresh, otherwise null.
 */
function getCachedData(city) {
  const key = city.toLowerCase().trim();
  const entry = cache.get(key);
  if (entry && Date.now() - entry.timestamp < CACHE_TTL_MS) {
    return entry.data;
  }
  // Expired or not found — remove stale entry
  cache.delete(key);
  return null;
}

/**
 * Stores data in cache with current timestamp.
 */
function setCachedData(city, data) {
  const key = city.toLowerCase().trim();
  cache.set(key, { data, timestamp: Date.now() });
}

app.get('/', (req, res) => {
  res.json({
    status: 'ok',
    service: 'Weather Backend API',
    version: '1.0.0',
    endpoints: {
      weather: 'GET /weather?city=CityName',
    },
  });
});

app.get('/weather', async (req, res) => {
  try {
    const { city } = req.query;

    // Validate city parameter
    if (!city || typeof city !== 'string' || city.trim().length === 0) {
      return res.status(400).json({
        error: true,
        message: 'Missing or invalid "city" query parameter. Usage: /weather?city=London',
      });
    }

    const cityName = city.trim();

 
    const cached = getCachedData(cityName);
    if (cached) {
      console.log(`[CACHE HIT] ${cityName}`);
      return res.json({ ...cached, cached: true });
    }


    if (!API_KEY || API_KEY === 'your_api_key_here') {
      return res.status(500).json({
        error: true,
        message: 'Server misconfiguration: OpenWeatherMap API key not set. Check .env file.',
      });
    }
    console.log("API KEY:", process.env.OPENWEATHER_API_KEY);
    console.log(`[API CALL] Fetching weather for: ${cityName}`);

    // Fetch from OpenWeatherMap
    const response = await axios.get('https://api.openweathermap.org/data/2.5/weather', {
      params: {
        q: cityName,
        appid: API_KEY,
        units: 'metric',
      },
      timeout: 10000,
    });

    const raw = response.data;
    const weatherData = {
      city: raw.name,
      country: raw.sys?.country || '',
      temperature: Math.round(raw.main.temp * 10) / 10,
      feelsLike: Math.round(raw.main.feels_like * 10) / 10,
      tempMin: Math.round(raw.main.temp_min * 10) / 10,
      tempMax: Math.round(raw.main.temp_max * 10) / 10,
      condition: raw.weather[0]?.main || 'Unknown',
      description: raw.weather[0]?.description || '',
      humidity: raw.main.humidity,
      windSpeed: raw.wind?.speed || 0,
      icon: raw.weather[0]?.icon || '01d',
      pressure: raw.main.pressure,
      visibility: raw.visibility || 0,
      cloudiness: raw.clouds?.all || 0,
      sunrise: raw.sys?.sunrise || 0,
      sunset: raw.sys?.sunset || 0,
      timezone: raw.timezone || 0,
      dt: raw.dt || 0,
      cached: false,
    };

    setCachedData(cityName, weatherData);

    return res.json(weatherData);
  } catch (error) {
    if (error.response) {
      const status = error.response.status;
      if (status === 404) {
        return res.status(404).json({
          error: true,
          message: `City "${req.query.city}" not found. Please check the spelling and try again.`,
        });
      }
      if (status === 401) {
        return res.status(502).json({
          error: true,
          message: 'Invalid API key. Please check your OpenWeatherMap API key.',
        });
      }
      return res.status(502).json({
        error: true,
        message: `Weather service error (${status}). Please try again later.`,
      });
    }
    if (error.code === 'ECONNABORTED') {
      return res.status(504).json({
        error: true,
        message: 'Weather service request timed out. Please try again.',
      });
    }

    console.error('[ERROR]', error.message);
    return res.status(500).json({
      error: true,
      message: 'Internal server error. Please try again later.',
    });
  }
});
app.listen(PORT, () => {
  console.log(`\n🌤️  Weather Backend running on http://localhost:${PORT}`);
  console.log(`   Endpoint: GET /weather?city=CityName`);
  console.log(`   Cache TTL: ${CACHE_TTL_MS / 1000 / 60} minutes`);
  console.log(`   API Key: ${API_KEY ? '✅ Configured' : '❌ MISSING — check .env file'}\n`);
});
