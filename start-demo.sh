#!/bin/bash

# Wundr Platform Demo Startup Script
# This script starts a working component demo

echo "🚀 Starting Wundr Platform Demo..."

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: Please run this script from the Wundr project root directory"
    exit 1
fi

# Function to check if port is available
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo "⚠️  Port $1 is already in use"
        return 1
    else
        echo "✅ Port $1 is available"
        return 0
    fi
}

echo ""
echo "📋 Available Demo Options:"
echo "1. Web Client Dashboard (Next.js)"
echo "2. Simple Node.js Server Demo"
echo ""

read -p "Select demo option (1-2): " choice

case $choice in
    1)
        echo ""
        echo "🔧 Starting Web Client Dashboard..."
        
        # Check if port 3000 is available
        if ! check_port 3000; then
            echo "Please stop the service using port 3000 or try option 2"
            exit 1
        fi
        
        cd tools/web-client
        
        # Install dependencies if needed
        if [ ! -d "node_modules" ]; then
            echo "📦 Installing dependencies..."
            npm install
        fi
        
        # Build the project
        echo "🔨 Building project..."
        npm run build
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "✅ Build successful!"
            echo "🚀 Starting development server..."
            echo ""
            echo "📍 Dashboard will be available at: http://localhost:3000"
            echo "📍 API endpoints available at: http://localhost:3000/api"
            echo ""
            echo "Press Ctrl+C to stop the demo"
            echo ""
            npm run dev
        else
            echo "❌ Build failed. Please check the error messages above."
            exit 1
        fi
        ;;
    
    2)
        echo ""
        echo "🔧 Starting Simple Node.js Demo..."
        
        # Check if port 3001 is available
        if ! check_port 3001; then
            echo "Please stop the service using port 3001 or try option 1"
            exit 1
        fi
        
        # Create a simple demo server
        cat > demo-server.js << 'EOF'
const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 3001;

// Simple analysis demo data
const demoAnalysis = {
    project: 'Wundr Demo',
    timestamp: new Date().toISOString(),
    metrics: {
        totalFiles: 142,
        linesOfCode: 15420,
        maintainabilityIndex: 72,
        testCoverage: 78,
        issues: 12,
        technicalDebt: 180
    },
    issues: [
        { type: 'complexity', severity: 'high', file: 'src/services/user.ts', line: 45 },
        { type: 'duplication', severity: 'medium', file: 'src/utils/validation.ts', line: 12 },
        { type: 'security', severity: 'high', file: 'package.json', description: 'Vulnerable dependency detected' }
    ],
    recommendations: [
        'Refactor UserService to reduce complexity',
        'Extract duplicate validation logic',
        'Update vulnerable dependencies'
    ]
};

const server = http.createServer((req, res) => {
    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Access-Control-Allow-Origin', '*');
    
    if (req.url === '/') {
        res.setHeader('Content-Type', 'text/html');
        res.end(`
<!DOCTYPE html>
<html>
<head>
    <title>Wundr Platform Demo</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .metric { display: inline-block; margin: 10px; padding: 15px; background: #f8f9fa; border-radius: 6px; min-width: 120px; text-align: center; }
        .metric-value { font-size: 24px; font-weight: bold; color: #007bff; }
        .metric-label { font-size: 12px; color: #666; margin-top: 5px; }
        .issue { padding: 10px; margin: 10px 0; border-left: 4px solid #dc3545; background: #f8d7da; border-radius: 4px; }
        .recommendation { padding: 10px; margin: 10px 0; border-left: 4px solid #28a745; background: #d4edda; border-radius: 4px; }
        h1 { color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        h2 { color: #555; margin-top: 30px; }
        .status { color: #28a745; font-weight: bold; }
        .api-link { color: #007bff; text-decoration: none; }
        .api-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Wundr Platform Demo</h1>
        <p class="status">✅ Demo server is running successfully!</p>
        
        <h2>📊 Project Metrics</h2>
        <div class="metrics">
            <div class="metric">
                <div class="metric-value">${demoAnalysis.metrics.totalFiles}</div>
                <div class="metric-label">Total Files</div>
            </div>
            <div class="metric">
                <div class="metric-value">${demoAnalysis.metrics.linesOfCode.toLocaleString()}</div>
                <div class="metric-label">Lines of Code</div>
            </div>
            <div class="metric">
                <div class="metric-value">${demoAnalysis.metrics.maintainabilityIndex}</div>
                <div class="metric-label">Maintainability</div>
            </div>
            <div class="metric">
                <div class="metric-value">${demoAnalysis.metrics.testCoverage}%</div>
                <div class="metric-label">Test Coverage</div>
            </div>
        </div>
        
        <h2>⚠️ Issues Found</h2>
        ${demoAnalysis.issues.map(issue => `
            <div class="issue">
                <strong>${issue.type.toUpperCase()}</strong> (${issue.severity}): ${issue.description || 'Found in ' + issue.file + ':' + issue.line}
            </div>
        `).join('')}
        
        <h2>💡 Recommendations</h2>
        ${demoAnalysis.recommendations.map(rec => `
            <div class="recommendation">${rec}</div>
        `).join('')}
        
        <h2>🔗 API Endpoints</h2>
        <p>Try these API endpoints:</p>
        <ul>
            <li><a href="/api/analysis" class="api-link">/api/analysis</a> - Full analysis data</li>
            <li><a href="/api/metrics" class="api-link">/api/metrics</a> - Project metrics only</li>
            <li><a href="/api/issues" class="api-link">/api/issues</a> - Issues list</li>
            <li><a href="/api/health" class="api-link">/api/health</a> - Health check</li>
        </ul>
        
        <h2>🛠️ Next Steps</h2>
        <p>This demo shows basic functionality. The full Wundr platform includes:</p>
        <ul>
            <li>Interactive dashboards with real-time updates</li>
            <li>Advanced code analysis and dependency tracking</li>
            <li>Automated report generation</li>
            <li>Integration with CI/CD pipelines</li>
            <li>Team collaboration features</li>
        </ul>
        
        <p><em>Demo running on port ${PORT} - Press Ctrl+C in terminal to stop</em></p>
    </div>
</body>
</html>
        `);
    } else if (req.url === '/api/analysis') {
        res.end(JSON.stringify(demoAnalysis, null, 2));
    } else if (req.url === '/api/metrics') {
        res.end(JSON.stringify(demoAnalysis.metrics, null, 2));
    } else if (req.url === '/api/issues') {
        res.end(JSON.stringify(demoAnalysis.issues, null, 2));
    } else if (req.url === '/api/health') {
        res.end(JSON.stringify({ status: 'healthy', timestamp: new Date().toISOString() }, null, 2));
    } else {
        res.statusCode = 404;
        res.end(JSON.stringify({ error: 'Endpoint not found' }));
    }
});

server.listen(PORT, () => {
    console.log(`🚀 Wundr Demo Server running at http://localhost:${PORT}`);
    console.log(`📊 View dashboard: http://localhost:${PORT}`);
    console.log(`🔗 API available: http://localhost:${PORT}/api/analysis`);
    console.log(`Press Ctrl+C to stop`);
});
EOF
        
        echo "✅ Simple demo server created"
        echo "🚀 Starting demo server..."
        echo ""
        echo "📍 Demo dashboard will be available at: http://localhost:3001"
        echo "📍 API endpoints available at: http://localhost:3001/api"
        echo ""
        echo "Press Ctrl+C to stop the demo"
        echo ""
        node demo-server.js
        ;;
    
    *)
        echo "❌ Invalid option selected"
        exit 1
        ;;
esac