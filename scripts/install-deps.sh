#!/bin/bash

# Project dependency installation script
# This script automatically installs required npm packages and displays completion status

set -e

echo "🔧 Starting dependency installation..."

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "❌ Error: npm is not installed. Please install Node.js and npm first."
    exit 1
fi

# Check if package.json exists
if [ ! -f "package.json" ]; then
    echo "📦 No package.json found. Initializing new npm project..."
    npm init -y
fi

# Install common development dependencies for Claude automation projects
echo "📥 Installing development dependencies..."

# Install TypeScript and related tools
npm install --save-dev typescript @types/node

# Install testing frameworks
npm install --save-dev jest @types/jest

# Install linting and formatting tools
npm install --save-dev eslint prettier eslint-config-prettier

# Install build tools
npm install --save-dev nodemon ts-node

# Install HTTP request libraries (useful for API tasks)
npm install axios node-fetch

# Install CLI tools
npm install --save-dev commander inquirer

echo "✅ Dependencies installed successfully!"

# Display installed packages
echo ""
echo "📋 Installed packages:"
npm list --depth=0

echo ""
echo "🎉 Installation complete! You can now run the project scripts."
echo "💡 Available scripts:"
echo "   - npm run build: Compile TypeScript"
echo "   - npm run dev: Run in development mode with auto-reload"
echo "   - npm test: Run tests"
echo "   - npm run lint: Run linter"
echo "   - npm run format: Format code with Prettier"