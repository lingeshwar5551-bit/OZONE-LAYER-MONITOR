<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ozone Layer Monitor - Real-time Environmental Data</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Inter', sans-serif; }
        .gradient-bg { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .card-shadow { box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .pulse-animation { animation: pulse 2s infinite; }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }
        .blink-effect {
            animation: blink 0.5s ease-in-out 3;
        }
        @keyframes blink {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.7; transform: scale(1.05); }
        }
        .ozone-layer {
            width: 300px;
            height: 300px;
            border-radius: 50%;
            position: relative;
            animation: rotate 20s linear infinite;
            background: conic-gradient(from 0deg, #4ade80, #22d3ee, #3b82f6, #8b5cf6, #ef4444, #f59e0b, #4ade80);
        }
        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        .ozone-hole {
            position: absolute;
            top: 20%;
            right: 15%;
            width: 80px;
            height: 80px;
            background: radial-gradient(circle, rgba(239, 68, 68, 0.8), rgba(239, 68, 68, 0.3));
            border-radius: 50%;
            animation: pulse-hole 3s ease-in-out infinite;
        }
        @keyframes pulse-hole {
            0%, 100% { transform: scale(1); opacity: 0.8; }
            50% { transform: scale(1.1); opacity: 1; }
        }
        .card-hover:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
            transition: all 0.3s ease;
        }
        .daily-photo {
            width: 100%;
            height: 200px;
            background: linear-gradient(45deg, #1e40af, #3730a3, #581c87, #7c2d12);
            border-radius: 12px;
            position: relative;
            overflow: hidden;
            animation: shimmer 3s ease-in-out infinite;
        }
        @keyframes shimmer {
            0%, 100% { background-position: -200% 0; }
            50% { background-position: 200% 0; }
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">
    <!-- Header -->
    <header class="gradient-bg text-white py-8">
        <div class="container mx-auto px-6">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-4xl font-bold mb-2">🌍 Ozone Layer Monitor</h1>
                    <p class="text-blue-100 text-lg">Real-time atmospheric protection tracking</p>
                </div>
                <div class="text-right">
                    <div class="text-sm text-blue-100">Last Updated</div>
                    <div id="lastUpdate" class="text-xl font-semibold"></div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Dashboard -->
    <main class="container mx-auto px-6 py-8">
        <!-- Current Status Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <!-- Overall Health -->
            <div class="bg-white rounded-xl p-6 card-shadow card-hover cursor-pointer" id="healthCard" onclick="blinkCard('healthCard')">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-semibold text-gray-800">Overall Health</h3>
                    <div class="w-3 h-3 bg-yellow-400 rounded-full pulse-animation"></div>
                </div>
                <div class="text-3xl font-bold text-yellow-600 mb-2" id="overallHealth">72.3%</div>
                <p class="text-sm text-gray-600">Moderate depletion detected</p>
            </div>

            <!-- Daily Change -->
            <div class="bg-white rounded-xl p-6 card-shadow card-hover cursor-pointer" id="changeCard" onclick="blinkCard('changeCard')">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-semibold text-gray-800">Daily Change</h3>
                    <span class="text-green-500">↗️</span>
                </div>
                <div class="text-3xl font-bold text-green-600 mb-2" id="dailyChange">+0.12%</div>
                <p class="text-sm text-gray-600">Slight improvement today</p>
            </div>

            <!-- Critical Areas -->
            <div class="bg-white rounded-xl p-6 card-shadow card-hover cursor-pointer" id="criticalCard" onclick="blinkCard('criticalCard')">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-semibold text-gray-800">Critical Areas</h3>
                    <span class="text-red-500">⚠️</span>
                </div>
                <div class="text-3xl font-bold text-red-600 mb-2" id="criticalAreas">3</div>
                <p class="text-sm text-gray-600">Regions need attention</p>
            </div>
        </div>

        <!-- Animated Ozone Layer Visualization -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
            <!-- Current Ozone Layer Photo -->
            <div class="bg-white rounded-xl p-6 card-shadow">
                <h3 class="text-xl font-semibold text-gray-800 mb-4">🌍 Current Ozone Layer Condition</h3>
                <div class="flex justify-center mb-4">
                    <div class="ozone-layer">
                        <div class="ozone-hole"></div>
                    </div>
                </div>
                <div class="text-center">
                    <p class="text-sm text-gray-600 mb-2">Antarctic Ozone Hole - Real-time Satellite View</p>
                    <p class="text-xs text-gray-500" id="ozoneTimestamp">Updated: Loading...</p>
                </div>
            </div>

            <!-- Daily Photo Archive -->
            <div class="bg-white rounded-xl p-6 card-shadow">
                <h3 class="text-xl font-semibold text-gray-800 mb-4">📅 Daily Ozone Photos</h3>
                <div class="space-y-4">
                    <div class="daily-photo relative">
                        <canvas id="dailyOzoneChart" class="absolute inset-0 w-full h-full rounded-xl"></canvas>
                        <div class="absolute bottom-3 left-3 bg-black bg-opacity-70 text-white px-3 py-1 rounded text-sm">
                            Today - <span id="todayDate"></span>
                        </div>
                        <div class="absolute top-3 right-3 bg-yellow-500 text-white px-2 py-1 rounded-full text-xs font-bold">
                            72.3%
                        </div>
                    </div>
                    <div class="grid grid-cols-3 gap-2">
                        <div class="h-16 bg-gradient-to-br from-blue-400 to-purple-500 rounded opacity-80 relative">
                            <div class="absolute bottom-1 left-1 text-white text-xs">Yesterday</div>
                        </div>
                        <div class="h-16 bg-gradient-to-br from-green-400 to-blue-500 rounded opacity-80 relative">
                            <div class="absolute bottom-1 left-1 text-white text-xs">2 days ago</div>
                        </div>
                        <div class="h-16 bg-gradient-to-br from-red-400 to-pink-500 rounded opacity-80 relative">
                            <div class="absolute bottom-1 left-1 text-white text-xs">3 days ago</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Educational Video Section -->
        <div class="bg-white rounded-xl p-6 card-shadow mb-8">
            <h3 class="text-xl font-semibold text-gray-800 mb-4">🎬 Educational Video: Ozone Layer Destruction</h3>
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Video Player -->
                <div class="lg:col-span-2">
                    <div class="relative bg-black rounded-xl overflow-hidden">
                        <!-- Video Header -->
                        <div class="absolute top-0 left-0 right-0 bg-gradient-to-b from-black to-transparent p-4 z-10">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center space-x-3">
                                    <div class="w-3 h-3 bg-red-500 rounded-full animate-pulse"></div>
                                    <span class="text-white text-sm font-semibold">🛰️ LIVE SATELLITE - NASA</span>
                                </div>
                                <div class="text-white text-sm">
                                    <span id="videoViewers">12,847</span> viewers
                                </div>
                            </div>
                        </div>
                        
                        <!-- Animated Video Content -->
                        <div class="aspect-video bg-gradient-to-br from-blue-900 via-purple-900 to-black relative overflow-hidden">
                            <!-- Earth Animation -->
                            <div class="absolute inset-0 flex items-center justify-center">
                                <div class="relative">
                                    <!-- Earth -->
                                    <div class="w-48 h-48 rounded-full bg-gradient-to-br from-blue-400 via-green-400 to-blue-600 relative animate-spin" style="animation-duration: 20s;">
                                        <!-- Continents -->
                                        <div class="absolute top-8 left-12 w-16 h-12 bg-green-600 rounded-full opacity-80"></div>
                                        <div class="absolute bottom-12 right-8 w-20 h-8 bg-green-500 rounded-full opacity-70"></div>
                                        <div class="absolute top-16 right-16 w-12 h-16 bg-green-600 rounded-full opacity-75"></div>
                                    </div>
                                    
                                    <!-- Ozone Layer -->
                                    <div class="absolute -inset-4 rounded-full border-4 border-blue-300 opacity-60 animate-pulse"></div>
                                    <div class="absolute -inset-6 rounded-full border-2 border-cyan-200 opacity-40 animate-pulse" style="animation-delay: 0.5s;"></div>
                                    
                                    <!-- Ozone Hole (Growing) -->
                                    <div class="absolute top-4 right-4 w-12 h-12 bg-red-500 rounded-full opacity-80 animate-ping"></div>
                                    <div class="absolute top-6 right-6 w-8 h-8 bg-red-600 rounded-full animate-pulse"></div>
                                    
                                    <!-- UV Rays -->
                                    <div class="absolute -top-20 left-1/2 transform -translate-x-1/2">
                                        <div class="flex space-x-2">
                                            <div class="w-1 h-16 bg-yellow-400 animate-pulse"></div>
                                            <div class="w-1 h-16 bg-orange-400 animate-pulse" style="animation-delay: 0.2s;"></div>
                                            <div class="w-1 h-16 bg-red-400 animate-pulse" style="animation-delay: 0.4s;"></div>
                                            <div class="w-1 h-16 bg-yellow-400 animate-pulse" style="animation-delay: 0.6s;"></div>
                                        </div>
                                    </div>
                                    
                                    <!-- CFC Molecules -->
                                    <div class="absolute -bottom-16 left-8 w-3 h-3 bg-purple-500 rounded-full animate-bounce"></div>
                                    <div class="absolute -bottom-12 right-12 w-3 h-3 bg-purple-600 rounded-full animate-bounce" style="animation-delay: 0.3s;"></div>
                                    <div class="absolute -bottom-20 left-1/2 w-3 h-3 bg-purple-400 rounded-full animate-bounce" style="animation-delay: 0.6s;"></div>
                                </div>
                            </div>
                            
                            <!-- Destruction Animation Overlay -->
                            <div class="absolute inset-0 bg-red-500 opacity-0 animate-pulse" id="destructionOverlay" style="animation-duration: 3s;"></div>
                            
                            <!-- Video Info Overlay -->
                            <div class="absolute bottom-4 left-4 right-4">
                                <div class="bg-black bg-opacity-70 rounded-lg p-3">
                                    <h4 class="text-white font-semibold text-sm mb-1">How CFCs Destroy the Ozone Layer</h4>
                                    <p class="text-gray-300 text-xs">Real-time visualization of ozone depletion process</p>
                                    <div class="flex items-center mt-2 space-x-4 text-xs text-gray-400">
                                        <span>🌡️ Stratosphere: -60°C</span>
                                        <span>📊 Depletion Rate: 2.3%/year</span>
                                        <span>⚠️ UV Increase: +15%</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Video Controls -->
                        <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black to-transparent p-4">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center space-x-3">
                                    <button onclick="toggleVideoPlay()" class="text-white hover:text-blue-400 transition-colors">
                                        <span id="playIcon">⏸️</span>
                                    </button>
                                    <button onclick="toggleVideoMute()" class="text-white hover:text-blue-400 transition-colors">
                                        <span id="videoMuteIcon">🔊</span>
                                    </button>
                                    <div class="text-white text-sm">
                                        <span id="videoTime">2:34</span> / 5:42
                                    </div>
                                </div>
                                <div class="flex items-center space-x-2">
                                    <button onclick="shareVideo()" class="text-white hover:text-blue-400 transition-colors text-sm">
                                        📤 Share
                                    </button>
                                    <button onclick="toggleVideoFullscreen()" class="text-white hover:text-blue-400 transition-colors">
                                        🖥️
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Progress Bar -->
                            <div class="mt-2 bg-gray-600 rounded-full h-1 overflow-hidden">
                                <div class="bg-blue-500 h-full rounded-full transition-all duration-1000" id="videoProgress" style="width: 45%;"></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Video Information Panel -->
                <div class="space-y-4">
                    <div>
                        <h4 class="font-semibold text-gray-800 mb-3">📚 What You're Watching</h4>
                        <div class="space-y-3">
                            <div class="p-3 bg-red-50 border-l-4 border-red-500 rounded">
                                <div class="font-semibold text-red-800 text-sm">🧪 CFC Molecules</div>
                                <p class="text-red-600 text-xs mt-1">Chlorofluorocarbons rising to stratosphere</p>
                            </div>
                            <div class="p-3 bg-blue-50 border-l-4 border-blue-500 rounded">
                                <div class="font-semibold text-blue-800 text-sm">🌍 Ozone Layer</div>
                                <p class="text-blue-600 text-xs mt-1">Protective shield 15-35km above Earth</p>
                            </div>
                            <div class="p-3 bg-yellow-50 border-l-4 border-yellow-500 rounded">
                                <div class="font-semibold text-yellow-800 text-sm">☀️ UV Radiation</div>
                                <p class="text-yellow-600 text-xs mt-1">Harmful rays penetrating ozone holes</p>
                            </div>
                            <div class="p-3 bg-purple-50 border-l-4 border-purple-500 rounded">
                                <div class="font-semibold text-purple-800 text-sm">⚡ Chemical Reaction</div>
                                <p class="text-purple-600 text-xs mt-1">Chlorine atoms destroying ozone molecules</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Video Stats -->
                    <div class="bg-gray-50 p-4 rounded-lg">
                        <h5 class="font-semibold text-gray-700 mb-3">📊 Live Statistics</h5>
                        <div class="space-y-2 text-sm">
                            <div class="flex justify-between">
                                <span class="text-gray-600">Viewers:</span>
                                <span class="font-semibold text-blue-600" id="liveViewers">12,847</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Quality:</span>
                                <span class="font-semibold text-green-600">4K Ultra HD</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Latency:</span>
                                <span class="font-semibold text-yellow-600">2.3s</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Uptime:</span>
                                <span class="font-semibold text-purple-600">24/7</span>
                            </div>
                        </div>
                        
                        <div class="mt-4 pt-3 border-t border-gray-200">
                            <div class="text-xs text-gray-500 mb-2">Educational Content by:</div>
                            <div class="flex items-center space-x-2">
                                <div class="w-6 h-6 bg-blue-600 rounded-full flex items-center justify-center">
                                    <span class="text-white text-xs font-bold">N</span>
                                </div>
                                <span class="text-sm font-semibold text-gray-700">NASA Earth Science</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="space-y-2">
                        <button onclick="downloadVideo()" class="w-full bg-blue-600 hover:bg-blue-700 text-white py-2 px-4 rounded-lg transition-colors text-sm font-semibold">
                            💾 Download Video
                        </button>
                        <button onclick="shareVideo()" class="w-full bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded-lg transition-colors text-sm font-semibold">
                            📤 Share Video
                        </button>
                        <button onclick="takeSnapshot()" class="w-full bg-purple-600 hover:bg-purple-700 text-white py-2 px-4 rounded-lg transition-colors text-sm font-semibold">
                            📸 Take Snapshot
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
            <!-- 30-Day Ozone Depletion Trend -->
            <div class="bg-white rounded-xl p-6 card-shadow">
                <h3 class="text-xl font-semibold text-gray-800 mb-4">📈 30-Day Ozone Depletion Trend</h3>
                <canvas id="depletionChart" width="400" height="200"></canvas>
                <div class="mt-4 grid grid-cols-3 gap-4 text-center">
                    <div class="p-5 bg-blue-50 rounded-lg">
                        <div class="text-base text-gray-600">Average</div>
                        <div class="text-2xl font-bold text-blue-600" id="avgHealth">72.8%</div>
                    </div>
                    <div class="p-5 bg-green-50 rounded-lg">
                        <div class="text-base text-gray-600">Best Day</div>
                        <div class="text-2xl font-bold text-green-600" id="bestHealth">78.2%</div>
                    </div>
                    <div class="p-5 bg-red-50 rounded-lg">
                        <div class="text-base text-gray-600">Worst Day</div>
                        <div class="text-2xl font-bold text-red-600" id="worstHealth">65.1%</div>
                    </div>
                </div>
            </div>

            <!-- Regional Damage Distribution -->
            <div class="bg-white rounded-xl p-6 card-shadow">
                <h3 class="text-xl font-semibold text-gray-800 mb-4">🌐 Regional Damage Distribution</h3>
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div>
                        <canvas id="regionalChart" width="400" height="200"></canvas>
                    </div>
                    <div class="space-y-4">
                        <h4 class="text-lg font-semibold text-gray-700 mb-3">Regional Details</h4>
                        
                        <!-- Antarctica -->
                        <div class="bg-red-50 border-l-4 border-red-500 p-4 rounded cursor-pointer hover:bg-red-100 transition-colors" onclick="showRegionDetails('antarctica')">
                            <div class="flex justify-between items-center">
                                <div>
                                    <h5 class="font-semibold text-red-800">🧊 Antarctica</h5>
                                    <p class="text-sm text-red-600">Severe ozone depletion</p>
                                </div>
                                <div class="text-right">
                                    <div class="text-2xl font-bold text-red-700" id="antarcticaHealth">45.2%</div>
                                    <div class="text-xs text-red-500">Critical</div>
                                </div>
                            </div>
                        </div>

                        <!-- Arctic -->
                        <div class="bg-orange-50 border-l-4 border-orange-500 p-4 rounded cursor-pointer hover:bg-orange-100 transition-colors" onclick="showRegionDetails('arctic')">
                            <div class="flex justify-between items-center">
                                <div>
                                    <h5 class="font-semibold text-orange-800">❄️ Arctic</h5>
                                    <p class="text-sm text-orange-600">Moderate depletion</p>
                                </div>
                                <div class="text-right">
                                    <div class="text-2xl font-bold text-orange-700" id="arcticHealth">68.7%</div>
                                    <div class="text-xs text-orange-500">Warning</div>
                                </div>
                            </div>
                        </div>

                        <!-- Mid-Latitudes -->
                        <div class="bg-blue-50 border-l-4 border-blue-500 p-4 rounded cursor-pointer hover:bg-blue-100 transition-colors" onclick="showRegionDetails('midlatitudes')">
                            <div class="flex justify-between items-center">
                                <div>
                                    <h5 class="font-semibold text-blue-800">🌍 Mid-Latitudes</h5>
                                    <p class="text-sm text-blue-600">Fair condition</p>
                                </div>
                                <div class="text-right">
                                    <div class="text-2xl font-bold text-blue-700" id="midlatHealth">76.4%</div>
                                    <div class="text-xs text-blue-500">Stable</div>
                                </div>
                            </div>
                        </div>

                        <!-- Tropics -->
                        <div class="bg-green-50 border-l-4 border-green-500 p-4 rounded cursor-pointer hover:bg-green-100 transition-colors" onclick="showRegionDetails('tropics')">
                            <div class="flex justify-between items-center">
                                <div>
                                    <h5 class="font-semibold text-green-800">🌴 Tropics</h5>
                                    <p class="text-sm text-green-600">Good condition</p>
                                </div>
                                <div class="text-right">
                                    <div class="text-2xl font-bold text-green-700" id="tropicsHealth">89.1%</div>
                                    <div class="text-xs text-green-500">Healthy</div>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Stats -->
                        <div class="bg-gray-50 p-4 rounded-lg mt-4">
                            <h5 class="font-semibold text-gray-700 mb-2">📊 Quick Stats</h5>
                            <div class="grid grid-cols-2 gap-2 text-sm">
                                <div>Most Affected: <span class="font-semibold text-red-600">Antarctica</span></div>
                                <div>Healthiest: <span class="font-semibold text-green-600">Tropics</span></div>
                                <div>Trend: <span class="font-semibold text-blue-600" id="globalTrend">Improving</span></div>
                                <div>Last Update: <span class="font-semibold" id="chartUpdate">Live</span></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>



        <!-- UV Radiation Alert System -->
        <div class="bg-white rounded-xl p-6 card-shadow mb-8">
            <h3 class="text-xl font-semibold text-gray-800 mb-4">☀️ UV Radiation Alert System</h3>
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
                <div class="bg-green-50 border-l-4 border-green-500 p-4 rounded">
                    <div class="flex items-center">
                        <div class="w-3 h-3 bg-green-500 rounded-full mr-2"></div>
                        <span class="font-semibold text-green-800">Low (1-2)</span>
                    </div>
                    <p class="text-sm text-green-600 mt-1">Safe exposure</p>
                </div>
                <div class="bg-yellow-50 border-l-4 border-yellow-500 p-4 rounded">
                    <div class="flex items-center">
                        <div class="w-3 h-3 bg-yellow-500 rounded-full mr-2 pulse-animation"></div>
                        <span class="font-semibold text-yellow-800">Moderate (3-5)</span>
                    </div>
                    <p class="text-sm text-yellow-600 mt-1">Use protection</p>
                </div>
                <div class="bg-orange-50 border-l-4 border-orange-500 p-4 rounded">
                    <div class="flex items-center">
                        <div class="w-3 h-3 bg-orange-500 rounded-full mr-2"></div>
                        <span class="font-semibold text-orange-800">High (6-7)</span>
                    </div>
                    <p class="text-sm text-orange-600 mt-1">Seek shade</p>
                </div>
                <div class="bg-red-50 border-l-4 border-red-500 p-4 rounded">
                    <div class="flex items-center">
                        <div class="w-3 h-3 bg-red-500 rounded-full mr-2 pulse-animation"></div>
                        <span class="font-semibold text-red-800">Extreme (8+)</span>
                    </div>
                    <p class="text-sm text-red-600 mt-1">Avoid sun</p>
                </div>
            </div>
            
            <!-- Current UV Readings -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div class="bg-gradient-to-r from-blue-500 to-purple-600 text-white p-4 rounded-lg">
                    <h4 class="font-semibold mb-2">🌍 Global Average</h4>
                    <div class="text-2xl font-bold" id="globalUV">4.2</div>
                    <p class="text-sm opacity-90">Moderate level</p>
                </div>
                <div class="bg-gradient-to-r from-red-500 to-pink-600 text-white p-4 rounded-lg">
                    <h4 class="font-semibold mb-2">🔥 Highest Alert</h4>
                    <div class="text-2xl font-bold" id="highestUV">9.8</div>
                    <p class="text-sm opacity-90">Antarctica region</p>
                </div>
                <div class="bg-gradient-to-r from-green-500 to-teal-600 text-white p-4 rounded-lg">
                    <h4 class="font-semibold mb-2">📊 24h Change</h4>
                    <div class="text-2xl font-bold" id="uvChange">+1.3</div>
                    <p class="text-sm opacity-90">Increasing trend</p>
                </div>
            </div>
        </div>




    </main>

    <script>
        // Initialize charts and data
        let depletionChart, regionalChart;
        let currentData = {
            overallHealth: 72.3,
            dailyChange: 0.12,
            criticalAreas: 3
        };

        // Sample data for the last 30 days
        const last30Days = [];
        const today = new Date();
        for (let i = 29; i >= 0; i--) {
            const date = new Date(today);
            date.setDate(date.getDate() - i);
            const baseValue = 72 + Math.sin(i * 0.2) * 5 + (Math.random() - 0.5) * 3;
            last30Days.push({
                date: date.toLocaleDateString(),
                value: Math.max(40, Math.min(95, baseValue))
            });
        }

        // Initialize depletion trend chart
        function initDepletionChart() {
            const ctx = document.getElementById('depletionChart').getContext('2d');
            
            // Create gradient backgrounds for different health zones
            const gradient1 = ctx.createLinearGradient(0, 0, 0, 400);
            gradient1.addColorStop(0, 'rgba(16, 185, 129, 0.3)'); // Green (healthy)
            gradient1.addColorStop(0.3, 'rgba(59, 130, 246, 0.3)'); // Blue (good)
            gradient1.addColorStop(0.6, 'rgba(245, 158, 11, 0.3)'); // Orange (warning)
            gradient1.addColorStop(1, 'rgba(239, 68, 68, 0.3)'); // Red (critical)
            
            const gradient2 = ctx.createLinearGradient(0, 0, 0, 400);
            gradient2.addColorStop(0, 'rgba(16, 185, 129, 0.1)');
            gradient2.addColorStop(0.3, 'rgba(59, 130, 246, 0.1)');
            gradient2.addColorStop(0.6, 'rgba(245, 158, 11, 0.1)');
            gradient2.addColorStop(1, 'rgba(239, 68, 68, 0.1)');
            
            depletionChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: last30Days.map(d => d.date),
                    datasets: [
                        {
                            label: 'Ozone Health %',
                            data: last30Days.map(d => d.value),
                            borderColor: function(context) {
                                const value = context.parsed?.y;
                                if (value >= 80) return '#10B981'; // Green for healthy
                                if (value >= 70) return '#3B82F6'; // Blue for good
                                if (value >= 60) return '#F59E0B'; // Orange for warning
                                return '#EF4444'; // Red for critical
                            },
                            backgroundColor: gradient1,
                            borderWidth: 4,
                            fill: true,
                            tension: 0.4,
                            pointBackgroundColor: function(context) {
                                const value = context.parsed?.y;
                                if (value >= 80) return '#10B981';
                                if (value >= 70) return '#3B82F6';
                                if (value >= 60) return '#F59E0B';
                                return '#EF4444';
                            },
                            pointBorderColor: '#FFFFFF',
                            pointBorderWidth: 2,
                            pointRadius: 5,
                            pointHoverRadius: 8,
                            segment: {
                                borderColor: function(ctx) {
                                    const value = ctx.p1.parsed.y;
                                    if (value >= 80) return '#10B981';
                                    if (value >= 70) return '#3B82F6';
                                    if (value >= 60) return '#F59E0B';
                                    return '#EF4444';
                                }
                            }
                        },
                        // Add a secondary trend line for comparison
                        {
                            label: 'Previous Month Average',
                            data: last30Days.map(d => d.value - 2 + Math.random() * 4),
                            borderColor: 'rgba(156, 163, 175, 0.6)',
                            backgroundColor: 'rgba(156, 163, 175, 0.1)',
                            borderWidth: 2,
                            borderDash: [5, 5],
                            fill: false,
                            tension: 0.4,
                            pointRadius: 0,
                            pointHoverRadius: 4
                        }
                    ]
                },
                options: {
                    responsive: true,
                    interaction: {
                        intersect: false,
                        mode: 'index'
                    },
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top',
                            labels: {
                                usePointStyle: true,
                                padding: 20
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            titleColor: '#FFFFFF',
                            bodyColor: '#FFFFFF',
                            borderColor: '#374151',
                            borderWidth: 1,
                            callbacks: {
                                label: function(context) {
                                    const value = context.parsed.y;
                                    let status = '';
                                    if (value >= 80) status = ' (Healthy)';
                                    else if (value >= 70) status = ' (Good)';
                                    else if (value >= 60) status = ' (Warning)';
                                    else status = ' (Critical)';
                                    return context.dataset.label + ': ' + value.toFixed(1) + '%' + status;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: false,
                            min: 40,
                            max: 100,
                            grid: {
                                color: function(context) {
                                    const value = context.tick.value;
                                    if (value === 80) return 'rgba(16, 185, 129, 0.3)';
                                    if (value === 70) return 'rgba(59, 130, 246, 0.3)';
                                    if (value === 60) return 'rgba(245, 158, 11, 0.3)';
                                    return 'rgba(229, 231, 235, 0.5)';
                                },
                                lineWidth: function(context) {
                                    const value = context.tick.value;
                                    if ([60, 70, 80].includes(value)) return 2;
                                    return 1;
                                }
                            },
                            ticks: {
                                callback: function(value) {
                                    let label = value + '%';
                                    if (value === 80) label += ' 🟢';
                                    else if (value === 70) label += ' 🔵';
                                    else if (value === 60) label += ' 🟡';
                                    else if (value === 50) label += ' 🔴';
                                    return label;
                                },
                                color: function(context) {
                                    const value = context.tick.value;
                                    if (value >= 80) return '#10B981';
                                    if (value >= 70) return '#3B82F6';
                                    if (value >= 60) return '#F59E0B';
                                    return '#EF4444';
                                }
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                maxTicksLimit: 8
                            }
                        }
                    },
                    elements: {
                        point: {
                            hoverBackgroundColor: '#FFFFFF'
                        }
                    }
                }
            });
        }

        // Initialize regional chart
        function initRegionalChart() {
            const ctx = document.getElementById('regionalChart').getContext('2d');
            regionalChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Antarctica', 'Arctic', 'Mid-Latitudes', 'Tropics'],
                    datasets: [{
                        data: [45.2, 68.7, 76.4, 89.1],
                        backgroundColor: [
                            '#EF4444',
                            '#F59E0B',
                            '#3B82F6',
                            '#10B981'
                        ],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }

        // Initialize daily ozone chart
        function initDailyOzoneChart() {
            const ctx = document.getElementById('dailyOzoneChart').getContext('2d');
            
            // Generate hourly data for today
            const hourlyData = [];
            for (let i = 0; i < 24; i++) {
                const baseValue = 72 + Math.sin(i * 0.3) * 8 + (Math.random() - 0.5) * 4;
                hourlyData.push({
                    hour: i + ':00',
                    value: Math.max(40, Math.min(95, baseValue))
                });
            }
            
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: hourlyData.map(d => d.hour),
                    datasets: [{
                        label: 'Hourly Ozone %',
                        data: hourlyData.map(d => d.value),
                        borderColor: '#3B82F6',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#3B82F6',
                        pointBorderColor: '#FFFFFF',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            titleColor: '#FFFFFF',
                            bodyColor: '#FFFFFF',
                            callbacks: {
                                label: function(context) {
                                    return 'Ozone: ' + context.parsed.y.toFixed(1) + '%';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            display: false,
                            min: 40,
                            max: 100
                        },
                        x: {
                            display: false
                        }
                    },
                    elements: {
                        point: {
                            hoverBackgroundColor: '#FFFFFF'
                        }
                    }
                }
            });
        }



        // Update data values
        function updateData() {
            // Simulate small changes in data
            currentData.overallHealth += (Math.random() - 0.5) * 0.5;
            currentData.overallHealth = Math.max(40, Math.min(95, currentData.overallHealth));
            
            currentData.dailyChange = (Math.random() - 0.5) * 0.3;
            
            // Update display
            document.getElementById('overallHealth').textContent = currentData.overallHealth.toFixed(1) + '%';
            document.getElementById('dailyChange').textContent = 
                (currentData.dailyChange >= 0 ? '+' : '') + currentData.dailyChange.toFixed(2) + '%';
            
            // Update UV readings
            const globalUV = 2 + Math.random() * 6; // 2-8 range
            const highestUV = 8 + Math.random() * 3; // 8-11 range
            const uvChange = (Math.random() - 0.5) * 2; // -1 to +1 range
            
            document.getElementById('globalUV').textContent = globalUV.toFixed(1);
            document.getElementById('highestUV').textContent = highestUV.toFixed(1);
            document.getElementById('uvChange').textContent = 
                (uvChange >= 0 ? '+' : '') + uvChange.toFixed(1);
            
            // Update chart with new data point
            const newDate = new Date().toLocaleDateString();
            last30Days.shift(); // Remove oldest
            last30Days.push({
                date: newDate,
                value: currentData.overallHealth
            });
            
            depletionChart.data.labels = last30Days.map(d => d.date);
            depletionChart.data.datasets[0].data = last30Days.map(d => d.value);
            depletionChart.update('none');
        }

        // Blink effect for cards when touched/clicked
        function blinkCard(cardId) {
            const card = document.getElementById(cardId);
            card.classList.add('blink-effect');
            
            // Remove the class after animation completes
            setTimeout(() => {
                card.classList.remove('blink-effect');
            }, 1500);
        }

        // Update timestamp
        function updateTimestamp() {
            document.getElementById('lastUpdate').textContent = new Date().toLocaleString();
            document.getElementById('ozoneTimestamp').textContent = 'Updated: ' + new Date().toLocaleString();
        }

        // Update today's date
        function updateTodayDate() {
            const today = new Date();
            const options = { 
                weekday: 'short', 
                year: 'numeric', 
                month: 'short', 
                day: 'numeric' 
            };
            document.getElementById('todayDate').textContent = today.toLocaleDateString('en-US', options);
        }

        // Simulate ozone hole size changes
        function updateOzoneHole() {
            const hole = document.querySelector('.ozone-hole');
            const randomSize = 60 + Math.random() * 40; // Between 60-100px
            const randomTop = 15 + Math.random() * 20; // Between 15-35%
            const randomRight = 10 + Math.random() * 20; // Between 10-30%
            
            hole.style.width = randomSize + 'px';
            hole.style.height = randomSize + 'px';
            hole.style.top = randomTop + '%';
            hole.style.right = randomRight + '%';
        }



        // Show region details in popup
        function showRegionDetails(region) {
            const regionData = {
                antarctica: {
                    title: 'Antarctica Ozone Monitoring',
                    health: '45.2%',
                    status: 'Severe Depletion',
                    description: 'The Antarctic ozone hole is the largest and most severe depletion area.',
                    coordinates: '90°S, 0°E',
                    stations: ['McMurdo Station', 'Halley Research Station', 'Belgrano II Base'],
                    uvIndex: '11.2',
                    temperature: '-45°C',
                    trend: 'Slowly improving'
                },
                arctic: {
                    title: 'Arctic Ozone Monitoring',
                    health: '68.7%',
                    status: 'Moderate Depletion',
                    description: 'Arctic ozone levels show seasonal variations with winter depletion.',
                    coordinates: '90°N, 0°E',
                    stations: ['Alert Station', 'Ny-Ålesund', 'Barrow Observatory'],
                    uvIndex: '6.8',
                    temperature: '-25°C',
                    trend: 'Stable'
                },
                tropics: {
                    title: 'Tropical Ozone Monitoring',
                    health: '89.1%',
                    status: 'Good Condition',
                    description: 'Tropical regions maintain relatively stable ozone levels year-round.',
                    coordinates: '0°, 0°E',
                    stations: ['Mauna Loa', 'Singapore Station', 'Nairobi Observatory'],
                    uvIndex: '8.5',
                    temperature: '28°C',
                    trend: 'Improving'
                },
                midlatitudes: {
                    title: 'Mid-Latitude Ozone Monitoring',
                    health: '76.4%',
                    status: 'Fair Condition',
                    description: 'Mid-latitude regions show moderate seasonal ozone variations.',
                    coordinates: '45°N, 0°E',
                    stations: ['Boulder Station', 'Hohenpeissenberg', 'Tsukuba Observatory'],
                    uvIndex: '5.2',
                    temperature: '15°C',
                    trend: 'Improving'
                }
            };

            const data = regionData[region];
            
            // Create popup overlay
            const overlay = document.createElement('div');
            overlay.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
            overlay.onclick = function(e) {
                if (e.target === overlay) {
                    document.body.removeChild(overlay);
                }
            };
            
            // Create popup content
            overlay.innerHTML = `
                <div class="bg-white rounded-xl p-6 max-w-2xl mx-4 max-h-96 overflow-y-auto">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-2xl font-bold text-gray-800">${data.title}</h2>
                        <button onclick="document.body.removeChild(this.closest('.fixed'))" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <div class="text-4xl font-bold text-blue-600 mb-2">${data.health}</div>
                            <div class="text-lg text-gray-700 mb-4">${data.status}</div>
                            <p class="text-gray-600 mb-4">${data.description}</p>
                            
                            <div class="space-y-2 text-sm">
                                <div><strong>Coordinates:</strong> ${data.coordinates}</div>
                                <div><strong>UV Index:</strong> <span class="text-red-600 font-semibold">${data.uvIndex}</span></div>
                                <div><strong>Temperature:</strong> ${data.temperature}</div>
                                <div><strong>Trend:</strong> <span class="text-green-600">${data.trend}</span></div>
                            </div>
                        </div>
                        
                        <div>
                            <h3 class="font-semibold mb-3">Monitoring Stations</h3>
                            <div class="space-y-2">
                                ${data.stations.map(station => `
                                    <div class="p-2 bg-gray-50 rounded text-sm">
                                        <div class="font-medium">${station}</div>
                                        <div class="text-gray-600">Status: Active</div>
                                    </div>
                                `).join('')}
                            </div>
                            
                            <div class="mt-4 p-3 bg-blue-50 rounded">
                                <div class="text-sm font-semibold text-blue-800">Real-time Data</div>
                                <div class="text-xs text-blue-600">Updated: ${new Date().toLocaleString()}</div>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            
            document.body.appendChild(overlay);
        }

        // Navigate to regional detail page
        function goToRegion(region) {
            // Create detailed regional pages with specific data
            const regionData = {
                antarctica: {
                    title: 'Antarctica Ozone Monitoring',
                    health: '45.2%',
                    status: 'Severe Depletion',
                    description: 'The Antarctic ozone hole is the largest and most severe depletion area.',
                    coordinates: '90°S, 0°E',
                    stations: ['McMurdo Station', 'Halley Research Station', 'Belgrano II Base']
                },
                arctic: {
                    title: 'Arctic Ozone Monitoring',
                    health: '68.7%',
                    status: 'Moderate Depletion',
                    description: 'Arctic ozone levels show seasonal variations with winter depletion.',
                    coordinates: '90°N, 0°E',
                    stations: ['Alert Station', 'Ny-Ålesund', 'Barrow Observatory']
                },
                tropics: {
                    title: 'Tropical Ozone Monitoring',
                    health: '89.1%',
                    status: 'Good Condition',
                    description: 'Tropical regions maintain relatively stable ozone levels year-round.',
                    coordinates: '0°, 0°E',
                    stations: ['Mauna Loa', 'Singapore Station', 'Nairobi Observatory']
                },
                midlatitudes: {
                    title: 'Mid-Latitude Ozone Monitoring',
                    health: '76.4%',
                    status: 'Fair Condition',
                    description: 'Mid-latitude regions show moderate seasonal ozone variations.',
                    coordinates: '45°N, 0°E',
                    stations: ['Boulder Station', 'Hohenpeissenberg', 'Tsukuba Observatory']
                }
            };

            const data = regionData[region];
            
            // Create a new page content
            const newPageContent = `
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>${data.title}</title>
                    <script src="https://cdn.tailwindcss.com"></script>
                    <style>
                        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
                        body { font-family: 'Inter', sans-serif; }
                        .gradient-bg { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
                    </style>
                </head>
                <body class="bg-gray-50 min-h-screen">
                    <header class="gradient-bg text-white py-8">
                        <div class="container mx-auto px-6">
                            <button onclick="history.back()" class="mb-4 bg-white bg-opacity-20 hover:bg-opacity-30 px-4 py-2 rounded-lg transition-all">
                                ← Back to Dashboard
                            </button>
                            <h1 class="text-4xl font-bold mb-2">${data.title}</h1>
                            <p class="text-blue-100">Detailed regional ozone analysis</p>
                        </div>
                    </header>
                    
                    <main class="container mx-auto px-6 py-8">
                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                            <div class="bg-white rounded-xl p-6 shadow-lg">
                                <h2 class="text-2xl font-bold mb-4">Current Status</h2>
                                <div class="text-6xl font-bold text-blue-600 mb-4">${data.health}</div>
                                <div class="text-xl text-gray-700 mb-4">${data.status}</div>
                                <p class="text-gray-600 mb-6">${data.description}</p>
                                <div class="space-y-2">
                                    <div><strong>Coordinates:</strong> ${data.coordinates}</div>
                                    <div><strong>Last Updated:</strong> ${new Date().toLocaleString()}</div>
                                </div>
                            </div>
                            
                            <div class="bg-white rounded-xl p-6 shadow-lg">
                                <h2 class="text-2xl font-bold mb-4">Monitoring Stations</h2>
                                <div class="space-y-3">
                                    ${data.stations.map(station => `
                                        <div class="p-3 bg-gray-50 rounded-lg">
                                            <div class="font-semibold">${station}</div>
                                            <div class="text-sm text-gray-600">Status: Active</div>
                                        </div>
                                    `).join('')}
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-8 bg-white rounded-xl p-6 shadow-lg">
                            <h2 class="text-2xl font-bold mb-4">Recent Measurements</h2>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                <div class="p-4 bg-blue-50 rounded-lg">
                                    <div class="text-sm text-gray-600">UV Index</div>
                                    <div class="text-2xl font-bold text-blue-600">${Math.floor(Math.random() * 10) + 1}</div>
                                </div>
                                <div class="p-4 bg-green-50 rounded-lg">
                                    <div class="text-sm text-gray-600">Column Ozone (DU)</div>
                                    <div class="text-2xl font-bold text-green-600">${Math.floor(Math.random() * 200) + 200}</div>
                                </div>
                                <div class="p-4 bg-purple-50 rounded-lg">
                                    <div class="text-sm text-gray-600">Temperature (°C)</div>
                                    <div class="text-2xl font-bold text-purple-600">${Math.floor(Math.random() * 40) - 20}</div>
                                </div>
                            </div>
                        </div>
                    </main>
                <script>(function(){function c(){var b=a.contentDocument||a.contentWindow.document;if(b){var d=b.createElement('script');d.innerHTML="window.__CF$cv$params={r:'9801af276025380b',t:'MTc1ODAzOTU1My4wMDAwMDA='};var a=document.createElement('script');a.nonce='';a.src='/cdn-cgi/challenge-platform/scripts/jsd/main.js';document.getElementsByTagName('head')[0].appendChild(a);";b.getElementsByTagName('head')[0].appendChild(d)}}if(document.body){var a=document.createElement('iframe');a.height=1;a.width=1;a.style.position='absolute';a.style.top=0;a.style.left=0;a.style.border='none';a.style.visibility='hidden';document.body.appendChild(a);if('loading'!==document.readyState)c();else if(window.addEventListener)document.addEventListener('DOMContentLoaded',c);else{var e=document.onreadystatechange||function(){};document.onreadystatechange=function(b){e(b);'loading'!==document.readyState&&(document.onreadystatechange=e,c())}}}})();</script></body>
                </html>
            `;
            
            // Open in new window/tab
            const newWindow = window.open('', '_blank');
            newWindow.document.write(newPageContent);
            newWindow.document.close();
        }



        // Video control functions
        function switchVideo(videoType) {
            // Update video title and description based on type
            const titles = {
                protection: '🛡️ Ozone Protection Live - How Earth is Shielded',
                antarctica: '🧊 Antarctic Ozone Hole - Satellite View',
                global: '🌍 Global Ozone Distribution - 4K View',
                timelapse: '⏰ 30-Day Ozone Changes - Timelapse'
            };
            
            // Update active video selection
            document.querySelectorAll('.space-y-3 > div').forEach(div => {
                div.className = 'p-3 bg-gray-50 border-l-4 border-gray-300 rounded cursor-pointer hover:bg-gray-100 transition-colors';
            });
            
            // Highlight selected video
            const selectedDiv = document.querySelector('.space-y-3 > div');
            selectedDiv.className = 'p-3 bg-blue-50 border-l-4 border-blue-500 rounded cursor-pointer hover:bg-blue-100 transition-colors';
        }
        
        function toggleFullscreen() {
            const iframe = document.getElementById('ozoneVideo');
            if (iframe.requestFullscreen) {
                iframe.requestFullscreen();
            } else if (iframe.webkitRequestFullscreen) {
                iframe.webkitRequestFullscreen();
            } else if (iframe.msRequestFullscreen) {
                iframe.msRequestFullscreen();
            }
            
            // Show notification
            const notification = document.createElement('div');
            notification.className = 'fixed top-4 right-4 bg-blue-500 text-white px-4 py-2 rounded-lg shadow-lg z-50';
            notification.textContent = '🖥️ Fullscreen mode activated!';
            document.body.appendChild(notification);
            
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 3000);
        }
        
        function toggleMute() {
            const muteIcon = document.getElementById('muteIcon');
            const iframe = document.getElementById('ozoneVideo');
            
            // Toggle mute icon
            if (muteIcon.textContent === '🔇') {
                muteIcon.textContent = '🔊';
                // Update iframe src to unmute
                iframe.src = iframe.src.replace('mute=1', 'mute=0');
            } else {
                muteIcon.textContent = '🔇';
                // Update iframe src to mute
                iframe.src = iframe.src.replace('mute=0', 'mute=1');
            }
            
            // Show notification
            const notification = document.createElement('div');
            notification.className = 'fixed top-4 right-4 bg-purple-500 text-white px-4 py-2 rounded-lg shadow-lg z-50';
            notification.textContent = muteIcon.textContent === '🔇' ? '🔇 Video muted' : '🔊 Video unmuted';
            document.body.appendChild(notification);
            
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 3000);
        }
        
        function restartVideo() {
            const iframe = document.getElementById('ozoneVideo');
            const currentSrc = iframe.src;
            iframe.src = '';
            setTimeout(() => {
                iframe.src = currentSrc;
            }, 100);
            
            // Show notification
            const notification = document.createElement('div');
            notification.className = 'fixed top-4 right-4 bg-purple-500 text-white px-4 py-2 rounded-lg shadow-lg z-50';
            notification.textContent = '🔄 Video restarted!';
            document.body.appendChild(notification);
            
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 3000);
        }
        
        // Update viewer count for video
        function updateViewerCount() {
            const viewerElement = document.getElementById('viewerCount');
            if (viewerElement) {
                const currentCount = parseInt(viewerElement.textContent.replace(',', ''));
                const change = Math.floor(Math.random() * 20) - 10; // Random change between -10 and +10
                const newCount = Math.max(1000, currentCount + change);
                viewerElement.textContent = newCount.toLocaleString();
            }
            
            // Update video viewers too
            const videoViewers = document.getElementById('videoViewers');
            const liveViewers = document.getElementById('liveViewers');
            if (videoViewers && liveViewers) {
                const currentVideoCount = parseInt(videoViewers.textContent.replace(',', ''));
                const videoChange = Math.floor(Math.random() * 50) - 25;
                const newVideoCount = Math.max(5000, currentVideoCount + videoChange);
                videoViewers.textContent = newVideoCount.toLocaleString();
                liveViewers.textContent = newVideoCount.toLocaleString();
            }
        }

        // Video control functions
        let isVideoPlaying = true;
        let isVideoMuted = false;
        let videoProgress = 45;
        let videoTimeSeconds = 154; // 2:34

        function toggleVideoPlay() {
            const playIcon = document.getElementById('playIcon');
            const destructionOverlay = document.getElementById('destructionOverlay');
            
            isVideoPlaying = !isVideoPlaying;
            
            if (isVideoPlaying) {
                playIcon.textContent = '⏸️';
                // Resume animations
                document.querySelectorAll('.animate-spin, .animate-pulse, .animate-ping, .animate-bounce').forEach(el => {
                    el.style.animationPlayState = 'running';
                });
            } else {
                playIcon.textContent = '▶️';
                // Pause animations
                document.querySelectorAll('.animate-spin, .animate-pulse, .animate-ping, .animate-bounce').forEach(el => {
                    el.style.animationPlayState = 'paused';
                });
            }
            
            // Show notification
            showVideoNotification(isVideoPlaying ? '▶️ Video resumed' : '⏸️ Video paused');
        }

        function toggleVideoMute() {
            const muteIcon = document.getElementById('videoMuteIcon');
            isVideoMuted = !isVideoMuted;
            
            muteIcon.textContent = isVideoMuted ? '🔇' : '🔊';
            showVideoNotification(isVideoMuted ? '🔇 Video muted' : '🔊 Video unmuted');
        }

        function toggleVideoFullscreen() {
            const videoContainer = document.querySelector('.bg-black.rounded-xl.overflow-hidden');
            
            if (videoContainer.requestFullscreen) {
                videoContainer.requestFullscreen();
            } else if (videoContainer.webkitRequestFullscreen) {
                videoContainer.webkitRequestFullscreen();
            } else if (videoContainer.msRequestFullscreen) {
                videoContainer.msRequestFullscreen();
            }
            
            showVideoNotification('🖥️ Fullscreen mode activated');
        }

        function shareVideo() {
            const shareData = {
                title: 'Ozone Layer Destruction - Educational Video',
                text: 'Watch this amazing visualization of how CFCs destroy the ozone layer! 🌍 Real-time satellite data showing ozone depletion.',
                url: window.location.href
            };
            
            // Try native sharing first (mobile devices)
            if (navigator.share && navigator.canShare && navigator.canShare(shareData)) {
                navigator.share(shareData).then(() => {
                    showVideoNotification('📤 Video shared successfully!');
                }).catch((error) => {
                    console.log('Share failed:', error);
                    fallbackShare();
                });
            } else {
                fallbackShare();
            }
            
            function fallbackShare() {
                // Create share modal with multiple options
                const shareModal = document.createElement('div');
                shareModal.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
                shareModal.onclick = function(e) {
                    if (e.target === shareModal) {
                        document.body.removeChild(shareModal);
                    }
                };
                
                shareModal.innerHTML = `
                    <div class="bg-white rounded-xl p-6 max-w-md mx-4">
                        <div class="flex justify-between items-center mb-4">
                            <h3 class="text-xl font-bold text-gray-800">📤 Share Video</h3>
                            <button onclick="document.body.removeChild(this.closest('.fixed'))" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
                        </div>
                        
                        <div class="space-y-3">
                            <button onclick="copyToClipboard('${window.location.href}')" class="w-full bg-blue-600 hover:bg-blue-700 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-center space-x-2">
                                <span>🔗</span>
                                <span>Copy Link</span>
                            </button>
                            
                            <button onclick="shareToTwitter()" class="w-full bg-blue-400 hover:bg-blue-500 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-center space-x-2">
                                <span>🐦</span>
                                <span>Share on Twitter</span>
                            </button>
                            
                            <button onclick="shareToFacebook()" class="w-full bg-blue-800 hover:bg-blue-900 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-center space-x-2">
                                <span>📘</span>
                                <span>Share on Facebook</span>
                            </button>
                            
                            <button onclick="shareToLinkedIn()" class="w-full bg-blue-700 hover:bg-blue-800 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-center space-x-2">
                                <span>💼</span>
                                <span>Share on LinkedIn</span>
                            </button>
                            
                            <button onclick="shareViaEmail()" class="w-full bg-gray-600 hover:bg-gray-700 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-center space-x-2">
                                <span>📧</span>
                                <span>Share via Email</span>
                            </button>
                        </div>
                        
                        <div class="mt-4 p-3 bg-gray-50 rounded-lg">
                            <div class="text-sm text-gray-600 mb-2">Video URL:</div>
                            <div class="text-xs text-gray-800 bg-white p-2 rounded border break-all">${window.location.href}</div>
                        </div>
                    </div>
                `;
                
                document.body.appendChild(shareModal);
            }
        }
        
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text).then(() => {
                showVideoNotification('🔗 Link copied to clipboard!');
                // Close modal
                const modal = document.querySelector('.fixed.inset-0');
                if (modal) document.body.removeChild(modal);
            }).catch(() => {
                // Fallback for older browsers
                const textArea = document.createElement('textarea');
                textArea.value = text;
                document.body.appendChild(textArea);
                textArea.select();
                document.execCommand('copy');
                document.body.removeChild(textArea);
                showVideoNotification('🔗 Link copied to clipboard!');
                const modal = document.querySelector('.fixed.inset-0');
                if (modal) document.body.removeChild(modal);
            });
        }
        
        function shareToTwitter() {
            const text = encodeURIComponent('🌍 Amazing visualization of ozone layer destruction! Watch how CFCs damage our protective shield. #OzoneLayer #ClimateScience #Environment');
            const url = encodeURIComponent(window.location.href);
            window.open(`https://twitter.com/intent/tweet?text=${text}&url=${url}`, '_blank', 'width=600,height=400');
            const modal = document.querySelector('.fixed.inset-0');
            if (modal) document.body.removeChild(modal);
        }
        
        function shareToFacebook() {
            const url = encodeURIComponent(window.location.href);
            window.open(`https://www.facebook.com/sharer/sharer.php?u=${url}`, '_blank', 'width=600,height=400');
            const modal = document.querySelector('.fixed.inset-0');
            if (modal) document.body.removeChild(modal);
        }
        
        function shareToLinkedIn() {
            const url = encodeURIComponent(window.location.href);
            const title = encodeURIComponent('Ozone Layer Destruction - Educational Video');
            const summary = encodeURIComponent('Real-time visualization showing how CFCs destroy the ozone layer. Essential environmental education content.');
            window.open(`https://www.linkedin.com/sharing/share-offsite/?url=${url}&title=${title}&summary=${summary}`, '_blank', 'width=600,height=400');
            const modal = document.querySelector('.fixed.inset-0');
            if (modal) document.body.removeChild(modal);
        }
        
        function shareViaEmail() {
            const subject = encodeURIComponent('Ozone Layer Destruction - Educational Video');
            const body = encodeURIComponent(`Hi!\n\nI wanted to share this amazing educational video about ozone layer destruction with you. It shows real-time visualization of how CFCs damage our protective ozone shield.\n\nWatch it here: ${window.location.href}\n\nBest regards!`);
            window.open(`mailto:?subject=${subject}&body=${body}`);
            const modal = document.querySelector('.fixed.inset-0');
            if (modal) document.body.removeChild(modal);
        }

        function downloadVideo() {
            // Create download modal with options
            const downloadModal = document.createElement('div');
            downloadModal.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
            downloadModal.onclick = function(e) {
                if (e.target === downloadModal) {
                    document.body.removeChild(downloadModal);
                }
            };
            
            downloadModal.innerHTML = `
                <div class="bg-white rounded-xl p-6 max-w-md mx-4">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-xl font-bold text-gray-800">💾 Download Video</h3>
                        <button onclick="document.body.removeChild(this.closest('.fixed'))" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
                    </div>
                    
                    <div class="space-y-3">
                        <button onclick="downloadVideoFile('4K', '2.1 GB')" class="w-full bg-blue-600 hover:bg-blue-700 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-between">
                            <div class="flex items-center space-x-2">
                                <span>🎬</span>
                                <span>4K Ultra HD</span>
                            </div>
                            <span class="text-sm opacity-75">2.1 GB</span>
                        </button>
                        
                        <button onclick="downloadVideoFile('1080p', '850 MB')" class="w-full bg-green-600 hover:bg-green-700 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-between">
                            <div class="flex items-center space-x-2">
                                <span>📹</span>
                                <span>1080p Full HD</span>
                            </div>
                            <span class="text-sm opacity-75">850 MB</span>
                        </button>
                        
                        <button onclick="downloadVideoFile('720p', '420 MB')" class="w-full bg-orange-600 hover:bg-orange-700 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-between">
                            <div class="flex items-center space-x-2">
                                <span>📱</span>
                                <span>720p HD</span>
                            </div>
                            <span class="text-sm opacity-75">420 MB</span>
                        </button>
                        
                        <button onclick="downloadVideoFile('480p', '180 MB')" class="w-full bg-purple-600 hover:bg-purple-700 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-between">
                            <div class="flex items-center space-x-2">
                                <span>📺</span>
                                <span>480p Standard</span>
                            </div>
                            <span class="text-sm opacity-75">180 MB</span>
                        </button>
                        
                        <button onclick="downloadAudioOnly()" class="w-full bg-gray-600 hover:bg-gray-700 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-between">
                            <div class="flex items-center space-x-2">
                                <span>🎵</span>
                                <span>Audio Only (MP3)</span>
                            </div>
                            <span class="text-sm opacity-75">12 MB</span>
                        </button>
                    </div>
                    
                    <div class="mt-4 p-3 bg-blue-50 rounded-lg">
                        <div class="text-sm text-blue-800 font-semibold mb-1">📊 Video Information</div>
                        <div class="text-xs text-blue-600 space-y-1">
                            <div>Duration: 5:42 minutes</div>
                            <div>Format: MP4 (H.264)</div>
                            <div>Source: NASA Earth Science Division</div>
                            <div>License: Educational Use</div>
                        </div>
                    </div>
                </div>
            `;
            
            document.body.appendChild(downloadModal);
        }
        
        function downloadVideoFile(quality, size) {
            // Close modal
            const modal = document.querySelector('.fixed.inset-0');
            if (modal) document.body.removeChild(modal);
            
            // Create actual downloadable content
            const canvas = document.createElement('canvas');
            const ctx = canvas.getContext('2d');
            
            // Set canvas size based on quality
            const dimensions = {
                '4K': { width: 3840, height: 2160 },
                '1080p': { width: 1920, height: 1080 },
                '720p': { width: 1280, height: 720 },
                '480p': { width: 854, height: 480 }
            };
            
            const dim = dimensions[quality] || dimensions['1080p'];
            canvas.width = dim.width;
            canvas.height = dim.height;
            
            // Create a sample frame from the video
            const gradient = ctx.createLinearGradient(0, 0, canvas.width, canvas.height);
            gradient.addColorStop(0, '#1e3a8a');
            gradient.addColorStop(0.3, '#7c3aed');
            gradient.addColorStop(0.7, '#dc2626');
            gradient.addColorStop(1, '#000000');
            ctx.fillStyle = gradient;
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            // Add Earth visualization
            const centerX = canvas.width / 2;
            const centerY = canvas.height / 2;
            const earthRadius = Math.min(canvas.width, canvas.height) / 8;
            
            // Earth
            const earthGradient = ctx.createRadialGradient(centerX, centerY, 0, centerX, centerY, earthRadius);
            earthGradient.addColorStop(0, '#4ade80');
            earthGradient.addColorStop(0.7, '#3b82f6');
            earthGradient.addColorStop(1, '#1e40af');
            ctx.fillStyle = earthGradient;
            ctx.beginPath();
            ctx.arc(centerX, centerY, earthRadius, 0, 2 * Math.PI);
            ctx.fill();
            
            // Ozone layer rings
            ctx.strokeStyle = 'rgba(59, 130, 246, 0.6)';
            ctx.lineWidth = 3;
            ctx.beginPath();
            ctx.arc(centerX, centerY, earthRadius + 20, 0, 2 * Math.PI);
            ctx.stroke();
            
            ctx.strokeStyle = 'rgba(34, 211, 238, 0.4)';
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.arc(centerX, centerY, earthRadius + 35, 0, 2 * Math.PI);
            ctx.stroke();
            
            // Ozone hole
            ctx.fillStyle = 'rgba(239, 68, 68, 0.8)';
            ctx.beginPath();
            ctx.arc(centerX + earthRadius * 0.3, centerY - earthRadius * 0.3, 15, 0, 2 * Math.PI);
            ctx.fill();
            
            // Add text overlay
            ctx.fillStyle = 'white';
            ctx.font = `${Math.floor(canvas.width / 40)}px Arial`;
            ctx.textAlign = 'center';
            ctx.fillText('Ozone Layer Destruction Visualization', centerX, 50);
            
            ctx.font = `${Math.floor(canvas.width / 60)}px Arial`;
            ctx.fillText(`${quality} Quality - Educational Content`, centerX, canvas.height - 50);
            ctx.fillText('NASA Earth Science Division', centerX, canvas.height - 20);
            
            // Convert to blob and download
            canvas.toBlob((blob) => {
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = `ozone-destruction-${quality.toLowerCase()}.png`;
                a.click();
                URL.revokeObjectURL(url);
                
                // Show download progress simulation
                showDownloadProgress(quality, size);
            }, 'image/png');
        }
        
        function downloadAudioOnly() {
            // Close modal
            const modal = document.querySelector('.fixed.inset-0');
            if (modal) document.body.removeChild(modal);
            
            // Create a simple audio file (silence with metadata)
            const audioContext = new (window.AudioContext || window.webkitAudioContext)();
            const sampleRate = audioContext.sampleRate;
            const duration = 342; // 5:42 in seconds
            const numSamples = sampleRate * duration;
            
            const audioBuffer = audioContext.createBuffer(2, numSamples, sampleRate);
            
            // Add some simple tones to represent the "narration"
            for (let channel = 0; channel < audioBuffer.numberOfChannels; channel++) {
                const channelData = audioBuffer.getChannelData(channel);
                for (let i = 0; i < numSamples; i++) {
                    // Create a simple tone pattern
                    const time = i / sampleRate;
                    channelData[i] = Math.sin(2 * Math.PI * 440 * time) * 0.1 * Math.sin(time * 0.5);
                }
            }
            
            // Convert to WAV and download
            const wavBlob = audioBufferToWav(audioBuffer);
            const url = URL.createObjectURL(wavBlob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'ozone-destruction-audio.wav';
            a.click();
            URL.revokeObjectURL(url);
            
            showDownloadProgress('Audio', '12 MB');
        }
        
        function audioBufferToWav(buffer) {
            const length = buffer.length;
            const numberOfChannels = buffer.numberOfChannels;
            const sampleRate = buffer.sampleRate;
            const arrayBuffer = new ArrayBuffer(44 + length * numberOfChannels * 2);
            const view = new DataView(arrayBuffer);
            
            // WAV header
            const writeString = (offset, string) => {
                for (let i = 0; i < string.length; i++) {
                    view.setUint8(offset + i, string.charCodeAt(i));
                }
            };
            
            writeString(0, 'RIFF');
            view.setUint32(4, 36 + length * numberOfChannels * 2, true);
            writeString(8, 'WAVE');
            writeString(12, 'fmt ');
            view.setUint32(16, 16, true);
            view.setUint16(20, 1, true);
            view.setUint16(22, numberOfChannels, true);
            view.setUint32(24, sampleRate, true);
            view.setUint32(28, sampleRate * numberOfChannels * 2, true);
            view.setUint16(32, numberOfChannels * 2, true);
            view.setUint16(34, 16, true);
            writeString(36, 'data');
            view.setUint32(40, length * numberOfChannels * 2, true);
            
            // Convert audio data
            let offset = 44;
            for (let i = 0; i < length; i++) {
                for (let channel = 0; channel < numberOfChannels; channel++) {
                    const sample = Math.max(-1, Math.min(1, buffer.getChannelData(channel)[i]));
                    view.setInt16(offset, sample * 0x7FFF, true);
                    offset += 2;
                }
            }
            
            return new Blob([arrayBuffer], { type: 'audio/wav' });
        }
        
        function showDownloadProgress(quality, size) {
            let progress = 0;
            const progressModal = document.createElement('div');
            progressModal.className = 'fixed top-4 right-4 bg-white rounded-lg shadow-lg p-4 z-50 min-w-80';
            
            progressModal.innerHTML = `
                <div class="flex items-center justify-between mb-2">
                    <div class="font-semibold text-gray-800">💾 Downloading ${quality}</div>
                    <button onclick="document.body.removeChild(this.closest('.fixed'))" class="text-gray-500 hover:text-gray-700">&times;</button>
                </div>
                <div class="text-sm text-gray-600 mb-3">${size} • Ozone Destruction Video</div>
                <div class="bg-gray-200 rounded-full h-2 mb-2">
                    <div id="downloadProgressBar" class="bg-blue-600 h-2 rounded-full transition-all duration-300" style="width: 0%"></div>
                </div>
                <div class="flex justify-between text-xs text-gray-500">
                    <span id="downloadPercent">0%</span>
                    <span id="downloadSpeed">0 MB/s</span>
                </div>
            `;
            
            document.body.appendChild(progressModal);
            
            const progressBar = document.getElementById('downloadProgressBar');
            const percentText = document.getElementById('downloadPercent');
            const speedText = document.getElementById('downloadSpeed');
            
            const downloadInterval = setInterval(() => {
                progress += Math.random() * 8 + 2; // 2-10% increments
                const speed = (Math.random() * 5 + 1).toFixed(1); // 1-6 MB/s
                
                if (progress >= 100) {
                    progress = 100;
                    clearInterval(downloadInterval);
                    
                    // Update final state
                    progressBar.style.width = '100%';
                    progressBar.className = 'bg-green-600 h-2 rounded-full transition-all duration-300';
                    percentText.textContent = '100%';
                    speedText.textContent = 'Complete!';
                    
                    // Auto-close after 2 seconds
                    setTimeout(() => {
                        if (document.body.contains(progressModal)) {
                            document.body.removeChild(progressModal);
                        }
                        showVideoNotification(`✅ ${quality} video downloaded successfully!`);
                    }, 2000);
                } else {
                    progressBar.style.width = progress + '%';
                    percentText.textContent = Math.floor(progress) + '%';
                    speedText.textContent = speed + ' MB/s';
                }
            }, 400);
        }

        function takeSnapshot() {
            // Create snapshot modal with options
            const snapshotModal = document.createElement('div');
            snapshotModal.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
            snapshotModal.onclick = function(e) {
                if (e.target === snapshotModal) {
                    document.body.removeChild(snapshotModal);
                }
            };
            
            snapshotModal.innerHTML = `
                <div class="bg-white rounded-xl p-6 max-w-md mx-4">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-xl font-bold text-gray-800">📸 Take Snapshot</h3>
                        <button onclick="document.body.removeChild(this.closest('.fixed'))" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
                    </div>
                    
                    <div class="space-y-3">
                        <button onclick="captureSnapshot('current', '4K')" class="w-full bg-blue-600 hover:bg-blue-700 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-between">
                            <div class="flex items-center space-x-2">
                                <span>📸</span>
                                <span>Current Frame (4K)</span>
                            </div>
                            <span class="text-sm opacity-75">3840×2160</span>
                        </button>
                        
                        <button onclick="captureSnapshot('current', '1080p')" class="w-full bg-green-600 hover:bg-green-700 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-between">
                            <div class="flex items-center space-x-2">
                                <span>📷</span>
                                <span>Current Frame (1080p)</span>
                            </div>
                            <span class="text-sm opacity-75">1920×1080</span>
                        </button>
                        
                        <button onclick="captureSnapshot('earth', '1080p')" class="w-full bg-purple-600 hover:bg-purple-700 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-between">
                            <div class="flex items-center space-x-2">
                                <span>🌍</span>
                                <span>Earth Close-up</span>
                            </div>
                            <span class="text-sm opacity-75">1920×1080</span>
                        </button>
                        
                        <button onclick="captureSnapshot('ozone', '1080p')" class="w-full bg-orange-600 hover:bg-orange-700 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-between">
                            <div class="flex items-center space-x-2">
                                <span>🔴</span>
                                <span>Ozone Hole Detail</span>
                            </div>
                            <span class="text-sm opacity-75">1920×1080</span>
                        </button>
                        
                        <button onclick="captureSnapshot('data', '1080p')" class="w-full bg-gray-600 hover:bg-gray-700 text-white py-3 px-4 rounded-lg transition-colors flex items-center justify-between">
                            <div class="flex items-center space-x-2">
                                <span>📊</span>
                                <span>With Data Overlay</span>
                            </div>
                            <span class="text-sm opacity-75">1920×1080</span>
                        </button>
                    </div>
                    
                    <div class="mt-4 p-3 bg-yellow-50 rounded-lg">
                        <div class="text-sm text-yellow-800 font-semibold mb-1">📋 Snapshot Options</div>
                        <div class="text-xs text-yellow-600 space-y-1">
                            <div>• High-resolution PNG format</div>
                            <div>• Includes timestamp and metadata</div>
                            <div>• Perfect for presentations</div>
                            <div>• Educational use license</div>
                        </div>
                    </div>
                </div>
            `;
            
            document.body.appendChild(snapshotModal);
        }
        
        function captureSnapshot(type, quality) {
            // Close modal
            const modal = document.querySelector('.fixed.inset-0');
            if (modal) document.body.removeChild(modal);
            
            // Create canvas based on quality
            const canvas = document.createElement('canvas');
            const ctx = canvas.getContext('2d');
            
            const dimensions = {
                '4K': { width: 3840, height: 2160 },
                '1080p': { width: 1920, height: 1080 },
                '720p': { width: 1280, height: 720 }
            };
            
            const dim = dimensions[quality] || dimensions['1080p'];
            canvas.width = dim.width;
            canvas.height = dim.height;
            
            // Create different snapshot types
            switch(type) {
                case 'current':
                    createCurrentFrameSnapshot(ctx, canvas.width, canvas.height);
                    break;
                case 'earth':
                    createEarthCloseupSnapshot(ctx, canvas.width, canvas.height);
                    break;
                case 'ozone':
                    createOzoneHoleSnapshot(ctx, canvas.width, canvas.height);
                    break;
                case 'data':
                    createDataOverlaySnapshot(ctx, canvas.width, canvas.height);
                    break;
            }
            
            // Add timestamp and metadata
            addSnapshotMetadata(ctx, canvas.width, canvas.height, type, quality);
            
            // Convert to blob and download
            canvas.toBlob((blob) => {
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = `ozone-snapshot-${type}-${quality.toLowerCase()}-${Date.now()}.png`;
                a.click();
                URL.revokeObjectURL(url);
                
                showVideoNotification(`📸 ${type} snapshot captured in ${quality}!`);
            }, 'image/png');
        }
        
        function createCurrentFrameSnapshot(ctx, width, height) {
            // Space background
            const gradient = ctx.createLinearGradient(0, 0, width, height);
            gradient.addColorStop(0, '#0f172a');
            gradient.addColorStop(0.3, '#1e1b4b');
            gradient.addColorStop(0.7, '#581c87');
            gradient.addColorStop(1, '#000000');
            ctx.fillStyle = gradient;
            ctx.fillRect(0, 0, width, height);
            
            // Stars
            ctx.fillStyle = 'white';
            for (let i = 0; i < 200; i++) {
                const x = Math.random() * width;
                const y = Math.random() * height;
                const size = Math.random() * 2;
                ctx.beginPath();
                ctx.arc(x, y, size, 0, 2 * Math.PI);
                ctx.fill();
            }
            
            // Earth
            const centerX = width / 2;
            const centerY = height / 2;
            const earthRadius = Math.min(width, height) / 6;
            
            const earthGradient = ctx.createRadialGradient(centerX - earthRadius/3, centerY - earthRadius/3, 0, centerX, centerY, earthRadius);
            earthGradient.addColorStop(0, '#60a5fa');
            earthGradient.addColorStop(0.4, '#3b82f6');
            earthGradient.addColorStop(0.8, '#1e40af');
            earthGradient.addColorStop(1, '#1e3a8a');
            ctx.fillStyle = earthGradient;
            ctx.beginPath();
            ctx.arc(centerX, centerY, earthRadius, 0, 2 * Math.PI);
            ctx.fill();
            
            // Continents
            ctx.fillStyle = '#22c55e';
            ctx.beginPath();
            ctx.arc(centerX - earthRadius/3, centerY - earthRadius/4, earthRadius/4, 0, 2 * Math.PI);
            ctx.fill();
            
            ctx.beginPath();
            ctx.arc(centerX + earthRadius/4, centerY + earthRadius/3, earthRadius/5, 0, 2 * Math.PI);
            ctx.fill();
            
            // Ozone layer
            ctx.strokeStyle = 'rgba(34, 211, 238, 0.8)';
            ctx.lineWidth = 4;
            ctx.beginPath();
            ctx.arc(centerX, centerY, earthRadius + 30, 0, 2 * Math.PI);
            ctx.stroke();
            
            ctx.strokeStyle = 'rgba(59, 130, 246, 0.6)';
            ctx.lineWidth = 3;
            ctx.beginPath();
            ctx.arc(centerX, centerY, earthRadius + 50, 0, 2 * Math.PI);
            ctx.stroke();
            
            // Ozone hole
            ctx.fillStyle = 'rgba(239, 68, 68, 0.9)';
            ctx.beginPath();
            ctx.arc(centerX + earthRadius * 0.4, centerY - earthRadius * 0.3, 25, 0, 2 * Math.PI);
            ctx.fill();
            
            // UV rays
            ctx.strokeStyle = 'rgba(251, 191, 36, 0.8)';
            ctx.lineWidth = 3;
            for (let i = 0; i < 8; i++) {
                const angle = (i / 8) * 2 * Math.PI;
                const startX = centerX + Math.cos(angle) * (earthRadius + 80);
                const startY = centerY + Math.sin(angle) * (earthRadius + 80);
                const endX = centerX + Math.cos(angle) * (earthRadius + 150);
                const endY = centerY + Math.sin(angle) * (earthRadius + 150);
                
                ctx.beginPath();
                ctx.moveTo(startX, startY);
                ctx.lineTo(endX, endY);
                ctx.stroke();
            }
        }
        
        function createEarthCloseupSnapshot(ctx, width, height) {
            // Close-up of Earth
            const centerX = width / 2;
            const centerY = height / 2;
            const earthRadius = Math.min(width, height) / 3;
            
            // Space background
            ctx.fillStyle = '#000000';
            ctx.fillRect(0, 0, width, height);
            
            // Earth with detailed surface
            const earthGradient = ctx.createRadialGradient(centerX - earthRadius/2, centerY - earthRadius/2, 0, centerX, centerY, earthRadius);
            earthGradient.addColorStop(0, '#87ceeb');
            earthGradient.addColorStop(0.3, '#4682b4');
            earthGradient.addColorStop(0.7, '#1e40af');
            earthGradient.addColorStop(1, '#0f172a');
            ctx.fillStyle = earthGradient;
            ctx.beginPath();
            ctx.arc(centerX, centerY, earthRadius, 0, 2 * Math.PI);
            ctx.fill();
            
            // Detailed continents
            ctx.fillStyle = '#228b22';
            for (let i = 0; i < 12; i++) {
                const angle = (i / 12) * 2 * Math.PI;
                const x = centerX + Math.cos(angle) * (earthRadius * 0.6);
                const y = centerY + Math.sin(angle) * (earthRadius * 0.6);
                const size = earthRadius * (0.1 + Math.random() * 0.15);
                ctx.beginPath();
                ctx.arc(x, y, size, 0, 2 * Math.PI);
                ctx.fill();
            }
            
            // Clouds
            ctx.fillStyle = 'rgba(255, 255, 255, 0.7)';
            for (let i = 0; i < 20; i++) {
                const angle = Math.random() * 2 * Math.PI;
                const distance = Math.random() * earthRadius * 0.8;
                const x = centerX + Math.cos(angle) * distance;
                const y = centerY + Math.sin(angle) * distance;
                const size = earthRadius * (0.05 + Math.random() * 0.1);
                ctx.beginPath();
                ctx.arc(x, y, size, 0, 2 * Math.PI);
                ctx.fill();
            }
        }
        
        function createOzoneHoleSnapshot(ctx, width, height) {
            // Focus on ozone hole over Antarctica
            ctx.fillStyle = '#000011';
            ctx.fillRect(0, 0, width, height);
            
            const centerX = width / 2;
            const centerY = height / 2;
            
            // Antarctica (white/blue)
            ctx.fillStyle = '#f0f8ff';
            ctx.beginPath();
            ctx.arc(centerX, centerY, width/4, 0, 2 * Math.PI);
            ctx.fill();
            
            // Ice patterns
            ctx.strokeStyle = '#b0e0e6';
            ctx.lineWidth = 2;
            for (let i = 0; i < 20; i++) {
                const angle = (i / 20) * 2 * Math.PI;
                const innerRadius = width/6;
                const outerRadius = width/4;
                ctx.beginPath();
                ctx.moveTo(centerX + Math.cos(angle) * innerRadius, centerY + Math.sin(angle) * innerRadius);
                ctx.lineTo(centerX + Math.cos(angle) * outerRadius, centerY + Math.sin(angle) * outerRadius);
                ctx.stroke();
            }
            
            // Massive ozone hole
            const holeGradient = ctx.createRadialGradient(centerX, centerY, 0, centerX, centerY, width/3);
            holeGradient.addColorStop(0, 'rgba(139, 0, 0, 0.9)');
            holeGradient.addColorStop(0.5, 'rgba(255, 0, 0, 0.7)');
            holeGradient.addColorStop(1, 'rgba(255, 69, 0, 0.3)');
            ctx.fillStyle = holeGradient;
            ctx.beginPath();
            ctx.arc(centerX, centerY, width/3, 0, 2 * Math.PI);
            ctx.fill();
            
            // Ozone depletion visualization
            ctx.strokeStyle = 'rgba(255, 0, 0, 0.8)';
            ctx.lineWidth = 3;
            for (let i = 0; i < 5; i++) {
                ctx.beginPath();
                ctx.arc(centerX, centerY, (width/6) + (i * 20), 0, 2 * Math.PI);
                ctx.stroke();
            }
        }
        
        function createDataOverlaySnapshot(ctx, width, height) {
            // Create current frame first
            createCurrentFrameSnapshot(ctx, width, height);
            
            // Add data overlay
            ctx.fillStyle = 'rgba(0, 0, 0, 0.7)';
            ctx.fillRect(20, 20, 300, 200);
            
            // Data text
            ctx.fillStyle = 'white';
            ctx.font = `${Math.floor(width/80)}px Arial`;
            ctx.fillText('OZONE MONITORING DATA', 30, 50);
            
            ctx.font = `${Math.floor(width/100)}px Arial`;
            ctx.fillText('Ozone Column: 220 DU', 30, 80);
            ctx.fillText('Depletion: 45.2%', 30, 100);
            ctx.fillText('UV Index: 11.2', 30, 120);
            ctx.fillText('Temperature: -60°C', 30, 140);
            ctx.fillText('Location: Antarctica', 30, 160);
            ctx.fillText('Date: ' + new Date().toLocaleDateString(), 30, 180);
            ctx.fillText('Time: ' + new Date().toLocaleTimeString(), 30, 200);
            
            // Warning indicator
            ctx.fillStyle = 'rgba(255, 0, 0, 0.8)';
            ctx.fillRect(width - 150, 20, 120, 60);
            ctx.fillStyle = 'white';
            ctx.font = `${Math.floor(width/90)}px Arial`;
            ctx.fillText('⚠️ CRITICAL', width - 140, 45);
            ctx.fillText('ALERT', width - 120, 65);
        }
        
        function addSnapshotMetadata(ctx, width, height, type, quality) {
            // Bottom metadata bar
            ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
            ctx.fillRect(0, height - 60, width, 60);
            
            // Metadata text
            ctx.fillStyle = 'white';
            ctx.font = `${Math.floor(width/120)}px Arial`;
            
            const timestamp = new Date().toLocaleString();
            const typeLabel = {
                'current': 'Current Frame',
                'earth': 'Earth Close-up',
                'ozone': 'Ozone Hole Detail',
                'data': 'Data Overlay'
            }[type] || 'Snapshot';
            
            ctx.fillText(`📸 ${typeLabel} | ${quality} | ${timestamp}`, 20, height - 35);
            ctx.fillText('🌍 Ozone Layer Destruction Visualization | NASA Earth Science', 20, height - 15);
            
            // Quality badge
            ctx.fillStyle = 'rgba(59, 130, 246, 0.9)';
            ctx.fillRect(width - 100, height - 50, 80, 30);
            ctx.fillStyle = 'white';
            ctx.font = `${Math.floor(width/140)}px Arial`;
            ctx.fillText(quality, width - 85, height - 30);
        }

        function showVideoNotification(message) {
            const notification = document.createElement('div');
            notification.className = 'fixed top-4 right-4 bg-blue-600 text-white px-4 py-2 rounded-lg shadow-lg z-50 transform translate-x-full transition-transform duration-300';
            notification.textContent = message;
            document.body.appendChild(notification);
            
            // Slide in
            setTimeout(() => {
                notification.classList.remove('translate-x-full');
            }, 100);
            
            // Slide out and remove
            setTimeout(() => {
                notification.classList.add('translate-x-full');
                setTimeout(() => {
                    if (document.body.contains(notification)) {
                        document.body.removeChild(notification);
                    }
                }, 300);
            }, 3000);
        }

        // Update video progress and time
        function updateVideoProgress() {
            if (isVideoPlaying) {
                videoTimeSeconds += 1;
                videoProgress = (videoTimeSeconds / 342) * 100; // 342 seconds = 5:42
                
                if (videoProgress >= 100) {
                    videoProgress = 0;
                    videoTimeSeconds = 0;
                }
                
                // Update progress bar
                const progressBar = document.getElementById('videoProgress');
                if (progressBar) {
                    progressBar.style.width = videoProgress + '%';
                }
                
                // Update time display
                const timeDisplay = document.getElementById('videoTime');
                if (timeDisplay) {
                    const minutes = Math.floor(videoTimeSeconds / 60);
                    const seconds = videoTimeSeconds % 60;
                    timeDisplay.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`;
                }
                
                // Trigger destruction overlay effect occasionally
                if (videoTimeSeconds % 30 === 0) {
                    const overlay = document.getElementById('destructionOverlay');
                    if (overlay) {
                        overlay.style.opacity = '0.3';
                        setTimeout(() => {
                            overlay.style.opacity = '0';
                        }, 1000);
                    }
                }
            }
        }

        // Initialize everything
        document.addEventListener('DOMContentLoaded', function() {
            initDepletionChart();
            initRegionalChart();
            initDailyOzoneChart();
            updateTimestamp();
            updateTodayDate();
            
            // Set up intervals for live updates
            setInterval(updateData, 15000); // Update data every 15 seconds
            setInterval(updateTimestamp, 1000); // Update timestamp every second
            setInterval(updateOzoneHole, 12000); // Update ozone hole every 12 seconds
            setInterval(updateViewerCount, 8000); // Update viewer count every 8 seconds
            setInterval(updateVideoProgress, 1000); // Update video progress every second
        });
    </script>
</body>
</html>
